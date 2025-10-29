@ECHO OFF

SETLOCAL EnableDelayedExpansion

ECHO Building...
IF EXIST build RMDIR /S /Q build
MKDIR build

PUSHD scripts
SET source=
set target_prefix=
SET target=
FOR /F %%V IN ('dir /b /ad .') DO (
	CALL ..\normalizeVersionNumber.cmd %%V > normalizedVersionNumber.txt
	SET /P target_prefix=<normalizedVersionNumber.txt
	DEL normalizedVersionNumber.txt

	PUSHD %%V

	ECHO Processing !target_prefix!...

	FOR %%S IN (*.sql) DO (
		SET source=%%S%
		SET target=!target_prefix!.!source!
		COPY "!source!" "..\..\build\!target!" >nul 2>&1
	)

	POPD
)
POPD

ECHO Done
