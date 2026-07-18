import SwiftUI

struct ProView: View {
    @EnvironmentObject private var purchase: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    var isSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Image("HeroBanner")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                titleBlock
                priceCard
                includedFeatures
                purchaseActions
                billingNotice
                Link(destination: AppConfig.privacyURL) {
                    Label("プライバシーポリシー", systemImage: "hand.raised.fill")
                }
                Link(destination: AppConfig.supportURL) {
                    Label("サポート", systemImage: "questionmark.circle.fill")
                }
            }
            .frame(maxWidth: 720)
            .padding(16)
            .frame(maxWidth: .infinity)
        }
        .background(AppTheme.paper)
        .navigationTitle("全図解を解除")
        .toolbar {
            if isSheet {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("閉じる") { dismiss() }
                }
            }
        }
        .task { await purchase.loadProduct() }
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(purchase.isUnlocked ? "全図解を解除済み" : "全250図解を買い切りで解除")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(AppTheme.ink)
            Text("最初の20図解と100ツールは無料です。完全版は残り230図解の高解像度閲覧を一度の購入で解除します。")
                .font(.body)
                .foregroundStyle(AppTheme.muted)
        }
    }

    private var priceCard: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("買い切り価格")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white.opacity(0.78))
                Text(AppConfig.fixedPrice)
                    .font(.system(size: 34, weight: .heavy, design: .rounded))
                Text("1回払い・定期購読なし")
                    .font(.subheadline.weight(.semibold))
            }
            Spacer()
            Image(systemName: purchase.isUnlocked ? "checkmark.seal.fill" : "lock.open.fill")
                .font(.system(size: 38, weight: .bold))
        }
        .foregroundStyle(Color.white)
        .padding(18)
        .background(
            LinearGradient(colors: [AppTheme.indigo, AppTheme.cobalt], startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 18)
        )
        .accessibilityIdentifier("pro-price")
    }

    private var includedFeatures: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("解除される内容")
                .font(.headline)
            feature("250枚すべての3D図解", "rectangle.stack.fill")
            feature("25テーマの法・令・規則・告示ナビゲーション", "square.stack.3d.up.fill")
            feature("全画面拡大、出典、確認ラベル、共有", "arrow.up.left.and.arrow.down.right")
            feature("購入後は同じApple IDで復元可能", "arrow.clockwise.circle.fill")
            Divider()
            feature("100ツールは購入しなくても無料", "wrench.and.screwdriver.fill")
        }
        .padding(16)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 16))
        .overlay { RoundedRectangle(cornerRadius: 16).stroke(AppTheme.line) }
    }

    private var purchaseActions: some View {
        VStack(spacing: 10) {
            Button {
                Task { await purchase.purchase() }
            } label: {
                HStack {
                    Spacer()
                    if purchase.isPurchasing { ProgressView().tint(.white) }
                    Text(purchase.isUnlocked ? "購入済み" : "\(AppConfig.fixedPrice)で全図解を解除")
                        .font(.headline)
                    Spacer()
                }
                .frame(minHeight: 48)
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.indigo)
            .disabled(purchase.isPurchasing || purchase.isUnlocked)
            .accessibilityIdentifier("purchase-button")

            Button("購入を復元") {
                Task { await purchase.restore() }
            }
            .buttonStyle(.bordered)
            .disabled(purchase.isPurchasing)
            .accessibilityIdentifier("restore-button")

            if purchase.product == nil && !purchase.isLoading {
                Button("購入情報を再読み込み") {
                    Task { await purchase.loadProduct() }
                }
            }
            if let message = purchase.message {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(AppTheme.muted)
                    .multilineTextAlignment(.center)
            }
        }
    }

    private var billingNotice: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("購入前にご確認ください", systemImage: "info.circle.fill")
                .font(.headline)
            Text("購入ボタンを押した後、App Storeの確認画面で承認するまで請求されません。これは非消耗型の1回払いで、月額・年額料金はありません。返金と購入管理はAppleの規約に従います。")
            Text("完全版は図解閲覧を解除するもので、法適合の保証、個別設計、申請代行、専門家監修又は行政認定を提供するものではありません。")
        }
        .font(.footnote)
        .foregroundStyle(AppTheme.muted)
        .padding(14)
        .background(AppTheme.brass.opacity(0.10), in: RoundedRectangle(cornerRadius: 14))
    }

    private func feature(_ text: String, _ icon: String) -> some View {
        Label(text, systemImage: icon)
            .font(.subheadline.weight(.medium))
            .foregroundStyle(AppTheme.ink)
    }
}
