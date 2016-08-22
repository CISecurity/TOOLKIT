@echo off
cls
PUSHD %~dp0
SET BaseDir=%cd%
SET toolpath=%cd%\scripts\
color 0b
ECHO *****************************************************
ECHO	   	     .oooooo.   ooooo  .oooooo..o      
ECHO		    d8P'  `Y8b  `888' d8P'    `Y8      
ECHO		    888          888  Y88bo.           
ECHO		    888          888   `"Y8888o.       
ECHO		    888          888       `"Y88b      
ECHO		    `88b    ooo  888  oo     .d8P      
ECHO		     `Y8bood8P' o888o 8""88888P'  
ECHO *****************************************************
ECHO.-----------------------WARNING-----------------------
ECHO.
ECHO. This kit contains scripts that modify system settings.
ECHO. please use caution when using this tool.
ECHO.
ECHO. Welcome to The CIS ToolKIT Script. This script has been
ECHO. created to help users apply remediation to a standalone 
ECHO. system. please backup you local policy before applying
ECHO. any of the included remediation.
ECHO.  
ECHO. Press Ctrl+C to cancel at any time, or press any other 
ECHO  key to continue...
ECHO *****************************************************
ECHO. 
PAUSE > nul


:Main
cls
color 0b
ECHO CIS Toolkit Menu
ECHO.
ECHO 1 - Backup Local Security Policy
ECHO 2 - Apply CIS Remediation Kit
ECHO 3 - Restore Backup Local Security Policy
ECHO 4 - Exit
ECHO.
GOTO Mainvalues

:Mainvalues
SET /P "M=Enter your Selection:"
IF %M%==1 GOTO BACKUP
IF %M%==2 GOTO remediateopts
IF %M%==3 GOTO restoreopts
IF %M%==4 GOTO Close
color 0c
ECHO Please enter a valid number!
timeout /t 4
GOTO Main

:Exit
color 0b
ECHO.
ECHO.
ECHO Press 1 for Main Menu
ECHO Press 2 to Exit
ECHO.
SET /p "E=Enter your Selection:"
IF %E%==1 GOTO Main
IF %E%==2 GOTO Close
color 0c
ECHO Please enter a valid number!
timeout /t 4
cls
GOTO Exit


:Close
exit

:BACKUP
cd %BaseDir%
Tools\LGPO.exe /b "%BaseDir%\Backup"
GOTO Exit

::Start of restore option selection


:restoreopts
cls
color 0b
setlocal enabledelayedexpansion
ECHO Select the Backup you would like to restore:
ECHO Enter 0 to Go Back
ECHO.
ECHO.
set Index=1
for /d %%D in ("%BaseDir%\Backup\*") do (
  set Subfolders[!Index!]=%%D
  set /a Index+=1
)

set /a UBound=Index-1

for /l %%i in (1,1,%UBound%) do echo %%i. !Subfolders[%%i]!


:restorechoice
set /p Choice=Enter your Selection: 
if "%Choice%"=="" goto badrestorechoice
if %Choice% LSS 1 goto Main
if %Choice% GTR %UBound% goto badrestorechoice

set Subfolder=!Subfolders[%Choice%]!
goto ask

:ask
color 0b
ECHO You have selected to restore from: %Subfolder%
ECHO.
ECHO If this is corect Press Y,  if this is incorrect Press N
ECHO.
set /p "askagain=(Y/N):"
IF %askagain%==Y GOTO restore
IF %askagain%==y GOTO restore
IF %askagain%==N GOTO restoreopts
IF %askagain%==n GOTO restoreopts
else GOTO restoreopts
color 0c
ECHO Please enter a valid number!
timeout /t 4
cls
goto ask


:restore
cls
cd %BaseDir%
Tools\LGPO.exe /g "%Subfolder%"
goto Exit

:badrestorechoice
color 0c
ECHO Please enter a valid number!
timeout /t 4
cls
GOTO restoreopts

::End of restore option selection


:: Start of Remediation Selections and Application
:remediateopts
cls
color 0b
setlocal enabledelayedexpansion
ECHO Select the Remediation Kit you would like to apply:
ECHO Enter 0 to Go Back
ECHO.
set Index=1
cd %toolpath%
for /d %%D in ("*") do (
  set Subfolders[!Index!]=%%D
  set /a Index+=1
)

set /a UBound=Index-1

for /l %%i in (1,1,%UBound%) do echo %%i. !Subfolders[%%i]!

:remediate
set /p ChoiceR=Enter your Selection: 
if "%ChoiceR%"=="" goto badremediatechoice
if %ChoiceR% LSS 1 goto Main
if %ChoiceR% GTR %UBound% goto badremediatechoice

set Subfolder2=!Subfolders[%ChoiceR%]!
goto ask2

:ask2
color 0b
ECHO You have selected to remediate: %Subfolder2%
ECHO.
ECHO If this is corect Press Y,  if this is incorrect Press N
ECHO.
set /p "askagain2=(Y/N):"
IF %askagain2%==Y GOTO Profilecheck
IF %askagain2%==y GOTO Profilecheck
IF %askagain2%==N GOTO remediateopts
IF %askagain2%==n GOTO remediateopts
else GOTO remediateopts
color 0c
ECHO Please enter a valid number!
timeout /t 4
cls
goto ask2

:Profilecheck
if %Subfolder2%==Windows_10 GOTO ProfileClient
if %Subfolder2%==Windows_8.1 GOTO ProfileClient
if %Subfolder2%==Windows_7 GOTO ProfileClient
if %Subfolder2%==Windows_Server_2012_R2 GOTO ProfileServer
if %Subfolder2%==Windows_Server_2012 GOTO ProfileServer
if %Subfolder2%==Windows_Server_2008_R2 GOTO ProfileServer
if %Subfolder2%==Windows_Server_2008 GOTO ProfileServer
pause

:badremediatechoice
color 0c
ECHO Please enter a valid number!
timeout /t 4
cls
GOTO remediateopts


:ProfileClient
cls
color 0b
ECHO Select the Level Profile you would like to apply:
ECHO.
ECHO 1 - Level 1
ECHO 2 - Level 1 + Bitlocker
ECHO 3 - Level 2
ECHO 4 - Level 2 + Bitlocker
ECHO 5 - Go Back
GOTO ProfilevaluesClient

:ProfilevaluesClient
SET /P "G=Enter your Selection:"
IF %G%==1 SET "L=Level 1"
IF %G%==2 SET "L=Level 1 + Bitlocker"
IF %G%==3 SET "L=Level 2"
IF %G%==4 SET "L=Level 2 + Bitlocker"
IF %G%==5 GOTO remediateopts
if "%L%" EQU "Level 1" Goto L1ProfileDescription
if "%L%" EQU "Level 1 + Bitlocker" Goto L1BLProfileDescription
if "%L%" EQU "Level 2" Goto L2ProfileDescription
if "%L%" EQU "Level 2 + Bitlocker" Goto L2BLProfileDescription
color 0c
ECHO Please enter a valid number!
timeout /t 4
cls
GOTO ProfilevaluesClient


:ProfileServer
cls
color 0b
ECHO Select the Level Profile you would like to apply:
ECHO.
ECHO 1 - Domain Controller Level 1
ECHO 2 - Domain Controller Level 2
ECHO 3 - Member Server Level 1
ECHO 4 - Member Server Level 2
ECHO 5 - Go Back
GOTO ProfilevaluesServer

:ProfilevaluesServer
SET /P "G=Enter your Selection:"
IF %G%==1 SET "L=Level 1 - Domain Controller"
IF %G%==2 SET "L=Level 2 - Domain Controller"
IF %G%==3 SET "L=Level 1 - Member Server"
IF %G%==4 SET "L=Level 2 - Member Server"
IF %G%==5 GOTO remediateopts
if "%L%" EQU "Level 1 - Domain Controller" Goto DCL1ProfileDescription
if "%L%" EQU "Level 2 - Domain Controller" Goto DCL2ProfileDescription
if "%L%" EQU "Level 1 - Member Server" Goto MSL1ProfileDescription
if "%L%" EQU "Level 2 - Member Server" Goto MSL2ProfileDescription
color 0c
ECHO Please enter a valid number!
timeout /t 4
cls
GOTO ProfilevaluesServer




:L1ProfileDescription
echo.
echo Profile Description
echo.
echo. Items in this profile intend to:
echo.
echo. -be practical and prudent;
echo. -provide a clear security benefit; and
echo. -not inhibit the utility of the technology beyond acceptable means.
echo. 
echo.
echo. Press any key to apply this profile or Press Ctrl+C to stop the installation
echo.
PAUSE > nul
goto L1

:L1BLProfileDescription
echo.
echo Profile Description
echo.
echo. Items in this profile intend to:
echo.
echo. -be practical and prudent;
echo. -provide a clear security benefit; and
echo. -not inhibit the utility of the technology beyond acceptable means.
echo. -include Bitlocker specific Settings.
echo.
echo.
echo. Press any key to apply this profile or Press Ctrl+C to stop the installation
echo.
PAUSE > nul
goto L1BL

:L2ProfileDescription
echo.
echo Profile Description
echo.
echo. This profile extends the "Level 1" profile. Items in this profile exhibit one or more echo. of the following characteristics:
echo.
echo. -are intended for environments or use cases where security is paramount.
echo. -acts as defense in depth measure.
echo. -may negatively inhibit the utility or performance of the technology.
echo.
echo.
echo. Press any key to apply this profile or Press Ctrl+C to stop the installation
echo.
PAUSE > nul
goto L2L1


:L2BLProfileDescription
echo.
echo Profile Description
echo.
echo. This profile extends the "Level 1" profile. Items in this profile exhibit one or more echo. of the following characteristics:
echo.
echo. -are intended for environments or use cases where security is paramount.
echo. -acts as defense in depth measure.
echo. -may negatively inhibit the utility or performance of the technology.
echo. -include Bitlocker specific Settings
echo.
echo.
echo. Press any key to apply this profile or Press Ctrl+C to stop the installation
echo.
PAUSE > nul
goto L2BL

::Start Of Server Profile Description

:MSL1ProfileDescription
echo.
echo Profile Description
echo.
echo. Items in this profile intend to:
echo.
echo. -be practical and prudent;
echo. -provide a clear security benefit; and
echo. -not inhibit the utility of the technology beyond acceptable means.
echo. 
echo.
echo. Press any key to apply this profile or Press Ctrl+C to stop the installation
echo.
PAUSE > nul
goto MSL1


:DCL1ProfileDescription
echo.
echo Profile Description
echo.
echo. Items in this profile intend to:
echo.
echo. -be practical and prudent;
echo. -provide a clear security benefit; and
echo. -not inhibit the utility of the technology beyond acceptable means.
echo. 
echo.
echo. Press any key to apply this profile or Press Ctrl+C to stop the installation
echo.
PAUSE > nul
goto MSL1

:MSL2ProfileDescription
echo.
echo Profile Description
echo.
echo. This profile extends the "Level 1" profile. Items in this profile exhibit one or more echo. of the following characteristics:
echo.
echo. -are intended for environments or use cases where security is paramount.
echo. -acts as defense in depth measure.
echo. -may negatively inhibit the utility or performance of the technology.
echo.
echo.
echo. Press any key to apply this profile or Press Ctrl+C to stop the installation
echo.
PAUSE > nul
goto MSL2L1


:DCL2ProfileDescription
echo.
echo Profile Description
echo.
echo. This profile extends the "Level 1" profile. Items in this profile exhibit one or more echo. of the following characteristics:
echo.
echo. -are intended for environments or use cases where security is paramount.
echo. -acts as defense in depth measure.
echo. -may negatively inhibit the utility or performance of the technology.
echo.
echo.
echo. Press any key to apply this profile or Press Ctrl+C to stop the installation
echo.
PAUSE > nul
goto DCL2L1

::End of Server Profile Description


:L1
cd %toolpath%
echo.
LGPO.exe /m "%Subfolder2%\Level_1\comp_registry.pol" /s "%Subfolder2%\Level_1\GptTmpl.inf" /ac "%Subfolder2%\Level_1\audit.csv" /u "%Subfolder2%\Level_1\user_registry.pol"
echo.
echo. The Level 1 Remediation has been applied.. please restart the system.
echo.
echo.
Goto Exit

:L1BL
cd %toolpath%
echo.
LGPO.exe /m "%Subfolder2%\Level_1\comp_registry.pol" /s "%Subfolder2%\Level_1\GptTmpl.inf" /ac "%Subfolder2%\Level_1\audit.csv" /u "%Subfolder2%\Level_1\user_registry.pol" 
echo.
echo. The Level 1 Remediation has been applied.. Press any key to apply Bitlocker settings.
echo.
PAUSE > nul
echo.
Goto BL

:BL
cd %toolpath%
echo.
LGPO.exe /m "%Subfolder2%\Bitlocker\registry.pol" /s "%Subfolder2%\Bitlocker\GptTmpl.inf"  
echo.
echo. The Bitlocker settings have been applied.. please restart the system.
echo.
echo.
Goto Exit

:L2L1
cd %toolpath%
echo.
LGPO.exe /m "%Subfolder2%\Level_1\comp_registry.pol" /s "%Subfolder2%\Level_1\GptTmpl.inf" /ac "%Subfolder2%\Level_1\audit.csv" /u "%Subfolder2%\Level_1\user_registry.pol"
echo.
echo. The Level 1 Remediation has been applied.. please any key to apply Level 2 settings.
echo.
PAUSE > nul
echo.
Goto L2

:L2
set toolpath=%CD%
echo.
LGPO.exe /m "%Subfolder2%\Level_2\comp_registry.pol" /s "%Subfolder2%\Level_2\GptTmpl.inf" /u "%Subfolder2%\Level_2\user_registry.pol" 
echo.
echo. The Level 2 Remediation has been applied.. please restart the system.
echo.
echo.
Goto Exit

:L2BL
set toolpath=%CD%
echo.
LGPO.exe /m "%Subfolder2%\Bitlocker\registry.pol" /s "%Subfolder2%\Bitlocker\GptTmpl.inf"  
echo.
echo. Level 2 Bitlocker settings have been applied. . Press any key to apply remaining settings.
echo.
PAUSE > nul
echo.
Goto L2L1

:: Start of Member Server Application
:MSL1
cd %toolpath%
echo.
LGPO.exe /m "%Subfolder2%\MS\Level_1\comp_registry.pol" /s "%Subfolder2%\MS\Level_1\GptTmpl.inf" /ac "%Subfolder2%\MS\Level_1\audit.csv" /u "%Subfolder2%\MS\Level_1\user_registry.pol"
echo.
echo. The Level 1 Remediation has been applied.. please restart the system.
echo.
echo.
Goto Exit

:MSL2L1
cd %toolpath%
echo.
LGPO.exe /m "%Subfolder2%\MS\Level_1\comp_registry.pol" /s "%Subfolder2%\MS\Level_1\GptTmpl.inf" /ac "%Subfolder2%\MS\Level_1\audit.csv" /u "%Subfolder2%\MS\Level_1\user_registry.pol"
echo.
echo. The Level 1 Remediation has been applied.. please any key to apply Level 2 settings.
echo.
PAUSE > nul
echo.
Goto L2

:MSL2
set toolpath=%CD%
echo.
LGPO.exe /m "%Subfolder2%\MS\Level_2\comp_registry.pol" /s "%Subfolder2%\MS\Level_2\GptTmpl.inf" /u "%Subfolder2%\MS\Level_2\user_registry.pol" 
echo.
echo. The Level 2 Remediation has been applied.. please restart the system.
echo.
echo.
Goto Exit

:: End of Member server Application

:: Start of Domain Controller Application

:DCL1
cd %toolpath%
echo.
LGPO.exe /m "%Subfolder2%\DC\Level_1\comp_registry.pol" /s "%Subfolder2%\DC\Level_1\GptTmpl.inf" /ac "%Subfolder2%\DC\Level_1\audit.csv" /u "%Subfolder2%\DC\Level_1\user_registry.pol"
echo.
echo. The Level 1 Remediation has been applied.. please restart the system.
echo.
echo.
Goto Exit

:DCL2L1
cd %toolpath%
echo.
LGPO.exe /m "%Subfolder2%\DC\Level_1\comp_registry.pol" /s "%Subfolder2%\DC\Level_1\GptTmpl.inf" /ac "%Subfolder2%\DC\Level_1\audit.csv" /u "%Subfolder2%\DC\Level_1\user_registry.pol"
echo.
echo. The Level 1 Remediation has been applied.. please any key to apply Level 2 settings.
echo.
PAUSE > nul
echo.
Goto L2

:DCL2
set toolpath=%CD%
echo.
LGPO.exe /m "%Subfolder2%\DC\Level_2\comp_registry.pol" /s "%Subfolder2%\DC\Level_2\GptTmpl.inf" /u "%Subfolder2%\DC\Level_2\user_registry.pol" 
echo.
echo. The Level 2 Remediation has been applied.. please restart the system.
echo.
echo.
Goto Exit

::End of Domain Controller Application


::End of Remediation Selections and Application
