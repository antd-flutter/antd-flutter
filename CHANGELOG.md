## 0.2.0-beta.1

新增 Typography 排版组件。

- AntTypography 排版基类：支持 ellipsis 省略（tooltip/expandable）、copyable 可复制、editable 可编辑、mark 标记、delete 删除线、underline 下划线、disabled 禁用、type（secondary/success/warning/danger）
- AntTitle（h1-h5）：五级标题，字号/行高与 Ant Design token 对齐
- AntParagraph：段落，支持 ellipsis 省略与 expandable 展开/收起
- AntText：文本，支持 secondary/success/warning/danger 类型
- AntLink：链接，支持 href 与 hover 下划线
- Widget test：37 个测试用例全量通过
- Example demo 页：10 个展示区块

## 0.1.0-beta.1

首个 beta 版本。

- L1 基础层：AntPlatform 平台工具（desktop/mobile 判定 + ohos 隔离）、AntOhosChannel 抽象接口
- L2 颜色层：[antd_color](https://pub.dev/packages/antd_color) — AntFastColor / antGeneratePalette / AntColor / antParseColor
- L2 令牌层：[antd_tokens](https://pub.dev/packages/antd_tokens) — AntSeedToken / AntTokenGenerators / AntColorTokens / AntShadowTokens
- L3 主题层：[antd_theme](https://pub.dev/packages/antd_theme) — AntThemeData / AntTheme / AntBreakpoint / AntScreenUtilInit
- 图标资源层：[antd_icons_flutter](https://pub.dev/packages/antd_icons_flutter) — 698 TTF 图标（outlined 447 + filled 251）+ 150 twotone SVG 图标
- L4 组件层：AntButton（primary/default/dashed/text/link + danger + loading + icon + block）
- 响应式适配：flutter_screenutil 集成（.w/.sp/.r，禁 .h）