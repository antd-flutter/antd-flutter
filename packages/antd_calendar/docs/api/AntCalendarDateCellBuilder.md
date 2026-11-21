<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCalendarDateCellBuilder

> 种类：类型定义

```dart
typedef AntCalendarDateCellBuilder
```

自定义日期单元格构建回调。

`date` 为单元格对应日期（已去除时分秒）；
`isCurrentMonth` 表示是否属于当前展示月份（非本月补位日期为 false）；
`isToday` 表示是否为今天；
`isSelected` 表示是否为选中日期。

