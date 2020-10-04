/* ==============================
** Copyright 2020 nishy software
**
**      First Author : nishy2000
**		Create : 2020/08/30
** ============================== */

namespace NishySoftware.Utilities
{
    using System;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using System.Reflection;

    static class Extensions
    {
        internal static Attribute GetCustomAttribute(this Assembly element, Type attributeType, bool inherit = true)
        {
            Attribute[] customAttributes = Attribute.GetCustomAttributes(element, attributeType, inherit);
            return customAttributes?.FirstOrDefault();
        }
    }

    /// <summary>
    /// Provides functionality to detect which version of the .NET Framework / .NET Core.
    /// </summary>
    public static class DotNetDetector
    {
        public enum FrameworkTypes
        {
            Unknown = 0,
            DotNetFramework = 1,
            DotNet = 2,
            DotNetCore = DotNet,
        }

        /// <summary>
        /// Provides functionality to detect which version of the .NET Framework / .NET Core used by the running application.
        /// </summary>
        /// <returns>Detected version, null if version cannot be determined</returns>
        public static Version DetectAppRuntimeNetVersion()
        {
            return DetectAppRuntimeNetVersion(out string _);
        }

        /// <summary>
        /// Provides functionality to detect which version of the .NET Framework / .NET Core used by the running application.
        /// </summary>
        /// <returns>Detected version, null if version cannot be determined</returns>
        public static Version DetectAppRuntimeNetVersion(out string previewName)
        {
            previewName = null;
            Version version = null;

            // Lets examine all assemblies loaded into the current application domain.
            var assems = AppDomain.CurrentDomain.GetAssemblies();
            var entry = Assembly.GetEntryAssembly();
            var systemPrivateCoreLib = assems.FirstOrDefault(i => string.CompareOrdinal(i.GetName().Name, "System.Private.CoreLib") == 0);
            var systemRuntime = assems.FirstOrDefault(i => string.CompareOrdinal(i.GetName().Name, "System.Runtime") == 0);
            var isPrivateCoreLib = systemPrivateCoreLib != null;
            var isRuntime = systemRuntime != null;
            var isNetCore = isPrivateCoreLib && isRuntime;
            var entryFolder = Path.GetDirectoryName(entry.Location);
            var pathCompOpt = Path.DirectorySeparatorChar == '\\' ? StringComparison.OrdinalIgnoreCase : StringComparison.Ordinal;
            var isSelfContained = isNetCore
                && isPrivateCoreLib && string.Compare(entryFolder, Path.GetDirectoryName(systemPrivateCoreLib?.Location), pathCompOpt) == 0
                && isRuntime && string.Compare(entryFolder, Path.GetDirectoryName(systemRuntime?.Location), pathCompOpt) == 0;
            foreach (var assembly in assems)
            {
                Version itemVersion = null;
                switch (assembly.ManifestModule.Name.ToLowerInvariant())
                {
                    // for .NET/.NET Core
                    case "system.private.corelib.dll":
                        // 2.0.5:
                        //   targetAttr: (none)
                        //   infoVerAttr: 4.6.26020.03 built by: dlab-DDVSOWINAGE012. 
                        //   fileVerAttr: 4.6.26020.03
                        //   productAttr: Microsoft® .NET Framework
                        //   fullName: System.Private.CoreLib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e
                        //   imageRuntime: v4.0.30319
                        //   moduleVerId: {51c22d6f-bc23-41dd-8525-4df19ed44462}
                        // 2.1.21:
                        //   targetAttr: (none)
                        //   infoVerAttr: 4.6.29130.01 @BuiltBy: dlab14-vs2017mb2000006 @Branch: release/2.1 @SrcCode: https://github.com/dotnet/coreclr/tree/963dcb54bccadc9c7e2e6e2b0fdc7d76fc4afb2a
                        //   fileVerAttr: 4.6.29130.01
                        //   productAttr: Microsoft® .NET Framework
                        //   fullName: System.Private.CoreLib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e
                        //   imageRuntime: v4.0.30319
                        //   moduleVerId: {ca75e838-2b51-482d-8f40-329c91701992}
                        // 2.2.8:
                        //   targetAttr: (none)
                        //   infoVerAttr: 4.6.28207.03 @BuiltBy: dlab14-DDVSOWINAGE057 @Branch: release/2.2 @SrcCode: https://github.com/dotnet/coreclr/tree/9f5a8dda38fa26eae4f8ddd05d062a9de3ac4765
                        //   fileVerAttr: 4.6.28207.03
                        //   productAttr: Microsoft® .NET Framework
                        //   fullName: System.Private.CoreLib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e
                        //   imageRuntime: v4.0.30319
                        //   moduleVerId: {fc7c73a1-b1d4-4035-b4e5-fadc40deab92}
                        // 3.0.3:
                        //   targetAttr: (none)
                        //   infoVerAttr: 3.0.3-servicing.20066.3+259ce7d4619478cfefe7b0c0f6fa765f765f7e37
                        //   fileVerAttr: 4.700.20.6603
                        //   productAttr: Microsoft® .NET Core
                        //   fullName: System.Private.CoreLib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e
                        //   imageRuntime: v4.0.30319
                        //   moduleVerId: {333269f9-3a71-4f9c-b215-51ef685a74fa}
                        // 3.1.7:
                        //   targetAttr: (none)
                        //   infoVerAttr: 3.1.7-servicing.20366.2+e8b17841cb5ce923aec48a1b0c12042d445d508f
                        //   fileVerAttr: 4.700.20.36602
                        //   productAttr: Microsoft® .NET Core
                        //   fullName: System.Private.CoreLib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e
                        //   imageRuntime: v4.0.30319
                        //   moduleVerId: {4065b38d-0f9f-44d9-8f53-f4c9102af396}
#if DEBUG
                        Console.WriteLine(assembly.Location);
#endif
                        break;
                    case "system.runtime.dll":
                        // 2.0.x:
                        //   infoVerAttr: 4.6.25519.03 built by: dlab-DDVSOWINAGE029. Commit Hash: 8321c729934c0f8be754953439b88e6e1c120c24
                        //   fileVerAttr: 4.6.25519.03
                        //   productAttr: Microsoft® .NET Framework
                        //   fullName: System.Runtime, Version=4.2.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a
                        //   imageRuntime: v4.0.30319
                        //   moduleVerId: {60d8a943-ef9f-4ff0-8627-ddbd2d0c2691}
                        // 2.0.5:
                        //   targetAttr: (none)
                        //   infoVerAttr: 4.6.26018.01 built by: dlab - DDVSOWINAGE022. 
                        //   fileVerAttr: 4.6.26018.01
                        //   productAttr: Microsoft® .NET Framework
                        //   fullName: System.Runtime, Version=4.2.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a
                        //   imageRuntime: v4.0.30319
                        //   moduleVerId: {d52bcb64-e59a-4385-97f4-c710fe3f97e9}
                        // 2.1.21:
                        //   targetAttr: (none)
                        //   infoVerAttr: 4.6.29130.02 @BuiltBy: dlab14-vs2017mb200000D @Branch: release/2.1-MSRC @SrcCode: https://github.com/dotnet/corefx/tree/b0a8bf6faaf392a939ab0dd5e94db09ef4b631d5
                        //   fileVerAttr: 4.6.29130.02
                        //   productAttr: Microsoft® .NET Framework
                        //   fullName: System.Runtime, Version=4.2.1.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a
                        //   imageRuntime: v4.0.30319
                        //   moduleVerId: {f7b4efcd-8eae-4a25-94c6-d78f1af90a17}
                        // 2.2.8:
                        //   targetAttr: (none)
                        //   infoVerAttr: 4.6.28208.02 @BuiltBy: dlab14-DDVSOWINAGE084 @Branch: release/2.2 @SrcCode: https://github.com/dotnet/corefx/tree/7fa45dc0661b0df16e0649a3f054a0dc1c9200aa
                        //   fileVerAttr: 4.6.28208.02
                        //   productAttr: Microsoft® .NET Framework
                        //   fullName: System.Runtime, Version=4.2.1.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a
                        //   imageRuntime: v4.0.30319
                        //   moduleVerId: {c32deffd-0231-4e49-9343-1bb41d4065c1}
                        // 3.0.3:
                        //   targetAttr: (none)
                        //   infoVerAttr: 3.0.3+a4238c9819075be9bff74e009da802ce47233f38
                        //   fileVerAttr: 4.700.20.6701
                        //   productAttr: Microsoft® .NET Core
                        //   fullName: System.Runtime, Version=4.2.1.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a
                        //   imageRuntime: v4.0.30319
                        //   moduleVerId: {866f12e1-67d8-4d08-939b-fb3d7b948e1e}
                        // 3.1.7:
                        //   targetAttr: (none)
                        //   infoVerAttr: 3.1.7+36b8b8e26a8e2e06e000f59e19910d117bf0025b
                        //   fileVerAttr: 4.700.20.37001
                        //   productAttr: Microsoft® .NET Core
                        //   fullName: System.Runtime, Version=4.2.2.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a
                        //   imageRuntime: v4.0.30319
                        //   moduleVerId: {58ec7492-c413-46cf-9784-c40c2c506fc6}
                        // 5.0.0-preview8:
                        //   targetAttr: .NETCoreApp,Version=v5.0
                        //   infoVerAttr: 5.0.0-preview.8.20407.11+bf456654f9a4f9a86c15d9d50095ff29cde5f0a4
                        //   fileVerAttr: 5.0.20.40711
                        //   productAttr: Microsoft® .NET Core
                        //   fullName: System.Runtime, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a
                        //   imageRuntime: v4.0.30319
                        //   moduleVerId: {519aaf73-f0d9-461d-9e95-fd2b53fd6248}
#if DEBUG
                        Console.WriteLine(assembly.Location);
#endif
                        if (isNetCore && itemVersion == null)
                        {
                            var filteredType = typeof(AssemblyInformationalVersionAttribute);
                            var infoVersionAttr = assembly.GetCustomAttribute(filteredType) as AssemblyInformationalVersionAttribute;
#if DEBUG
                            Console.WriteLine("InformationalVersion: " + infoVersionAttr.InformationalVersion);
#endif

                            // .NET Core 3.x/.NET 5.0-preview
                            var infoVersionDetails = infoVersionAttr.InformationalVersion.Split(new char[] { '+' }, 2);
                            if (infoVersionDetails.Length == 2)
                            {
                                var infoVersions = infoVersionDetails.First().Split(new char[] { '-' }, 2);
                                var infoVersion = infoVersions.FirstOrDefault();
                                if (Version.TryParse(infoVersion, out Version ver))
                                {
                                    var productAttrType = typeof(AssemblyProductAttribute);
                                    var productAttr = assembly.GetCustomAttribute(productAttrType) as AssemblyProductAttribute;
#if DEBUG
                                    Console.WriteLine("Product:" + productAttr.Product);
#endif
                                    if (productAttr != null
                                        && (productAttr.Product.Contains(".NET Core"))
                                        || productAttr.Product == "Microsoft® .NET")
                                    {
                                        itemVersion = ver;
                                        if (infoVersions.Length == 2)
                                        {
                                            previewName = infoVersions[1];
                                        }
                                    }
                                }
                            }

                            if(itemVersion == null)
                            {
                                // try .NET Core 2.1/2.2
                                const string atBranch = "@Branch:";
                                var branch = infoVersionAttr.InformationalVersion.IndexOf(atBranch);
                                var srccode = infoVersionAttr.InformationalVersion.IndexOf("@SrcCode:");
                                if (0 <= branch && branch < srccode)
                                {
                                    var branchVer = infoVersionAttr.InformationalVersion.Substring(branch + atBranch.Length, srccode - branch - atBranch.Length);
                                    var numbers = "0123456789.".ToCharArray();
                                    var start = branchVer.IndexOfAny(numbers);
                                    if (start >= 0)
                                    {
                                        branchVer = branchVer.Substring(start);
                                        var numberVer = "";
                                        foreach (var ch in branchVer)
                                        {
                                            if (numbers.Contains(ch))
                                            {
                                                numberVer += ch;
                                            }
                                            else
                                            {
                                                break;
                                            }
                                        }
                                        if (Version.TryParse(numberVer, out Version ver2))
                                        {
                                            var productAttrType = typeof(AssemblyProductAttribute);
                                            var productAttr = assembly.GetCustomAttribute(productAttrType) as AssemblyProductAttribute;
#if DEBUG
                                            Console.WriteLine("Product: " + productAttr.Product);
#endif
                                            if (productAttr != null
                                                && productAttr.Product == "Microsoft® .NET Framework")
                                            {
                                                itemVersion = ver2;
                                            }
                                        }

                                        // to be not able to detect whether it is preview edition from the attribute information
                                    }
                                }
                                else
                                {
                                    itemVersion = new Version(2, 0);
                                    // to be not able to detect whether it is preview edition from the attribute information
                                }
                                if (itemVersion != null && !isSelfContained)
                                {
                                    // C:\Program Files\dotnet\shared\Microsoft.NETCore.App\2.0.5\System.Runtime.dll
                                    // C:\Program Files\dotnet\shared\Microsoft.NETCore.App\5.0.0-preview.8.20411.6\System.Runtime.dll
                                    var folderPath = Path.GetDirectoryName(assembly.Location);
                                    var folderVerName = Path.GetFileName(folderPath);
                                    folderPath = Path.GetDirectoryName(folderPath);
                                    var folderSdkName = Path.GetFileName(folderPath);
                                    if (string.Compare(folderSdkName, "Microsoft.NETCore.App", pathCompOpt) == 0)
                                    {
                                        var verNames = folderVerName.Split(new char[] { '-' }, 2);
                                        if (verNames.Length == 2)
                                        {
                                            previewName = verNames[1];
                                        }
                                        if (Version.TryParse(verNames[0], out Version ver3))
                                        {
                                            if (itemVersion.Major == ver3.Major && itemVersion <= ver3)
                                            {
                                                itemVersion = ver3;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        break;

                    // for .NET Framework
                    case "mscorlib.dll":
                    case "system.dll":
                    case "system.core.dll":
#if DEBUG
                        Console.WriteLine(assembly.Location);
#endif
                        // 4.8
                        //   fileVer: 4.8.4220.0
                        //   product: Microsoft® .NET Framework
                        //    
                        if (!isNetCore && itemVersion == null)
                        {
                            var filteredType = typeof(AssemblyFileVersionAttribute);
                            var fileVersion = assembly.GetCustomAttribute(filteredType) as AssemblyFileVersionAttribute;
                            if (Version.TryParse(fileVersion.Version, out Version ver))
                            {
                                var productAttrType = typeof(AssemblyProductAttribute);
                                var productAttr = assembly.GetCustomAttribute(productAttrType) as AssemblyProductAttribute;
#if DEBUG
                                Console.WriteLine("Product:" + productAttr.Product);
#endif
                                if (productAttr != null && productAttr.Product.Contains(".NET Framework"))
                                {
                                    itemVersion = ver;
                                }
                            }
                        }
                        if (!isNetCore && itemVersion == null)
                        {
                            var fileVer = System.Diagnostics.FileVersionInfo.GetVersionInfo(
                            assembly.Location);
                            if (fileVer.ProductName.Contains(".NET Framework"))
                            {
                                if (fileVer.FileMajorPart > 0)
                                {
                                    itemVersion = new Version(fileVer.FileMajorPart, fileVer.FileMinorPart, fileVer.FileBuildPart, fileVer.FilePrivatePart);
                                }
                            }
                        }
                        break;
                }
                if (itemVersion != null)
                {
                    if (version == null || version < itemVersion)
                    {
                        version = itemVersion;
                    }
                }
            }

            return version;
        }


        /// <summary>
        /// Provides functionality to detect which type of the .NET Framework / .NET Core used by the running application.
        /// </summary>
        /// <returns>Detected FrameworkTypes</returns>
        public static FrameworkTypes DetectAppTargetNetType()
        {
            FrameworkTypes frameworkType = FrameworkTypes.Unknown;

            var assembly = Assembly.GetEntryAssembly();
            var filteredType = typeof(System.Runtime.Versioning.TargetFrameworkAttribute);
            var targetAttribute = assembly.GetCustomAttribute(filteredType) as System.Runtime.Versioning.TargetFrameworkAttribute;
            if (targetAttribute != null)
            {
                var props = targetAttribute.FrameworkName.Split(',');
                var frameworkName = props.FirstOrDefault();
                switch (frameworkName)
                {
                    case ".NETCoreApp":
                        frameworkType = FrameworkTypes.DotNet;
                        break;
                    case ".NETFramework":
                        frameworkType = FrameworkTypes.DotNetFramework;
                        break;
                }
            }
            return frameworkType;
        }

        /// <summary>
        /// Provides functionality to detect which version of the .NET Framework / .NET Core that was specified as the TargetFramwork at build time.
        /// </summary>
        /// <returns>Detected version, null if version cannot be determined</returns>
        public static Version DetectAppTargetNetVersion()
        {
            return DetectTaregetNetVersion(Assembly.GetEntryAssembly());
        }

        /// <summary>
        /// Provides functionality to detect which version of the .NET Framework / .NET Core that was specified as the TargetFramwork at build time.
        /// </summary>
        /// <returns>Detected version, null if version cannot be determined</returns>
        public static Version DetectTaregetNetVersion(string moudleFilePath)
        {
            Version version = null;

            var assembly = Assembly.LoadFrom(moudleFilePath);
            if (assembly != null)
            {
                version = DetectTaregetNetVersion(assembly);
            }

            return version;
        }

        /// <summary>
        /// Provides functionality to detect which version of the .NET Framework / .NET Core that was specified as the TargetFramwork at build time.
        /// </summary>
        /// <returns>Detected version, null if version cannot be determined</returns>
        public static Version DetectTaregetNetVersion(Assembly assembly)
        {
            Version version = null;

            var filteredType = typeof(System.Runtime.Versioning.TargetFrameworkAttribute);
            var targetAttribute = assembly.GetCustomAttribute(filteredType) as System.Runtime.Versioning.TargetFrameworkAttribute;
            if (targetAttribute != null)
            {
                const string versionTag = "Version=";
                var props = targetAttribute.FrameworkName.Split(',');
                var versionName = props.FirstOrDefault(i => i.Replace(" ", "").StartsWith(versionTag, StringComparison.OrdinalIgnoreCase))?.Replace(" ", "")?.Substring(versionTag.Length)?.Trim(' ');
                if (versionName != null)
                {
                    versionName = versionName.TrimStart('v', 'V');
                    if (Version.TryParse(versionName, out Version result))
                    {
                        version = result;
                    }
                }
            }
            return version;
        }

        static Version ConvertDotNetFrameworkVersion(Version fileVersion)
        {
            var result = fileVersion;
            if (new Version(4, 8, 4220) == fileVersion)
            {
                result = new Version(4, 8, 0, 4200);
            }
            return result;
        }
    }
}