# Git 双地址推送

> 触发词：双地址推送/推GitCode/配置双远程

## 约定

本仓库一次 `git push` 同时推送到 GitHub 与 GitCode 双远程，保证两侧代码同步：

- 日常推送只用 `git push origin <branch>`（或 `git push`），**不要**直接 push 单一远程 URL，避免漏推一侧
- 任务分支推送同样走 origin 双地址（对齐 PLAN.md R3）

## 首次配置（仅初始化时需要）

```bash
git remote set-url --add --push origin git@github.com:antd-flutter/antd-flutter.git
git remote set-url --add --push origin git@gitcode.com:antd-flutter/antd-flutter.git
```

- 校验：`git remote -v` 应显示 fetch 1 条 + push 2 条
- GitCode 侧远程认证方式由使用者本机的 Git 凭证/平台账号体系决定，配置时按平台要求完成授权即可（本技能不涉及具体凭证操作）

## 单侧失败处理

- 双地址推送时某一侧失败，另一侧可能已成功
- 失败侧单独补推：`git push <失败侧仓库地址> <branch>`
- 补推成功后保持 origin 双地址配置不变
