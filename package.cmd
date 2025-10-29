@ECHO OFF

SETLOCAL EnableDelayedExpansion

ECHO Downloading tools...
.nuget\NuGet.exe install 7-Zip.CommandLine -ExcludeVersion -o packages
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%

ECHO.
ECHO Packaging...

hg branch > branch.txt
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%

SET /P branch=<branch.txt
DEL branch.txt
ECHO Branch: %branch%

SET revision_num=%BUILD_NUMBER%
IF "%revision_num%"=="" SET revision_num=0

hg identify --id --rev . > revision.txt
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
SET /P revision=<revision.txt

DEL revision.txt

ECHO Revision Number: %revision_num%
ECHO Revision: %revision%

SET version=0.0.0
SET /A version_score=0

SETLOCAL EnableDelayedExpansion
FOR /F "tokens=1,2,3 delims=." %%x IN ('dir /B /O:D build\*.sql') DO (
	SET /A score = %%z
	SET /A score += %%y * 100
	SET /A score += %%x * 10000

	IF !score! GTR !version_score! (
		SET version_score=!score!
		SET version=%%x.%%y.%%z
	)
)
ECHO Version: %version%

FOR /F "tokens=1 delims=/" %%s IN ("%branch%") DO SET stream=%%s
ECHO Stream: %stream%

SET semversion=%version%
IF NOT %stream%==default SET semversion=%semversion%-%stream%.%revision_num%+%revision%

ECHO Semantic Version: %semversion%

SET filename=Scripts_v%semversion%.zip
PUSHD build

ECHO.
ECHO Creating package %filename%...
IF EXIST %filename% DEL /F %filename%
..\packages\7-Zip.CommandLine\tools\7za.exe a %filename% >nul 2>&1
MOVE /Y %filename% .. >nul 2>&1

POPD
ECHO Done
