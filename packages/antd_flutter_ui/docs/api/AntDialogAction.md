<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntDialogAction

> 种类：类

```dart
class AntDialogAction
```

AntDialog 自定义按钮项。

## 构造函数

### `AntDialogAction({required this.text, this.onClick, this.bold = false, this.primary = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `text` | `String` | 可选 | — |
| `onClick` | `VoidCallback?` | 可选 | — |
| `bold` | `bool` | = false | — |
| `primary` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `bold` | `bool` | 是否加粗（主操作） |
| `onClick` | `VoidCallback?` | 点击回调 |
| `primary` | `bool` | 是否使用主色文字 |
| `text` | `String` | 按钮文案 |

