# 更新日志

## 1.0.0

首个正式版（stable）。API 与 0.1.0-beta.1 相比**无破坏性变更**。

- **AntSeedToken** — antd v6 主题最小输入集（colorPrimary / fontSize / borderRadius / sizeUnit / motionUnit …），默认值与 antd `seed.ts` 一致，含 `dark()` 工厂
- **Token 生成器** — Seed → Map 派生算法精确移植：`antGenFontMapToken`、`antGenRadius`、`antGenSizeMapToken`、`antGenControlHeight`、`antGenMotionDuration`（共 7 个生成器，含字体阶梯 / 行高 / 字重派生）
- **AntColorTokens** — 完整颜色令牌集（Map Token + Alias Token），`light` / `dark` 工厂，每个令牌同时暴露 Flutter `Color` 与原始 CSS 字符串（`css` 视图）
- **AntShadowTokens** — 全部 antd 阴影令牌（boxShadow / boxShadowSecondary / boxShadowCard / drawer / tabs 等）转换为 Flutter `List<BoxShadow>`
- **antd v6 对齐断言** — 测试内置与 antd v6 官方 token 快照的对齐断言（默认 seed 下 colorPrimary #1677ff、字号阶梯、圆角阶梯、控件高度等），共 66 个测试用例全量通过
