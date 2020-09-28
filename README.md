[Click here](https://nishy-software.com/ja/dotnetdetector/) for Japanese page (日本語ページは[こちら](https://nishy-software.com/ja/dotnetdetector/))

# NishySoftware.DotNetDetector
## Development status
[![Build Status (develop)](https://nishy-software.visualstudio.com/DotNetDetector/_apis/build/status/nishy2000.DotNetDetector?branchName=develop&label=develop)](https://nishy-software.visualstudio.com/DotNetDetector/_build/latest?definitionId=6&branchName=develop)
[![Build Status (master)](https://nishy-software.visualstudio.com/DotNetDetector/_apis/build/status/nishy2000.DotNetDetector?branchName=master&label=master)](https://nishy-software.visualstudio.com/DotNetDetector/_build/latest?definitionId=6&branchName=master)

[![Downloads](https://img.shields.io/nuget/dt/NishySoftware.DotNetDetector.svg?style=flat-square&label=downloads)](https://www.nuget.org/packages/NishySoftware.DotNetDetector/)
[![NuGet](https://img.shields.io/nuget/v/NishySoftware.DotNetDetector.svg?style=flat-square)](https://www.nuget.org/packages/NishySoftware.DotNetDetector/)
[![NuGet (pre)](https://img.shields.io/nuget/vpre/NishySoftware.DotNetDetector.svg?style=flat-square&label=nuget-pre)](https://www.nuget.org/packages/NishySoftware.DotNetDetector/)
[![Release](https://img.shields.io/github/release/nishy2000/DotNetDetector.svg?style=flat-square)](https://github.com/nishy2000/DotNetDetector/releases)
[![License](https://img.shields.io/github/license/nishy2000/DotNetDetector.svg?style=flat-square)](https://github.com/nishy2000/DotNetDetector/blob/master/LICENSE)

[![Issues](https://img.shields.io/github/issues/nishy2000/DotNetDetector.svg?style=flat-square)](https://github.com/nishy2000/DotNetDetector/issues)
[![Issues](https://img.shields.io/github/issues-closed/nishy2000/DotNetDetector.svg?style=flat-square)](https://github.com/nishy2000/DotNetDetector/issues?q=is%3Aissue+is%3Aclosed)
[![Pull Requests](https://img.shields.io/github/issues-pr/nishy2000/DotNetDetector.svg?style=flat-square)](https://github.com/nishy2000/DotNetDetector/pulls)
[![Pull Requests](https://img.shields.io/github/issues-pr-closed/nishy2000/DotNetDetector.svg?style=flat-square)](https://github.com/nishy2000/DotNetDetector/pulls?q=is%3Apr+is%3Aclosed)

# About
NishySoftware.DotNetDetector / NishySoftware.DotNetDetector.DNF provide the ability to detect various .NET Framework / .NET Core versions.
- Target .NET Framework / .NET Core version when the application was built (NishySoftware.DotNetDetector)
- .NET Framework / .NET Core version used by the running application. (NishySoftware.DotNetDetector)
- .NET Framework version installed on the system (NishySoftware.DotNetDetector.DNF)


# Installation

Install NuGet package(s).

```powershell
PM> Install-Package NishySoftware.DotNetDetector
PM> Install-Package NishySoftware.DotNetDetector.DNF
```

* [NishySoftware.DotNetDetector](https://www.nuget.org/packages/NishySoftware.DotNetDetector/) - DotNetDetector library.

* [NishySoftware.DotNetDetector.DNF](https://www.nuget.org/packages/NishySoftware.DotNetDetector.DNF/) - DotNetDetector.DNF library.


# Features / How to use

## NishySoftware.DotNetDetector
This library provides static `DotNetDetector` class.
All public methods are exported as static methods.

### DetectAppTargetNetType()
```csharp
DotNetDetector.FrameworkTypes DetectAppTargetNetType()
```

This method returns the framework type.
```csharp
    public enum FrameworkTypes
    {
        Unknown = 0,
        DotNetFramework = 1,
        DotNet = 2,
        DotNetCore = DotNet,
    }
```

### DetectAppTargetNetVersion()
```csharp
Version DetectAppTargetNetVersion()
```

This method returns the version of the .NET Framework / .NET Core that was specified as the TargetFramwork at build time.
If it cannot be determined, it returns null.

### DetectAppRuntimeNetVersion()
```csharp
Version DetectAppRuntimeNetVersion()
```

This method returns the version of .NET Framework / .NET Core used by the running application.
If it cannot be determined, null is returned.

## NishySoftware.DotNetDetector.DNF
This library provides static `DotNetDetectorDNF` class.
All public methods are exported as static methods.

### Version DetectInstalledNetFrameworkVersion()
```csharp
Version DetectInstalledNetFrameworkVersion()
```
This method returns the maximum version of .NET Framework that installed on the system.
If it cannot be determined, null is returned.

# Example

```csharp
namespace NishySoftware.Utilities.DotNetDetector.ConsoleApp
{
    using NishySoftware.Utilities;
    using System;

    class Program
    {
        static void Main(string[] args)
        {
            // build
            var clrVersionBuildtime = System.Reflection.Assembly.GetEntryAssembly().ImageRuntimeVersion;
            Console.WriteLine("ImageRuntimeVersion: " + clrVersionBuildtime);

            // runtime
            var clrVersionRuntime = System.Runtime.InteropServices.RuntimeEnvironment.GetSystemVersion();
            Console.WriteLine("RuntimeEnvironment: " + clrVersionRuntime);
            Console.WriteLine("Environment.Version: " + Environment.Version.ToString());

            // DotNetDetector
            var targetFramework = DotNetDetector.DetectAppTargetNetType();
            Console.WriteLine("App target framework type: " + targetFramework.ToString());

            var targetVersion = DotNetDetector.DetectAppTargetNetVersion();
            Console.WriteLine("App target framework version: " + targetVersion?.ToString());

            var runtimeVesion = DotNetDetector.DetectAppRuntimeNetVersion();
            Console.WriteLine("App runtime framework version: " + runtimeVesion?.ToString());

            var installedDotNetFramework = DotNetDetectorDNF.DetectInstalledNetFrameworkVersion();
            Console.WriteLine("Installed .NET framework version: " + installedDotNetFramework?.ToString());
        }
    }
}
```

## Output by .NET Framework 4.7.2 app
```
ImageRuntimeVersion: v4.0.30319
RuntimeEnvironment: v4.0.30319
Environment.Version: 4.0.30319.42000
App target framework type: DotNetFramework
App target framework version: 4.7.2
App runtime framework version: 4.8.4220.0
Installed .NET framework version: 4.8
```

## Output by .NET Core 2.2 app
```
ImageRuntimeVersion: v4.0.30319
RuntimeEnvironment: v4.0.30319
Environment.Version: 4.0.30319.42000
App target framework type: DotNet
App target framework version: 2.2
App runtime framework version: 2.2.8
Installed .NET framework version: 4.8
```

# License

This library is under [the MIT License (MIT)](LICENSE).
