# Design System

## Direction

深い藍色の建築青図、生成した切断建築モデル、白い編集紙面、朱色と真鍮の微細なアクセントを組み合わせる。既存の施工大樣 App より階層、余白、入力状態、iPad 対応を精緻化する。

## Tokens

- Paper: `#F4F6F8`
- Surface: `#FFFFFF`
- Ink: `#101827`
- Muted: `#5B6574`
- Indigo: `#102B5C`
- Cobalt: `#1C58A5`
- Vermilion: `#C84D35`
- Brass: `#B58A45`
- Line: `#D5DCE6`
- Radius: 12 / 16 / 20 pt
- Phone gutter: 16 pt; iPad gutter: 24 pt

## Required layouts

- 検索直下の `図解／無料／ツール／解除` は一つの surface 内で必ず同一行。
- Gallery は縦長画像を欠けさせない 2 列 `LazyVGrid`。
- Tool card は 76–88 pt のコンパクト高さ。`Pro Tool` バッジを表示しない。
- Dynamic Type、VoiceOver、44 pt 以上の操作領域、Reduce Motion を尊重する。

