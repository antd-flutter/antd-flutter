<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# buildCalendarMonthGrid

> 种类：函数

```dart
List<DateTime> buildCalendarMonthGrid(DateTime month, {required bool weekStartsOnMonday, int maxWeeks = kCalendarMaxWeeks})
```

生成月份网格：固定 `maxWeeks` 行（默认 6 行 × 7 列，上下月补位）。

## 参数

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `month` | `DateTime` | 可选 | — |
| `weekStartsOnMonday` | `bool` | 可选 | — |
| `maxWeeks` | `int` | = kCalendarMaxWeeks | — |

返回 `List<DateTime>`。

