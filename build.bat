@echo off
setlocal enabledelayedexpansion enableextensions
set BUILD_DIR=%~dp0

pushd %BUILD_DIR%

for /f "delims=" %%X IN ('dir /B /A /S *') DO (
	for %%D in ("%%~dpX\.") do (
		set PACKAGE_NAME=%%~nxD
		goto FoundPkgName
	)
)

:FoundPkgName
pushd ..\System

:: make sure to always rebuild the package
:: New package GUID, No doubts about staleness
del %PACKAGE_NAME%.u

ucc make -ini=%BUILD_DIR%make.ini -Silent

:: dont do the post-process steps if compilation failed
if ERRORLEVEL 1 goto cleanup

:: Generate compressed file for redirects
ucc compress %PACKAGE_NAME%.u

:: copy to release location
if not exist %BUILD_DIR%System (mkdir %BUILD_DIR%System)
copy %PACKAGE_NAME%.u     %BUILD_DIR%System >NUL
copy %PACKAGE_NAME%.u.uz  %BUILD_DIR%System >NUL

popd

if exist "PostBuildHook.bat" call "PostBuildHook.bat"

:cleanup
popd
endlocal
