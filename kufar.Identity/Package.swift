// swift-tools-version: 5.9
import PackageDescription

// Два продукта: Profile и Auth. Реализация сессии (KeychainSessionStore)
// спрятана внутри — наружу отдаётся any SessionStore.

let package = Package(
    name: "KufarIdentity",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "Profile", targets: ["Profile"]),
        .library(name: "Auth", targets: ["Auth"])
    ],
    dependencies: [
        .package(id: "kufar.IdentityContracts", from: "1.0.0"),
        .package(id: "kufar.SearchContracts", from: "1.0.0"),
        .package(id: "kufar.Foundation", from: "1.0.0"),
        .package(id: "kufar.Navigation", from: "1.0.0"),
        .package(id: "kufar.DesignTokens", from: "1.0.0"),
        .package(id: "kufar.DesignComponents", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "ProfileUI",
            dependencies: [
                .product(name: "ProfileInterface", package: "kufar.IdentityContracts"),
                .product(name: "SessionInterface", package: "kufar.IdentityContracts"),
                .product(name: "SearchInterface", package: "kufar.SearchContracts"),
                .product(name: "Navigation", package: "kufar.Navigation"),
                .product(name: "DesignTokens", package: "kufar.DesignTokens"),
                .product(name: "DesignComponents", package: "kufar.DesignComponents"),
                .product(name: "SharedKernel", package: "kufar.Foundation")
            ]
        ),
        .target(
            name: "Profile",
            dependencies: [
                "ProfileUI",
                .product(name: "SessionInterface", package: "kufar.IdentityContracts"),
                .product(name: "SharedKernel", package: "kufar.Foundation")
            ]
        ),
        .target(
            name: "AuthData",
            dependencies: [
                .product(name: "SessionInterface", package: "kufar.IdentityContracts"),
                .product(name: "NetworkingInterface", package: "kufar.Foundation"),
                .product(name: "SharedKernel", package: "kufar.Foundation")
            ]
        ),
        .target(
            name: "AuthUI",
            dependencies: [
                .product(name: "AuthInterface", package: "kufar.IdentityContracts"),
                .product(name: "SessionInterface", package: "kufar.IdentityContracts"),
                .product(name: "DesignTokens", package: "kufar.DesignTokens"),
                .product(name: "DesignComponents", package: "kufar.DesignComponents")
            ]
        ),
        .target(
            name: "Auth",
            dependencies: [
                "AuthUI",
                "AuthData",
                .product(name: "SessionInterface", package: "kufar.IdentityContracts"),
                .product(name: "NetworkingInterface", package: "kufar.Foundation")
            ]
        )
    ]
)
