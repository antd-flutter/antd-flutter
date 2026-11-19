<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntKeyboardKey

> 种类：类

```dart
class AntKeyboardKey
```

键盘按键统一模型

## 构造函数

### `AntKeyboardKey.action(this.action, {this.actionLabel, this.flex = 1})`

动作键

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `action` | `AntKeyAction` | 可选 | — |
| `actionLabel` | `String?` | 可选 | — |
| `flex` | `int` | = 1 | — |

### `AntKeyboardKey.text(this.text, {this.variants = const [], this.flex = 1})`

文本输入键（`variants` 为长按备选字符，如字母重音/标点变体）

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `text` | `String?` | 可选 | — |
| `variants` | `List<String>` | = const [] | — |
| `flex` | `int` | = 1 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `action` | `AntKeyAction` | 动作类型 |
| `actionLabel` | `String?` | 动作键显示文本（如 '确定'） |
| `flex` | `int` | 行内宽度权重 |
| `text` | `String?` | 文本键主字符（动作键可为 null，配合 actionLabel 显示） |
| `variants` | `List<String>` | 长按备选字符 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `hasVariants` | `bool` | — |
| `isBackspace` | `bool` | — |

