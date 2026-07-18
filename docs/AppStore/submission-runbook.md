# Xcode Cloud + Fastlane 送信手順

1. `main` の署名済みソースを GitHub に push。
2. Xcode Cloud で `BuildingCode3D` の Archive を実行し、App Store eligible artifact を生成。
3. App Store Connect で build が `VALID` になることを確認。Cloud の表示だけで完了と判断しない。
4. Fastlane で metadata と iPhone 6.9 / iPad 13 の各6枚を upload。
5. 非消耗型 IAP `com.jiangyushiung.jpbuildingcode3d.pro`、価格 JPY¥1600、レビュー画像、ローカライズを確認。
6. `VALID` build を version 1.0 に選択し、App Privacy、Support、IAP を同じ submission に関連付ける。
7. review submission を送信し、App version と IAP が `WAITING_FOR_REVIEW` 以上になったことを live ASC で確認。

## 2026-07-19 完了記録

- App Store version：`1.0 (6)`／`WAITING_FOR_REVIEW`
- IAP：`6792344078`／`com.jiangyushiung.jpbuildingcode3d.pro`／`WAITING_FOR_REVIEW`
- Review submission：`45bedc93-68a0-4d1e-a291-20c5bc099aa9`
- 提交時間：`2026-07-19 06:59`（Asia/Taipei）
- 提交項目：App version と IAP の 2 項目
- 發佈方式：手動發佈
- 次の操作：App Review を待機。Apple から要求がない限り、submission をキャンセルしない。
