import Foundation

struct Diagram: Codable, Identifiable, Hashable {
    let id: String
    let serial: Int
    let themeNo: Int
    let themeName: String
    let category: String
    let plateNo: Int
    let plateType: String
    let figureClass: String
    let title: String
    let purpose: String
    let visualType: String
    let scene: String
    let labels: [String]
    let primarySourceTitle: String
    let primarySourceLocator: String
    let primarySourceURL: String
    let applicability: String
    let professionalCaution: String
    let sourceCaption: String
    let nonofficialCaption: String
    let basisDate: String
    let image: String

    var sourceURL: URL? { URL(string: primarySourceURL) }
    var serialLabel: String { String(format: "%03d", serial) }
}

struct DiagramTheme: Identifiable, Hashable {
    let id: Int
    let name: String
    let category: String
    let items: [Diagram]
}

enum DiagramSort: String, CaseIterable, Identifiable {
    case number, title, category

    var id: String { rawValue }
    var title: String {
        switch self {
        case .number: "図版番号順"
        case .title: "タイトル順"
        case .category: "カテゴリ順"
        }
    }
}

