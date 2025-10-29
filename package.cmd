@ECHO OFF

SETLOCAL EnableDelayedExpansion

ECHO Downloading tools...

.nuget\NuGet.exe install 7-Zip.CommandLine -Source https://api.nuget.org/v3/index.json -ExcludeVersion -o packages

ECHO.
ECHO Packaging...


REM Get current branch name
git rev-parse --abbrev-ref HEAD > branch.txt


SET /P branch=<branch.txt
DEL branch.txt
ECHO Branch: %branch%


SET revision_num=%BUILD_NUMBER%
IF "%revision_num%"=="" SET revision_num=0


REM Get short commit hash
git rev-parse --short HEAD > revision.txt

SET /P revision=<revision.txt
DEL revision.txt

ECHO Revision Number: %revision_num%
ECHO Revision: %revision%


SET version=0.0.0
REM ...existing code...

REM Read version from version.txt
IF EXIST version.txt (
    SET /P version=<version.txt
) ELSE (
    SET version=0.0.0
)
ECHO Version: %version%

REM ...existing code...


FOR /F "tokens=1 delims=/" %%s IN ("%branch%") DO SET stream=%%s
ECHO Stream: %stream%


SET semversion=%version%
IF NOT %stream%==default SET semversion=%semversion%-%stream%.%revision_num%+%revision%

ECHO Semantic Version: %semversion%


REM Replace + with _ for the zip filename (7-Zip wildcard limitation)
SET safe_semversion=%semversion:+=_%
SET safe_semversion=%safe_semversion: =%
SET filename=Github_v%safe_semversion%.zip

SET zippath=%filename%

ECHO.
ECHO Creating package %zippath%...


IF EXIST %zippath% DEL /F %zippath%
REM Only include specific folders and files
packages\7-Zip.CommandLine\tools\7za.exe a %zippath% form-builder\* form-response-template-builder\* privacy\* register\* tinymce\* assets\* compatibility-matrix.json index.html
ECHO Done
