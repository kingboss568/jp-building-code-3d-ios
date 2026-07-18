import Foundation

enum ToolCatalog {
    private struct GroupTemplate {
        let name: String
        let icon: String
        let titles: [String]
        let modes: [ToolMode]
        let firstLabel: String
        let secondLabel: String
        let resultLabel: String
        let unit: String
        let guidance: String
        let checklist: [String]
    }

    static let tools: [ToolDefinition] = groups.enumerated().flatMap { groupIndex, group in
        group.titles.enumerated().map { itemIndex, title in
            ToolDefinition(
                id: groupIndex * 10 + itemIndex + 1,
                title: title,
                group: group.name,
                icon: group.icon,
                mode: group.modes[itemIndex % group.modes.count],
                firstLabel: group.firstLabel,
                secondLabel: group.secondLabel,
                resultLabel: group.resultLabel,
                unit: group.unit,
                guidance: group.guidance,
                checklist: group.checklist
            )
        }
    }

    static var groupsWithTools: [(name: String, tools: [ToolDefinition])] {
        groups.map { group in (group.name, tools.filter { $0.group == group.name }) }
    }

    private static let groups: [GroupTemplate] = [
        .init(
            name: "面積・比率", icon: "square.split.2x2.fill",
            titles: ["建蔽率チェック", "容積率チェック", "延べ面積集計", "建築面積算定", "床面積合計", "開口率計算", "壁面比率", "採光有効面積", "換気有効面積", "敷地面積差分"],
            modes: [.percentage, .sum, .multiply, .difference],
            firstLabel: "対象値", secondLabel: "基準値／係数", resultLabel: "算定結果", unit: "%",
            guidance: "図面・申請条件に基づく値を入力し、算定根拠と端数処理を別途記録してください。",
            checklist: ["対象範囲を図面で確認", "除外部分を確認", "単位を統一", "算定根拠を記録"]
        ),
        .init(
            name: "高さ・勾配", icon: "ruler.fill",
            titles: ["道路斜線勾配", "北側斜線高低差", "隣地斜線高低差", "絶対高さ確認", "軒高差", "階高合計", "天井高差", "平均地盤面メモ", "日影時間記録", "敷地高低差"],
            modes: [.slope, .difference, .sum, .divide],
            firstLabel: "高さ／立上り", secondLabel: "距離／基準", resultLabel: "高さ・勾配", unit: "%",
            guidance: "用途地域、道路境界、方位、地盤面及び緩和条件を確認したうえで補助計算に使用します。",
            checklist: ["基準点を固定", "方位と境界を確認", "緩和条件を確認", "断面図へ反映"]
        ),
        .init(
            name: "避難・動線", icon: "figure.walk.motion",
            titles: ["避難歩行距離", "出口幅合計", "直通階段数", "階段勾配", "蹴上・踏面比", "廊下幅余裕", "避難経路高低差", "非常用進入口数", "排煙区画数", "照明配置間隔"],
            modes: [.difference, .sum, .divide, .percentage],
            firstLabel: "計画値", secondLabel: "基準／比較値", resultLabel: "動線チェック値", unit: "m",
            guidance: "用途、階、規模、避難階、重複区間及び地方取扱いを確認して使用してください。",
            checklist: ["起点と終点を確認", "重複区間を確認", "扉の開き方を確認", "最新条文・告示を確認"]
        ),
        .init(
            name: "防火・区画", icon: "flame.fill",
            titles: ["防火区画面積", "竪穴区画チェック", "異種用途区画", "貫通部件数", "防火戸一覧", "延焼ライン確認", "開口部面積比", "防煙垂壁長さ", "防火設備作動点検", "区画図レビュー"],
            modes: [.multiply, .percentage, .sum, .checklist],
            firstLabel: "対象数量", secondLabel: "寸法／総量", resultLabel: "区画チェック値", unit: "㎡",
            guidance: "区画種別、要求性能、認定仕様、貫通処理及び連動条件を個別に照合します。",
            checklist: ["区画種別を確認", "要求性能を確認", "貫通部を全数確認", "認定仕様と施工を照合"]
        ),
        .init(
            name: "構造・荷重", icon: "building.columns.fill",
            titles: ["床荷重換算", "梁スパン比", "柱負担面積", "壁量比", "コンクリート量", "鉄筋重量", "基礎底面積", "偏心距離", "開口補強数量", "構造図整合チェック"],
            modes: [.multiply, .divide, .percentage, .difference],
            firstLabel: "数量／寸法A", secondLabel: "係数／寸法B", resultLabel: "構造補助値", unit: "",
            guidance: "この計算は概算補助です。構造設計、計算書、認定仕様及び専門技術者の判定を優先してください。",
            checklist: ["構造種別を確認", "荷重条件を確認", "計算書と照合", "構造設計者へ確認"]
        ),
        .init(
            name: "環境・衛生", icon: "leaf.fill",
            titles: ["採光面積比", "換気面積比", "居室容積", "窓面積合計", "開口有効率", "室間高低差", "排水勾配", "必要換気量", "湿気対策チェック", "シックハウス確認"],
            modes: [.percentage, .multiply, .slope, .sum],
            firstLabel: "有効量／立上り", secondLabel: "床面積／距離", resultLabel: "環境チェック値", unit: "%",
            guidance: "用途、居室区分、開口条件、機械換気及び設備仕様を確認して補助計算に使用します。",
            checklist: ["対象居室を確認", "有効部分を確認", "設備方式を確認", "地方条件を確認"]
        ),
        .init(
            name: "敷地・集団規定", icon: "map.fill",
            titles: ["接道長さ確認", "道路後退面積", "用途地域メモ", "高度地区チェック", "壁面後退距離", "外壁後退余裕", "日影測定点", "天空率比較値", "敷地分割前後", "条例上乗せ確認"],
            modes: [.difference, .multiply, .percentage, .checklist],
            firstLabel: "計画値", secondLabel: "基準／比較値", resultLabel: "敷地チェック値", unit: "m",
            guidance: "都市計画指定、道路種別、境界、特定行政庁の取扱い及び条例を必ず併記してください。",
            checklist: ["都市計画指定を取得", "道路種別を確認", "境界根拠を確認", "条例・行政取扱いを確認"]
        ),
        .init(
            name: "申請・検査", icon: "checklist.checked",
            titles: ["確認申請図書", "構造計算書照合", "設備図書照合", "中間検査準備", "完了検査準備", "軽微変更整理", "計画変更判定メモ", "消防同意確認", "省エネ図書確認", "検査指摘追跡"],
            modes: [.checklist],
            firstLabel: "", secondLabel: "", resultLabel: "", unit: "",
            guidance: "必要図書、提出先、期限、版番号及び指摘対応を一つのチェック記録にまとめます。",
            checklist: ["最新版図書を確認", "版番号と日付を確認", "提出先・期限を確認", "指摘対応を記録"]
        ),
        .init(
            name: "法令・出典", icon: "books.vertical.fill",
            titles: ["条文ブックマーク", "施行令対照", "施行規則対照", "告示番号メモ", "改正履歴チェック", "施行日チェック", "経過措置確認", "地方条例対照", "大臣認定確認", "出典ロック記録"],
            modes: [.checklist],
            firstLabel: "", secondLabel: "", resultLabel: "", unit: "",
            guidance: "法令名、条項、改正、施行日、基準日、URL 及び地方取扱いをセットで記録します。",
            checklist: ["e-Gov現行条文を開く", "改正履歴と施行日を確認", "告示・条例を確認", "確認日とURLを記録"]
        ),
        .init(
            name: "現場・記録", icon: "camera.metering.matrix",
            titles: ["現場写真台帳", "是正事項リスト", "検査立会記録", "材料承認記録", "施工要領確認", "区画貫通台帳", "防火戸台帳", "変更箇所メモ", "引渡し資料確認", "定期報告準備"],
            modes: [.checklist],
            firstLabel: "", secondLabel: "", resultLabel: "", unit: "",
            guidance: "図面番号、場所、日付、担当、写真又は証跡を記録し、是正完了まで追跡します。",
            checklist: ["場所・図面番号を記録", "日付と担当を記録", "写真・証跡を確認", "是正完了を確認"]
        )
    ]
}

