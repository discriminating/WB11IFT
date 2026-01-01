@echo off

:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------    

@echo off

set "WB_DIR=C:\ProgramData\Stardock\WindowBlinds"
set "WB_EXE=WB11Config.exe"

tasklist /FI "IMAGENAME eq %WB_EXE%" 2>NUL | find /I "%WB_EXE%" >NUL

if errorlevel 1 (
    if exist "%WB_DIR%" (
        echo Deleting %WB_DIR%...
        rmdir /s /q "%WB_DIR%"
        mkdir "%WB_DIR%"
        echo Done.
    ) else (
        echo Directory not found.
    )
) else (
    echo Please exit WindowBlinds before running this script.
	pause
	exit /B
)

reg delete HKCU\Software\Stardock /f

echo Done, start new trial with temp email @ https://temp-mail.org or https://sharklasers.com.

pause
