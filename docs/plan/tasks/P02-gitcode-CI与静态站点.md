# P02. GitCode CI 与国内静态站点发布

- 状态：`[ ]`
- 目标：完善 CI 命令，使 GitCode 侧也能跑 CI，并发布国内可访问的静态站点（对应现有 GitHub Pages 的 example 演示站 + 图标库站点）
- 前置依赖：P01（代码先同步到 GitCode）

## 步骤
1. 调研 GitCode CI 能力：确认 GitCode.com 的流水线形态（是否兼容 GitHub Actions 语法 / 使用 `.workflow/` 或其他配置），以及静态站点托管产品（对应 GitHub Pages）
2. 现有 GitHub 侧 CI 盘点（`.github/workflows/`）：
   - `ci.yml`：analyze + test + 六端构建矩阵
   - `deploy.yml`：flutter build web（example + icons 画廊，base-href `/antd-flutter/`）→ Pages 发布
3. 在 GitCode 侧落地等效流水线配置：analyze/test/build 命令复用 `ci.yml` 中的命令
4. 落地 GitCode 静态站点发布：构建产物 = `example/build/web` + `icons/` 子目录合并，发布到 GitCode Pages；确认 base-href 路径与 GitCode 站点 URL 匹配（必要时调整 base-href）
5. 验证：push 到 GitCode 触发流水线全绿，国内网络可直接访问静态站

## 验收标准
- [ ] GitCode push 触发 CI（analyze/test/build）
- [ ] GitCode 静态站点可国内访问，含 example 演示与 icons 画廊
- [ ] GitHub 侧 CI 不受影响

## 调研结论（2026-11-17，来源 docs.gitcode.com AtomGit 帮助文档）

1. **流水线形态**：GitCode 使用 AtomGit Action，**语法高度兼容 GitHub Actions**（`on`/`jobs`/`runs-on`/`steps`/`run`/`uses`/`with`/`strategy.matrix`/`concurrency`/`secrets` 均支持），但配置目录为 **`.gitcode/workflows/*.yml`**（不是 `.github/workflows/`，也不是 `.workflow/`），目录错误则流水线不被识别触发。
2. **差异点**：
   - 触发语法同 GH Actions（`push`/`pull_request`/`workflow_dispatch`/`schedule` 等，支持 branches 过滤）
   - 上下文用 `atomgit.*` 与环境变量 `ATOMGIT_REF`/`ATOMGIT_SHA`/`ATOMGIT_REPOSITORY` 等，**不支持 `github.*`**
   - 官方插件直接 `uses: checkout`、`setup-node`；开源插件 `owner/repo/path@ref`（AtomGit 仓库）；GitHub Marketplace 插件（如 `actions/checkout@v4`、`subosito/flutter-action@v2`）不保证可用，配置中已避免使用
   - 托管 Runner 仅 **Linux**（ubuntu-latest/euler-latest，三段式标签 `[ubuntu-latest, x64, small]`），无 macOS/Windows → **六端构建矩阵无法在 GitCode 侧跑**，CI 侧只覆盖 analyze/test/web 构建
   - Runner 未预装 Flutter → 通过下载官方 `flutter_linux_3.50.0-stable.tar.xz` 安装
   - **流水线为内测功能**，需申请内测名额（见用户待办）
3. **GitCode Pages**：官方帮助文档**未见 GitCode Pages（静态站点托管）公开文档**（sitemap 全量检查无 pages/静态站点条目）；开通方式、URL 映射、发布语法待官方开放或咨询客服确认。发布配置已按「构建 + 制品上传」落地，发布步骤待 Pages 开通后补齐。

## 落地内容

- `.gitcode/workflows/ci.yml`：analyze + test + web 构建（复用 GitHub ci.yml 命令，Flutter 3.50.0）
- `.gitcode/workflows/pages.yml`：构建 example + icons 合并站点并上传制品（复用 GitHub deploy.yml 命令）
- `scripts/build_site.sh`：站点构建合并脚本（`example/build/web` + `icons/` 合并到 `build/site`，base-href 默认 `/antd-flutter/`，可通过 `SITE_BASE_HREF`/`ICON_BASE_HREF` 环境变量调整以匹配 GitCode Pages URL）
- origin 已配置双地址推送（fetch 1 条 GitHub + push 2 条 GitHub/GitCode，SSH 均已验证可用）

## 用户待办清单

- [ ] 在 GitCode 申请/开通**流水线（AtomGit Action）内测名额**（quick-start 文档注明需申请，详情咨询 AtomGit 客服）
- [ ] 确认 **GitCode Pages** 开通方式（若产品已对部分用户开放需在仓库网页开通；未开放则咨询客服/等待开放）
- [ ] Pages 开通后确认站点 URL 形态，若路径前缀非 `/antd-flutter/`，调整 pages.yml 的 `SITE_BASE_HREF`/`ICON_BASE_HREF` 并补齐发布步骤
- [ ] push 后在 GitCode 仓库「流水线/Actions」Tab 确认 CI 全绿

## 验证结果
- 本地验证：`bash -n scripts/build_site.sh` 通过；两个 workflow YAML 解析通过；GitHub 侧 `.github/workflows/` 未删改
- `ssh -T git@gitcode.com` 认证成功（公钥已生效），双地址推送已可用，无受阻点

## 备注
- 待调研点：GitCode Pages 是否需要开通/白名单、仓库名与站点路径的映射规则（→ 已调研，见上）
