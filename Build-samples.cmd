@ECHO OFF
SETLOCAL
SET CONFIGURATION=%1
IF "x-" == "x-%CONFIGURATION%" SET CONFIGURATION=Debug

dotnet build --configuration %CONFIGURATION% --no-incremental src\DotNetDetector.ConsoleApp\DotNetDetector.ConsoleApp.csproj
dotnet build --configuration %CONFIGURATION% --no-incremental src\DotNetDetector.ConsoleAppNetCore\DotNetDetector.ConsoleAppNetCore.csproj

REM change folder to enable private global.json
pushd src\DotNetDetector.ConsoleAppNet5
dotnet build --configuration %CONFIGURATION% --no-incremental --no-dependencies DotNetDetector.ConsoleAppNet5.csproj
popd

ENDLOCAL