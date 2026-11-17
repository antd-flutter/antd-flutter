#!/usr/bin/env bash
# 把 build/site 产物推送到 gitee-pages 分支（Gitee Pages 数据源）
# Gitee Pages 需在仓库「服务」中手动开通一次并选择 gitee-pages 分支；开通后推送本脚本自动更新站点
set -euo pipefail
SITE_DIR="${SITE_DIR:-build/site}"
BRANCH="${GITEE_PAGES_BRANCH:-gitee-pages}"
[ -d "$SITE_DIR" ] || { echo "[错误] 站点产物不存在：$SITE_DIR，先运行 build_site.sh"; exit 1; }
REPO_URL="${GITEE_REPO_URL:-https://gitee.com/antd-flutter/antd-flutter.git}"
REPO_ROOT=$(git rev-parse --show-toplevel)
SITE_DIR="${REPO_ROOT}/${SITE_DIR}"
WORK_DIR=$(mktemp -d)
git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$WORK_DIR" 2>/dev/null || git clone "$REPO_URL" "$WORK_DIR"
cd "$WORK_DIR"
git checkout -B "$BRANCH" 2>/dev/null || true
rm -rf ./*
cp -r "$SITE_DIR"/. .
echo "site updated: $(date '+%Y-%m-%d %H:%M:%S')" > .site-build-info
git add -A
git commit -m "site: rebuild $(date '+%Y-%m-%d %H:%M:%S')" || { echo "[跳过] 站点无变化"; exit 0; }
git push origin "$BRANCH"
echo "[完成] 已推送到 $BRANCH（Gitee Pages 数据源）"
