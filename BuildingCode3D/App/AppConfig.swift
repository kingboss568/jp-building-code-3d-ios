import SwiftUI

enum AppConfig {
    static let appName = "建築基準法令3D図解"
    static let bundleID = "com.jiangyushiung.jpbuildingcode3d"
    static let sku = bundleID
    static let productID = "com.jiangyushiung.jpbuildingcode3d.pro"
    static let fixedPrice = "JPY¥1600"
    static let freeDiagramCount = 20
    static let basisDate = "2026年7月12日"
    static let supportURL = URL(string: "https://kingboss568.github.io/jp-building-code-3d-ios/support.html")!
    static let privacyURL = URL(string: "https://kingboss568.github.io/jp-building-code-3d-ios/privacy.html")!
}

enum AppTheme {
    static let paper = Color(red: 0.957, green: 0.965, blue: 0.973)
    static let surface = Color.white
    static let ink = Color(red: 0.063, green: 0.094, blue: 0.153)
    static let muted = Color(red: 0.357, green: 0.396, blue: 0.455)
    static let indigo = Color(red: 0.063, green: 0.173, blue: 0.361)
    static let cobalt = Color(red: 0.11, green: 0.345, blue: 0.647)
    static let vermilion = Color(red: 0.784, green: 0.302, blue: 0.208)
    static let brass = Color(red: 0.710, green: 0.541, blue: 0.271)
    static let line = Color(red: 0.835, green: 0.863, blue: 0.902)
    static let accentSoft = Color(red: 0.925, green: 0.949, blue: 0.984)
}
