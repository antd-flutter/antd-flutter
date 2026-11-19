<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntKeyboardThemeData

> 种类：类

```dart
class AntKeyboardThemeData
```

## 构造函数

### `AntKeyboardThemeData({this.surfaceColor, this.keyBackgroundColor, this.keyForegroundColor, this.keyPressedBackgroundColor, this.keyHoverBackgroundColor, this.actionKeyBackgroundColor, this.actionKeyForegroundColor, this.actionKeyPressedBackgroundColor, this.confirmBackgroundColor, this.confirmForegroundColor, this.keyBorderRadius, this.keyHeight, this.keySpacing, this.sectionPadding, this.fontSize, this.iconSize, this.desktop = false})`

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
| `desktop` | `bool` | = false | — |

### `AntKeyboardThemeData.resolve(AntThemeData t, {bool desktop = false})`

从 antd 主题 token 派生默认主题（亮/暗自适应 + 桌面密度）

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `t` | `AntThemeData` | 可选 | — |
| `desktop` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `actionKeyBackgroundColor` | `Color?` | 动作键（退格/空格/收起等）背景 |
| `actionKeyForegroundColor` | `Color?` | 动作键前景 |
| `actionKeyPressedBackgroundColor` | `Color?` | 动作键按压态背景 |
| `confirmBackgroundColor` | `Color?` | 确认键背景 |
| `confirmForegroundColor` | `Color?` | 确认键前景 |
| `desktop` | `bool` | 桌面密度（键高更大、间距更宽、启用悬停反馈） |
| `fontSize` | `double?` | 键文字字号 |
| `iconSize` | `double?` | 动作键图标尺寸 |
| `keyBackgroundColor` | `Color?` | 文本键背景 |
| `keyBorderRadius` | `double?` | 键圆角 |
| `keyForegroundColor` | `Color?` | 文本键前景（文字色） |
| `keyHeight` | `double?` | 键高 |
| `keyHoverBackgroundColor` | `Color?` | 文本键悬停态背景（桌面端鼠标交互） |
| `keyPressedBackgroundColor` | `Color?` | 文本键按压态背景 |
| `keySpacing` | `double?` | 键水平/垂直间距 |
| `sectionPadding` | `double?` | 键盘内边距 |
| `surfaceColor` | `Color?` | 键盘表面（容器底色），null 时取主题 colorBgContainer |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `merge` | `AntKeyboardThemeData` | 合并覆盖（this 非 null 字段优先） |

