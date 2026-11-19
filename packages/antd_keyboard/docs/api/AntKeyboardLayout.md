<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntKeyboardLayout

> 种类：类

```dart
class AntKeyboardLayout
```

键盘布局

## 构造函数

### `AntKeyboardLayout({required this.rows})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `rows` | `List<AntKeyboardRow>` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `rows` | `List<AntKeyboardRow>` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `decimal` | `AntKeyboardLayout` | 小数键盘（数字 + 小数点） |
| `email` | `AntKeyboardLayout` | 邮箱键盘（QWERTY + @/ |
| `numeric` | `AntKeyboardLayout` | 数字键盘（antd-mobile NumberKeyboard 形态 |
| `symbol` | `AntKeyboardLayout` | 符号键盘 |
| `text` | `AntKeyboardLayout` | 文本键盘（QWERTY 小写，字母长按出重音/备选字符） |

