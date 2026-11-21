<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntBadge

> 种类：类

```dart
class AntBadge
```

徽标 — 图标右上角展示消息数或状态点。

对齐 antd React Badge 组件。

## 构造函数

### `AntBadge({super.key, this.count, this.dot = false, this.overflowCount = 99, this.showZero = false, this.offset, this.color, this.status, this.text, this.child, this.size = 20})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `count` | `int?` | 可选 | — |
| `dot` | `bool` | = false | — |
| `overflowCount` | `int` | = 99 | — |
| `showZero` | `bool` | = false | — |
| `offset` | `List<double>?` | 可选 | — |
| `color` | `Color?` | 可选 | — |
| `status` | `AntBadgeStatus?` | 可选 | — |
| `text` | `String?` | 可选 | — |
| `child` | `Widget?` | 可选 | — |
| `size` | `double` | = 20 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget?` | 包裹的内容 |
| `color` | `Color?` | 自定义徽标颜色 |
| `count` | `int?` | 数字徽标值 |
| `dot` | `bool` | 是否显示红点 |
| `offset` | `List<double>?` | 徽标偏移 x, y |
| `overflowCount` | `int` | 超出此值显示 +N |
| `showZero` | `bool` | count 为 0 时是否显示 |
| `size` | `double` | 徽标数字容器尺寸 |
| `status` | `AntBadgeStatus?` | 状态点模式 |
| `text` | `String?` | 状态文字（配合 status 使用） |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_shouldShowCount` | `bool` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_buildBadge` | `Widget` | — |
| `_resolveColor` | `Color` | — |
| `build` | `Widget` | — |

