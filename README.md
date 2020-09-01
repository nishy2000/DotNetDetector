# NishySoftware.DotNetDetector

Provides the ability to detect various .NET Framework / .NET Core versions.
- Target .NET Framework / .NET Core version when the application was built
- .NET Framework / .NET Core version used by the running application.
- .NET Framework version installed on the system


# Installation

**2020/09/01: In preparation. The module has not yet been uploaded to nuget.**

Install NuGet package(s).

```powershell
PM> Install-Package NishySoftware.DotNetDetector
```

* [NishySoftware.DotNetDetector](https://www.nuget.org/packages/NishySoftware.DotNetDetector/) - DotNetDetector library.


# Features / How to use

## NishySoftware.DotNetDetector

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

### Version DetectInstalledNetFrameworkVersion()
```csharp
Version DetectInstalledNetFrameworkVersion()
```
This method returns the maximum version of .NET Framework that installed on the system.
If it cannot be determined, or if the calling application is not a .NET Framework application, null is returned.

### Example

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

            var installedDotNetFramework = DotNetDetector.DetectInstalledNetFrameworkVersion();
            Console.WriteLine("Installed .NET framework version: " + installedDotNetFramework?.ToString());
        }
    }
}
```

Output by .NET Framework 4.7.2 app:
```
ImageRuntimeVersion: v4.0.30319
RuntimeEnvironment: v4.0.30319
Environment.Version: 4.0.30319.42000
App target framework type: DotNetFramework
App target framework version: 4.7.2
App runtime framework version: 4.8.4220.0
Installed .NET framework version: 4.8
```

Output by .NET Core 2.2 app:
```
ImageRuntimeVersion: v4.0.30319
RuntimeEnvironment: v4.0.30319
Environment.Version: 4.0.30319.42000
App target framework type: DotNet
App target framework version: 2.2
App runtime framework version: 2.2.8
Installed .NET framework version:
```

# License

This library is under [the MIT License (MIT)](LICENSE).
