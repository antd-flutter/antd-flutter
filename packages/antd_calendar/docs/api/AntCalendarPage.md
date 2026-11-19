<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCalendarPage

> 种类：类

```dart
class AntCalendarPage
```

年月页面（antd-mobile Page 对齐），用于 minPage/maxPage 面板导航范围限制。

## 构造函数

### `AntCalendarPage({required this.year, required this.month})`

创建年月页面（month 取 1~12）。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `year` | `int` | 可选 | — |
| `month` | `int` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `month` | `int` | 月份（1~12） |
| `year` | `int` | 年份 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `hashCode` | `int` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `==` | `bool` | — |
| `compareTo` | `int` | 与目标月份比较：负数表示在目标之前，0 相同，正数在目标之后 |

