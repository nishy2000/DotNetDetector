@ECHO OFF
SETLOCAL
SET ANYFILE=%0
SET CONFIGURATION=%1
IF "x-" == "x-%CONFIGURATION%" SET CONFIGURATION=Debug

SET Frameworks=net40 net45 net451 net452 net46 net461 net462 net47 net471 net472 net48
for %%i in (%Frameworks%) DO (
src\dotNetDetector.ConsoleApp\bin\%CONFIGURATION%\%%i\DotNetDetector.ConsoleApp.exe < %ANYFILE%
)

SET Frameworks=netcoreapp2 netcoreapp2.1 netcoreapp2.2 netcoreapp3 netcoreapp3.1
for %%i in (%Frameworks%) DO (
	if EXIST "src\dotNetDetector.ConsoleAppNetCore\bin\%CONFIGURATION%\%%i\DotNetDetector.ConsoleAppNetCore.exe" (
		src\dotNetDetector.ConsoleAppNetCore\bin\%CONFIGURATION%\%%i\DotNetDetector.ConsoleAppNetCore.exe < %ANYFILE%
	) ELSE (
		dotnet src\dotNetDetector.ConsoleAppNetCore\bin\%CONFIGURATION%\%%i\DotNetDetector.ConsoleAppNetCore.dll < %ANYFILE%
	)
)

SET Frameworks=net5.0
for %%i in (%Frameworks%) DO (
src\dotNetDetector.ConsoleAppNet5\bin\%CONFIGURATION%\%%i\DotNetDetector.ConsoleAppNet5.exe < %ANYFILE%
)
ENDLOCAL