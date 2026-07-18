import SwiftUI
import UIKit

struct AppSearchField: View {
    @EnvironmentObject private var store: DiagramStore
    @FocusState private var focused: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(AppTheme.cobalt)
            TextField(
                "",
                text: $store.query,
                prompt: Text("図解・条文・用途・確認点を検索")
                    .foregroundStyle(AppTheme.muted)
            )
            .focused($focused)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .accessibilityIdentifier("diagram-search")

            if !store.query.isEmpty {
                Button {
                    store.query = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(AppTheme.muted)
                }
                .accessibilityLabel("検索語を消去")
            }

            Menu {
                Picker("並べ替え", selection: $store.sort) {
                    ForEach(DiagramSort.allCases) { sort in
                        Text(sort.title).tag(sort)
                    }
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 32, height: 32)
                    .background(AppTheme.accentSoft, in: RoundedRectangle(cornerRadius: 9))
            }
            .accessibilityLabel("並べ替え")
        }
        .padding(.horizontal, 14)
        .frame(minHeight: 52)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(focused ? AppTheme.cobalt : AppTheme.line, lineWidth: focused ? 1.5 : 1)
        }
        .shadow(color: .black.opacity(focused ? 0.08 : 0.03), radius: focused ? 10 : 4, y: 3)
    }
}

struct CategoryChips: View {
    @EnvironmentObject private var store: DiagramStore

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 8) {
                ForEach(store.categories, id: \.self) { category in
                    Button {
                        withAnimation(.easeOut(duration: 0.18)) {
                            store.category = category
                        }
                    } label: {
                        Text(category)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(store.category == category ? Color.white : AppTheme.indigo)
                            .padding(.horizontal, 12)
                            .frame(minHeight: 36)
                            .background(
                                store.category == category ? AppTheme.indigo : AppTheme.surface,
                                in: Capsule()
                            )
                            .overlay {
                                Capsule().stroke(store.category == category ? Color.clear : AppTheme.line)
                            }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct HomeSummaryBar: View {
    let diagramCount: Int
    let isUnlocked: Bool
    let unlockAction: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            SummaryMetric(id: "details", value: "\(diagramCount)", label: "図解", icon: "square.stack.3d.up.fill")
            divider
            SummaryMetric(id: "free", value: "20", label: "無料", icon: "gift.fill")
            divider
            SummaryMetric(id: "tools", value: "100", label: "ツール", icon: "wrench.and.screwdriver.fill")
            divider
            Button(action: unlockAction) {
                SummaryMetric(
                    id: "unlock",
                    value: isUnlocked ? "解除済" : AppConfig.fixedPrice,
                    label: "解除",
                    icon: isUnlocked ? "checkmark.seal.fill" : "lock.open.fill"
                )
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("summary-unlock")
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 9)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay { RoundedRectangle(cornerRadius: 16).stroke(AppTheme.line) }
        .shadow(color: .black.opacity(0.035), radius: 6, y: 3)
    }

    private var divider: some View {
        Rectangle().fill(AppTheme.line).frame(width: 1, height: 44)
    }
}

private struct SummaryMetric: View {
    let id: String
    let value: String
    let label: String
    let icon: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(AppTheme.cobalt)
            Text(value)
                .font(.system(size: 14, weight: .heavy, design: .rounded))
                .foregroundStyle(AppTheme.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.55)
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(AppTheme.muted)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, minHeight: 60)
        .padding(.horizontal, 5)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("summary-\(id)")
        .accessibilityLabel("\(label) \(value)")
    }
}

struct SectionHeading: View {
    let title: String
    let subtitle: String?
    let actionTitle: String?
    let action: (() -> Void)?

    init(_ title: String, subtitle: String? = nil, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(AppTheme.ink)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(AppTheme.muted)
                }
            }
            Spacer()
            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.subheadline.weight(.bold))
            }
        }
    }
}

struct DiagramImage: View {
    let path: String

    var body: some View {
        Group {
            if let image = loadImage() {
                Image(uiImage: image).resizable()
            } else {
                Rectangle()
                    .fill(AppTheme.accentSoft)
                    .overlay {
                        VStack(spacing: 8) {
                            Image(systemName: "photo.badge.exclamationmark")
                            Text("画像を読み込めません")
                                .font(.caption)
                        }
                        .foregroundStyle(AppTheme.muted)
                    }
            }
        }
    }

    private func loadImage() -> UIImage? {
        let name = (path as NSString).lastPathComponent
        let base = (name as NSString).deletingPathExtension
        let ext = (name as NSString).pathExtension
        let directory = (path as NSString).deletingLastPathComponent
        let url = Bundle.main.url(forResource: base, withExtension: ext, subdirectory: directory)
            ?? Bundle.main.url(forResource: base, withExtension: ext)
        return url.flatMap { UIImage(contentsOfFile: $0.path) }
    }
}

struct DiagramRow: View {
    let diagram: Diagram
    let locked: Bool

    var body: some View {
        HStack(spacing: 12) {
            DiagramImage(path: diagram.image)
                .scaledToFill()
                .frame(width: 62, height: 78)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(diagram.serialLabel)
                        .font(.caption2.weight(.heavy))
                        .foregroundStyle(AppTheme.cobalt)
                    Text(diagram.category)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(AppTheme.muted)
                }
                Text(diagram.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.ink)
                    .lineLimit(2)
                Text(diagram.primarySourceLocator)
                    .font(.caption)
                    .foregroundStyle(AppTheme.muted)
                    .lineLimit(1)
            }
            Spacer(minLength: 4)
            Image(systemName: locked ? "lock.fill" : "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(locked ? AppTheme.vermilion : AppTheme.muted)
        }
        .contentShape(Rectangle())
    }
}

struct GalleryCard: View {
    let diagram: Diagram
    let locked: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
                DiagramImage(path: diagram.image)
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                if locked {
                    Label("解除対象", systemImage: "lock.fill")
                        .font(.caption2.weight(.heavy))
                        .foregroundStyle(AppTheme.indigo)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial, in: Capsule())
                        .padding(8)
                }
            }
            Text("#\(diagram.serialLabel)  \(diagram.title)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppTheme.ink)
                .lineLimit(3)
            Text(diagram.category)
                .font(.caption2.weight(.bold))
                .foregroundStyle(AppTheme.cobalt)
        }
        .padding(7)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        .overlay { RoundedRectangle(cornerRadius: 13).stroke(AppTheme.line) }
    }
}

struct ToolCard: View {
    let tool: ToolDefinition

    var body: some View {
        HStack(spacing: 11) {
            Image(systemName: tool.icon)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(AppTheme.cobalt)
                .frame(width: 36, height: 36)
                .background(AppTheme.accentSoft, in: RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 3) {
                Text(tool.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.ink)
                    .lineLimit(2)
                Text(tool.group)
                    .font(.caption2)
                    .foregroundStyle(AppTheme.muted)
            }
            Spacer(minLength: 2)
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(AppTheme.muted)
        }
        .frame(maxWidth: .infinity, minHeight: 58, alignment: .leading)
        .padding(.horizontal, 11)
        .padding(.vertical, 9)
        .background(AppTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
        .overlay { RoundedRectangle(cornerRadius: 13).stroke(AppTheme.line) }
    }
}

struct ProCallout: View {
    @EnvironmentObject private var purchase: PurchaseManager
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: purchase.isUnlocked ? "checkmark.seal.fill" : "sparkles")
                    .font(.title3.weight(.bold))
                    .frame(width: 42, height: 42)
                    .background(.white.opacity(0.13), in: RoundedRectangle(cornerRadius: 12))
                VStack(alignment: .leading, spacing: 3) {
                    Text(purchase.isUnlocked ? "全図解を解除済み" : "250図解を買い切りで解除")
                        .font(.headline)
                    Text(purchase.isUnlocked ? "すべての図解を閲覧できます" : "定期購読なし・100ツールは無料")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.82))
                }
                Spacer()
                Text(purchase.isUnlocked ? "解除済" : AppConfig.fixedPrice)
                    .font(.subheadline.weight(.heavy))
                    .foregroundStyle(AppTheme.indigo)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .background(Color.white, in: Capsule())
            }
            .padding(15)
            .foregroundStyle(Color.white)
            .background(
                LinearGradient(colors: [AppTheme.indigo, AppTheme.cobalt], startPoint: .topLeading, endPoint: .bottomTrailing),
                in: RoundedRectangle(cornerRadius: 17, style: .continuous)
            )
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("pro-callout")
    }
}

struct TagFlow: View {
    let tags: [String]

    var body: some View {
        FlowLayout(spacing: 6) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(AppTheme.indigo)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 6)
                    .background(AppTheme.accentSoft, in: Capsule())
            }
        }
    }
}

struct FlowLayout: Layout {
    let spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        layout(proposal: proposal, subviews: subviews).size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for item in result.items {
            subviews[item.index].place(
                at: CGPoint(x: bounds.minX + item.origin.x, y: bounds.minY + item.origin.y),
                proposal: .unspecified
            )
        }
    }

    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, items: [(index: Int, origin: CGPoint)]) {
        let width = proposal.width ?? 320
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var placements: [(Int, CGPoint)] = []
        for (index, subview) in subviews.enumerated() {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > width, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            placements.append((index, CGPoint(x: x, y: y)))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return (CGSize(width: width, height: y + rowHeight), placements)
    }
}
