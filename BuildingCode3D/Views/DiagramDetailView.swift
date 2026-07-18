import SwiftUI

struct DiagramDetailView: View {
    @EnvironmentObject private var purchase: PurchaseManager
    let diagram: Diagram
    @Binding var showPaywall: Bool
    @State private var showImage = false

    private var accessible: Bool { purchase.canAccess(diagram) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                imagePanel
                header
                if accessible {
                    content
                    actions
                } else {
                    lockedPanel
                }
                sourcePanel
                cautionPanel
            }
            .frame(maxWidth: 820)
            .padding(14)
            .frame(maxWidth: .infinity)
        }
        .background(AppTheme.paper)
        .navigationTitle("図版 \(diagram.serialLabel)")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showImage) {
            NavigationStack {
                ScrollView([.horizontal, .vertical]) {
                    DiagramImage(path: diagram.image)
                        .scaledToFit()
                        .padding()
                }
                .background(Color.black)
                .navigationTitle("図版 \(diagram.serialLabel)")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    private var imagePanel: some View {
        ZStack {
            DiagramImage(path: diagram.image)
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .onTapGesture {
                    if accessible { showImage = true }
                    else { showPaywall = true }
                }
            if !accessible {
                RoundedRectangle(cornerRadius: 14)
                    .fill(.ultraThinMaterial)
                VStack(spacing: 10) {
                    Image(systemName: "lock.fill")
                        .font(.largeTitle)
                        .foregroundStyle(AppTheme.indigo)
                    Text("解除対象の図解")
                        .font(.title2.weight(.bold))
                    Text("20枚の無料図解以外は買い切り解除後に閲覧できます。")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(AppTheme.muted)
                    Button("全250図解を解除・\(AppConfig.fixedPrice)") {
                        showPaywall = true
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.indigo)
                    .accessibilityIdentifier("locked-unlock")
                }
                .padding(24)
            }
        }
        .overlay { RoundedRectangle(cornerRadius: 14).stroke(AppTheme.line) }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text(diagram.id)
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(AppTheme.cobalt)
                Text(diagram.category)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.vermilion)
                Spacer()
                Text("基準日 \(formattedBasisDate)")
                    .font(.caption2)
                    .foregroundStyle(AppTheme.muted)
            }
            Text(diagram.title)
                .font(.title2.weight(.bold))
                .foregroundStyle(AppTheme.ink)
            Text(diagram.themeName)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.muted)
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 14) {
            contentCard(title: "図の目的", icon: "scope", text: diagram.purpose)
            contentCard(title: "図示内容", icon: "cube.transparent", text: diagram.scene)
            VStack(alignment: .leading, spacing: 8) {
                Label("確認ラベル", systemImage: "tag.fill")
                    .font(.headline)
                TagFlow(tags: Array(diagram.labels.prefix(16)))
            }
            .padding(14)
            .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 14))
        }
    }

    private var actions: some View {
        HStack(spacing: 10) {
            Button {
                showImage = true
            } label: {
                Label("拡大", systemImage: "arrow.up.left.and.arrow.down.right")
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.indigo)

            ShareLink(item: shareText) {
                Label("共有", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(.bordered)

            if let url = diagram.sourceURL {
                Link(destination: url) {
                    Label("一次情報", systemImage: "arrow.up.right.square")
                }
                .buttonStyle(.bordered)
            }
        }
        .font(.subheadline.weight(.semibold))
    }

    private var lockedPanel: some View {
        ProCallout { showPaywall = true }
    }

    private var sourcePanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("根拠・出典", systemImage: "books.vertical.fill")
                .font(.headline)
            Text(diagram.sourceCaption)
                .font(.subheadline)
            Text(diagram.primarySourceLocator)
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppTheme.cobalt)
            if let url = diagram.sourceURL {
                Link(destination: url) {
                    Label("\(diagram.primarySourceTitle) を開く", systemImage: "safari")
                }
                .font(.subheadline.weight(.bold))
            }
        }
        .padding(14)
        .background(AppTheme.accentSoft, in: RoundedRectangle(cornerRadius: 14))
    }

    private var cautionPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("適用上の注意", systemImage: "exclamationmark.triangle.fill")
                .font(.headline)
                .foregroundStyle(AppTheme.vermilion)
            Text(diagram.applicability)
            Text(diagram.professionalCaution)
            Text(diagram.nonofficialCaption)
        }
        .font(.footnote)
        .foregroundStyle(AppTheme.muted)
        .padding(14)
        .background(AppTheme.vermilion.opacity(0.06), in: RoundedRectangle(cornerRadius: 14))
    }

    private func contentCard(title: String, icon: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Label(title, systemImage: icon)
                .font(.headline)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(AppTheme.muted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 14))
    }

    private var formattedBasisDate: String {
        diagram.basisDate.replacingOccurrences(of: "-", with: ".")
    }

    private var shareText: String {
        "\(diagram.id) \(diagram.title)\n\(diagram.sourceCaption)\n\(diagram.primarySourceURL)"
    }
}
