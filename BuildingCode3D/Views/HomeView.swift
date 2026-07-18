import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: DiagramStore
    @EnvironmentObject private var purchase: PurchaseManager
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Binding var tab: AppTab
    @Binding var showPaywall: Bool

    private let categoryIcons = [
        "doc.text.magnifyingglass", "building.2.fill", "ruler", "map.fill", "flame.fill",
        "figure.walk", "building.columns.fill", "leaf.fill", "square.grid.3x3", "checklist"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 19) {
                    hero
                    AppSearchField()
                    CategoryChips()
                    if !store.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        searchResults
                    }
                    HomeSummaryBar(
                        diagramCount: store.items.count,
                        isUnlocked: purchase.isUnlocked,
                        unlockAction: { tab = .pro }
                    )
                    SectionHeading("25テーマ", subtitle: "法令体系から避難規定まで、実務の確認順に整理")
                    themeGrid
                    ProCallout { tab = .pro }
                    featuredDiagrams
                    featuredTools
                    officialSources
                    editorialNotice
                }
                .frame(maxWidth: 980)
                .padding(.horizontal, sizeClass == .regular ? 24 : 16)
                .padding(.top, 8)
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity)
            }
            .background(AppTheme.paper)
            .navigationTitle(AppConfig.appName)
        }
    }

    private var hero: some View {
        Image("HeroBanner")
            .resizable()
            .scaledToFit()
            .background(AppTheme.indigo)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay { RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.15)) }
            .shadow(color: AppTheme.indigo.opacity(0.16), radius: 18, y: 8)
            .accessibilityLabel("建築基準法令3D図解。250図解、25テーマ、100ツール。")
    }

    private var searchResults: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("検索結果")
                    .font(.headline)
                Spacer()
                Text("\(store.filteredItems.count)件")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.muted)
            }
            if store.filteredItems.isEmpty {
                ContentUnavailableView(
                    "該当する図解がありません",
                    systemImage: "magnifyingglass",
                    description: Text("別の語句またはカテゴリで検索してください。")
                )
            } else {
                ForEach(store.filteredItems.prefix(7)) { diagram in
                    NavigationLink {
                        DiagramDetailView(diagram: diagram, showPaywall: $showPaywall)
                    } label: {
                        DiagramRow(diagram: diagram, locked: !purchase.canAccess(diagram))
                    }
                    .buttonStyle(.plain)
                }
                if store.filteredItems.count > 7 {
                    Button("全\(store.filteredItems.count)件を図解タブで表示") {
                        tab = .library
                    }
                    .font(.subheadline.weight(.bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
            }
        }
        .padding(13)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay { RoundedRectangle(cornerRadius: 16).stroke(AppTheme.line) }
    }

    private var themeGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 10)], spacing: 10) {
            ForEach(store.themes) { theme in
                NavigationLink {
                    ThemeView(theme: theme, showPaywall: $showPaywall)
                } label: {
                    VStack(alignment: .leading, spacing: 9) {
                        HStack {
                            Image(systemName: categoryIcons[(theme.id - 1) % categoryIcons.count])
                                .font(.system(size: 17, weight: .bold))
                                .foregroundStyle(AppTheme.cobalt)
                                .frame(width: 36, height: 36)
                                .background(AppTheme.accentSoft, in: RoundedRectangle(cornerRadius: 10))
                            Spacer()
                            Text(String(format: "%02d", theme.id))
                                .font(.caption.weight(.heavy))
                                .foregroundStyle(AppTheme.vermilion)
                        }
                        Text(theme.name)
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(AppTheme.ink)
                            .lineLimit(2)
                        HStack {
                            Text("\(theme.items.count)図解")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(AppTheme.muted)
                    }
                    .frame(maxWidth: .infinity, minHeight: 106, alignment: .topLeading)
                    .padding(12)
                    .background(AppTheme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay { RoundedRectangle(cornerRadius: 15).stroke(AppTheme.line) }
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("theme-\(theme.id)")
            }
        }
    }

    private var featuredDiagrams: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeading("注目の3D図解", subtitle: "図版を欠けさせず縦長で閲覧", actionTitle: "ギャラリー") {
                tab = .gallery
            }
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 11) {
                    ForEach(Array(store.items.prefix(12))) { diagram in
                        NavigationLink {
                            DiagramDetailView(diagram: diagram, showPaywall: $showPaywall)
                        } label: {
                            GalleryCard(diagram: diagram, locked: !purchase.canAccess(diagram))
                                .frame(width: 188)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var featuredTools: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeading("注目ツール", subtitle: "ロックなし。計算・チェック・メモ・共有まで実動", actionTitle: "100ツール") {
                tab = .tools
            }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 225), spacing: 9)], spacing: 9) {
                ForEach(ToolCatalog.tools.prefix(6)) { tool in
                    NavigationLink {
                        ToolWorkspaceView(tool: tool)
                    } label: {
                        ToolCard(tool: tool)
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("featured-tool-\(tool.id)")
                }
            }
        }
    }

    private var officialSources: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeading("一次情報", subtitle: "e-Gov・国土交通省の現行情報へ直接アクセス")
            VStack(spacing: 0) {
                ForEach(Array(ResourceCatalog.resources.prefix(5).enumerated()), id: \.element.id) { index, resource in
                    Link(destination: resource.url) {
                        HStack(spacing: 11) {
                            Image(systemName: "arrow.up.right.square.fill")
                                .foregroundStyle(AppTheme.cobalt)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(resource.title)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(AppTheme.ink)
                                Text(resource.note)
                                    .font(.caption)
                                    .foregroundStyle(AppTheme.muted)
                                    .lineLimit(1)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 13)
                        .padding(.vertical, 11)
                    }
                    if index < 4 { Divider().padding(.leading, 44) }
                }
                NavigationLink {
                    ResourcesView()
                } label: {
                    Label("すべての公式リンクとアプリ情報", systemImage: "link")
                        .font(.subheadline.weight(.bold))
                        .frame(maxWidth: .infinity)
                        .padding(13)
                }
            }
            .background(AppTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay { RoundedRectangle(cornerRadius: 15).stroke(AppTheme.line) }
        }
    }

    private var editorialNotice: some View {
        Label {
            Text("資料基準日：\(AppConfig.basisDate)。本アプリは参考図と確認支援を提供し、法適合の最終判定、設計、申請、工事監理又は検査を代替しません。")
                .font(.footnote)
        } icon: {
            Image(systemName: "exclamationmark.shield.fill")
                .foregroundStyle(AppTheme.vermilion)
        }
        .foregroundStyle(AppTheme.muted)
        .padding(14)
        .background(AppTheme.vermilion.opacity(0.06), in: RoundedRectangle(cornerRadius: 14))
    }
}

struct ThemeView: View {
    @EnvironmentObject private var purchase: PurchaseManager
    let theme: DiagramTheme
    @Binding var showPaywall: Bool

    var body: some View {
        List(theme.items) { diagram in
            NavigationLink {
                DiagramDetailView(diagram: diagram, showPaywall: $showPaywall)
            } label: {
                DiagramRow(diagram: diagram, locked: !purchase.canAccess(diagram))
            }
        }
        .navigationTitle(theme.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
