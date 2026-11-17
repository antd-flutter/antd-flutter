#!/usr/bin/env bash
# 构建 example 演示站 + icons 图标画廊并合并为静态站点产物（build/site）
# 供 GitHub Pages deploy.yml 与 GitCode Pages 流水线复用，也可本地手动执行。
#
# 用法：
#   bash scripts/build_site.sh
# 环境变量（可选）：
#   FLUTTER_VERSION   Flutter 版本（默认 3.50.0）
#   SITE_BASE_HREF    演示站 base-href（默认 /antd-flutter/，与 GitHub Pages 一致）
#   ICON_BASE_HREF    图标画廊 base-href（默认 /antd-flutter/icons/）
#   OUTPUT_DIR        产物目录（默认 build/site，相对仓库根）
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

FLUTTER_VERSION="${FLUTTER_VERSION:-3.50.0}"
SITE_BASE_HREF="${SITE_BASE_HREF:-/antd-flutter/}"
ICON_BASE_HREF="${ICON_BASE_HREF:-/antd-flutter/icons/}"
OUTPUT_DIR="${OUTPUT_DIR:-build/site}"

echo "[信息] Flutter 版本: $FLUTTER_VERSION"
flutter --version

echo "[信息] 解析 example 依赖"
(cd example && flutter pub get)

echo "[信息] 构建 example 演示站 (base-href=$SITE_BASE_HREF)"
(cd example && flutter build web --release --base-href "$SITE_BASE_HREF")

echo "[信息] 解析 icons 画廊依赖"
(cd packages/antd_icons_flutter/example && flutter pub get)

echo "[信息] 构建 icons 图标画廊 (base-href=$ICON_BASE_HREF)"
(cd packages/antd_icons_flutter/example && flutter build web --release --base-href "$ICON_BASE_HREF")

echo "[信息] 合并站点产物到 $OUTPUT_DIR"
rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR/icons"
cp -r example/build/web/* "$OUTPUT_DIR/"
cp -r packages/antd_icons_flutter/example/build/web/* "$OUTPUT_DIR/icons/"

echo "[完成] 静态站点已生成: $REPO_ROOT/$OUTPUT_DIR"
