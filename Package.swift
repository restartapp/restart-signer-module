// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "RestartSigner",
  platforms: [
    .macOS(.v12)
  ],
  products: [
    .library(
      name: "RestartSigner",
      targets: ["RestartSigner"]),
  ],
  dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", from: "4.55.0"),
    .package(url: "https://github.com/vapor/jwt.git", .upToNextMajor(from: "4.1.0")),
  ],
  targets: [
    .target(
      name: "RestartSigner",
      dependencies: [
        .product(name: "Vapor", package: "vapor"),
        .product(name: "JWT", package: "jwt"),
      ]),
    .testTarget(
      name: "RestartSignerTests",
      dependencies: ["RestartSigner"]),
  ]
)
