<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntNumberKeyboard

> 种类：类

```dart
class AntNumberKeyboard
```

数字键盘 — 移动端完全对齐 antd-mobile v5 NumberKeyboard，桌面端取 antd v6
浮层形态（`colorBgElevated` + `boxShadowSecondary` + 圆角 + 间距键）。

布局：左侧 4 行数字区（75%），右侧确认列（25%，退格 48 + 确认键跨余高）；
带标题/关闭按钮时顶部 34 高 header；`customKey` / `extraKey` 对齐
antd-mobile 的单/双自定义键规则；退格长按 700ms 后每 150ms 连删。

## 构造函数

### `AntNumberKeyboard({super.key, this.value, this.defaultValue = '', this.onChange, this.maxLength, this.confirmText, this.onConfirm, this.onCancel, this.onInput, this.onDelete, this.randomOrder = false, this.customKey, this.extraKey, this.title, this.visible = true, this.onClose, this.theme, this.desktop = false, this.showCloseButton = true, this.safeArea = true})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `String?` | 可选 | — |
| `defaultValue` | `String` | = '' | — |
| `onChange` | `ValueChanged<String>?` | 可选 | — |
| `maxLength` | `int?` | 可选 | — |
| `confirmText` | `String?` | 可选 | — |
| `onConfirm` | `VoidCallback?` | 可选 | — |
| `onCancel` | `VoidCallback?` | 可选 | — |
| `onInput` | `ValueChanged<String>?` | 可选 | — |
| `onDelete` | `VoidCallback?` | 可选 | — |
| `randomOrder` | `bool` | = false | — |
| `customKey` | `String?` | 可选 | — |
| `extraKey` | `String?` | 可选 | — |
| `title` | `String?` | 可选 | — |
| `visible` | `bool` | = true | — |
| `onClose` | `VoidCallback?` | 可选 | — |
| `theme` | `AntKeyboardThemeData?` | 可选 | — |
| `desktop` | `bool` | = false | — |
| `showCloseButton` | `bool` | = true | — |
| `safeArea` | `bool` | = true | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `confirmText` | `String?` | 确认键文案 |
| `customKey` | `String?` | 自定义键（显示并输入该字符串，如 .） |
| `defaultValue` | `String` | 非受控初始值 |
| `desktop` | `bool` | 强制桌面形态（默认按平台 + 主题判定） |
| `extraKey` | `String?` | 第二个自定义键（antd-mobile customKey 数组形态） |
| `maxLength` | `int?` | 最大长度 |
| `onCancel` | `VoidCallback?` | 取消/关闭回调（未提供 onClose 时使用） |
| `onChange` | `ValueChanged<String>?` | 值变化回调 |
| `onClose` | `VoidCallback?` | 关闭回调（头部关闭按钮） |
| `onConfirm` | `VoidCallback?` | 确认回调 |
| `onDelete` | `VoidCallback?` | 退格回调（antd-mobile onDelete） |
| `onInput` | `ValueChanged<String>?` | 单键输入回调（antd-mobile onInput），在 onChange 同时触发 |
| `randomOrder` | `bool` | 是否乱序数字 1-9 |
| `safeArea` | `bool` | 移动端是否追加底部安全区高度 |
| `showCloseButton` | `bool` | 是否显示头部关闭按钮 |
| `theme` | `AntKeyboardThemeData?` | 主题覆盖 |
| `title` | `String?` | 头部标题 |
| `value` | `String?` | 受控值（null 时使用内部缓冲） |
| `visible` | `bool` | 是否显示 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntNumberKeyboard>` | — |

