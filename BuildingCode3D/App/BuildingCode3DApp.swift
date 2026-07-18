import SwiftUI

@main
struct BuildingCode3DApp: App {
    @StateObject private var store = DiagramStore()
    @StateObject private var purchase = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(store)
                .environmentObject(purchase)
                .task {
                    await store.load()
                    await purchase.refresh()
                    purchase.startListening()
                }
        }
    }
}

