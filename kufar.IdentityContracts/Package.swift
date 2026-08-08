// swift-tools-version: 5.9
import PackageDescription

// Маршрутные контракты identity: профиль и авторизация.
//
// Сессия жила здесь третьим продуктом и уехала в kufar.SessionContracts.
// Причина — не размер, а направление: Profile и Auth обращены к вертикалям
// (товары, авто), а сессия к композиционному корню. Резолв идёт по пакетам,
// поэтому пока они лежали вместе, мажор в сессии запирал товары с авто
// на старой мажорной версии контракта, который они не импортируют.
//
// Из того, что все зависят от авторизации, по-прежнему не следует, что все
// зависят от фичи Auth: почти всем нужен SessionInterface, и он теперь
// подключается, не втягивая маршруты.

let package = Package(
    name: "KufarIdentityContracts",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(name: "ProfileInterface", targets: ["ProfileInterface"]),
        .library(name: "AuthInterface", targets: ["AuthInterface"])
    ],
    dependencies: [
        .package(id: "kufar.Foundation", from: "1.0.0")
    ],
    targets: [
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
        )
    ]
)
