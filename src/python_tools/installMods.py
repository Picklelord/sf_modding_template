import sys
import os
import json
import shutil
import time
import subprocess
import traceback

ROOT = ""
# set ROOT global variable
if getattr(sys, 'frozen', False):
    # If the script is running as a compiled .exe via PyInstaller
    ROOT = os.path.dirname(sys.executable).replace("\\", "/").rsplit("/",1)[0] + "/"
else:
    # If the script is running as a raw .py file
    ROOT = os.path.dirname(os.path.abspath(__file__)).replace("\\", "/").rsplit("/",2)[0] + "/"



def copy_directory(src, dest, dry_mode=False):
    # List for storing files that would be overwritten
    overwritten_files = []
    copied_files = []

    # Walk the source directory
    for subdir, _, files in os.walk(src):
        # Compute the corresponding destination directory
        dest_dir = os.path.join(dest, subdir[len(src):].lstrip(os.path.sep))

        # If destination directory doesn't exist, create it
        if not os.path.exists(dest_dir) and not dry_mode:
            os.makedirs(dest_dir)

        # Copy each file to the destination directory
        for file in files:
            src_file = os.path.join(subdir, file)
            dest_file = os.path.join(dest_dir, file)
            src_file = src_file.replace("/", "\\")
            dest_file = dest_file.replace("/", "\\")

            # Check if file already exists at the destination
            if os.path.exists(dest_file):
                overwritten_files.append([src_file, dest_file])
                if not dry_mode:
                    print(f"transfering:  {src_file}")
                    res = shutil.copy2(src_file, dest_file)
                    print(f"   - result = {res}")
            else:
                copied_files.append([src_file, dest_file])
                if not dry_mode:
                    print(f"transfering:  {src_file}")
                    res = shutil.copy2(src_file, dest_file)
                    print(f"   - result = {res}")

    return overwritten_files, copied_files

def getConfigData():
    # open config and get variables needed
    try:
        CONFIG = json.loads(f"{ROOT}config.json")
    except (TypeError, AttributeError, ValueError):
        try:
            with open(f"{ROOT}config.json","r") as jFile:
                CONFIG = json.load(jFile)
        except ValueError:
            print("Failed to load .\config.json")
            return
    return CONFIG

def runFileTransfer(CONFIG, dryRun):
    sourceMyGames = ROOT + CONFIG["starfieldMyGameBuildLocation"]
    sourceInstall = ROOT + CONFIG["starfieldBaseBuildLocation"]
    # If source directory doesn't exist, return
    if not os.path.exists(sourceMyGames) or not os.path.exists(sourceInstall):
        print("\n\nERROR: Build files don't exist!")
        print("You need to run 'buildMods.exe' before running the installMods.exe")
        time.sleep(10)
        return

    wFilesMyGames, cFilesMyGames = copy_directory(
        sourceMyGames,
        CONFIG["starfieldMyGamesLocation"],
        dry_mode=dryRun
    )
    wFilesInstall, cFilesInstall = copy_directory(
        sourceInstall,
        CONFIG["starfieldInstallLocation"],
        dry_mode=dryRun
    )
    return wFilesMyGames, cFilesMyGames, wFilesInstall, cFilesInstall

def transferTextures(myGamesDir, installDir):
    src = f"{installDir}/Data/textures"
    dest = f"{myGamesDir}/Data/textures"
    # Walk the source directory
    for subdir, _, files in os.walk(src):
        # Compute the corresponding destination directory
        dest_dir = os.path.join(dest, subdir[len(src):].lstrip(os.path.sep))

        # If destination directory doesn't exist, create it
        if not os.path.exists(dest_dir):
            os.makedirs(dest_dir)

        # Copy each file to the destination directory
        for file in files:
            src_file = os.path.join(subdir, file)
            dest_file = os.path.join(dest_dir, file)
            src_file = src_file.replace("/", "\\")
            dest_file = dest_file.replace("/", "\\")

            print(f"transfering:  {src_file}")
            res = shutil.copy2(src_file, dest_file)
            print(f"   - result = {res}")

def doDryRun(CONFIG, results):
    wFilesMyGames = results[0]
    cFilesMyGames = results[1]
    wFilesInstall = results[2]
    cFilesInstall = results[3]

    with open(ROOT + "dryRunInstallation.log", "w") as f:
        f.write("OVERWRITE Files that exist in the My Games location: \n")
        f.write(CONFIG["starfieldMyGamesLocation"].replace("/", "\\") + ":\n")
        for sourceFile, destFile in wFilesMyGames:
            f.write("\t{}\n".format(
                destFile.replace(CONFIG["starfieldMyGamesLocation"], ".."))
            )
        if len(wFilesMyGames) == 0:
            f.write("\tNone\n")
        f.write("COPY the following Files to the My Games location, they don't exist already: \n")
        for sourceFile, destFile in cFilesMyGames:
            f.write("\t{}\n".format(
                destFile.replace(CONFIG["starfieldMyGamesLocation"], ".."))
            )
        if len(cFilesMyGames) == 0:
            f.write("\tNone\n")
        f.write("\n\nOVERWRITE Files that exist in the Main Install Location location: \n")
        f.write(CONFIG["starfieldInstallLocation"].replace("/", "\\") + ":\n")
        for sourceFile, destFile in wFilesInstall:
            f.write("\t{}\n".format(
                destFile.replace(CONFIG["starfieldInstallLocation"], ".."))
            )
        if len(wFilesInstall) == 0:
            f.write("\tNone\n")
        f.write("COPY the following Files to the Main Install location, they don't exist already: \n")
        for sourceFile, destFile in cFilesInstall:
            f.write("\t{}\n".format(
                destFile.replace(CONFIG["starfieldInstallLocation"], ".."))
            )
        if len(cFilesInstall) == 0:
            f.write("\tNone\n")

        if CONFIG["doTextureDataShift"]:
            f.write("Copying Textures from: "+ROOT + CONFIG["starfieldBaseBuildLocation"]+"\n")
            f.write("                 - to: "+ROOT + CONFIG["starfieldMyGameBuildLocation"]+"\n")

    print("\n\nHey You, Your finally awake!?\n.\n")
    time.sleep(2)
    print("Log written out, please check its going to do exactly what you are expecting")
    time.sleep(1)
    print("Opening the dryRunInstallation.log now...")
    time.sleep(2)
    os.system("notepad.exe {}dryRunInstallation.log".format(ROOT))
    proceed = input("Do you want to run the install now? (y/n): ")
    if proceed.lower() == "y":
        print("Beginning Transfer")
        runFileTransfer(CONFIG, False)
        print("All Files successfully transferred!")
        time.sleep(2)


def main():
    # Validate arguments
    if not (len(sys.argv) == 2 or len(sys.argv) == 1):
        print("got {} arguments, {}".format(len(sys.argv), sys.argv))
        print("# the following will log out what would be copied and where to './dryRunInstallation.log'")
        print("Usage via cmd: installMods.exe -dryRun")
        print("# the following will run the installation and overwrite all existing files")
        print("Usage via cmd: installMods.exe")
        print("Usage: run the exe as is")
        sys.exit(1)
    if len(sys.argv) == 2:
        dryRun = (sys.argv[1] == "-dryRun")
    else:
        dryRun = False

    # get config data
    CONFIG = getConfigData()

    if CONFIG["doBuildBeforeInstall"]:
        print("Rerunning BuildMods.exe")
        try:
            result = subprocess.run([ROOT+"apps/buildMods.exe"], capture_output=True, text=True, check=True)
            print(result.stdout)  # This will print stdout if the command succeeds
        except subprocess.CalledProcessError as e:
            print("Command returned non-zero exit status:", e.returncode)
            print("stdout:", e.stdout)
            print("stderr:", e.stderr)


    # do transfer if not dryrun mode
    if not dryRun:
        print("Beginning Transfer")
        runFileTransfer(CONFIG, False)
        print("All Files successfully transferred!")

    # do dry run transfer log
    else:
        results = runFileTransfer(CONFIG, True)
        doDryRun(CONFIG, results)
        return

    if CONFIG["doTextureDataShift"]:
        transferTextures(
            ROOT + CONFIG["starfieldBaseBuildLocation"],
            ROOT + CONFIG["starfieldMyGameBuildLocation"]
        )

    if CONFIG["doDeleteBuildAfterInstall"]:
        # wipe any existing build data
        if os.path.exists(ROOT+CONFIG["starfieldBaseBuildLocation"]+"/Data"):
            shutil.rmtree(ROOT+CONFIG["starfieldBaseBuildLocation"])
        if os.path.exists(ROOT+CONFIG["starfieldMyGameBuildLocation"]+"/Data"):
            shutil.rmtree(ROOT+CONFIG["starfieldMyGameBuildLocation"])
        if os.path.exists(ROOT+"build/build.log"):
            os.remove(ROOT.replace("/", "\\")+"build\\build.log")
    return

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        for line in traceback.format_exception(e):
            print(line)
    proceed = input("press Enter to exit...")