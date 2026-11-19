<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntKeyboard

> 种类：类

```dart
class AntKeyboard
```

通用屏上键盘

## 构造函数

### `AntKeyboard({super.key, required this.layout, this.theme, this.confirmText, this.onTextInput, this.onBackspace, this.onConfirm, this.onHide, this.onKey})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `layout` | `AntKeyboardLayout` | 可选 | — |
| `theme` | `AntKeyboardThemeData?` | 可选 | — |
| `confirmText` | `String?` | 可选 | — |
| `onTextInput` | `ValueChanged<String>?` | 可选 | — |
| `onBackspace` | `VoidCallback?` | 可选 | — |
| `onConfirm` | `VoidCallback?` | 可选 | — |
| `onHide` | `VoidCallback?` | 可选 | — |
| `onKey` | `ValueChanged<AntKeyboardKey>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `confirmText` | `String?` | 确认键文案（null 时不渲染独立确认键，confirm 动作键按布局显示） |
| `layout` | `AntKeyboardLayout` | 布局（预设或自定义） |
| `onBackspace` | `VoidCallback?` | 退格回调（长按连续触发） |
| `onConfirm` | `VoidCallback?` | 确认回调 |
| `onHide` | `VoidCallback?` | 收起回调（hide 动作键） |
| `onKey` | `ValueChanged<AntKeyboardKey>?` | 原始按键回调（所有按键统一出口，便于扩展） |
| `onTextInput` | `ValueChanged<String>?` | 文本输入回调（含长按变体选择） |
| `theme` | `AntKeyboardThemeData?` | 主题覆盖（null 时从 AntTheme 派生） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntKeyboard>` | — |

