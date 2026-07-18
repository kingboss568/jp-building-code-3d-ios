# 建築基準法令3D図解 Release Status

最終確認日：2026-07-19（Asia/Taipei）

## App Store Connect

| 項目 | 最終狀態 |
|---|---|
| App | `建築基準法令3D図解` |
| ASC App ID | `6792328983` |
| Bundle ID | `com.jiangyushiung.jpbuildingcode3d` |
| 版本 / build | `1.0 (6)` |
| App version state | `WAITING_FOR_REVIEW` |
| Build | `6`、`VALID`、已綁定 1.0 |
| IAP | `建築基準法令3D図解 完全版` |
| IAP Apple ID | `6792344078` |
| IAP Product ID | `com.jiangyushiung.jpbuildingcode3d.pro` |
| IAP state | `WAITING_FOR_REVIEW` |
| 價格文案 | `JPY¥1600` |
| Review submission | `45bedc93-68a0-4d1e-a291-20c5bc099aa9` |
| 提交時間 | `2026-07-19 06:59`（Asia/Taipei） |
| 提交者 | `MaiYaLin` |
| 提交項目 | 2 個：App version `1.0 (6)` + IAP `6792344078` |
| 內容版權聲明 | `否，此 App 不包含、顯示或存取第三方內容。` |
| 發佈方式 | 手動發佈 |

## Release evidence

- Live App Store Connect「App 審查」頁顯示 submission 與兩個項目均為「等待審查」。
- iPhone 6.9 吋與 iPad 13 吋各 6 張日文截圖均已提交，包含搜尋、圖解、雙欄 Gallery、100 Tools 與 `JPY¥1600` 解除頁。
- Xcode Cloud 的 App Store artifact 已由 Fastlane 上傳，build 6 已處理並選入版本。
- Privacy Policy 與 Support 已納入 Git repo 並公開：
  - https://kingboss568.github.io/jp-building-code-3d-ios/privacy.html
  - https://kingboss568.github.io/jp-building-code-3d-ios/support.html
- `PrivacyInfo.xcprivacy` 已納入版本控管。

## Next action

等待 App Review。除非 Apple 退件或明確要求補件，不要取消 submission、重建版本或替換 build。核准後須在 App Store Connect 手動發佈。
