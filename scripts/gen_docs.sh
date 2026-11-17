#!/usr/bin/env bash
# gen_docs.sh — 文档生成命令（dart doc + API 索引 + 单轨一致性校验）
# 用法: ./scripts/gen_docs.sh [--pkg <name>] [--check-only] [--skip-dart-doc]
# 平台: macOS/Linux 完整实现（Windows 用 gen_docs.bat/gen_docs.ps1，逻辑一致）
set -euo pipefail

# ---- 输出标签 ----
INFO="[信息]"
OK="[成功]"
WARN="[警告]"
ERR="[错误]"
DONE="[完成]"

# ---- 参数解析 ----
PKG=""
CHECK_ONLY=0
SKIP_DART_DOC=0
while [ $# -gt 0 ]; do
  case "$1" in
    --pkg) PKG="${2:?缺少 --pkg 的值}"; shift 2 ;;
    --check-only) CHECK_ONLY=1; shift ;;
    --skip-dart-doc) SKIP_DART_DOC=1; shift ;;
    -h|--help)
      sed -n '2,6p' "$0"
      exit 0 ;;
    *) echo "$ERR 未知参数: $1"; exit 2 ;;
  esac
done

# ---- 定位工作区根（脚本位于 <root>/scripts/）----
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$ROOT"

# ---- dart 探测：fvm 优先，其次 PATH ----
DART_BIN=""
if [ -x "$HOME/fvm/default/bin/dart" ]; then
  DART_BIN="$HOME/fvm/default/bin/dart"
elif command -v dart >/dev/null 2>&1; then
  DART_BIN="$(command -v dart)"
elif command -v fvm >/dev/null 2>&1; then
  DART_BIN="fvm dart"
else
  echo "$ERR 未找到 dart（fvm 或 PATH 均不可用）"
  exit 1
fi
echo "$INFO 使用 dart: $DART_BIN"

run_dart() { $DART_BIN "$@"; }

# ---- 依赖解析（提取脚本依赖 analyzer dev 依赖）----
if [ "$CHECK_ONLY" -eq 0 ]; then
  if [ ! -f "$ROOT/.dart_tool/package_config.json" ] || \
     ! grep -q '"name": "analyzer"' "$ROOT/.dart_tool/package_config.json" 2>/dev/null; then
    echo "$INFO 解析依赖（flutter pub get）..."
    flutter pub get || { echo "$ERR flutter pub get 失败"; exit 1; }
  fi
fi

# ---- 待处理包列表 ----
PACKAGES_DIR="$ROOT/packages"
if [ -n "$PKG" ]; then
  if [ ! -d "$PACKAGES_DIR/$PKG" ]; then
    echo "$ERR 未知包: $PKG"
    exit 2
  fi
  TARGETS="$PKG"
else
  TARGETS="$(ls -1 "$PACKAGES_DIR")"
fi

FAILED=0

# ---- 1. dart doc（产物 doc/api/，已 gitignore）----
if [ "$CHECK_ONLY" -eq 0 ] && [ "$SKIP_DART_DOC" -eq 0 ]; then
  echo "$INFO 步骤 1/3: dart doc（根包 + $(echo ${TARGETS} | tr "\n" " ")）"
  for d in . $TARGETS; do
    if [ "$d" = "." ]; then DIR="$ROOT"; else DIR="$PACKAGES_DIR/$d"; fi
    echo "$INFO dart doc: $d"
    (cd "$DIR" && run_dart doc --output doc/api) || { echo "$ERR dart doc 失败: $d"; FAILED=1; }
  done
else
  echo "$INFO 跳过 dart doc（--check-only 或 --skip-dart-doc）"
fi

# ---- 2+3. API 索引提取 + 一致性校验（Dart 工具脚本）----
echo "$INFO 步骤 2/3: 生成 docs/api-index.md + docs/api/*.md 并执行步骤 3/3 一致性校验"
EXTRACT_ARGS=(--root "$ROOT")
if [ "$CHECK_ONLY" -eq 1 ]; then
  EXTRACT_ARGS+=(--check-only)
fi
if [ -n "$PKG" ]; then
  EXTRACT_ARGS+=(--pkg "$PKG")
fi

set +e
run_dart run scripts/gen_docs_extract.dart "${EXTRACT_ARGS[@]}"
EXTRACT_EXIT=$?
set -e

if [ "$EXTRACT_EXIT" -ne 0 ]; then
  echo "$ERR 一致性校验未通过（缺失/多余 API 清单见上方输出），退出码 $EXTRACT_EXIT"
  exit "$EXTRACT_EXIT"
fi

if [ "$FAILED" -ne 0 ]; then
  echo "$ERR 存在 dart doc 失败的包"
  exit 1
fi

echo "$DONE gen-docs 完成"
exit 0
