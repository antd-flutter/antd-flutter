# Git 双地址推送约定

> **现状（2026-11-17）**：目标约定，**尚未配置完成**。GitHub 单地址可用；GitCode SSH 密钥已就绪（`~/.ssh/chenlei_gitcode`，config 已配 Host gitcode.com），待公钥添加到 GitCode 账号后按下方命令配置双地址。落地工作在 P02 任务中完成，完成后删除本段现状说明。

目标：一次 `git push` 同时推送到 GitHub 与 GitCode：

- GitHub：`git@github.com:antd-flutter/antd-flutter.git`
- GitCode：`git@gitcode.com:antd-flutter/antd-flutter.git`（SSH，密钥 `~/.ssh/chenlei_gitcode`，config 已配置）

## 日常使用

- 日常推送只用 `git push origin <branch>`（或 `git push`），不要直接 push 单一远程 URL，避免漏推一侧
- 首次配置命令（仅初始化时需要）：

```bash
git remote set-url --add --push origin git@github.com:antd-flutter/antd-flutter.git
git remote set-url --add --push origin git@gitcode.com:antd-flutter/antd-flutter.git
```

- 校验：`git remote -v` 应显示 fetch 1 条 + push 2 条

## 注意事项

- GitCode 推送走 SSH（账号密码 git 认证已被 GitCode 停用，PAT 也未采用）；首次配置需在 GitCode 设置中添加 `gitcode_ed25519.pub` 公钥
- 校验 SSH：`ssh -T git@gitcode.com`，返回 Welcome 即通过
- 某一侧推送失败时，另一侧可能已成功；失败侧单独 `git push <url> <branch>` 补推后，保持 origin 双地址不变
