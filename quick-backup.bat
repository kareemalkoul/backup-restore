

@echo off
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
echo This bat file offer backup and restore the Drivers of your Device
echo This simple bat file created by kareem alkoul
echo 1-backup
echo 2-restore

CHOICE /N /C:12 /M "Choose :"
set datetimef=%date:~-4,4%-%date:~4,2%-%date:~7,2%-%time:~0,2%-%time:~3,2%
IF errorlevel  2 GOTO Restore
IF errorlevel  1 GOTO Backup
:Backup
set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'choose folder to put the backup inside it',0,0).self.path""
for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"
set folder_backup=%folder%\Driver-Backup-%datetimef%
if not exist "%folder_backup%" ( mkdir "%folder_backup%" ) else rmdir /s /q %folder_backup%
dism /online /export-driver /destination:"%folder_backup%"
GOTO End

:Restore
set "psCommand="(new-object -COM 'Shell.Application')^
.BrowseForFolder(0,'choose driver''s folder to restore it',0,0).self.path""
for /f "usebackq delims=" %%I in (`powershell %psCommand%`) do set "folder=%%I"
pnputil /add-driver "%folder%\*.inf" /subdirs /install /reboot
GOTO End
:End
pause



