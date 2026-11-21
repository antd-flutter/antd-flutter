<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntNumberKeyboard

> 种类：类

```dart
class AntNumberKeyboard
```

数字键盘 — 提供数字输入面板。

对齐 antd-mobile React NumberKeyboard。

## 构造函数

### `AntNumberKeyboard({super.key, this.value, this.defaultValue, this.onChange, this.maxLength, this.confirmText, this.onConfirm, this.randomOrder = false, this.customKey, this.title, this.visible = true, this.onClose, this.theme, this.desktop = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `String?` | 可选 | — |
| `defaultValue` | `String?` | 可选 | — |
| `onChange` | `ValueChanged<String>?` | 可选 | — |
| `maxLength` | `int?` | 可选 | — |
| `confirmText` | `String?` | 可选 | — |
| `onConfirm` | `VoidCallback?` | 可选 | — |
| `randomOrder` | `bool` | = false | — |
| `customKey` | `String?` | 可选 | — |
| `title` | `String?` | 可选 | — |
| `visible` | `bool` | = true | — |
| `onClose` | `VoidCallback?` | 可选 | — |
| `theme` | `AntKeyboardThemeData?` | 可选 | — |
| `desktop` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `confirmText` | `String?` | 确认按钮文案（null 则不显示确认键） |
| `customKey` | `String?` | 自定义按键（如 '.' 或 'X'） |
| `defaultValue` | `String?` | 非受控初始值 |
| `desktop` | `bool` | 桌面密度（键高/间距更大 + 悬停反馈 |
| `maxLength` | `int?` | 最大输入长度 |
| `onChange` | `ValueChanged<String>?` | 值变化回调 |
| `onClose` | `VoidCallback?` | 关闭回调 |
| `onConfirm` | `VoidCallback?` | 确认回调 |
| `randomOrder` | `bool` | 数字是否乱序 |
| `theme` | `AntKeyboardThemeData?` | 键盘主题覆盖（null 时从 AntTheme 派生） |
| `title` | `String?` | 标题 |
| `value` | `String?` | 受控当前值 |
| `visible` | `bool` | 是否可见 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntNumberKeyboard>` | — |

