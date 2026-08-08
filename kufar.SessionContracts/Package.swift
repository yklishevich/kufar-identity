// swift-tools-version: 5.9
import PackageDescription

// Сессия отдельным ПАКЕТОМ, а не продуктом внутри kufar.IdentityContracts.
//
// Разрез сделан по двум условиям (оба записаны в architecture-overall.md):
//
//   1. Межкомандная экспозиция. Резолв идёт по пакетам, а не по продуктам:
//      товары и авто берут из identity только ProfileInterface, но пакет
//      подключают целиком — и мажор в сессии, которую они не импортируют,
//      запирает их на старой мажорной версии.
//
//   2. Разные направления и разные причины изменений. ProfileInterface
//      и AuthInterface — маршруты, обращённые к вертикалям; они меняются,
//      когда меняется инвентарь экранов. SessionInterface обращён к корню
//      и меняется, когда меняется жизненный цикл авторизации. Общего
//      у них — только команда-владелец.
//
// Что это дало: kufar.AppComposition перестал зависеть от
// kufar.IdentityContracts вообще — ему нужна была только сессия.

let package = Package(
    name: "KufarSessionContracts",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(name: "SessionInterface", targets: ["SessionInterface"]),
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
            name: "SessionInterfaceTesting",
            dependencies: [
                "SessionInterface",
                .product(name: "SharedKernel", package: "kufar.Foundation")
            ]
        )
    ]
)
