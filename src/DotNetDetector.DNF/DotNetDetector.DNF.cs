/* ==============================
** Copyright 2020 nishy software
**
**      First Author : nishy2000
**		Create : 2020/08/30
** ============================== */

namespace NishySoftware.Utilities
{
    using Microsoft.Win32;
    using System;
    using System.IO;
    using System.Linq;
    using System.Collections.Generic;

    /// <summary>
    /// Provides the ability to detect version of .NET Framework installed on the system.
    /// </summary>
    public static class DotNetDetectorDNF
    {
        /// <summary>
        /// Provides functionality to detect which version of the .NET Framework that is installed on the current machine.
        /// </summary>
        /// <returns>.NET Framework app: Detected version, null if version cannot be determined.
        /// .NET Core app/.NET app: null</returns>
        public static Version DetectInstalledNetFrameworkVersion()
        {
            return GetInstalledDotNetFrameworkVersion();
        }

        /// <summary>
        /// List the minimum release keys to the associated versions.
        /// </summary>
        /// <remarks>
        /// See https://docs.microsoft.com/en-us/dotnet/framework/migration-guide/minimum-release-dword
        /// </remarks>
        static readonly Tuple<int,Version> [] Versions = new Tuple<int, Version>[]
        {
            new Tuple<int,Version>(528040, new Version(4, 8)),
            new Tuple<int,Version>(461808, new Version(4, 7, 2)),
            new Tuple<int,Version>(461308, new Version(4, 7, 1)),
            new Tuple<int,Version>(460798, new Version(4, 7)),
            new Tuple<int,Version>(394802, new Version(4, 6, 2)),
            new Tuple<int,Version>(394254, new Version(4, 6, 1)),
            new Tuple<int,Version>(393295, new Version(4, 6)),
            new Tuple<int,Version>(379893, new Version(4, 5, 2)),
            new Tuple<int,Version>(378675, new Version(4, 5, 1)),
            new Tuple<int,Version>(378389, new Version(4, 5)),
        };

        /// <summary>
        /// Returns the .NET Framework version that is installed on this machine.
        /// </summary>
        /// <returns>The .NET Framework version that is installed on this machine.</returns>
        public static Version GetInstalledDotNetFrameworkVersion()
        {
            var releaseKey = GetDotNetFrameworkReleaseKey();
            if (releaseKey == null || releaseKey == 0)
            {
                if (IsInstalledDotNetFramework(@"Software\Microsoft\NET Framework Setup\NDP\v4\Full\", "Install")
                    || IsInstalledDotNetFramework(@"Software\Microsoft\NET Framework Setup\NDP\v4\Client\", "Install"))
                {
                    return new Version(4, 0);
                }
                else if (IsInstalledDotNetFramework(@"Software\Microsoft\NET Framework Setup\NDP\v3.5\", "Install"))
                {
                    return new Version(3, 5);
                }
                else if (IsInstalledDotNetFramework(@"Software\Microsoft\NET Framework Setup\NDP\v3.0\Setup\", "InstallSuccess"))
                {
                    return new Version(3, 0);
                }
                else if (IsInstalledDotNetFramework(@"Software\Microsoft\NET Framework Setup\NDP\v2.0.50727\", "Install"))
                {
                    return new Version(2, 0);
                }
                else if (IsInstalledDotNetFramework(@"Software\Microsoft\NET Framework Setup\NDP\v1.1.4322\", "Install"))
                {
                    return new Version(1, 1);
                }
                else if (IsInstalledDotNetFramework(@"Software\Microsoft\.NETFramework\Policy\v1.0\3705\", "Install"))
                {
                    return new Version(1, 0);
                }
            }
            else
            {
                foreach (var version in Versions)
                {
                    if (releaseKey >= version.Item1)
                    {
                        return version.Item2;
                    }
                }
            }

            return null;
        }

        /// <summary>
        /// Returns the release key of the .NET Framework version that is installed on this machine.
        /// </summary>
        /// <returns>The release key of the .NET Framework version that is installed on this machine.</returns>
        public static int? GetDotNetFrameworkReleaseKey()
        {
            return GetDotNetFrameworkReleaseKeyFromRegistry();
        }

        /// <summary>
        /// Gets the .NET release key from the registry.
        /// </summary>
        /// <returns>The .NET release key, or null if unable to find the release key.</returns>
        /// <remarks>
        /// See https://docs.microsoft.com/en-us/dotnet/framework/migration-guide/how-to-determine-which-versions-are-installed
        /// </remarks>
        static int? GetDotNetFrameworkReleaseKeyFromRegistry()
        {
            using (var hklm = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, RegistryView.Registry32))
            {
                using (var key = hklm.OpenSubKey(@"SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\"))
                {
                    var value = key.GetValue("Release");
                    if (value is int releaseKey)
                    {
                        return releaseKey;
                    }
                }
            }

            return null;
        }

        static bool IsInstalledDotNetFramework(string keyPath, string valueName)
        {
            using (var hklm = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, RegistryView.Registry32))
            {
                using (var key = hklm.OpenSubKey(keyPath))
                {
                    if (key != null)
                    {
                        var valueObject = key.GetValue(valueName);
                        if (valueObject is int valueInt)
                        {
                            return valueInt == 1;
                        }
                        else if (valueObject is string valueString)
                        {
                            return valueString == "1";
                        }
                    }
                }
            }

            return false;
        }
    }
}