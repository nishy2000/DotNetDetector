/* ==============================
** Copyright 2020 nishy software
**
**      First Author : nishy2000
**		Create : 2020/08/30
** ============================== */

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

            // wait
            Console.WriteLine("\npress any key to exit the process...");
            Console.ReadKey();
        }
    }
}
