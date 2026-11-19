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

# 独立组件包 example 站点（R32/R33：每个独立包的 web demo 发布到子路径）
# 环境变量 PKG_EXAMPLES：空格分隔的「包名:子路径」列表（默认全部已建 example 的独立包）
#   例：PKG_EXAMPLES="antd_qrcode:qr_code antd_refresh:refresh"
PKG_EXAMPLES="${PKG_EXAMPLES:-antd_qrcode:qr_code antd_refresh:refresh antd_swipe_action:swipe_action antd_splitter:splitter antd_image_viewer:image_viewer antd_upload:upload antd_picker:picker antd_tree:tree antd_carousel:carousel antd_masonry:masonry antd_floating:floating}"
for entry in $PKG_EXAMPLES; do
  pkg="${entry%%:*}"
  sub="${entry##*:}"
  example_dir="packages/$pkg/example"
  if [ -d "$example_dir" ]; then
    echo "[信息] 构建独立包 example: $pkg (base-href=$SITE_BASE_HREF$sub/)"
    (cd "$example_dir" && flutter pub get && flutter build web --release --base-href "$SITE_BASE_HREF$sub/")
    mkdir -p "$OUTPUT_DIR/$sub"
    cp -r "$example_dir/build/web/"* "$OUTPUT_DIR/$sub/"
  else
    echo "[跳过] $example_dir 不存在"
  fi
done

echo "[完成] 静态站点已生成: $REPO_ROOT/$OUTPUT_DIR"
