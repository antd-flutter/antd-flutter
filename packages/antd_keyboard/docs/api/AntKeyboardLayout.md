<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntKeyboardLayout

> 种类：类

```dart
class AntKeyboardLayout
```

键盘布局

## 构造函数

### `AntKeyboardLayout({required List<AntKeyboardRow> rows})`

单模式布局

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `rows` | `List<AntKeyboardRow>` | 可选 | — |

### `AntKeyboardLayout._({required this.rows, this.modes, this.initialMode})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `rows` | `List<AntKeyboardRow>` | 可选 | — |
| `modes` | `Map<String, List<AntKeyboardRow>>?` | 可选 | — |
| `initialMode` | `String?` | 可选 | — |

### `AntKeyboardLayout.modes(Map<String, List<AntKeyboardRow>> modes, {String? initialModeName})`

多模式布局（参考库 KeyboardMode 设计）：modeSwitch 动作键循环切换

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `modes` | `Map<String, List<AntKeyboardRow>>` | 可选 | — |
| `initialModeName` | `String?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `initialMode` | `String?` | 初始模式名 |
| `modes` | `Map<String, List<AntKeyboardRow>>?` | 多模式注册表（null = 单模式） |
| `rows` | `List<AntKeyboardRow>` | 单模式行（多模式布局返回初始模式行） |
| `_digits123` | `List<AntKeyboardKey>` | — |
| `_digits456` | `List<AntKeyboardKey>` | — |
| `_digits789` | `List<AntKeyboardKey>` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_lettersMode` | `List<AntKeyboardRow>` | 字母模式（Shift/CapsLock 大写 + modeSwitch 切符号） |
| `_symbolsBarMode` | `List<AntKeyboardRow>` | 符号条模式（数字行 Shift 出符号 + modeSwitch 切回字母） |
| `decimal` | `AntKeyboardLayout` | 小数键盘（数字 + 小数点） |
| `email` | `AntKeyboardLayout` | 邮箱键盘（QWERTY + @/ |
| `numeric` | `AntKeyboardLayout` | 数字键盘（antd-mobile NumberKeyboard 形态 |
| `qwertyDesktop` | `AntKeyboardLayout` | 完整桌面 QWERTY（参考库 DesktopKeyboardLayout 设计，MIT 吸收）： 数字行（sec… |
| `symbol` | `AntKeyboardLayout` | 符号键盘（单模式全量符号） |
| `text` | `AntKeyboardLayout` | 文本键盘（多模式：letters/symbols，参考库 MobileKeyboardLayout 设计） |

