// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "GoogleMaps",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(
            name: "GoogleMaps",
            targets: [
                "GoogleMaps",
                "GoogleMapsBase",
                "GoogleMapsCore",
                "GoogleMapsM4B"
            ]
        ),
    ],
    targets: [
        .binaryTarget(name: "GoogleMaps", url: "https://github.com/lunij/swift-package-converter/raw/google-maps/Frameworks/GoogleMaps.zip", checksum: "11f80eec3876f7e60f1e517fb43462a3165ff17ed0eb2572866a5c83cd637267"),
        .binaryTarget(name: "GoogleMapsBase", url: "https://github.com/lunij/swift-package-converter/raw/google-maps/Frameworks/GoogleMapsBase.zip", checksum: "7d38fcbb5e0a1e1d17cae81b7f8bd077cf971bf56f22afbef9d3578efd40fa0a"),
        .binaryTarget(name: "GoogleMapsCore", url: "https://github.com/lunij/swift-package-converter/raw/google-maps/Frameworks/GoogleMapsCore.zip", checksum: "4079ec611d0cb073957de8fdc35fb3b5864f0a2463e232b3cf8c3c258dd95f7d"),
        .binaryTarget(name: "GoogleMapsM4B", url: "https://github.com/lunij/swift-package-converter/raw/google-maps/Frameworks/GoogleMapsM4B.zip", checksum: "0411eb84a314c0c02773d2decd64227d5de3cb438c5d458c80d579b9ff066d0a")
    ]
)
