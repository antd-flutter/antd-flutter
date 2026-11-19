<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCalendarMonthNavigator

> 种类：类

```dart
class AntCalendarMonthNavigator
```

月份导航目标接口：由 AntCalendar 内部 State 实现，Controller 调用。

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `navigateMonths` | `void` | 按 delta 个月导航（负数向前） |
| `navigateToToday` | `void` | 回到今天（antd-mobile jumpToToday 对齐） |
| `navigateToYearMonth` | `void` | 跳转到指定年月（month 取 1~12） |

