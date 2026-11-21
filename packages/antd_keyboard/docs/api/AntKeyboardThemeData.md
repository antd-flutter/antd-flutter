<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntKeyboardThemeData

> 种类：类

```dart
class AntKeyboardThemeData
```

AntKeyboard 主题数据。

采用与 `flutter_onscreen_keyboard` 相同的「键级主题」思路：所有键共用一份
主题，通过 `desktop` 切换桌面 / 移动两套形态（仓库 R38 双端规则）：

- 移动端：对齐 antd-mobile v5（白色键面、1px 描边、4 圆角、48 高）；
- 桌面端：对齐 antd v6（`colorBgElevated` 浮层、`colorFillSecondary` 键面、
  6 圆角、`boxShadowSecondary` 阴影、hover 反馈）。

尺寸一律走仓库约定 `theme.s(...)`（宽高/间距/描边/字号/圆角统一缩放因子），
颜色一律取自 `AntThemeData` 令牌，不硬编码。

## 构造函数

### `AntKeyboardThemeData({this.surfaceColor, this.keyBackgroundColor, this.keyForegroundColor, this.keyPressedBackgroundColor, this.keyHoverBackgroundColor, this.actionKeyBackgroundColor, this.actionKeyForegroundColor, this.actionKeyPressedBackgroundColor, this.confirmBackgroundColor, this.confirmForegroundColor, this.keyBorderRadius, this.keyHeight, this.keySpacing, this.sectionPadding, this.fontSize, this.iconSize, this.keyBorderColor, this.keyBorderWidth, this.boxShadow, this.surfaceBorderColor, this.surfaceBorderRadius, this.showKeyBorders = true, this.headerHeight, this.headerBackgroundColor, this.titleColor, this.titleFontSize, this.confirmFontSize, this.desktop = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `surfaceColor` | `Color?` | 可选 | — |
| `keyBackgroundColor` | `Color?` | 可选 | — |
| `keyForegroundColor` | `Color?` | 可选 | — |
| `keyPressedBackgroundColor` | `Color?` | 可选 | — |
| `keyHoverBackgroundColor` | `Color?` | 可选 | — |
| `actionKeyBackgroundColor` | `Color?` | 可选 | — |
| `actionKeyForegroundColor` | `Color?` | 可选 | — |
| `actionKeyPressedBackgroundColor` | `Color?` | 可选 | — |
| `confirmBackgroundColor` | `Color?` | 可选 | — |
| `confirmForegroundColor` | `Color?` | 可选 | — |
| `keyBorderRadius` | `double?` | 可选 | — |
| `keyHeight` | `double?` | 可选 | — |
| `keySpacing` | `double?` | 可选 | — |
| `sectionPadding` | `double?` | 可选 | — |
| `fontSize` | `double?` | 可选 | — |
| `iconSize` | `double?` | 可选 | — |
| `keyBorderColor` | `Color?` | 可选 | — |
| `keyBorderWidth` | `double?` | 可选 | — |
| `boxShadow` | `List<BoxShadow>?` | 可选 | — |
| `surfaceBorderColor` | `Color?` | 可选 | — |
| `surfaceBorderRadius` | `double?` | 可选 | — |
| `showKeyBorders` | `bool` | = true | — |
| `headerHeight` | `double?` | 可选 | — |
| `headerBackgroundColor` | `Color?` | 可选 | — |
| `titleColor` | `Color?` | 可选 | — |
| `titleFontSize` | `double?` | 可选 | — |
| `confirmFontSize` | `double?` | 可选 | — |
| `desktop` | `bool` | = false | — |

### `AntKeyboardThemeData.resolve(AntThemeData t, {bool desktop = false})`

从 `AntThemeData` 派生：移动端对齐 antd-mobile v5，桌面端对齐 antd v6。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `t` | `AntThemeData` | 可选 | — |
| `desktop` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `actionKeyBackgroundColor` | `Color?` | 动作键底色（shift / caps / backspace / 自定义键等） |
| `actionKeyForegroundColor` | `Color?` | 动作键前景色 |
| `actionKeyPressedBackgroundColor` | `Color?` | 动作键按下底色 |
| `boxShadow` | `List<BoxShadow>?` | 面板阴影（桌面） |
| `confirmBackgroundColor` | `Color?` | 确认键底色 |
| `confirmFontSize` | `double?` | 确认键字号 |
| `confirmForegroundColor` | `Color?` | 确认键前景色 |
| `desktop` | `bool` | 是否桌面形态（由调用方显式指定，默认跟随平台） |
| `fontSize` | `double?` | 键字号 |
| `headerBackgroundColor` | `Color?` | 头部底色 |
| `headerHeight` | `double?` | 头部高度（标题 / 关闭按钮区） |
| `iconSize` | `double?` | 动作图标尺寸 |
| `keyBackgroundColor` | `Color?` | 文本键底色 |
| `keyBorderColor` | `Color?` | 键描边颜色 |
| `keyBorderRadius` | `double?` | 键圆角 |
| `keyBorderWidth` | `double?` | 键描边宽度 |
| `keyForegroundColor` | `Color?` | 文本键前景色 |
| `keyHeight` | `double?` | 键高度 |
| `keyHoverBackgroundColor` | `Color?` | 文本键 hover 底色（桌面） |
| `keyPressedBackgroundColor` | `Color?` | 文本键按下底色 |
| `keySpacing` | `double?` | 键间距 |
| `sectionPadding` | `double?` | 面板内边距 |
| `showKeyBorders` | `bool` | 是否绘制键描边（antd-mobile 数字键盘为 true，桌面浮层也为 true） |
| `surfaceBorderColor` | `Color?` | 面板描边颜色 |
| `surfaceBorderRadius` | `double?` | 面板圆角 |
| `surfaceColor` | `Color?` | 键盘面板底色 |
| `titleColor` | `Color?` | 标题颜色 |
| `titleFontSize` | `double?` | 标题字号 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `copyWith` | `AntKeyboardThemeData` | — |
| `merge` | `AntKeyboardThemeData` | 合并主题覆盖：other 的非空字段优先 |

