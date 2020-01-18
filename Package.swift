// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


/**

 Things to figure out:
 


 MACOS_FILES = *~macos.*
 IOS_FILES =*~ios.*
 TVOS_FILES = *~tvos.*
 WATCHOS_FILES = *~watchos.*

 // First things get excluded. For good measure, exclude ALL platform files
 EXCLUDED_SOURCE_FILE_NAMES = $(MACOS_FILES) $(IOS_FILES) $(TVOS_FILES) $(WATCHOS_FILES)

 // Then re-include the platform-specific files
 INCLUDED_SOURCE_FILE_NAMES =
 INCLUDED_SOURCE_FILE_NAMES[sdk=mac*] = $(MACOS_FILES)
 INCLUDED_SOURCE_FILE_NAMES[sdk=iphone*] = $(IOS_FILES)
 INCLUDED_SOURCE_FILE_NAMES[sdk=appletv*] = $(TVOS_FILES)
 INCLUDED_SOURCE_FILE_NAMES[sdk=watch*] = $(WATCHOS_FILES)
 


 
**/

/* Example:
 

 ///         cSettings: [
 ///             .headerSearchPath("path/relative/to/my/target"),
 ///             .define("DISABLE_SOMETHING", .when(platforms: [.iOS], configuration: .release)),
 ///         ],
 ///         swiftSettings: [
 ///             .define("ENABLE_SOMETHING", .when(configuration: .release)),
 ///         ],
 ///         linkerSettings: [
 ///             .linkLibrary("openssl", .when(platforms: [.linux])),
 ///         ]
 
 */


/*
TODO:
SYZ_DEVICE_GCC = BUILDING_FOR_DEVICE=1 BUILDING_FOR_SIMULATOR=0
SYZ_DEVICE_GCC[sdk=*simulator] = BUILDING_FOR_DEVICE=0 BUILDING_FOR_SIMULATOR=1

_SYZ_EXTENSION_GCC_YES = 1
_SYZ_EXTENSION_GCC_NO = 0
_SYZ_APP_GCC_YES = 0
_SYZ_APP_GCC_NO = 1
SYZ_EXTENSION_GCC = BUILDING_FOR_EXTENSION=$(_SYZ_EXTENSION_GCC_$(APPLICATION_EXTENSION_API_ONLY)) BUILDING_FOR_APP=$(_SYZ_APP_GCC_$(APPLICATION_EXTENSION_API_ONLY))
 */

let cSettings: Array<CSetting>? = [
    .define("BUILDING_FOR_MOBILE", to: "1", .when(platforms: [.iOS, .tvOS, .watchOS])),
    .define("BUILDING_FOR_MOBILE", to: "0", .when(platforms: [.macOS, .linux])),
    
    .define("BUILDING_FOR_DESKTOP", to: "0", .when(platforms: [.iOS, .tvOS, .watchOS])),
    .define("BUILDING_FOR_DESKTOP", to: "1", .when(platforms: [.macOS, .linux])),
    
    .define("BUILDING_FOR_MAC", to: "1", .when(platforms: [.macOS])),
    .define("BUILDING_FOR_MAC", to: "0", .when(platforms: [.iOS, .tvOS, .watchOS, .linux])),
    
    .define("BUILDING_FOR_IOS", to: "1", .when(platforms: [.iOS])),
    .define("BUILDING_FOR_IOS", to: "0", .when(platforms: [.macOS, .tvOS, .watchOS, .linux])),
    
    .define("BUILDING_FOR_TV", to: "1", .when(platforms: [.tvOS])),
    .define("BUILDING_FOR_TV", to: "0", .when(platforms: [.macOS, .iOS, .watchOS, .linux])),
    
    .define("BUILDING_FOR_WATCH", to: "1", .when(platforms: [.watchOS])),
    .define("BUILDING_FOR_WATCH", to: "0", .when(platforms: [.macOS, .iOS, .tvOS, .linux])),
    
    .define("BUILDING_FOR_LINUX", to: "1", .when(platforms: [.linux])),
    .define("BUILDING_FOR_LINUX", to: "0", .when(platforms: [.macOS, .iOS, .tvOS, .watchOS])),
]

/* TODO:
 
 // Device vs Simulator
 SYZ_DEVICE = BUILDING_FOR_DEVICE
 SYZ_DEVICE[sdk=*simulator] = BUILDING_FOR_SIMULATOR

 // App vs Extension

 _SYZ_EXTENSION_YES = BUILDING_FOR_EXTENSION
 _SYZ_EXTENSION_NO = BUILDING_FOR_APP
 SYZ_EXTENSION = $(_SYZ_EXTENSION_$(APPLICATION_EXTENSION_API_ONLY))
 */
let swiftSettings: Array<SwiftSetting>? = [
    .define("BUILDING_FOR_MOBILE", .when(platforms: [.iOS, .tvOS, .watchOS])),
    .define("BUILDING_FOR_DESKTOP", .when(platforms: [.macOS, .linux])),
    .define("BUILDING_FOR_MAC", .when(platforms: [.macOS])),
    .define("BUILDING_FOR_IOS", .when(platforms: [.iOS])),
    .define("BUILDING_FOR_TV", .when(platforms: [.tvOS])),
    .define("BUILDING_FOR_WATCH", .when(platforms: [.watchOS])),
    .define("BUILDING_FOR_LINUX", .when(platforms: [.linux])),
]


let package = Package(
    name: "Syzygy",
    platforms: [.macOS(.v10_12), .iOS(.v11), .watchOS(.v4), .tvOS(.v11)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(name: "SyzygyCore", targets: ["SyzygyCore"]),
//        .library(name: "SyzygyKit", targets: ["SyzygyKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/ra1028/DifferenceKit", from: "1.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "SyzygyCore-ObjC", dependencies: [], exclude: [], cSettings: cSettings, swiftSettings: swiftSettings),
        .target(name: "SyzygyCore", dependencies: ["SyzygyCore-ObjC", "DifferenceKit"], cSettings: cSettings, swiftSettings: swiftSettings),
//        .target(name: "SyzygyKit", dependencies: ["SyzygyCore"]),
    ]
)
