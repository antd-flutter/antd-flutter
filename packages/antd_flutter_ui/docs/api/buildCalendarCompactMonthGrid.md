<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# buildCalendarCompactMonthGrid

> 种类：函数

```dart
List<DateTime> buildCalendarCompactMonthGrid(DateTime month, {required bool weekStartsOnMonday})
```

生成自适应行数的月份网格：按当月实际天数向上取整为整周（紧凑布局用）。

## 参数

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `month` | `DateTime` | 可选 | — |
| `weekStartsOnMonday` | `bool` | 可选 | — |

返回 `List<DateTime>`。

