import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    @Published private(set) var isUnlocked = false
    @Published private(set) var product: Product?
    @Published private(set) var isLoading = false
    @Published private(set) var isPurchasing = false
    @Published private(set) var message: String?

    private var listener: Task<Void, Never>?

    func canAccess(_ diagram: Diagram) -> Bool {
        isUnlocked || diagram.serial <= AppConfig.freeDiagramCount
    }

    func loadProduct() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            product = try await Product.products(for: [AppConfig.productID]).first
            if product == nil {
                message = "購入情報を取得できません。通信状態を確認して再読み込みしてください。"
            }
        } catch {
            product = nil
            message = "購入情報の読み込みに失敗しました。再試行できます。"
        }
    }

    func refresh() async {
        await loadProduct()
        var unlocked = false
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == AppConfig.productID,
               transaction.revocationDate == nil {
                unlocked = true
                break
            }
        }
        isUnlocked = unlocked
    }

    func startListening() {
        guard listener == nil else { return }
        listener = Task.detached { [weak self] in
            for await result in Transaction.updates {
                guard case .verified(let transaction) = result else { continue }
                await transaction.finish()
                await self?.refresh()
            }
        }
    }

    func purchase() async {
        message = nil
        if product == nil { await loadProduct() }
        guard let product else {
            message = "購入情報を取得できません。しばらくしてから再試行してください。"
            return
        }
        isPurchasing = true
        defer { isPurchasing = false }
        do {
            switch try await product.purchase() {
            case .success(let verification):
                guard case .verified(let transaction) = verification else {
                    message = "購入の検証に失敗しました。料金は請求されません。"
                    return
                }
                await transaction.finish()
                await refresh()
                message = isUnlocked ? "全250図解を利用できるようになりました。" : nil
            case .pending:
                message = "購入は承認待ちです。承認後に自動で解除されます。"
            case .userCancelled:
                message = nil
            @unknown default:
                message = "購入処理を完了できませんでした。"
            }
        } catch {
            message = "購入に失敗しました：\(error.localizedDescription)"
        }
    }

    func restore() async {
        message = nil
        do {
            try await AppStore.sync()
            await refresh()
            message = isUnlocked ? "以前の購入を復元しました。" : "復元できる購入は見つかりませんでした。"
        } catch {
            message = "購入の復元に失敗しました：\(error.localizedDescription)"
        }
    }
}

