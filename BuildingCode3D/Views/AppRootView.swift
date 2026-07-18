import SwiftUI

enum AppTab: String, CaseIterable {
    case home, library, gallery, tools, pro

    var title: String {
        switch self {
        case .home: "ホーム"
        case .library: "図解"
        case .gallery: "ギャラリー"
        case .tools: "ツール"
        case .pro: "解除"
        }
    }

    var icon: String {
        switch self {
        case .home: "square.grid.2x2.fill"
        case .library: "books.vertical.fill"
        case .gallery: "rectangle.grid.2x2.fill"
        case .tools: "wrench.and.screwdriver.fill"
        case .pro: "sparkles"
        }
    }
}

struct AppRootView: View {
    @EnvironmentObject private var store: DiagramStore
    @State private var tab: AppTab = .home
    @State private var showPaywall = false

    var body: some View {
        TabView(selection: $tab) {
            HomeView(tab: $tab, showPaywall: $showPaywall)
                .tabItem { Label(AppTab.home.title, systemImage: AppTab.home.icon) }
                .tag(AppTab.home)
            LibraryView(showPaywall: $showPaywall)
                .tabItem { Label(AppTab.library.title, systemImage: AppTab.library.icon) }
                .tag(AppTab.library)
            GalleryView(showPaywall: $showPaywall)
                .tabItem { Label(AppTab.gallery.title, systemImage: AppTab.gallery.icon) }
                .tag(AppTab.gallery)
            ToolsView()
                .tabItem { Label(AppTab.tools.title, systemImage: AppTab.tools.icon) }
                .tag(AppTab.tools)
            ProView()
                .tabItem { Label(AppTab.pro.title, systemImage: AppTab.pro.icon) }
                .tag(AppTab.pro)
        }
        .tint(AppTheme.indigo)
        .sheet(isPresented: $showPaywall) {
            NavigationStack {
                ProView(isSheet: true)
            }
        }
        .onAppear(perform: applyScreenshotRoute)
    }

    private func applyScreenshotRoute() {
        let environment = ProcessInfo.processInfo.environment
        if let value = environment["SCREENSHOT_TAB"], let route = AppTab(rawValue: value) {
            tab = route
        }
        if environment["SCREENSHOT_PAYWALL"] == "1" {
            tab = .pro
        }
        if let query = environment["SCREENSHOT_QUERY"], !query.isEmpty {
            store.query = query
        }
    }
}
