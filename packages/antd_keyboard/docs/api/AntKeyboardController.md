<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntKeyboardController

> 种类：类

```dart
class AntKeyboardController
```

通用键盘控制器 — 修饰键 / 模式 / 文本绑定 / 物理键盘协作。

保持无外部依赖即可使用：不传 `AntKeyboard.controller` 时键盘内部自建一个，
传入后可由业务侧驱动 Shift/CapsLock、切换模式、或绑定输入框。

## 构造函数

### `AntKeyboardController({String? initialMode, bool capsLock = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `initialMode` | `String?` | 可选 | — |
| `capsLock` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_binding` | `AntKeyboardFieldBinding?` | — |
| `_capsOn` | `bool` | — |
| `_disposed` | `bool` | — |
| `_modeName` | `String?` | — |
| `_shiftOn` | `bool` | — |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `binding` | `AntKeyboardFieldBinding?` | 当前绑定的输入框（未绑定时为 null） |
| `capsOn` | `bool` | CapsLock 是否开启（持久修饰） |
| `focusNode` | `FocusNode?` | — |
| `hasAttachedField` | `bool` | 是否已绑定真实输入框 |
| `modeName` | `String?` | 当前模式名（null 表示使用布局默认模式） |
| `shiftActive` | `bool` | 是否输出大写/副字符 |
| `shiftOn` | `bool` | Shift 是否按下（一次性修饰） |
| `textController` | `TextEditingController?` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_notify` | `void` | — |
| `attach` | `void` | 绑定输入框 |
| `attachTextField` | `void` | 兼容参考库命名 |
| `backspace` | `bool` | 退格：有选区删选区，否则删光标前一个「字素」（emoji 不会被拦腰截断） |
| `consumeShift` | `void` | 输入一个字符后复位一次性 Shift |
| `cycleMode` | `String?` | 在给定模式列表里切换到下一个（首个为默认时自动跳过） |
| `detachTextField` | `void` | 解绑输入框 |
| `dispose` | `void` | — |
| `insert` | `bool` | 在光标/选区处插入文本 |
| `newline` | `void` | 回车：单行输入框失焦提交，多行插入换行 |
| `resetModifiers` | `void` | 清空所有修饰态 |
| `setMode` | `void` | 设置模式，非法模式名忽略 |
| `tab` | `void` | 制表符 |
| `toggleCaps` | `void` | 切换 CapsLock（持久） |
| `toggleShift` | `void` | 切换 Shift（一次性） |

