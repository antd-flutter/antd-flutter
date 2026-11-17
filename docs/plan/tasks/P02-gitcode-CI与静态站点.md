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

## 备注
- 待调研点：GitCode Pages 是否需要开通/白名单、仓库名与站点路径的映射规则
