// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let optimiseOnRelease = SwiftSetting.unsafeFlags(["-cross-module-optimization", "-O"], .when(configuration: .release))
let accessLevelOnImport = SwiftSetting.enableExperimentalFeature("AccessLevelOnImport", .when(configuration: .release))
let retroactiveAttribute = SwiftSetting.enableExperimentalFeature("RetroactiveAttribute", .when(configuration: .release))
//let disableOutwardActorInference = SwiftSetting.enableUpcomingFeature("DisableOutwardActorInference")
//let strictConcurrency = SwiftSetting.enableExperimentalFeature("StrictConcurrency")

let allSwiftSettings: [SwiftSetting] = [
    optimiseOnRelease,
    accessLevelOnImport,
    retroactiveAttribute
]

let package = Package(
    name: "KernelSwiftUtilities",
    platforms: [
        .macOS(.v14),
        .iOS(.v18)
    ],
    products: [
        .library(name: "KernelSwiftIOS", targets: ["KernelSwiftIOS"]),
        .library(name: "KernelSwiftMacOS", targets: ["KernelSwiftMacOS"]),
        .library(name: "KernelSwiftServer", targets: ["KernelSwiftServer"]),
        .library(name: "KernelSwiftCommon", targets: ["KernelSwiftCommon"]),
//        .library(name: "VariableBlurEffect", targets: ["VariableBlurEffect"]),
        .library(name: "KernelSwiftApplePlatforms", targets: ["KernelSwiftApplePlatforms"]),
        .library(name: "KernelSwiftTerminal", targets: ["KernelSwiftTerminal"]),
        .executable(name: "KSUCryptoX509DemoServer", targets: ["KSUCryptoX509DemoServer"]),
        .executable(name: "KernelOpenAPITester", targets: ["KernelOpenAPITester"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.12.0"),
        .package(url: "https://github.com/vapor/fluent-kit.git", from: "1.52.2"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.10.1"),
        .package(url: "https://github.com/vapor/fluent-mysql-driver.git", from: "4.7.1"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver.git", from: "4.8.1"),
        .package(url: "https://github.com/vapor/queues-redis-driver.git", from: "1.1.2"),
        .package(url: "https://github.com/mattpolzin/OpenAPIKit.git", from: "3.5.2"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.2.0"),
        .package(url: "https://github.com/karwa/uniqueid", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.2.1"),
        .package(url: "https://github.com/apple/swift-async-algorithms.git", from: "1.0.4"),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-http-types.git", from: "1.3.1"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.6.2"),
        .package(url: "https://github.com/apple/swift-atomics.git", from: "1.2.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
        .package(url: "https://github.com/JohnSundell/Plot.git", from: "0.14.0"),
        .package(url: "https://github.com/vapor-community/google-cloud-kit.git", from: "1.0.0-rc.12"),
        .package(url: "https://github.com/vapor-community/wkhtmltopdf.git", from: "4.0.0"),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", .upToNextMajor(from: "3.4.5")),
        .package(url: "https://github.com/zxingify/zxingify-objc.git", revision: "510db5f6ed293bf2f9e1905d3b8268c502f3fb55")
    ],
    targets: [
        .target(
            name: "KernelSwiftIOS",
            dependencies: [
                .byName(name: "KernelSwiftApplePlatforms")
            ],
            swiftSettings: allSwiftSettings
        ),
        .target(
            name: "KernelSwiftMacOS",
            dependencies: [
                .byName(name: "KernelSwiftApplePlatforms")
            ],
            swiftSettings: allSwiftSettings
        ),
        .target(
            name: "KernelSwiftServer",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentKit", package: "fluent-kit"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "FluentMySQLDriver", package: "fluent-mysql-driver"),
                .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
                .product(name: "GoogleCloudKit", package: "google-cloud-kit"),
                .product(name: "QueuesRedisDriver", package: "queues-redis-driver"),
                .product(name: "OpenAPIKit30", package: "OpenAPIKit"),
//                .product(name: "OpenAPIKitCompat", package: "OpenAPIKit"),
                .product(name: "Plot", package: "Plot"),
                .product(name: "wkhtmltopdf", package: "wkhtmltopdf", condition: .when(platforms: [.macOS])),
                .byName(name: "KernelSwiftCommon")
                
            ],
            exclude: [
                "Location/Fluent/Migrations/Migrations+BDLine-OGRScript"
            ],
            swiftSettings: allSwiftSettings
        ),
        .target(
            name: "KernelSwiftCommon",
            dependencies: [
                .product(name: "Atomics", package: "swift-atomics"),
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "HTTPTypes", package: "swift-http-types"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "UniqueID", package: "uniqueid"),
                .product(name: "Yams", package: "Yams")
            ],
            swiftSettings: allSwiftSettings
        ),
//        .target(name: "KernelCShims"),
//        .target(name: "VariableBlurEffect"),
        .target(
            name: "KernelSwiftApplePlatforms",
            dependencies: [
                .product(name: "HTTPTypes", package: "swift-http-types"),
                .product(name: "PhoneNumberKit", package: "PhoneNumberKit"),
                .product(name: "ZXingObjC", package: "zxingify-objc"),
                .byName(name: "KernelSwiftCommon"),
//                .byName(name: "VariableBlurEffect")
            ],
            resources: [
//                .process("BlurEffects/Media.xcassets")
            ],
            swiftSettings: [
                optimiseOnRelease,
                accessLevelOnImport,
                retroactiveAttribute
            ]
        ),
        .target(
            name: "KernelSwiftTerminal",
            dependencies: [
                .byName(name: "KernelSwiftCommon")
            ],
            swiftSettings: allSwiftSettings
        ),
        
        // TESTS
        .testTarget(
            name: "KernelSwiftServerTests",
            dependencies: [
                .byName(name: "KernelSwiftServer")
            ],
            resources: [
                .process("KernelSwiftServer.xctestplan")
            ],
            swiftSettings: [
                optimiseOnRelease
            ]
        ),
        .testTarget(
            name: "KernelSwiftServerDBTests",
            dependencies: [
                .byName(name: "KernelSwiftServer")
            ],
            resources: [
                .process("KernelSwiftServerDBTests.xctestplan")
            ],
            swiftSettings: [
                optimiseOnRelease
            ]
        ),
        .testTarget(
            name: "KernelSwiftCommonTests",
            dependencies: [
                .byName(name: "KernelSwiftCommon")
            ],
            resources: [
                .process("KernelSwiftCommon.xctestplan")
            ],
            swiftSettings: [
                optimiseOnRelease
            ]
        ),
        
        // EXECUTABLES
        // Demos some of the features
        .executableTarget(
            name: "KSUCryptoX509DemoServer",
            dependencies: [
                .byName(name: "KernelSwiftServer")
            ],
            path: "Sources/Demos/Server/KSUCryptoX509DemoServer",
            swiftSettings: [
                optimiseOnRelease
            ]
        ),
        .executableTarget(
            name: "KernelOpenAPITester",
            dependencies: [
                .product(name: "OpenAPIKit", package: "OpenAPIKit"),
                .byName(name: "KernelSwiftTerminal"),
                .product(name: "ArgumentParser", package: "swift-argument-parser")

            ],
            path: "Sources/TerminalApps/KernelOpenAPITester",
            swiftSettings: [
                optimiseOnRelease
            ]
        )
      
    ]
)
