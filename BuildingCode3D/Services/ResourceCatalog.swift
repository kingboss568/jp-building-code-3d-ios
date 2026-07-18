import Foundation

struct OfficialResource: Identifiable, Hashable {
    let id: String
    let title: String
    let note: String
    let url: URL
}

enum ResourceCatalog {
    static let resources: [OfficialResource] = [
        .init(id: "law", title: "e-Gov 建築基準法", note: "現行法、改正履歴、施行状態を確認。", url: URL(string: "https://laws.e-gov.go.jp/document?lawid=325AC0000000201")!),
        .init(id: "order", title: "e-Gov 建築基準法施行令", note: "構造、一般構造、防火、避難、形態制限等。", url: URL(string: "https://laws.e-gov.go.jp/law/325CO0000000338")!),
        .init(id: "rule", title: "e-Gov 建築基準法施行規則", note: "確認申請、添付図書、検査、様式等。", url: URL(string: "https://laws.e-gov.go.jp/law/325M50004000040")!),
        .init(id: "mlit-laws", title: "国土交通省 建築行政に係る法令等", note: "建築基準法令と関係規定の公式入口。", url: URL(string: "https://www.mlit.go.jp/jutakukentiku/build/code.html")!),
        .init(id: "mlit-notices", title: "国土交通省 告示の制定・改正", note: "平成30年以降の告示、新旧対照表、技術的助言。", url: URL(string: "https://www.mlit.go.jp/jutakukentiku/build/jutakukentiku_house_tk_000096.html")!),
        .init(id: "approval", title: "構造方法等の大臣認定", note: "性能規定と大臣認定制度の公式説明。", url: URL(string: "https://www.mlit.go.jp/jutakukentiku/build/jutakukentiku_house_tk_000042.html")!),
        .init(id: "standards", title: "官庁営繕の技術基準", note: "標準仕様書、標準図、設計図書作成基準の入口。", url: URL(string: "https://www.mlit.go.jp/gobuild/gobuild_tk2_000017.html")!),
        .init(id: "license", title: "国土交通省ウェブサイト利用ルール", note: "出典、加工表示、第三者権利、ロゴ利用を確認。", url: URL(string: "https://www.mlit.go.jp/link.html")!),
        .init(id: "pdl", title: "公共データ利用規約 第1.0版", note: "公的データの複製・編集・商用利用条件。", url: URL(string: "https://www.digital.go.jp/resources/open_data/public_data_license_v1.0")!),
        .init(id: "jis", title: "JIS 引用・転載の公式案内", note: "規格番号、本文、表、図の権利取扱いを確認。", url: URL(string: "https://www.jisc.go.jp/qa/a2-1.html")!)
    ]
}

