# Instructions for setting up the VEnv

1. **Modify the 3 variables in the config.ini:**
   - root, This is the location you cloned the repo to, including the root sf_mods or sf_mods-master folder if you unzip instead
   - starfieldInstallLocation, This is the folder where you have installed the game, the folder here should contain "Starfield.exe"
   - starfieldMyGamesLocation, This is the location to your "My Games" starfield game, the folder here should contain "starfieldPrefs.ini"
 
2. **run setup_venv.bat**
   - This goes through the process of setting up the virtual environment for modding
   - It downloads multiple tools and bits you will need into the ".\apps" folder and ".\reference" folder

3. **after setup has completed, you can modify/add:**
   - ini files in the ".\src\ini_mods\[iniFileName.ini]" folders. each group of modifications you make can be separated into separate ini files named what it does, later on we can merge these all together with another tool.
   - psc files in the ".src\psc_mods\" folder

4. **Make Mods**
   - You can test compile a single papyrus script using "compile_testing_script.bat", it will either ask what file to compile, or ask if you want to use the last compiled file.
   - Any errors will be printed in the shell, if successful the .pex file will be located in ".\build\Data\scripts"

5. **Test Compile Your Papyrus Scripts** 
   - You can compile a specific psc file by using "compile_testing_script.bat" after running it, you will be able to choose the script to compile.
   - It will be compiled into the build location.

6. **Build your Mods**
   - you can build all the mods you have generated using ".\apps\buildMods.exe"
     - This tool goes through all the separate ini files and merges them all into the appropriate files in the ".\build" folder
     - **(Opt-out in the config.ini)** it will run the Compile All papyrus Scripts just in case there were changes made that may have been skipped
     - it will copy all files in the ".\src\my_games_data_mods\" into the ".\build\MyGames-Data" folder
     - it will copy all files in the ".\src\base_data_mods\" into the ".build\Data" folder

7. **install the built mods**
   - you can install all the mods you have generated using "install_mods.bat"
   - it will copy All the built mod files in the ".\build\" folder and replace any existing files in the 2 game locations: starfieldInstallLocation and starfieldMyGamesLocation
   - **(Opt-out in the config.ini)** it will copy all texture related mods from the installed location to the My Games location to fix the issue with them not working in the install location

8. **PROFIT!**

Below are instructions around the variables in the config.json:

**NOTE: Make sure to match all trailing backslashes as it is shown below**
```{
  // This is the folder where you have installed the game, the folder here should contain "Starfield.exe"
  "starfieldInstallLocation": "D:\Generic Library\Starfield\Starfield-Modded",

  // This is the location to your "My Games" starfield game, the folder here should contain "starfieldPrefs.ini"
  "starfieldMyGamesLocation": "D:\Documents\My Games\Starfield",

  // (Optional, if wanting to alter the py files) only required for src\python_tools\BuildPythonCompilers.bat
  // Python 3.9+ is required, pyinstaller is also needed, use 'pip install pyinstaller', set the path below to the Scripts folder containing pyinstaller.exe
  "pyinstallerLocation": "C:\Users\Daniel\AppData\Roaming\Python\Python310\Scripts",


  // ----------------- buildMods.exe options below --------------------------

  // (default: false), when installing all the mods made, do you want to re-run the tool to catch recent changes?
  //     having this set to false means it will run it, which may result in errors while compiling meaning the changes will not get sent!
  "skipPSC_MassCompile": false,

  // ----------------- installMods.exe options below --------------------------

  // (default: true), fix for issues where textures need to be in the My Games\Starfield\Data folder, so this will COPY them from the install location
  //     after transferring all the build files NOTE: this will affect ALL existing mod textures, ie: installed mods from Vortex etc, they will be copied over too!
  "doTextureDataShift": true,

  // (default: true), set to false if you want to just build separately and not run the build script in the installMods.exe
  //     this respects the skipPSC_MassCompile build option when building with installing
  "doBuildBeforeInstall": true,

  // (default: true), set to true if you want to clean up the build folder after installing the mods.
  "doDeleteBuildAfterInstall": true

  // -----------------------------------------------------------------------------
  // --- below are all internal config variables, you shouldn't need to change ---
  // --- these unless you want to change the structure of the modding folders  ---
  // -----------------------------------------------------------------------------

  "baseDataModsPath": "src\base_data_mods\",
  "gamesDataModsPath": "src\my_games_data_mods\",
  "iniModsPath": "src\ini_mods\",
  "pscModsPath": "src\psc_mods\",
  "baseModsPath": "src\base_mods\",
  "starfieldFlagsLocation": "reference\Starfield_Papyrus_Flags.flg",
  "starfieldDecompiledScriptsLocation": "reference\StarfieldScriptsReference",
  "starfieldCompileOutputLocation": "build\installDir_Starfield\Data\scripts",
  "starfieldBaseBuildLocation": "build\installDir_Starfield",
  "starfieldMyGameBuildLocation": "build\MyGames_Starfield",

  // -----------------------------------------------------------------------------
  // ----- Thirdparty applications and files required for the initial setup  -----
  // ----- installation process                                              -----
  // -----------------------------------------------------------------------------

  "capricaUrl" "https://github.com/Orvid/Caprica/suites/16483071879/artifacts/941884665",
  "sevenZipUrl" "https://www.7-zip.org/a/7z2301-x64.exe",
  "champollionUrl" "https://github.com/Orvid/Champollion/releases/download/v1.3.1/Champollion.1.3.1.7z",
  "starfieldFlagsUrl" "https://raw.githubusercontent.com/Orvid/Caprica/9cd6d32ec2750adae329e81f7276dac95251e000/test/Starfield_Papyrus_Flags.flg",
  "baeManualUrl" "https://www.nexusmods.com/starfield/mods/165?tab: files&file_id: 775",
}```
