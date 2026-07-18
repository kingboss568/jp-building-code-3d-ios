#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="${0:A:h}"
PROJECT_ROOT="${SCRIPT_DIR:h}"
RESOURCE_ROOT="$PROJECT_ROOT/BuildingCode3D/Resources"

[[ -f "$RESOURCE_ROOT/PrivacyInfo.xcprivacy" ]] || { print -u2 "PrivacyInfo.xcprivacy がありません"; exit 1; }
plutil -lint "$RESOURCE_ROOT/PrivacyInfo.xcprivacy" >/dev/null

[[ -f "$PROJECT_ROOT/docs/privacy.html" && -f "$PROJECT_ROOT/docs/support.html" ]] || { print -u2 "公開privacy/supportがありません"; exit 1; }

diagram_count=$(find "$RESOURCE_ROOT/Generated/diagrams" -type f -name '*.heic' | wc -l | tr -d ' ')
[[ "$diagram_count" == "250" ]] || { print -u2 "HEIC図解は250枚必要です: $diagram_count"; exit 1; }

records_file="$RESOURCE_ROOT/Data/diagrams_ja.json"
record_count=$(plutil -p "$records_file" | grep -c '"id" =>')
first_record_id=$(plutil -extract 0.id raw -o - "$records_file")
last_record_id=$(plutil -extract 249.id raw -o - "$records_file")
[[ "$record_count" == "250" && "$first_record_id" == "A1-01-01" && "$last_record_id" == "A1-25-10" ]] || {
  print -u2 "図解データの件数またはIDが不正です: $record_count / $first_record_id / $last_record_id"
  exit 1
}

price_hits=$(
  find "$PROJECT_ROOT/BuildingCode3D" "$PROJECT_ROOT/fastlane/metadata" "$PROJECT_ROOT/Docs" \
    -type f \( -name '*.swift' -o -name '*.md' -o -name '*.txt' -o -name '*.json' \) \
    -exec grep -l 'JPY¥1600' {} + | wc -l | tr -d ' '
)
[[ "$price_hits" -ge 4 ]] || { print -u2 "JPY¥1600 の統一表記が不足しています"; exit 1; }

[[ $(find "$PROJECT_ROOT" -name '._*' -o -name '.DS_Store' | wc -l | tr -d ' ') == "0" ]] || { print -u2 "AppleDoubleまたは.DS_Storeがあります"; exit 1; }

screenshot_root="$PROJECT_ROOT/fastlane/screenshots/ja-JP"
iphone_count=$(find "$screenshot_root" -type f -name 'iPhone 6.9-*.png' 2>/dev/null | wc -l | tr -d ' ')
ipad_count=$(find "$screenshot_root" -type f -name 'iPad 13-*.png' 2>/dev/null | wc -l | tr -d ' ')
[[ "$iphone_count" == "6" && "$ipad_count" == "6" ]] || { print -u2 "スクリーンショットはiPhone/iPad各6枚必要です: $iphone_count / $ipad_count"; exit 1; }

while IFS= read -r image; do
  dimensions=$(sips -g pixelWidth -g pixelHeight "$image" 2>/dev/null | awk '/pixelWidth/{w=$2}/pixelHeight/{h=$2}END{print w "x" h}')
  [[ "$dimensions" == "1320x2868" ]] || { print -u2 "iPhone寸法エラー: $image ($dimensions)"; exit 1; }
done < <(find "$screenshot_root" -type f -name 'iPhone 6.9-*.png' | sort)

while IFS= read -r image; do
  dimensions=$(sips -g pixelWidth -g pixelHeight "$image" 2>/dev/null | awk '/pixelWidth/{w=$2}/pixelHeight/{h=$2}END{print w "x" h}')
  [[ "$dimensions" == "2064x2752" ]] || { print -u2 "iPad寸法エラー: $image ($dimensions)"; exit 1; }
done < <(find "$screenshot_root" -type f -name 'iPad 13-*.png' | sort)

print "release assets OK: 250 HEIC / 250 records / privacy / support / JPY¥1600 / screenshots 6+6"
