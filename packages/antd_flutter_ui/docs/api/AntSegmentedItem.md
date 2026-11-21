<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSegmentedItem

> 种类：类

```dart
class AntSegmentedItem
```

分段控制器选项（旧模型，自 1.x 起推荐直接用 `AntSegmented<T>(options: List<T>)`
配合 `labelOf` / `iconBuilder` / `disabledOf`）。

## 构造函数

### `AntSegmentedItem({this.label, this.icon, this.value, this.disabled = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `label` | `String?` | 可选 | — |
| `icon` | `Widget?` | 可选 | — |
| `value` | `String?` | 可选 | — |
| `disabled` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `disabled` | `bool` | 是否禁用该项 |
| `icon` | `Widget?` | 前置图标（icon-only 时可不传 label） |
| `label` | `String?` | 选项文案 |
| `value` | `String?` | 选项值（缺省取 label） |

