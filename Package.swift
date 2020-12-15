// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Renga",
  products: [
    .library(
      name: "Renga",
      targets: ["Renga"]
    ),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "Renga",
      dependencies: [
      ]
    ),
    .testTarget(
      name: "RengaTests",
      dependencies: [
        "Renga",
      ]
    ),
  ]
)
