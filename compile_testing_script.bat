@echo off
setlocal enabledelayedexpansion
set ROOT_DIR=%~dp0

FOR /F "usebackq tokens=*" %%i IN (`powershell -command "$json = Get-Content -Raw -Path %ROOT_DIR%config.json | ConvertFrom-Json; $json.starfieldCompileOutputLocation"`) DO SET starfieldCompileOutputLocation="!ROOT_DIR!%%i"
FOR /F "usebackq tokens=*" %%i IN (`powershell -command "$json = Get-Content -Raw -Path %ROOT_DIR%config.json | ConvertFrom-Json; $json.starfieldFlagsLocation"`) DO SET starfieldFlagsLocation="!ROOT_DIR!%%i"
FOR /F "usebackq tokens=*" %%i IN (`powershell -command "$json = Get-Content -Raw -Path %ROOT_DIR%config.json | ConvertFrom-Json; $json.pscModsPath"`) DO SET pscModsPath="!ROOT_DIR!%%i"
FOR /F "usebackq tokens=*" %%i IN (`powershell -command "$json = Get-Content -Raw -Path %ROOT_DIR%config.json | ConvertFrom-Json; $json.starfieldDecompiledScriptsLocation"`) DO SET starfieldDecompiledScriptsLocation="!ROOT_DIR!%%i"

IF NOT EXIST %starfieldCompileOutputLocation% (
  mkdir %starfieldCompileOutputLocation%
)

for /f "delims=" %%i in ('powershell -Command "[System.Reflection.Assembly]::LoadWithPartialName('System.windows.forms') | Out-Null; $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog; $OpenFileDialog.InitialDirectory = '!pscModsPath!'; $OpenFileDialog.Filter = 'PSC Files (*.psc)|*.psc'; $OpenFileDialog.ShowDialog() | Out-Null; $OpenFileDialog.FileName"') do set "selectedFile=%%i"

echo Compiling !selectedFile!

%ROOT_DIR%apps\Caprica.exe --game starfield --import "%starfieldDecompiledScriptsLocation%" --flags "%starfieldFlagsLocation%" --output "%starfieldCompileOutputLocation%" "!selectedFile!"
echo ------------------------------------------
echo .                                        .
echo --------------- Finished -----------------
echo .                                        .
echo ------------------------------------------
echo Completed Compiling !selectedFile!
endlocal
pause