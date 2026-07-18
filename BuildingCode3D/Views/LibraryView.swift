import SwiftUI

struct LibraryView: View {
    @EnvironmentObject private var store: DiagramStore
    @EnvironmentObject private var purchase: PurchaseManager
    @Binding var showPaywall: Bool

    var body: some View {
        NavigationStack {
            List {
                Section {
                    CategoryChips()
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                ForEach(store.filteredItems) { diagram in
                    NavigationLink {
                        DiagramDetailView(diagram: diagram, showPaywall: $showPaywall)
                    } label: {
                        DiagramRow(diagram: diagram, locked: !purchase.canAccess(diagram))
                    }
                    .accessibilityIdentifier("diagram-row-\(diagram.serial)")
                }
            }
            .listStyle(.insetGrouped)
            .searchable(text: $store.query, prompt: "図解・条文・用途・確認点を検索")
            .overlay {
                if store.filteredItems.isEmpty {
                    ContentUnavailableView.search(text: store.query)
                }
            }
            .navigationTitle("全250図解")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("並べ替え", selection: $store.sort) {
                            ForEach(DiagramSort.allCases) { sort in
                                Text(sort.title).tag(sort)
                            }
                        }
                    } label: {
                        Label("並べ替え", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
        }
    }
}

