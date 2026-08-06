// swift-tools-version: 5.9
import PackageDescription

// Сессия, профиль и авторизация — три РАЗНЫХ контракта.
// Из того, что все зависят от авторизации, не следует, что все
// зависят от фичи Auth: почти всем нужен только SessionInterface.

let package = Package(
    name: "KufarIdentityContracts",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(name: "SessionInterface", targets: ["SessionInterface"]),
        .library(name: "ProfileInterface", targets: ["ProfileInterface"]),
        .library(name: "AuthInterface", targets: ["AuthInterface"]),
        .library(name: "SessionInterfaceTesting", targets: ["SessionInterfaceTesting"])
    ],
    dependencies: [
        .package(id: "kufar.Foundation", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "SessionInterface",
            dependencies: [
                .product(name: "SharedKernel", package: "kufar.Foundation")
            ]
        ),
        .target(
            name: "ProfileInterface",
            dependencies: [
                .product(name: "SharedKernel", package: "kufar.Foundation")
            ]
        ),
        .target(
            name: "AuthInterface",
            dependencies: [
                .product(name: "SharedKernel", package: "kufar.Foundation")
            ]
        ),
        .target(
            name: "SessionInterfaceTesting",
            dependencies: [
                "SessionInterface",
                .product(name: "SharedKernel", package: "kufar.Foundation")
            ]
        )
    ]
)
