// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Swiping Carousel",
    platforms: [
        .iOS(.v8),
    ],
    products: [
        .library(
            name: "SwipingCarousel",
            targets: ["SwipingCarousel"]),
    ],
    dependencies: [
        // no dependencies
    ],
    targets: [
        .target(
            name: "SwipingCarousel",
            dependencies: []),
        .testTarget(
            name: "SwipingCarouselTests",
            dependencies: ["SwipingCarousel"]),
    ]
)
