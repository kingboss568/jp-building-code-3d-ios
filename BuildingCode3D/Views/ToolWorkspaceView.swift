import SwiftUI

struct ToolWorkspaceView: View {
    let tool: ToolDefinition
    @AppStorage private var notes: String
    @State private var firstValue = ""
    @State private var secondValue = ""
    @State private var completed: Set<Int> = []

    init(tool: ToolDefinition) {
        self.tool = tool
        _notes = AppStorage(wrappedValue: "", "tool.notes.\(tool.id)")
    }

    private var calculation: Double? {
        guard let first = Double(firstValue.replacingOccurrences(of: ",", with: ".")),
              let second = Double(secondValue.replacingOccurrences(of: ",", with: ".")) else {
            return nil
        }
        return tool.mode.calculate(first, second)
    }

    private var resultText: String {
        guard let calculation else { return "入力待ち" }
        let number = calculation.formatted(.number.precision(.fractionLength(0...2)))
        return tool.mode == .percentage || tool.mode == .slope ? "\(number)%" : "\(number)\(tool.unit)"
    }

    var body: some View {
        Form {
            Section {
                Label(tool.guidance, systemImage: tool.icon)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.muted)
            }

            Section("実務チェック") {
                ForEach(Array(tool.checklist.enumerated()), id: \.offset) { index, item in
                    Button {
                        if completed.contains(index) { completed.remove(index) }
                        else { completed.insert(index) }
                    } label: {
                        HStack {
                            Image(systemName: completed.contains(index) ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(completed.contains(index) ? AppTheme.cobalt : AppTheme.muted)
                            Text(item)
                                .foregroundStyle(AppTheme.ink)
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                }
                ProgressView(value: Double(completed.count), total: Double(tool.checklist.count)) {
                    Text("進捗 \(completed.count)/\(tool.checklist.count)")
                        .font(.caption.weight(.semibold))
                }
                .tint(AppTheme.cobalt)
                .accessibilityIdentifier("tool-progress")
            }

            if tool.mode != .checklist {
                Section("補助計算") {
                    TextField(tool.firstLabel, text: $firstValue)
                        .keyboardType(.decimalPad)
                        .accessibilityIdentifier("tool-input-first")
                    TextField(tool.secondLabel, text: $secondValue)
                        .keyboardType(.decimalPad)
                        .accessibilityIdentifier("tool-input-second")
                    LabeledContent(tool.resultLabel, value: resultText)
                        .font(.headline)
                        .accessibilityIdentifier("tool-result")
                        .accessibilityValue(resultText)
                    Button("入力をクリア", role: .destructive) {
                        firstValue = ""
                        secondValue = ""
                    }
                }
            }

            Section("メモ") {
                TextEditor(text: $notes)
                    .frame(minHeight: 130)
                    .accessibilityIdentifier("tool-notes")
            }

            Section {
                ShareLink(item: shareText) {
                    Label("記録を共有", systemImage: "square.and.arrow.up")
                }
                Button("チェックをリセット", role: .destructive) {
                    completed.removeAll()
                }
            }

            Section {
                Text("本ツールは確認・記録の補助です。法適合、設計、構造・設備計算及び行政判断を代替しません。")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.muted)
            }
        }
        .navigationTitle(tool.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var shareText: String {
        "\(tool.title)\n実務チェック：\(completed.count)/\(tool.checklist.count)\n計算結果：\(tool.mode == .checklist ? "対象外" : resultText)\nメモ：\(notes)"
    }
}

