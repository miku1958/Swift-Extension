// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let buildSetting: [SwiftSetting] = [
//	.define("TestMode", .when(configuration: .debug))
]
let package = Package(
	name: "Swift-Extension",
	platforms: [
		.macOS(.v12)
	],
	products: [
		.library(name: "Extension", targets: ["Extension", "ObjcExtension"])
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages this package depends on.
		.target(
			name: "Extension",
			dependencies: [
				"ObjcExtension"
			],
			swiftSettings: buildSetting
		),
		.target(
			name: "ObjcExtension",
			swiftSettings: buildSetting
		),
		.testTarget(
			name: "ExtensionTests",
			dependencies: ["Extension"],
			swiftSettings: buildSetting
		)
	]
)
