# P01. Git 双地址推送支持

- 状态：`[~]` 执行完成，待用户验证后提交
- 目标：每次 push 自动同步推送到 GitHub 与 GitCode 两个远程库
- 前置依赖：无

## 执行进度
- [x] 步骤 1：origin 已配置双 push 地址（fetch→GitHub；push→GitHub HTTPS + GitCode SSH）
- [x] 步骤 2：双推验证通过——GitHub up-to-date；GitCode SSH 认证通过（专用密钥 gitcode_ed25519 + ssh config），master 首推成功创建分支
- [x] 步骤 3：双地址约定已写入 `docs/git-双地址推送约定.md`（含 SSH 配置说明）

## 步骤
1. 添加第二远程：`git remote set-url --add --push origin https://github.com/antd-flutter/antd-flutter.git`，再 `--add --push https://gitcode.com/antd-flutter/antd-flutter.git`（origin 保留 fetch 指向 GitHub，push 配双 URL）
2. 验证 `git remote -v` 显示两条 push 地址，执行一次 `git push origin master` 确认两库均收到
3. 沉淀使用约定（推送到文档/README 内部说明）：日常只用 `git push`（走 origin 双 push），避免直接 push 单一远程 URL 造成漏推

## 验收标准
- [ ] `git remote -v` 包含 GitHub + GitCode 两条 push 地址
- [ ] 一次 push 两库均更新
- [ ] 双地址约定已写入文档

## 备注
- GitCode 仓库 https://gitcode.com/antd-flutter/antd-flutter.git 需确认有推送权限
- 若 GitCode 未建仓库，先在 GitCode 上创建同名空仓库（不要初始化 README，避免历史分叉）
