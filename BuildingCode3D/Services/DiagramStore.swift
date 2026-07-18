import Foundation

@MainActor
final class DiagramStore: ObservableObject {
    @Published private(set) var items: [Diagram] = []
    @Published var query = ""
    @Published var category = "すべて"
    @Published var sort: DiagramSort = .number
    @Published var loadError: String?

    var categories: [String] {
        ["すべて"] + Set(items.map(\.category)).sorted()
    }

    var themes: [DiagramTheme] {
        Dictionary(grouping: items, by: \.themeNo)
            .map { number, values in
                DiagramTheme(
                    id: number,
                    name: values.first?.themeName ?? "テーマ \(number)",
                    category: values.first?.category ?? "",
                    items: values.sorted { $0.serial < $1.serial }
                )
            }
            .sorted { $0.id < $1.id }
    }

    var filteredItems: [Diagram] {
        let needle = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let scoped = items.filter { item in
            let categoryMatches = category == "すべて" || item.category == category
            guard categoryMatches else { return false }
            guard !needle.isEmpty else { return true }
            return [
                item.id, item.title, item.themeName, item.category, item.plateType,
                item.purpose, item.scene, item.labels.joined(separator: " "),
                item.primarySourceTitle, item.primarySourceLocator
            ]
            .joined(separator: " ")
            .localizedStandardContains(needle)
        }

        switch sort {
        case .number:
            return scoped.sorted { $0.serial < $1.serial }
        case .title:
            return scoped.sorted { $0.title.localizedStandardCompare($1.title) == .orderedAscending }
        case .category:
            return scoped.sorted {
                ($0.category, $0.serial) < ($1.category, $1.serial)
            }
        }
    }

    func load() async {
        guard items.isEmpty else { return }
        let url = Bundle.main.url(forResource: "diagrams_ja", withExtension: "json", subdirectory: "Data")
            ?? Bundle.main.url(forResource: "diagrams_ja", withExtension: "json")
        guard let url else {
            loadError = "図解データを開けませんでした。"
            return
        }
        do {
            let data = try Data(contentsOf: url)
            items = try JSONDecoder().decode([Diagram].self, from: data)
            loadError = items.count == 250 ? nil : "図解データが250件ではありません。"
        } catch {
            loadError = "図解データの読み込みに失敗しました。"
        }
    }
}

