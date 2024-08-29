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
reg delete HKCU\Software\Stardock /f

echo Detecting Stardock Installations...

set "reset_trial="
for %%A in ("C:\ProgramData\Stardock\WindowBlinds|WB11Config.exe|WindowBlinds 11", "C:\ProgramData\Stardock\Start11|Start11Config.exe|Start11") do (
    for /f "tokens=1-3 delims=|" %%B in ("%%A") do (
        if exist "%%B" (
            echo   %%D detected
            tasklist | findstr "%%C" > nul
            if errorlevel 1 (
                rmdir /s /q "%%B"
                echo   %%D trial license has been reset
                set "reset_trial=1"
            ) else (
                echo Please exit %%D before running this script
            )
        )
    )
)

if not defined reset_trial (
    echo No Stardock installations detected or trial reset was unsuccessful.
)

echo Done, start new trial with temp email @ https://temp-mail.org or https://sharklasers.com
pause
