@echo off
setlocal ENABLEDELAYEDEXPANSION
set ROOT_DIR=%~dp0
FOR /F "usebackq tokens=*" %%i IN (`powershell -command "$json = Get-Content -Raw -Path %ROOT_DIR%config.json | ConvertFrom-Json; $json.starfieldInstallLocation"`) DO SET starfieldInstallLocation="!ROOT_DIR!%%i"
FOR /F "usebackq tokens=*" %%i IN (`powershell -command "$json = Get-Content -Raw -Path %ROOT_DIR%config.json | ConvertFrom-Json; $json.starfieldMyGamesLocation"`) DO SET starfieldMyGamesLocation="!ROOT_DIR!%%i"
FOR /F "usebackq tokens=*" %%i IN (`powershell -command "$json = Get-Content -Raw -Path %ROOT_DIR%config.json | ConvertFrom-Json; $json.iniModsPath"`) DO SET iniModsPath="!ROOT_DIR!%%i"
FOR /F "usebackq tokens=*" %%i IN (`powershell -command "$json = Get-Content -Raw -Path %ROOT_DIR%config.json | ConvertFrom-Json; $json.starfieldDecompiledScriptsLocation"`) DO SET starfieldDecompiledScriptsLocation="!ROOT_DIR!%%i"
FOR /F "usebackq tokens=*" %%i IN (`powershell -command "$json = Get-Content -Raw -Path %ROOT_DIR%config.json | ConvertFrom-Json; $json.sevenZipUrl"`) DO SET sevenZipUrl=%%i
FOR /F "usebackq tokens=*" %%i IN (`powershell -command "$json = Get-Content -Raw -Path %ROOT_DIR%config.json | ConvertFrom-Json; $json.capricaUrl"`) DO SET capricaUrl=%%i
FOR /F "usebackq tokens=*" %%i IN (`powershell -command "$json = Get-Content -Raw -Path %ROOT_DIR%config.json | ConvertFrom-Json; $json.champollionUrl"`) DO SET champollionUrl=%%i
FOR /F "usebackq tokens=*" %%i IN (`powershell -command "$json = Get-Content -Raw -Path %ROOT_DIR%config.json | ConvertFrom-Json; $json.starfieldFlagsUrl"`) DO SET starfieldFlagsUrl=%%i
FOR /F "usebackq tokens=*" %%i IN (`powershell -command "$json = Get-Content -Raw -Path %ROOT_DIR%config.json | ConvertFrom-Json; $json.baeManualUrl"`) DO SET baeManualUrl=%%i

echo ----------------------------------------
echo Collecting existing INI files from Game Install
IF EXIST "!starfieldMyGamesLocation:"=!\StarfieldCustom.ini" && NOT EXISTS "!iniModsPath:"=!StarfieldCustom.ini\original.ini" (
  echo Making a copy of the existing StarfieldCustom.ini to be used in compiling
  if not exist "!iniModsPath:\StarfieldCustom.ini\" mkdir "!iniModsPath:\StarfieldCustom.ini\"
  echo F|xcopy /Y /E "!starfieldMyGamesLocation:"=!\StarfieldCustom.ini" "!iniModsPath:"=!StarfieldCustom.ini\original.ini"
)
IF EXIST "!starfieldMyGamesLocation:"=!\StarfieldPrefs.ini" && NOT EXISTS "!iniModsPath:"=!StarfieldPrefs.ini\original.ini"(
  echo Making a copy of the existing StarfieldPrefs.ini to be used in compiling
  if not exist "!iniModsPath:\StarfieldPrefs.ini\" mkdir "!iniModsPath:\StarfieldPrefs.ini\"
  echo F|xcopy /Y /E "!starfieldMyGamesLocation:"=!\StarfieldPrefs.ini" "!iniModsPath:"=!StarfieldPrefs.ini\original.ini"
)
IF EXIST "!starfieldMyGamesLocation:"=!\StarfieldHotkeys.ini" && NOT EXISTS "!iniModsPath:"=!StarfieldHotkeys.ini\original.ini"(
  echo Making a copy of the existing StarfieldHotkeys.ini to be used in compiling
  if not exist "!iniModsPath:\StarfieldHotkeys.ini\" mkdir "!iniModsPath:\StarfieldHotkeys.ini\"
  echo F|xcopy /Y /E "!starfieldMyGamesLocation:"=!\StarfieldHotkeys.ini" "!iniModsPath:"=!StarfieldHotkeys.ini\original.ini"
)
IF EXIST "!starfieldInstallLocation:"=!\Starfield.ini" && NOT EXISTS "!iniModsPath:"=!Starfield.ini\original.ini"(
  echo Making a copy of the existing Starfield.ini to be used in compiling
  if not exist "!iniModsPath:\Starfield.ini\" mkdir "!iniModsPath:\Starfield.ini\"
  echo F|xcopy /Y /E "!starfieldInstallLocation:"=!\Starfield.ini" "!iniModsPath:"=!Starfield.ini\original.ini"
)
IF EXIST "!starfieldInstallLocation:"=!\StartingCommands.txt" && NOT EXISTS "!iniModsPath:"=!StartingCommands.txt\original.txt"(
  echo Making a copy of the existing StartingCommands.txt to be used in compiling
  if not exist "!iniModsPath:\StartingCommands.txt\" mkdir "!iniModsPath:\StartingCommands.txt\"
  echo F|xcopy /Y /E "!starfieldInstallLocation:"=!\StartingCommands.txt" "!iniModsPath:"=!StartingCommands.txt\original.txt"
)

IF EXIST "!starfieldInstallLocation:"=!\Low.ini" && NOT EXISTS "!iniModsPath:"=!Low.ini\original.ini"(
  echo Making a copy of the existing Starfield.ini to be used in compiling
  if not exist "!iniModsPath:\Low.ini\" mkdir "!iniModsPath:\Low.ini\"
  echo F|xcopy /Y /E "!starfieldInstallLocation:"=!\Low.ini" "!iniModsPath:"=!Low.ini\original.ini"
)
IF EXIST "!starfieldInstallLocation:"=!\Medium.ini" && NOT EXISTS "!iniModsPath:"=!Medium.ini\original.ini"(
  echo Making a copy of the existing Starfield.ini to be used in compiling
  if not exist "!iniModsPath:\Medium.ini\" mkdir "!iniModsPath:\Medium.ini\"
  echo F|xcopy /Y /E "!starfieldInstallLocation:"=!\Medium.ini" "!iniModsPath:"=!Medium.ini\original.ini"
)
IF EXIST "!starfieldInstallLocation:"=!\High.ini" && NOT EXISTS "!iniModsPath:"=!High.ini\original.ini"(
  echo Making a copy of the existing Starfield.ini to be used in compiling
  if not exist "!iniModsPath:\High.ini\" mkdir "!iniModsPath:\High.ini\"
  echo F|xcopy /Y /E "!starfieldInstallLocation:"=!\High.ini" "!iniModsPath:"=!High.ini\original.ini"
)
IF EXIST "!starfieldInstallLocation:"=!\Ultra.ini" && NOT EXISTS "!iniModsPath:"=!Ultra.ini\original.ini"(
  echo Making a copy of the existing Starfield.ini to be used in compiling
  if not exist "!iniModsPath:\Ultra.ini\" mkdir "!iniModsPath:\Ultra.ini\"
  echo F|xcopy /Y /E "!starfieldInstallLocation:"=!\Ultra.ini" "!iniModsPath:"=!Ultra.ini\original.ini"
)



echo ----------------------------------------
echo Attempting to install Caprica.exe
IF NOT EXIST %ROOT_DIR%apps\Caprica.exe (
  powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $response = [System.Windows.Forms.MessageBox]::Show('We need you to manually download the Caprica.exe Artifact and place it into the .apps\ directory, click Ok and we will attempt to download it. Install it in and give further instructions in the console.', 'Manual Download Required', [System.Windows.Forms.MessageBoxButtons]::Ok"
  echo Unable to automatically download the Caprica Artifact, please install it manually
  echo Attempting to download it now, if it doesnt download, download it here:
  echo %capricaUrl%
  echo Place it here: "%ROOT_DIR%apps\Caprica.exe"
  start "" "%capricaUrl%"
  start explorer.exe "%USERPROFILE%\Downloads"
  set /p userinput="Have you placed the Caprica.exe in the location specified above? (Y): "
) ELSE (
  echo Caprica Found!
)

echo ----------------------------------------
echo Attempting to install 7z.exe
IF NOT EXIST %ROOT_DIR%apps\7z.exe (
  IF EXIST "C:\Program Files\7-Zip\7z.exe" (
    set sevenZipLocation="C:\Program Files\7-Zip\"
    echo 7z Found!
  ) ELSE (
    call bitsadmin /transfer 7z_Download %sevenZipUrl% %ROOT_DIR%cache\7z.exe
    start %ROOT_DIR%cache\7z.exe
    set /p userinput="Have you installed 7z.exe? (Y): "
    del %ROOT_DIR%cache\7z.exe
  )
) ELSE (
  echo 7z Found!
)

echo ----------------------------------------
echo Attempting to install Champollion.exe
IF NOT EXIST %ROOT_DIR%apps\Champollion.exe (
  call bitsadmin /transfer Champollion_Download %champollionUrl% %ROOT_DIR%cache\Champollion.7z
  %sevenZipLocation%7z.exe e %ROOT_DIR%cache\Champollion.7z Champollion.exe -o%ROOT_DIR%apps\ Champollion.exe
  del %ROOT_DIR%cache\Champollion.7z
) ELSE (
  echo Champollion Found!
)

echo ----------------------------------------
echo Attempting to install Starfield_Papyrus_Flags.flg
IF NOT EXIST %ROOT_DIR%reference\Starfield_Papyrus_Flags.flg (
  call bitsadmin /transfer Starfield_Papyrus_Flags_Download %starfieldFlagsUrl% %ROOT_DIR%reference\Starfield_Papyrus_Flags.flg
) ELSE (
  echo Starfield_Papyrus_Flags.flg Found!
)

echo ----------------------------------------
echo Check for install of bae.exe
IF NOT EXIST %ROOT_DIR%apps\BAE\bae.exe (
  echo BAE not installed, requires manual install..
  powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $response = [System.Windows.Forms.MessageBox]::Show('We need you to manually download BAE and install it into the .apps\ directory, click Ok and we will open the URL and folder to install it in and give further instructions in the console.', 'Manual Download Required', [System.Windows.Forms.MessageBoxButtons]::Ok"
  echo You can manually download from: %baeManualUrl%
  echo The extracted BAE folder should be placed into: %ROOT_DIR%apps
  echo Once placed there, the bae should be located in: %ROOT_DIR%apps\BAE\bae.exe
  START "" %baeManualUrl%
  Start explorer.exe "%ROOT_DIR%apps"
  set /p userinput="Have you downloaded and placed the BAE folder in the location specified above? (Y): "
) ELSE (
  echo BAE installation found!
)

echo ----------------------------------------
echo Check for Decompiled Starfield Scripts
IF NOT EXIST %starfieldDecompiledScriptsLocation%\fragments (
  IF NOT EXIST %ROOT_DIR%cache\scripts (
    echo Starfields base Scripts have not been extracted, requires manual extraction..
    powershell -Command "Add-Type -AssemblyName System.Windows.Forms; $response = [System.Windows.Forms.MessageBox]::Show('We need you to manually download BAE and install it into the .apps\ directory, click Ok and we will open the URL and folder to install it in and give further instructions in the console.', 'Manual Download Required', [System.Windows.Forms.MessageBoxButtons]::Ok"
    echo You can manually extract the scripts by dragging "!starfieldInstallLocation!\Data\Starfield - Misc.ba2"
    echo The folder these should be extracted into is: %ROOT_DIR%cache
    START %ROOT_DIR%apps\BAE\bae.exe
    Start explorer.exe "!starfieldInstallLocation!\Data\Starfield - Misc.ba2"
    Start explorer.exe "%ROOT_DIR%cache"
    set /p userinput="Have you Dragged the 'Starfield - Misc.ba2' file into BAE and extracted to the cache location specified? (Y): "
  ) ELSE (
    echo Starfield pex Scripts found in cache!
  )
) ELSE (
  echo StarfieldScriptReference found!
)

echo ----------------------------------------
echo Check for, and if not found, Decompile all Starfield Scripts
IF NOT EXIST %starfieldDecompiledScriptsLocation%\fragments (

  %ROOT_DIR%apps\Champollion.exe -r -d -p "%starfieldDecompiledScriptsLocation%"                      "%ROOT_DIR%cache\scripts\*.pex"
  %ROOT_DIR%apps\Champollion.exe -r -d -p "%starfieldDecompiledScriptsLocation%\fx"                   "%ROOT_DIR%cache\scripts\fx\*.pex"
  %ROOT_DIR%apps\Champollion.exe -r -d -p "%starfieldDecompiledScriptsLocation%\fxscripts"            "%ROOT_DIR%cache\scripts\fxscripts\*.pex"
  %ROOT_DIR%apps\Champollion.exe -r -d -p "%starfieldDecompiledScriptsLocation%\nativeterminal"       "%ROOT_DIR%cache\scripts\nativeterminal\*.pex"
  %ROOT_DIR%apps\Champollion.exe -r -d -p "%starfieldDecompiledScriptsLocation%\fragments"            "%ROOT_DIR%cache\scripts\fragments\*.pex"
  %ROOT_DIR%apps\Champollion.exe -r -d -p "%starfieldDecompiledScriptsLocation%\fragments\packages"   "%ROOT_DIR%cache\scripts\fragments\packages\*.pex"
  %ROOT_DIR%apps\Champollion.exe -r -d -p "%starfieldDecompiledScriptsLocation%\fragments\perks"      "%ROOT_DIR%cache\scripts\fragments\perks\*.pex"
  %ROOT_DIR%apps\Champollion.exe -r -d -p "%starfieldDecompiledScriptsLocation%\fragments\quests"     "%ROOT_DIR%cache\scripts\fragments\quests\*.pex"
  %ROOT_DIR%apps\Champollion.exe -r -d -p "%starfieldDecompiledScriptsLocation%\fragments\scenes"     "%ROOT_DIR%cache\scripts\fragments\scenes\*.pex"
  %ROOT_DIR%apps\Champollion.exe -r -d -p "%starfieldDecompiledScriptsLocation%\fragments\terminals"  "%ROOT_DIR%cache\scripts\fragments\terminals\*.pex"
  %ROOT_DIR%apps\Champollion.exe -r -d -p "%starfieldDecompiledScriptsLocation%\fragments\topicinfos" "%ROOT_DIR%cache\scripts\fragments\topicinfos\*.pex"

)
echo ----------------------------------------
echo Removing Cached Starfield Pex Scripts
IF EXIST %ROOT_DIR%cache\misc (
  rmdir /s /q "%ROOT_DIR%cache\misc"
)
IF EXIST %ROOT_DIR%cache\scripts (
  rmdir /s /q "%ROOT_DIR%cache\scripts"
)
IF EXIST %ROOT_DIR%cache\space (
  rmdir /s /q "%ROOT_DIR%cache\space"
)

echo ----------------------------------------
echo Build INI and TXT python compilers
cd %ROOT_DIR%src\python_tools\
try(
  call %ROOT_DIR%src\python_tools\BuildPythonTools.bat
) except (
  echo Python 3.9+ is required to build the Python Compilers to exe's
  echo Please install python 3.9+ to continue
  echo Then run 'pip install pyinstaller'
  echo Re-run this setup and it will build the python compilers needed.
)


echo ----------------------------------------
echo Successfully setup the Modding environment!
echo Have fun modding!
endlocal
pause