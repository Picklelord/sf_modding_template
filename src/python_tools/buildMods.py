import sys
import os
import json
import shutil
from collections import OrderedDict
import subprocess

ROOT = ""
# set ROOT global variable
if getattr(sys, 'frozen', False):
    # If the script is running as a compiled .exe via PyInstaller
    ROOT = os.path.dirname(sys.executable).replace("\\", "/") + "/"
else:
    # If the script is running as a raw .py file
    ROOT = os.path.dirname(os.path.abspath(__file__)).replace("\\", "/") + "/"

def merge_text_files(directory, output_filepath):
    """
    Merge all text files in the provided directory.
    """
    # List to store the lines of all files
    all_lines = []

    # Start with original.txt
    original_filepath = os.path.join(directory, "original.txt")
    if os.path.exists(original_filepath):
        with open(original_filepath, 'r') as f:
            all_lines.extend(f.readlines())

    # Process all other .txt files and append to all_lines
    for filename in os.listdir(directory):
        if filename.endswith(".txt") and filename != "original.txt":
            with open(os.path.join(directory, filename), 'r') as f:
                all_lines.extend(f.readlines())

    # Write all lines to the output file
    with open(output_filepath, 'w') as f:
        f.writelines(all_lines)

    print(f"Merged text file has been created: {output_filepath}")

def parse_ini(filepath):
    """
    Parse an .ini file into a dictionary.
    """
    with open(filepath, 'r') as f:
        lines = f.readlines()

    sections = OrderedDict()
    current_section = None

    for line in lines:
        line = line.strip()

        # Skip comments or empty lines
        if not line or line.startswith(";"):
            continue

        # Detect sections
        if line.startswith("[") and line.endswith("]"):
            section_name = line[1:-1].strip()
            sections[section_name] = OrderedDict()
            current_section = sections[section_name]

        # Detect key=value pairs
        elif "=" in line and current_section is not None:
            key, value = map(str.strip, line.split("=", 1))
            current_section[key] = value

    return sections

def merge_ini_files(directory, output_filepath):
    """
    Merge all .ini files in the provided directory.
    """
    merged_data = OrderedDict()

    # Start with original.ini
    original_filepath = os.path.join(directory, "original.ini")
    if os.path.exists(original_filepath):
        merged_data.update(parse_ini(original_filepath))

    # Process all other .ini files and overwrite/add to merged_data
    for filename in os.listdir(directory):
        if filename.endswith(".ini") and filename != "original.ini":
            file_data = parse_ini(os.path.join(directory, filename))
            for section, keys in file_data.items():
                if section not in merged_data:
                    merged_data[section] = OrderedDict()
                merged_data[section].update(keys)

    with open(output_filepath, 'w') as f:
        for section, keys in merged_data.items():
            f.write(f"[{section}]\n")
            for key, value in keys.items():
                f.write(f"{key}={value}\n")
            f.write("\n")

    print(f"Merged INI file has been created: {output_filepath}")

def getConfigData():
    # open config and get variables needed
    try:
        CONFIG = json.loads(f"{ROOT}config.json")
    except (TypeError, AttributeError, ValueError):
        try:
            with open(f"{ROOT}config.json","r") as jFile:
                CONFIG = json.load(jFile)
        except ValueError:
            print("Failed to load ./config.json")
            return
    return CONFIG

def main():
    # get config data
    CONFIG = getConfigData()
    buildLog = f"{ROOT}build/build.log"
    logData = ["Beginning Build..."]

    # wipe any existing build data
    if os.path.exists(ROOT+CONFIG["starfieldBaseBuildLocation"]+"/Data"):
        shutil.rmtree(ROOT+CONFIG["starfieldBaseBuildLocation"])
        logData.append("\nRemoved: "+ROOT+CONFIG["starfieldBaseBuildLocation"])
    if os.path.exists(ROOT+CONFIG["starfieldMyGameBuildLocation"]+"/Data"):
        shutil.rmtree(ROOT+CONFIG["starfieldMyGameBuildLocation"])
        logData.append("\nRemoved: "+ROOT+CONFIG["starfieldMyGameBuildLocation"])
    if os.path.exists(buildLog):
        os.remove(buildLog.replace("/", "\\"))
        logData.append(f"\nRemoved: {buildLog}")

    # remake base structure
    if not os.path.exists(ROOT+CONFIG["starfieldBaseBuildLocation"]):
        os.makedirs(ROOT+CONFIG["starfieldBaseBuildLocation"])
    if not os.path.exists(ROOT+CONFIG["starfieldMyGameBuildLocation"]):
        os.makedirs(ROOT+CONFIG["starfieldMyGameBuildLocation"])

    # build INI and TXT files
    installIniFiles = ["StartingCommands.txt", "Starfield.ini"]
    myGamesIniFiles = ["StarfieldCustom.ini", "StarfieldPrefs.ini", "StarfieldHotkeys.ini"]
    for fileName in installIniFiles:
        logData.append(f"\nBuilding: {fileName}")
        merge_text_files(
            ROOT+CONFIG["iniModsPath"]+f"{fileName}/",
            ROOT+CONFIG["starfieldBaseBuildLocation"]+f"/{fileName}"
        )
        logData.append(f"\nSuccessfully Built: {fileName}")
    for fileName in myGamesIniFiles:
        logData.append(f"\nBuilding: {fileName}")
        merge_text_files(
            ROOT+CONFIG["iniModsPath"]+f"{fileName}/",
            ROOT+CONFIG["starfieldMyGameBuildLocation"]+f"/{fileName}"
        )
        logData.append(f"\nSuccessfully Built: {fileName}")

    # copy custom data mods to build location
    if len(os.listdir(ROOT+CONFIG["gamesDataModsPath"]))>=1:
        logData.append(f"\nTransferring any custom MyGames/Starfield/Data mods")
        shutil.copytree(
            ROOT+CONFIG["gamesDataModsPath"],
            ROOT+CONFIG["starfieldMyGameBuildLocation"]+"/Data"
        )
    if len(os.listdir(os.path.join(ROOT,CONFIG["baseDataModsPath"])))>=1:
        logData.append(f"\nTransferring any custom install/Starfield/Data mods")
        shutil.copytree(
            ROOT+CONFIG["baseDataModsPath"],
            ROOT+CONFIG["starfieldBaseBuildLocation"]+"/Data"
        )

    # cleanup readme files in build
    if os.path.exists(ROOT+CONFIG["starfieldBaseBuildLocation"]+"/Data/README.md"):
        os.remove(ROOT+CONFIG["starfieldBaseBuildLocation"]+"/Data/README.md")
    if os.path.exists(ROOT+CONFIG["starfieldMyGameBuildLocation"]+"/Data/README.md"):
        os.remove(ROOT+CONFIG["starfieldMyGameBuildLocation"]+"/Data/README.md")

    pscFailed = False
    #build all psc files
    if not CONFIG["skipPSC_MassCompile"]:
        if not os.path.exists(ROOT+CONFIG["starfieldCompileOutputLocation"]):
            os.makedirs(ROOT+CONFIG["starfieldCompileOutputLocation"])
        pscRoot=ROOT + CONFIG["pscModsPath"]
        outDir=ROOT + CONFIG["starfieldCompileOutputLocation"]
        for subdir, _, files in os.walk(pscRoot):
            print(subdir)
            for file in files:
                # exclude WIP scripts from full build until they make it available
                if not "_WIP_" in subdir:
                    if file.split(".",1)[1] == "psc":
                        pscFile = (subdir+"/"+file)
                        cBuildCmd = [
                            f"{ROOT}apps/Caprica.exe",
                            "--game",
                            "starfield",
                            "--import",
                            ROOT+CONFIG["starfieldDecompiledScriptsLocation"],
                            "--flags",
                            ROOT+CONFIG["starfieldFlagsLocation"],
                            "--output",
                            outDir,
                            pscFile
                        ]
                        logData.extend(["\nCalling Caprica:\n"," ".join(cBuildCmd)])
                        os.chdir(pscFile.rsplit("/",1)[0])
                        print("CD Before:", os.getcwd())
                        try:
                            callCaprica = subprocess.run(cBuildCmd, capture_output=True, text=True, check=True)
                            print(callCaprica.stdout)  # This will print stdout if the command succeeds
                        except subprocess.CalledProcessError as e:
                            print("Command returned non-zero exit status:", e.returncode)
                            print("stdout:", e.stdout)
                            print("stderr:", e.stderr)
                            logData.append("\n"+e.stdout)
                            logData.append("\n"+e.stderr)
                            pscFailed = True
                            print("Caprica FAILED FOR:\n"+" ".join(cBuildCmd))

                        logData.append(f"\nCaprica output: {outDir}/{file}")
                        os.chdir(ROOT)
                        print("CD After:", os.getcwd())

    print("-----------------")
    if pscFailed:
        print("Build Completed, but some .psc scripts failed to compile!")
    else:
        print("Build Completed Successfully!")
    logData.append("\nBuild Completed!")
    with open(buildLog, "w") as f:
        for line in logData:
            f.write(str(line))
    #os.system(f"notepad.exe \"{buildLog}\"")
    return

if __name__ == "__main__":
    main()
    exit()



