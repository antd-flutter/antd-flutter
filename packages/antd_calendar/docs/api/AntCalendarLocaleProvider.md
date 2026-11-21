<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCalendarLocaleProvider

> 种类：类

```dart
class AntCalendarLocaleProvider
```

日历国际化注入 — InheritedWidget，包裹一次全局生效。

```dart
AntCalendarLocaleProvider(
  locale: AntCalendarLocale.en,
  child: AntCalendar(...),
)
```

## 构造函数

### `AntCalendarLocaleProvider({super.key, required this.locale, required super.child})`

创建注入节点。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `locale` | `AntCalendarLocale` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `locale` | `AntCalendarLocale` | 注入的国际化配置 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `updateShouldNotify` | `bool` | — |

