<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntFloatButtonBadge

> 种类：类

```dart
class AntFloatButtonBadge
```

悬浮按钮角标配置 — 对应 antd `FloatButtonBadgeProps`。

## 构造函数

### `AntFloatButtonBadge({this.count, this.dot = false, this.color, this.overflowCount = 99})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `count` | `int?` | 可选 | — |
| `dot` | `bool` | = false | — |
| `color` | `Color?` | 可选 | — |
| `overflowCount` | `int` | = 99 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `color` | `Color?` | 自定义角标颜色（默认 colorError / colorPrimary） |
| `count` | `int?` | 角标数字，为 0 时不显示 |
| `dot` | `bool` | 是否显示为圆点（优先于 count） |
| `overflowCount` | `int` | 数字溢出阈值，超过显示 ${overflowCount}+ |

