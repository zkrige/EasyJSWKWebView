// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "EasyJSWKWebView",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "EasyJSWKWebView", targets: ["EasyJSWKWebView"])
    ],
    targets: [
        .target(
            name: "EasyJSWKWebView",
            path: "EasyJSWKWebView",
            resources: [.process("Assets")],
            publicHeadersPath: "Classes",
            cSettings: [
                .headerSearchPath("Classes")
            ]
        )
    ]
)
