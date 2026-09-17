if not exist %PREFIX% mkdir %PREFIX%
if not exist %LIBRARY_PREFIX% mkdir %LIBRARY_PREFIX%
if not exist %SCRIPTS% mkdir %SCRIPTS%

setlocal enableDelayedExpansion
for /F "tokens=1,2,3 delims=. " %%a in ("%PKG_VERSION%") do (
   set "version=%%a.%%b.%%c"
)
rmdir /q /s nsight-compute\!version!\lib

move nsight-compute %LIBRARY_PREFIX%

:: Create bat links for exe files that ship with a matching launcher .bat.
:: Some exes bundled under nsight-compute (e.g. its vendored python.exe) have
:: no matching .bat and must not be wrapped, since a stub like python.bat would
:: collide with and shadow the environment's own python on PATH.
cd %SCRIPTS%
for /r "%LIBRARY_PREFIX%\nsight-compute" %%f in (*.exe) do (
    if exist "%LIBRARY_PREFIX%\nsight-compute\!version!\%%~nf.bat" (
        echo @echo off > %%~nf.bat
        echo %%~dp0..\Library\nsight-compute\!version!\%%~nf.bat %%* >> %%~nf.bat
        if errorlevel 1 exit 1
    )
)
