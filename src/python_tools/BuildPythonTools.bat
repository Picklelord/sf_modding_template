
FOR /F "usebackq tokens=*" %%i IN (`powershell -command "$json = Get-Content -Raw -Path %~dp0..\..\config.json | ConvertFrom-Json; $json.pyinstallerLocation"`) DO SET pyinstallerLocation=%%i
echo %pyinstallerLocation%\pyinstaller
%pyinstallerLocation%\pyinstaller --onefile %~dp0\buildMods.py
%pyinstallerLocation%\pyinstaller --onefile %~dp0\installMods.py
@echo off
move dist\buildMods.exe ..\..\apps\buildMods.exe
move dist\installMods.exe ..\..\apps\installMods.exe
rmdir /s /q %~dp0\build
del %~dp0\buildMods.spec
del %~dp0\installMods.spec
rmdir /s /q %~dp0\dist
echo .
echo .
echo Compiled Python Tools Successfully, you can find them here:
echo - .\apps\buildMods.exe
echo - .\apps\installMods.exe
pause