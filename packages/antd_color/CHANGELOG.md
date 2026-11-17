# 更新日志

## 1.0.0

首个正式版（stable）。API 与 0.1.0-beta.1 相比**无破坏性变更**。

- **AntFastColor** — [`@ant-design/fast-color`](https://github.com/ant-design/fast-color) v3 精确移植：hex / rgb / hsl / hsv 解析，lighten / darken / mix / tint / shade / alpha 调整与各格式互转
- **antGeneratePalette** — Ant Design 标志性 10 阶色板生成（step1 ~ step10），支持暗色主题（dark + backgroundColor）
- **预设色板** — 13 组 Ant Design 预设色（red / volcano / orange / gold / yellow / lime / green / cyan / blue / geekblue / purple / magenta / grey），含暗色变体
- **AntColor** — 色板包装类：fromSeed / fromSeedDark，按 step（1-10）访问 hex 与 Flutter `Color`
- **antParseColor** — CSS 颜色字符串 → Flutter `Color`
- 测试：33 个测试用例全量通过（与移植源测试基线一致）
