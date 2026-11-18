<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# KeyboardInputBuffer

> 种类：类

```dart
class KeyboardInputBuffer
```

键盘输入缓冲 — 受控/非受控两种模式下的按键追加与退格。

纯文本逻辑（无 UI 状态），组件层据返回值决定是否 setState。

## 构造函数

### `KeyboardInputBuffer({String initialText = '', this.maxLength})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `initialText` | `String` | = '' | — |
| `maxLength` | `int?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `maxLength` | `int?` | 最大输入长度（null 不限制） |
| `text` | `String` | 当前缓冲文本 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `append` | `String?` | 按键追加，超长时返回 null（不产生变更） |
| `backspace` | `String?` | 退格，空文本时返回 null（不产生变更） |

