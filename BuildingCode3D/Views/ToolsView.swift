import SwiftUI

struct ToolsView: View {
    @State private var query = ""
    @State private var group = "すべて"

    private var groups: [String] {
        ["すべて"] + ToolCatalog.groupsWithTools.map(\.name)
    }

    private var filtered: [ToolDefinition] {
        ToolCatalog.tools.filter { tool in
            (group == "すべて" || tool.group == group)
                && (query.isEmpty || [tool.title, tool.group, tool.guidance]
                    .joined(separator: " ")
                    .localizedStandardContains(query))
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    accessNotice
                    groupChips
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 225), spacing: 9)], spacing: 9) {
                        ForEach(filtered) { tool in
                            NavigationLink {
                                ToolWorkspaceView(tool: tool)
                            } label: {
                                ToolCard(tool: tool)
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier("tool-\(tool.id)")
                        }
                    }
                    if filtered.isEmpty {
                        ContentUnavailableView.search(text: query)
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(maxWidth: 980)
                .padding(12)
                .frame(maxWidth: .infinity)
            }
            .background(AppTheme.paper)
            .searchable(text: $query, prompt: "100ツールを検索")
            .navigationTitle("100ツール")
        }
    }

    private var accessNotice: some View {
        HStack(spacing: 12) {
            Image(systemName: "lock.open.fill")
                .font(.title3.weight(.bold))
                .foregroundStyle(AppTheme.cobalt)
                .frame(width: 42, height: 42)
                .background(AppTheme.accentSoft, in: RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 3) {
                Text("100ツールをすべて無料開放")
                    .font(.headline)
                Text("各ツールで計算、チェック、メモ保存、共有ができます。")
                    .font(.caption)
                    .foregroundStyle(AppTheme.muted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(AppTheme.surface, in: RoundedRectangle(cornerRadius: 16))
        .overlay { RoundedRectangle(cornerRadius: 16).stroke(AppTheme.line) }
    }

    private var groupChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 8) {
                ForEach(groups, id: \.self) { value in
                    Button(value) { group = value }
                        .font(.caption.weight(.bold))
                        .foregroundStyle(group == value ? Color.white : AppTheme.indigo)
                        .padding(.horizontal, 12)
                        .frame(minHeight: 36)
                        .background(group == value ? AppTheme.indigo : AppTheme.surface, in: Capsule())
                        .overlay { Capsule().stroke(group == value ? Color.clear : AppTheme.line) }
                }
            }
        }
    }
}
