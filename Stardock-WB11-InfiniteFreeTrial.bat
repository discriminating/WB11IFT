@echo off

:: BatchGotAdmin
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
tasklist | findstr "WB11Config.exe" > nul
if errorlevel 1 (
    echo WBConfig11.exe is not running, continuing...
    echo [1/3] Removing AppData\Local\Stardock...
    rmdir /s /q "C:\Users\%USERNAME%\AppData\Local\Stardock"
    echo [2/3] Removing ProgramData\Stardock\WindowBlinds
    rmdir /s /q "C:\ProgramData\Stardock\WindowBlinds"
    echo [3/3] Removing HKEY_CURRENT_USER\Software\Stardock
    reg delete HKCU\Software\Stardock /f

    echo Done! Launch Stardock and start your free trial again. You can use the same email.
) else (
    echo Please close WindowBlinds 11 Config menu.
)

pause
