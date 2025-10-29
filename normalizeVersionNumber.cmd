@ECHO OFF
FOR /F "tokens=1,2,3 delims=." %%a IN ("%1") DO (
   SET major=%%a
   SET minor=%%b
   SET revision=%%c
)

IF [%major%]==[] SET major=0
IF [%minor%]==[] SET minor=0
IF [%revision%]==[] SET revision=0

ECHO %major%.%minor%.%revision%
