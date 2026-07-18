import SwiftUI

struct GalleryView: View {
    @EnvironmentObject private var store: DiagramStore
    @EnvironmentObject private var purchase: PurchaseManager
    @Binding var showPaywall: Bool

    private let columns = [
        GridItem(.flexible(minimum: 140), spacing: 10, alignment: .top),
        GridItem(.flexible(minimum: 140), spacing: 10, alignment: .top)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 12) {
                    ForEach(store.filteredItems) { diagram in
                        NavigationLink {
                            DiagramDetailView(diagram: diagram, showPaywall: $showPaywall)
                        } label: {
                            GalleryCard(diagram: diagram, locked: !purchase.canAccess(diagram))
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("gallery-card-\(diagram.serial)")
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 10)
                .padding(.bottom, 28)
            }
            .background(AppTheme.paper)
            .searchable(text: $store.query, prompt: "250図解を検索")
            .navigationTitle("ギャラリー")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Picker("カテゴリ", selection: $store.category) {
                            ForEach(store.categories, id: \.self) { category in
                                Text(category).tag(category)
                            }
                        }
                    } label: {
                        Label(store.category, systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
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

