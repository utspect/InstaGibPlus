@echo off
setlocal enabledelayedexpansion enableextensions
set VERBOSE=0
set BUILD_DIR=%~dp0
set BUILD_TEMP=%BUILD_DIR%Build\Temp\
set BUILD_NOINT=0
set BUILD_NOUZ=0
set BUILD_SILENT=0

:ParseArgs
    if /I "%1" EQU "NoInt"  ( set BUILD_NOINT=1 )
    if /I "%1" EQU "NoUz"   ( set BUILD_NOUZ=1 )
    if /I "%1" EQU "Silent" ( set BUILD_SILENT=1 )
    if /I "%1" EQU "Verbose" ( set /A VERBOSE+=1 )
    shift /1
    if [%1] NEQ [] goto ParseArgs

call :SetPackageName "%~dp0."

if %VERBOSE% GEQ 1 (
    echo VERBOSE=%VERBOSE%
    echo BUILD_DIR=%BUILD_DIR%
    echo BUILD_TEMP=%BUILD_TEMP%
    echo BUILD_NOINT=%BUILD_NOINT%
    echo BUILD_NOUZ=%BUILD_NOUZ%
    echo BUILD_SILENT=%BUILD_SILENT%
    echo PACKAGE_NAME=%PACKAGE_NAME%
)

pushd "%BUILD_DIR%"

set MAKEINI="%BUILD_TEMP%make.ini"
set DEPENDENCIES=

call :GenerateMakeIni %MAKEINI% %DEPENDENCIES% %PACKAGE_NAME%

pushd ..\System

:: make sure to always rebuild the package
:: New package GUID, No doubts about staleness
del %PACKAGE_NAME%.u

if %BUILD_SILENT% == 1 (
    call :Invoke ucc make -ini=%MAKEINI% -Silent
) else (
    call :Invoke ucc make -ini=%MAKEINI%
)

:: dont do the post-process steps if compilation failed
if ERRORLEVEL 1 goto compile_failed

:: copy to release location
if not exist "%BUILD_DIR%System" (mkdir "%BUILD_DIR%System")
copy %PACKAGE_NAME%.u %BUILD_DIR%System >NUL

if %BUILD_NOUZ% == 0 (
    :: generate compressed file for redirects
    call :Invoke ucc compress %PACKAGE_NAME%.u
    copy %PACKAGE_NAME%.u.uz "%BUILD_DIR%System" >NUL
)

if %BUILD_NOINT% == 0 (
    :: dump localization strings
    call :Invoke ucc dumpint %PACKAGE_NAME%.u
    copy %PACKAGE_NAME%.int "%BUILD_DIR%System" >NUL
)

popd

if exist "PostBuildHook.bat" call "PostBuildHook.bat"

echo [Finished at %Date% %Time%]

popd
endlocal
exit /B 0

:compile_failed
popd
popd
endlocal
exit /B 1

:Invoke
if %VERBOSE% GEQ 1 echo %*
%*
exit /B %ERRORLEVEL%

:SetPackageName
set PACKAGE_NAME=%~nx1
exit /B %ERRORLEVEL%

:: GenerateMakeIni
::  Generates an INI file for use with 'ucc make'
:: 
:: Usage:
::  call :GenerateMakeIni IniPath Packages...
::   IniPath is where to generate the ini to
::   Packages... is a variadic list of Packages (up to 254)
::    Usually the last Package is the one that you are trying to compile
::    If Package A depends on Package B, then B must appear before A in this list.
:GenerateMakeIni
    if not exist %1 mkdir "%~dp1"
    call :GenerateMakeIniPreamble %1

    :GenerateMakeIniNextDependency
        call :GenerateMakeIniDependency %1 %2
        shift /2
        if [%2] NEQ [] goto GenerateMakeIniNextDependency

    call :GenerateMakeIniPostscript %1
exit /B %ERRORLEVEL%

:: It is important to not have spaces before the >>.
:: Spaces will be part of the names UT parses from the INI.

:GenerateMakeIniPreamble
    echo ; Generated, DO NOT MODIFY>%1
    echo.>>%1
    echo [Engine.Engine]>>%1
    echo EditorEngine=Editor.EditorEngine>>%1
    echo.>>%1
    echo [Editor.EditorEngine]>>%1
    echo CacheSizeMegs=32>>%1
    echo EditPackages=Core>>%1
    echo EditPackages=Engine>>%1
    echo EditPackages=Editor>>%1
    echo EditPackages=UWindow>>%1
    echo EditPackages=Fire>>%1
    echo EditPackages=IpDrv>>%1
    echo EditPackages=UWeb>>%1
    echo EditPackages=UBrowser>>%1
    echo EditPackages=UnrealShare>>%1
    echo EditPackages=UnrealI>>%1
    echo EditPackages=UMenu>>%1
    echo EditPackages=Botpack>>%1
    echo EditPackages=IpServer>>%1
    echo EditPackages=UTServerAdmin>>%1
    echo EditPackages=UTMenu>>%1
    echo EditPackages=UTBrowser>>%1
exit /B %ERRORLEVEL%

:GenerateMakeIniPostscript
    echo.>>%1
    echo [Core.System]>>%1
    echo Paths=*.u>>%1
    echo Paths=../Maps/*.unr>>%1
    echo Paths=../Textures/*.utx>>%1
    echo Paths=../Sounds/*.uax>>%1
    echo Paths=../Music/*.umx>>%1
exit /B %ERRORLEVEL%

:GenerateMakeIniDependency
    echo EditPackages=%2>>%1
exit /B %ERRORLEVEL%
