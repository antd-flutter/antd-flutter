<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCalendarFormat

> 种类：枚举

```dart
enum AntCalendarFormat
```

日历可见格式（吸收 table_calendar calendarFormat，参考 Apache-2.0 源码改造）。

## 枚举值

| 名称 | 说明 |
| --- | --- |
| `month` | 月视图（默认，固定 6 行网格） |
| `twoWeeks` | 两周视图（锚定日期所在的两周） |
| `week` | 周视图（锚定日期所在的一周） |

