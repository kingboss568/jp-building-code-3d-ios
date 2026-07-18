import SwiftUI

struct ResourcesView: View {
    var body: some View {
        List {
            Section("公式情報") {
                ForEach(ResourceCatalog.resources) { resource in
                    Link(destination: resource.url) {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(resource.title)
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                            }
                            Text(resource.note)
                                .font(.caption)
                                .foregroundStyle(AppTheme.muted)
                        }
                    }
                }
            }
            Section("このアプリについて") {
                LabeledContent("資料基準日", value: AppConfig.basisDate)
                Link("プライバシーポリシー", destination: AppConfig.privacyURL)
                Link("サポート", destination: AppConfig.supportURL)
            }
            Section("重要") {
                Text("本アプリは公表資料をもとに独自編集した参考図と確認支援を提供します。国土交通省その他の行政機関が作成、監修又は認定した公式アプリではありません。最新法令、地方条例、特定行政庁の取扱い、個別認定及び専門家判断を必ず確認してください。")
                    .font(.footnote)
                    .foregroundStyle(AppTheme.muted)
            }
        }
        .navigationTitle("公式リンク")
    }
}

