<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCalendarValidRange

> 种类：类

```dart
class AntCalendarValidRange
```

有效日期范围（antd v6 validRange 对齐）。

范围外日期不可交互（等同禁用），且面板导航被裁剪在范围内；
传参方式：`AntCalendarValidRange(DateTime(2024, 1, 1), DateTime(2024, 12, 31))`。

## 构造函数

### `AntCalendarValidRange(DateTime start, DateTime end)`

创建有效范围（`start` ≤ `end`，构造时自动归一化并去除时分秒）。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `start` | `DateTime` | 可选 | — |
| `end` | `DateTime` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `end` | `DateTime` | 范围终点（含当天） |
| `start` | `DateTime` | 范围起点（含当天） |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `hashCode` | `int` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `==` | `bool` | — |
| `contains` | `bool` | 判断日期是否在范围内（按天比较，含边界） |
| `_dateOnly` | `DateTime` | — |

