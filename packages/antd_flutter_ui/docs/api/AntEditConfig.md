<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntEditConfig

> 种类：类

```dart
class AntEditConfig
```

可编辑配置 — 对应 antd `EditConfig`。

## 构造函数

### `AntEditConfig({this.text, this.editing = false, this.onStart, this.onChange, this.onCancel})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `text` | `String?` | 可选 | — |
| `editing` | `bool` | = false | — |
| `onStart` | `VoidCallback?` | 可选 | — |
| `onChange` | `ValueChanged<String>?` | 可选 | — |
| `onCancel` | `VoidCallback?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `editing` | `bool` | 是否处于编辑态 |
| `onCancel` | `VoidCallback?` | 取消编辑时的回调 |
| `onChange` | `ValueChanged<String>?` | 文本变化时的回调 |
| `onStart` | `VoidCallback?` | 开始编辑时的回调 |
| `text` | `String?` | 编辑时的初始文本 |

