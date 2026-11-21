<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntEllipsisConfig

> 种类：类

```dart
class AntEllipsisConfig
```

省略配置 — 对应 antd `EllipsisConfig`。

## 构造函数

### `AntEllipsisConfig({this.rows = 1, this.expandable = false, this.suffix, this.symbol, this.expanded = false, this.onExpand, this.tooltip = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `rows` | `int` | = 1 | — |
| `expandable` | `bool` | = false | — |
| `suffix` | `String?` | 可选 | — |
| `symbol` | `Widget?` | 可选 | — |
| `expanded` | `bool` | = false | — |
| `onExpand` | `void Function(bool expanded)?` | 可选 | — |
| `tooltip` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `expandable` | `bool` | 是否可展开 |
| `expanded` | `bool` | 是否已展开 |
| `onExpand` | `void Function(bool expanded)?` | 展开/收起时的回调 |
| `rows` | `int` | 最大显示行数 |
| `suffix` | `String?` | 尾部自定义后缀 |
| `symbol` | `Widget?` | 展开按钮的自定义内容（默认 "展开"） |
| `tooltip` | `bool` | 是否在省略时显示 tooltip 提示完整内容 |

