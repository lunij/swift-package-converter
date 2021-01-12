// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "NewRelic",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(
            name: "NewRelic",
            targets: [
                "NewRelic"
            ]
        ),
    ],
    targets: [
        .binaryTarget(name: "NewRelic", url: "https://github.com/lunij/swift-package-converter/raw/newrelic/Frameworks/NewRelic.zip", checksum: "3e6104fa9078c662c5630e85d67fa42a53c2cd15856d547fbcdbbef48d0533f9")
    ]
)
