// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

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
    
    .define("BUILDING_FOR_UIKIT", to: "1", .when(platforms: [.iOS, .tvOS])),
    .define("BUILDING_FOR_UIKIT", to: "0", .when(platforms: [.macOS, .watchOS, .linux])),
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
    .define("BUILDING_FOR_UIKIT", .when(platforms: [.iOS, .tvOS])),
]


let package = Package(
    name: "Syzygy",
    platforms: [.macOS(.v10_13), .iOS(.v11), .watchOS(.v4), .tvOS(.v11)],
    products: [
        .library(name: "SyzygyCore", targets: ["SyzygyCore"]),
        .library(name: "HTTP", targets: ["HTTP"]),
        .library(name: "XCTestExtensions", targets: ["XCTestExtensions"]),
        .library(name: "SyzygyKit", targets: ["SyzygyKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ra1028/DifferenceKit", from: "1.1.0"),
    ],
    
    targets: [
        // this target is pure Objective-C code. It's for stuff that's either impossible or very difficult to implement in Swift
        .target(name: "Syzygy-ObjC", dependencies: [], exclude: [], cSettings: cSettings, swiftSettings: swiftSettings),
        
        // Raw, fundamental types used EVERYWHERE
        .target(name: "Core", dependencies: [], cSettings: cSettings, swiftSettings: swiftSettings),
        
        // Extensions to Swift Standard Library
        .target(name: "StandardLibrary", dependencies: ["Core"], cSettings: cSettings, swiftSettings: swiftSettings),
        
        // Interacting with the filesystem
        .target(name: "Paths", dependencies: ["StandardLibrary"], cSettings: cSettings, swiftSettings: swiftSettings),
        
        // Observables
        .target(name: "Properties", dependencies: ["StandardLibrary", "DifferenceKit"], cSettings: cSettings, swiftSettings: swiftSettings),
        
        // Sorting 
        .target(name: "Sorting", dependencies: ["StandardLibrary"], cSettings: cSettings, swiftSettings: swiftSettings),
        
        // Structured persistence types (Plist, JSON)
        .target(name: "Structures", dependencies: ["Paths"], cSettings: cSettings, swiftSettings: swiftSettings),
        
        // Uniform Type Identifiers
        .target(name: "UTI", dependencies: ["Core", "Paths"], cSettings: cSettings, swiftSettings: swiftSettings),
        
        .target(name: "SyzygyCore", dependencies: ["Syzygy-ObjC", "Core", "Paths", "Properties", "Sorting", "StandardLibrary", "Structures", "UTI", "DifferenceKit"], cSettings: cSettings, swiftSettings: swiftSettings),
        
        
        .target(name: "SyzygyKit", dependencies: ["SyzygyCore", "Core"], cSettings: cSettings, swiftSettings: swiftSettings),
        
        .target(name: "HTTP", dependencies: []),
        .target(name: "XCTestExtensions", dependencies: []),
        
        .testTarget(name: "HTTPTests", dependencies: ["HTTP", "XCTestExtensions"])
    ]
)
