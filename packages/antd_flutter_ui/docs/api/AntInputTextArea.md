<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntInputTextArea

> 种类：类

```dart
class AntInputTextArea
```

文本域 — 多行输入。

对齐 antd React Input.TextArea，支持 rows、autoSize、字数统计。

```dart
AntInputTextArea(
  rows: 4,
  maxLength: 100,
  showCount: true,
)
```

## 构造函数

### `AntInputTextArea({super.key, this.value, this.defaultValue, this.onChange, this.onPressEnter, this.disabled = false, this.placeholder, this.rows = 3, this.autoSize, this.maxLength, this.showCount = false, this.status = AntInputStatus.normal, this.readOnly = false, this.bordered = true, this.controller, this.focusNode, this.autofocus = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `String?` | 可选 | — |
| `defaultValue` | `String?` | 可选 | — |
| `onChange` | `ValueChanged<String>?` | 可选 | — |
| `onPressEnter` | `VoidCallback?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `placeholder` | `String?` | 可选 | — |
| `rows` | `int` | = 3 | — |
| `autoSize` | `dynamic` | 可选 | — |
| `maxLength` | `int?` | 可选 | — |
| `showCount` | `bool` | = false | — |
| `status` | `AntInputStatus` | = AntInputStatus.normal | — |
| `readOnly` | `bool` | = false | — |
| `bordered` | `bool` | = true | — |
| `controller` | `TextEditingController?` | 可选 | — |
| `focusNode` | `FocusNode?` | 可选 | — |
| `autofocus` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `autoSize` | `dynamic` | 自适应高度，true 为自动 |
| `autofocus` | `bool` | 是否自动聚焦 |
| `bordered` | `bool` | 是否显示边框 |
| `controller` | `TextEditingController?` | 文本控制器 |
| `defaultValue` | `String?` | 非受控初始值 |
| `disabled` | `bool` | 是否禁用 |
| `focusNode` | `FocusNode?` | 焦点节点 |
| `maxLength` | `int?` | 最大输入长度 |
| `onChange` | `ValueChanged<String>?` | 输入变化回调 |
| `onPressEnter` | `VoidCallback?` | 按下回车回调 |
| `placeholder` | `String?` | 占位文本 |
| `readOnly` | `bool` | 是否只读 |
| `rows` | `int` | 行数 |
| `showCount` | `bool` | 是否显示字数统计 |
| `status` | `AntInputStatus` | 校验状态 |
| `value` | `String?` | 受控值 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntInputTextArea>` | — |

