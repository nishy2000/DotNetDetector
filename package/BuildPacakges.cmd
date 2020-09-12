@ECHO OFF
SETLOCAL enabledelayedexpansion
SET BAT_FOLDER=%~d0%~p0
SET DATE_TIME=%DATE:/=%_%TIME::=%
SET DATE_TIME=%DATE_TIME: =0%
SET SRC_FOLDER=%BAT_FOLDER%..\src
SET WORK_FOLDERNAME=Package_%DATE_TIME%
SET WORK_FOLDER=%BAT_FOLDER%%WORK_FOLDERNAME%
SET SIGNED_FOLER=%WORK_FOLDER%\signed
SET UNSIGNED_FOLER=%WORK_FOLDER%\unsigned
SET CERT_SUBJECT_NAME=nishy software

COLOR F

SET SIGNTOOL=%SIGNTOOL:"=%
ECHO signtool: %SIGNTOOL%
IF NOT EXIST "%SIGNTOOL%" (
    ECHO Pease SET SIGNTOOL=sign batch file path
    COLOR 6F
    PAUSE
    COLOR F
    GOTO END
)

mkdir "%WORK_FOLDER%"
PUSHD "%SRC_FOLDER%"

REM  Rebuild modules
ECHO =======================
ECHO Rebuild modules
ECHO -----------------------
dotnet.exe build -c Release --no-incremental --no-dependencies DotNetDetector\DotNetDetector.csproj
IF ERRORLEVEL 1 GOTO ERROR
dotnet.exe build -c Release --no-incremental --no-dependencies DotNetDetector.DNF\DotNetDetector.DNF.csproj
IF ERRORLEVEL 1 GOTO ERROR
dotnet.exe build -c Release --no-incremental --no-dependencies DotNetDetector.ConsoleApp\DotNetDetector.ConsoleApp.csproj
IF ERRORLEVEL 1 GOTO ERROR
dotnet.exe build -c Release --no-incremental --no-dependencies DotNetDetector.ConsoleAppNetCore\DotNetDetector.ConsoleAppNetCore.csproj
IF ERRORLEVEL 1 GOTO ERROR


REM  Backup unsigned modules
ECHO =======================
ECHO Backup unsigned modules
ECHO -----------------------

mkdir "%UNSIGNED_FOLER%"

REM  DotNetDetector modules
XCOPY /D /E "DotNetDetector\bin\Release" "%UNSIGNED_FOLER%\DotNetDetector\" > nul
IF ERRORLEVEL 1 GOTO ERROR

REM  DotNetDetector.DNF modules
XCOPY /D /E "DotNetDetector.DNF\bin\Release" "%UNSIGNED_FOLER%\DotNetDetector.DNF\" > nul
IF ERRORLEVEL 1 GOTO ERROR

REM  DotNetDetector.ConsoleApp modules
XCOPY /D /E "DotNetDetector.ConsoleApp\bin\Release" "%UNSIGNED_FOLER%\DotNetDetector.ConsoleApp\" > nul
IF ERRORLEVEL 1 GOTO ERROR

REM  DotNetDetector.ConsoleAppNetCore modules
XCOPY /D /E "DotNetDetector.ConsoleAppNetCore\bin\Release" "%UNSIGNED_FOLER%\DotNetDetector.ConsoleAppNetCore\" > nul
IF ERRORLEVEL 1 GOTO ERROR


REM  Sign modules
ECHO =======================
ECHO Sign modules
ECHO -----------------------
SET SIGN_FILES=
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector\bin\Release\net40\DotNetDetector.dll"
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector\bin\Release\netcoreapp2\DotNetDetector.dll"
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector.DNF\bin\Release\net40\DotNetDetector.DNF.dll"
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector.DNF\bin\Release\netcoreapp2\DotNetDetector.DNF.dll"
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector.ConsoleApp\bin\Release\net40\DotNetDetector.ConsoleApp.exe"
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector.ConsoleApp\bin\Release\net45\DotNetDetector.ConsoleApp.exe"
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector.ConsoleApp\bin\Release\net451\DotNetDetector.ConsoleApp.exe"
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector.ConsoleApp\bin\Release\net452\DotNetDetector.ConsoleApp.exe"
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector.ConsoleApp\bin\Release\net46\DotNetDetector.ConsoleApp.exe"
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector.ConsoleApp\bin\Release\net461\DotNetDetector.ConsoleApp.exe"
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector.ConsoleApp\bin\Release\net462\DotNetDetector.ConsoleApp.exe"
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector.ConsoleApp\bin\Release\net47\DotNetDetector.ConsoleApp.exe"
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector.ConsoleApp\bin\Release\net471\DotNetDetector.ConsoleApp.exe"
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector.ConsoleApp\bin\Release\net472\DotNetDetector.ConsoleApp.exe"
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector.ConsoleApp\bin\Release\net48\DotNetDetector.ConsoleApp.exe"
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector.ConsoleAppNetCore\bin\Release\netcoreapp2\DotNetDetector.ConsoleAppNetCore.dll"
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector.ConsoleAppNetCore\bin\Release\netcoreapp2.1\DotNetDetector.ConsoleAppNetCore.dll"
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector.ConsoleAppNetCore\bin\Release\netcoreapp2.2\DotNetDetector.ConsoleAppNetCore.dll"
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector.ConsoleAppNetCore\bin\Release\netcoreapp3\DotNetDetector.ConsoleAppNetCore.dll"
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector.ConsoleAppNetCore\bin\Release\netcoreapp3\DotNetDetector.ConsoleAppNetCore.exe"
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector.ConsoleAppNetCore\bin\Release\netcoreapp3.1\DotNetDetector.ConsoleAppNetCore.dll"
SET SIGN_FILES=%SIGN_FILES% "DotNetDetector.ConsoleAppNetCore\bin\Release\netcoreapp3.1\DotNetDetector.ConsoleAppNetCore.exe"

SETLOCAL
CALL "%SIGNTOOL%" %SIGN_FILES%
ENDLOCAL

REM  Backup signed modules
ECHO =====================
ECHO Backup signed modules
ECHO -----------------------

mkdir "%SIGNED_FOLER%"
mkdir "%SIGNED_FOLER%\net40"
mkdir "%SIGNED_FOLER%\net45"
mkdir "%SIGNED_FOLER%\net451"
mkdir "%SIGNED_FOLER%\net452"
mkdir "%SIGNED_FOLER%\net46"
mkdir "%SIGNED_FOLER%\net461"
mkdir "%SIGNED_FOLER%\net462"
mkdir "%SIGNED_FOLER%\net47"
mkdir "%SIGNED_FOLER%\net471"
mkdir "%SIGNED_FOLER%\net472"
mkdir "%SIGNED_FOLER%\net48"
mkdir "%SIGNED_FOLER%\netcoreapp2"
mkdir "%SIGNED_FOLER%\netcoreapp2.1"
mkdir "%SIGNED_FOLER%\netcoreapp2.2"
mkdir "%SIGNED_FOLER%\netcoreapp3"
mkdir "%SIGNED_FOLER%\netcoreapp3.1"

REM  DotNetDetector modules
COPY "DotNetDetector\bin\Release\net40\DotNetDetector.dll" "%SIGNED_FOLER%\net40\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "DotNetDetector\bin\Release\netcoreapp2\DotNetDetector.dll" "%SIGNED_FOLER%\netcoreapp2\" >nul
IF ERRORLEVEL 1 GOTO ERROR

REM  DotNetDetector.DNF modules
COPY "DotNetDetector.DNF\bin\Release\net40\DotNetDetector.DNF.dll" "%SIGNED_FOLER%\net40\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "DotNetDetector.DNF\bin\Release\netcoreapp2\DotNetDetector.DNF.dll" "%SIGNED_FOLER%\netcoreapp2\" >nul
IF ERRORLEVEL 1 GOTO ERROR

REM  DotNetDetector.ConsoleApp modules
COPY "DotNetDetector.ConsoleApp\bin\Release\net40\DotNetDetector.ConsoleApp.exe" "%SIGNED_FOLER%\net40\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "DotNetDetector.ConsoleApp\bin\Release\net45\DotNetDetector.ConsoleApp.exe" "%SIGNED_FOLER%\net45\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "DotNetDetector.ConsoleApp\bin\Release\net451\DotNetDetector.ConsoleApp.exe" "%SIGNED_FOLER%\net451\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "DotNetDetector.ConsoleApp\bin\Release\net452\DotNetDetector.ConsoleApp.exe" "%SIGNED_FOLER%\net452\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "DotNetDetector.ConsoleApp\bin\Release\net46\DotNetDetector.ConsoleApp.exe" "%SIGNED_FOLER%\net46\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "DotNetDetector.ConsoleApp\bin\Release\net461\DotNetDetector.ConsoleApp.exe" "%SIGNED_FOLER%\net461\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "DotNetDetector.ConsoleApp\bin\Release\net462\DotNetDetector.ConsoleApp.exe" "%SIGNED_FOLER%\net462\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "DotNetDetector.ConsoleApp\bin\Release\net47\DotNetDetector.ConsoleApp.exe" "%SIGNED_FOLER%\net47\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "DotNetDetector.ConsoleApp\bin\Release\net471\DotNetDetector.ConsoleApp.exe" "%SIGNED_FOLER%\net471\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "DotNetDetector.ConsoleApp\bin\Release\net472\DotNetDetector.ConsoleApp.exe" "%SIGNED_FOLER%\net472\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "DotNetDetector.ConsoleApp\bin\Release\net48\DotNetDetector.ConsoleApp.exe" "%SIGNED_FOLER%\net48\" >nul
IF ERRORLEVEL 1 GOTO ERROR

REM  DotNetDetector.ConsoleAppNetCore modules
COPY "DotNetDetector.ConsoleAppNetCore\bin\Release\netcoreapp2\DotNetDetector.ConsoleAppNetCore.dll" "%SIGNED_FOLER%\netcoreapp2\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "DotNetDetector.ConsoleAppNetCore\bin\Release\netcoreapp2.1\DotNetDetector.ConsoleAppNetCore.dll" "%SIGNED_FOLER%\netcoreapp2.1\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "DotNetDetector.ConsoleAppNetCore\bin\Release\netcoreapp2.2\DotNetDetector.ConsoleAppNetCore.dll" "%SIGNED_FOLER%\netcoreapp2.2\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "DotNetDetector.ConsoleAppNetCore\bin\Release\netcoreapp3\DotNetDetector.ConsoleAppNetCore.dll" "%SIGNED_FOLER%\netcoreapp3\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "DotNetDetector.ConsoleAppNetCore\bin\Release\netcoreapp3\DotNetDetector.ConsoleAppNetCore.exe" "%SIGNED_FOLER%\netcoreapp3\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "DotNetDetector.ConsoleAppNetCore\bin\Release\netcoreapp3.1\DotNetDetector.ConsoleAppNetCore.dll" "%SIGNED_FOLER%\netcoreapp3.1\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "DotNetDetector.ConsoleAppNetCore\bin\Release\netcoreapp3.1\DotNetDetector.ConsoleAppNetCore.exe" "%SIGNED_FOLER%\netcoreapp3.1\" >nul
IF ERRORLEVEL 1 GOTO ERROR


REM  Packaging
ECHO =======================
ECHO Packaging
ECHO -----------------------

dotnet.exe pack -c Release --no-build -o "%WORK_FOLDER%" DotNetDetector\DotNetDetector.csproj
IF ERRORLEVEL 1 GOTO ERROR
dotnet.exe pack -c Release --no-build -o "%WORK_FOLDER%" DotNetDetector.DNF\DotNetDetector.DNF.csproj
IF ERRORLEVEL 1 GOTO ERROR
dotnet.exe pack -c Release --no-build -o "%WORK_FOLDER%" DotNetDetector.ConsoleApp\DotNetDetector.ConsoleApp.csproj
IF ERRORLEVEL 1 GOTO ERROR
dotnet.exe pack -c Release --no-build -o "%WORK_FOLDER%" DotNetDetector.ConsoleAppNetCore\DotNetDetector.ConsoleAppNetCore.csproj
IF ERRORLEVEL 1 GOTO ERROR


REM  Backup packages
ECHO =======================
ECHO Backup packages
ECHO -----------------------

FOR %%i in (%WORK_FOLDER%\*.nupkg) do (
    COPY "%%i" "%SIGNED_FOLER%" > nul
    MOVE "%%i" "%UNSIGNED_FOLER%\%%~ni_unsigned%%~xi" > nul
)

REM  Create DotNetDetector.ConsoleApp folder
ECHO =======================
ECHO Create DotNetDetector.ConsoleApp folder
ECHO -----------------------

XCOPY /D /E "%UNSIGNED_FOLER%\DotNetDetector.ConsoleApp" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\" > nul
IF ERRORLEVEL 1 GOTO ERROR
XCOPY /D /E "%UNSIGNED_FOLER%\DotNetDetector.ConsoleAppNetCore" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\" > nul
IF ERRORLEVEL 1 GOTO ERROR

XCOPY /D /E /Y "%SIGNED_FOLER%\net40" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net40\" > nul
IF ERRORLEVEL 1 GOTO ERROR
XCOPY /D /E /Y "%SIGNED_FOLER%\net45" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net45\" > nul
IF ERRORLEVEL 1 GOTO ERROR
XCOPY /D /E /Y "%SIGNED_FOLER%\net451" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net451\" > nul
IF ERRORLEVEL 1 GOTO ERROR
XCOPY /D /E /Y "%SIGNED_FOLER%\net452" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net452\" > nul
IF ERRORLEVEL 1 GOTO ERROR
XCOPY /D /E /Y "%SIGNED_FOLER%\net46" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net46\" > nul
IF ERRORLEVEL 1 GOTO ERROR
XCOPY /D /E /Y "%SIGNED_FOLER%\net461" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net461\" > nul
IF ERRORLEVEL 1 GOTO ERROR
XCOPY /D /E /Y "%SIGNED_FOLER%\net462" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net462\" > nul
IF ERRORLEVEL 1 GOTO ERROR
XCOPY /D /E /Y "%SIGNED_FOLER%\net47" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net47\" > nul
IF ERRORLEVEL 1 GOTO ERROR
XCOPY /D /E /Y "%SIGNED_FOLER%\net471" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net471\" > nul
IF ERRORLEVEL 1 GOTO ERROR
XCOPY /D /E /Y "%SIGNED_FOLER%\net472" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net472\" > nul
IF ERRORLEVEL 1 GOTO ERROR
XCOPY /D /E /Y "%SIGNED_FOLER%\net48" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net48\" > nul
IF ERRORLEVEL 1 GOTO ERROR
XCOPY /D /E /Y "%SIGNED_FOLER%\netcoreapp2" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\netcoreapp2\" > nul
IF ERRORLEVEL 1 GOTO ERROR
XCOPY /D /E /Y "%SIGNED_FOLER%\netcoreapp2.1" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\netcoreapp2.1\" > nul
IF ERRORLEVEL 1 GOTO ERROR
XCOPY /D /E /Y "%SIGNED_FOLER%\netcoreapp2.2" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\netcoreapp2.2\" > nul
IF ERRORLEVEL 1 GOTO ERROR
XCOPY /D /E /Y "%SIGNED_FOLER%\netcoreapp3" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\netcoreapp3\" > nul
IF ERRORLEVEL 1 GOTO ERROR
XCOPY /D /E /Y "%SIGNED_FOLER%\netcoreapp3.1" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\netcoreapp3.1\" > nul
IF ERRORLEVEL 1 GOTO ERROR

REM  Copy DotNetDetector.dll
COPY "%SIGNED_FOLER%\net40\DotNetDetector.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net45\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\net40\DotNetDetector.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net451\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\net40\DotNetDetector.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net452\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\net40\DotNetDetector.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net46\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\net40\DotNetDetector.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net461\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\net40\DotNetDetector.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net462\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\net40\DotNetDetector.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net47\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\net40\DotNetDetector.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net471\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\net40\DotNetDetector.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net472\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\net40\DotNetDetector.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net48\" >nul
IF ERRORLEVEL 1 GOTO ERROR

COPY "%SIGNED_FOLER%\netcoreapp2\DotNetDetector.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\netcoreapp2.1\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\netcoreapp2\DotNetDetector.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\netcoreapp2.2\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\netcoreapp2\DotNetDetector.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\netcoreapp3\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\netcoreapp2\DotNetDetector.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\netcoreapp3.1\" >nul
IF ERRORLEVEL 1 GOTO ERROR

REM  Copy DotNetDetector.DNF.dll
COPY "%SIGNED_FOLER%\net40\DotNetDetector.DNF.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net45\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\net40\DotNetDetector.DNF.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net451\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\net40\DotNetDetector.DNF.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net452\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\net40\DotNetDetector.DNF.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net46\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\net40\DotNetDetector.DNF.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net461\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\net40\DotNetDetector.DNF.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net462\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\net40\DotNetDetector.DNF.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net47\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\net40\DotNetDetector.DNF.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net471\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\net40\DotNetDetector.DNF.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net472\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\net40\DotNetDetector.DNF.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\net48\" >nul
IF ERRORLEVEL 1 GOTO ERROR

COPY "%SIGNED_FOLER%\netcoreapp2\DotNetDetector.DNF.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\netcoreapp2.1\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\netcoreapp2\DotNetDetector.DNF.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\netcoreapp2.2\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\netcoreapp2\DotNetDetector.DNF.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\netcoreapp3\" >nul
IF ERRORLEVEL 1 GOTO ERROR
COPY "%SIGNED_FOLER%\netcoreapp2\DotNetDetector.DNF.dll" "%SIGNED_FOLER%\DotNetDetector.ConsoleApp\netcoreapp3.1\" >nul
IF ERRORLEVEL 1 GOTO ERROR

REM  Sign packages
ECHO =======================
ECHO Sign packages
ECHO -----------------------

FOR %%i in ("%WORK_FOLDER%\signed\*.nupkg") do (
    echo sign: %%~ni%%~xi
    "%BAT_FOLDER%nuget.exe" sign "%%i" -Verbosity quiet -CertificateSubjectName "%CERT_SUBJECT_NAME%"  -Timestamper "http://sha256timestamp.ws.symantec.com/sha256/timestamp" 
    IF ERRORLEVEL 1 GOTO ERROR
)

GOTO END

:ERROR
ECHO ERROR occurred
COLOR C1
PAUSE
COLOR F

:END
ECHO =======================
ECHO Output folder: "%WORK_FOLDERNAME%"

POPD
ENDLOCAL
EXIT /B