#!/bin/zsh
set -euo pipefail
cd "${CI_PRIMARY_REPOSITORY_PATH:?}"
./scripts/verify_release_assets.sh
test -d BuildingCode3D.xcodeproj
print "Xcode Cloud preflight OK"
