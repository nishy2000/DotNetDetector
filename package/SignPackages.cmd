@echo off
SETLOCAL enabledelayedexpansion
SET BAT_NAME=%~n0%~x0
SET TARGET_FOLDER=%1
SET CERT_SUBJECT_NAME=nishy software

IF "x-" == "x-%TARGET_FOLDER%" GOTO HELP
IF NOT EXIST "%TARGET_FOLDER%\" GOTO HELP
IF NOT EXIST "%TARGET_FOLDER%\signed\" GOTO HELP

REM  Signe packages
ECHO =======================
ECHO Signe packages
ECHO -----------------------
FOR %%i in (%TARGET_FOLDER%\signed\*.nupkg) do (
    echo sign: %%~ni%%~xi
    nuget.exe sign "%%i" -Verbosity quiet -CertificateSubjectName "%CERT_SUBJECT_NAME%" -Timestamper "http://sha256timestamp.ws.symantec.com/sha256/timestamp"
)
ECHO =======================

GOTO END

:ERROR
ECHO ERROR occurred
COLOR C1
PAUSE
COLOR F
GOTO END

:HELP
ECHO %BAT_NAME% TargetFolder
ECHO TargetFolder must have signed folder as a sub folder.

:END
ENDLOCAL
EXIT /B