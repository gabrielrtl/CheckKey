::::::::::::::::::::::::::::::::::::::::::::
:: Verifica e eleva os direitos de admin
::::::::::::::::::::::::::::::::::::::::::::
@echo off
CLS
ECHO.
ECHO =============================
ECHO Rodando a shell em Admin
ECHO =============================
cls

:init
setlocal DisableDelayedExpansion
set cmdInvoke=1
set winSysFolder=System32
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
ECHO.
ECHO **************************************
ECHO chamando UAC para escalação de privilegios
ECHO **************************************

ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"

if '%cmdInvoke%'=='1' goto InvokeCmd 

ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
goto ExecElevation

:InvokeCmd
ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
"%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

::::::::::::::::::::::::::::
::Executando menu
::::::::::::::::::::::::::::

:inicio

@echo off

cls
title CheckKey
echo. ---------------------------

echo   VERIFICADOR DE CHAVE WINDOWS
echo 	       by gabrielrtl
echo. ---------------------------

echo  1 - Start

echo  0 - SAIR

echo. ---------------------------

set /p Comando= Digite uma Opcao :

if "%Comando%" equ "1" (goto:op1)

if "%Comando%" equ "0" (goto:exit)

:op1
cls
echo.
echo O Numero da sua chave é:
echo. ---------------------------
wmic path softwarelicensingservice get OA3xOriginalProductKey
echo. ---------------------------
pause
slmgr /dli

goto:inicio

:exit

exit