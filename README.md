# 建築基準法令3D図解

日本の建築実務者向けに、建築基準法・施行令・施行規則・告示の関係を 250 枚の 3D 図解で参照できる iOS / iPadOS App です。

## Product handles

- App name: `建築基準法令3D図解`
- Bundle ID: `com.jiangyushiung.jpbuildingcode3d`
- SKU: `com.jiangyushiung.jpbuildingcode3d`
- IAP: `com.jiangyushiung.jpbuildingcode3d.pro`
- Price copy: `JPY¥1600`
- Primary locale: `ja`
- Version / build: `1.0 / 6`
- App Store Connect app ID: `6792328983`
- Review status: `WAITING_FOR_REVIEW`
- Review submission: `45bedc93-68a0-4d1e-a291-20c5bc099aa9`

最終送審狀態與證據請見 [RELEASE_STATUS.md](RELEASE_STATUS.md)。

## Main features

- 250 図解の実検索・カテゴリ絞り込み・並べ替え
- Pinterest 型の縦長 2 列ギャラリー
- Featured Tools と 100 Tools をすべて無料開放
- 各ツールの計算、チェック、メモ、共有ワークスペース
- 20 図解の無料閲覧と、StoreKit 非消耗型 Pro の買い切り解除
- e-Gov / 国土交通省の一次情報への外部リンク

## Build

```bash
DEVELOPER_DIR=/Users/jushiung/Downloads/Xcode-beta.app/Contents/Developer \
  xcodebuild -project BuildingCode3D.xcodeproj -scheme BuildingCode3D \
  -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO build
```
