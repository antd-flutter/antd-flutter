## 0.5.0-beta.1

新增 Divider 分割线与 Flex 弹性布局组件（Phase 3 布局组件首批）。

- AntDivider：分割线，支持 type（horizontal/vertical）、orientation（left/center/right）、orientationMargin 标题边距、plain 普通文本样式、variant（solid/dashed/dotted）、dashed 虚线便捷属性、child 标题内容、color/thickness/indent/endIndent/spacing 样式覆盖
- AntFlex：弹性布局，支持 vertical 垂直排列、wrap 换行、justify 主轴对齐（start/end/center/spaceBetween/spaceAround/spaceEvenly）、align 交叉轴对齐（start/end/center/baseline/stretch）、gap 间距（small/middle/large 预设 + all 单值 + only 行列分别）、mainAxisSize 主轴尺寸
- Widget test：Divider 21 个 + Flex 34 个测试用例全量通过
- Example demo 页：Divider 10 个 + Flex 8 个展示区块
- Example 首页系统 Divider/VerticalDivider/Row/Column 已替换为 AntDivider/AntFlex

## 0.4.0-beta.1

新增 NoticeBar 通告栏组件。

- AntNoticeBar：通告栏，支持 content 超长自动横向滚动（delay/speed）、color 语义颜色（normal/alert/error/info/success）、closeable 可关闭、icon 自定义左侧图标、extra 右侧操作区、wrap 多行展示、shape 形状（rectangular/neutral/rounded）、bordered 边框模式（block/full/none）、onClick/onClose 事件
- Widget test：25 个测试用例全量通过
- Example demo 页：10 个展示区块

## 0.3.0-beta.1

新增 FloatButton 悬浮按钮组件。

- AntFloatButton：悬浮按钮，支持 type(normal/primary)、shape(circle/square)、icon、content、href、disabled、badge(角标 count/dot)、tooltip、onClick
- AntFloatButtonGroup：悬浮按钮组，支持 trigger(click/hover) 展开/收起、placement(top/bottom/left/right) 方位、shape(circle/square)、closeIcon、AnimatedSize 展开动画
- AntFloatButtonBackTop：回到顶部，支持 visibilityHeight 显示阈值、duration 滚动时长、onClick、scrollController、AnimatedOpacity 显隐动画
- Widget test：21 个测试用例全量通过
- Example demo 页：11 个展示区块

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