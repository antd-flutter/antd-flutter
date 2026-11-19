<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCalendarController

> 种类：类

```dart
class AntCalendarController
```

`AntCalendar` 的控制器：程序化翻页与年月跳转。

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_navigator` | `AntCalendarMonthNavigator?` | — |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_requireNavigator` | `AntCalendarMonthNavigator` | — |
| `isAttached` | `bool` | 是否已挂载到组件（组件 initState 时 attach，dispose 时 detach） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `attach` | `void` | 组件挂载时由内部调用（对应 ScrollPosition.attach 惯例） |
| `detach` | `void` | 组件销毁/换绑时由内部调用 |
| `goToYearMonth` | `void` | 跳转到指定年月（month 取 1~12 |
| `jumpToToday` | `void` | 回到今天（antd-mobile CalendarRef.jumpToToday 对齐）： 面板切回当前月并聚焦今天 |
| `nextMonth` | `void` | 下一月 |
| `previousMonth` | `void` | 上一月 |

