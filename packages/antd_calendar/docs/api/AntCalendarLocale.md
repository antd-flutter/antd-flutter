<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCalendarLocale

> 种类：类

```dart
class AntCalendarLocale
```

日历国际化文案。

## 构造函数

### `AntCalendarLocale({this.languageCode = 'zh', this.monthTitlePattern, this.todayText, this.confirmText, this.cancelText, this.yearSuffix, this.monthSuffix, this.weekLabels, this.modeMonthText, this.modeYearText, this.messages = const {}, AntCalendarLocale? fallback})`

创建国际化配置（未提供的字段逐级回退 `fallback`，最终回退中文预设）。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `languageCode` | `String` | = 'zh' | — |
| `monthTitlePattern` | `String?` | 可选 | — |
| `todayText` | `String?` | 可选 | — |
| `confirmText` | `String?` | 可选 | — |
| `cancelText` | `String?` | 可选 | — |
| `yearSuffix` | `String?` | 可选 | — |
| `monthSuffix` | `String?` | 可选 | — |
| `weekLabels` | `List<String>?` | 可选 | — |
| `modeMonthText` | `String?` | 可选 | — |
| `modeYearText` | `String?` | 可选 | — |
| `messages` | `Map<String, String>` | = const {} | — |
| `fallback` | `AntCalendarLocale?` | 可选 | — |

### `AntCalendarLocale._raw({required this.languageCode, required this.monthTitlePattern, required this.todayText, required this.confirmText, required this.cancelText, required this.yearSuffix, required this.monthSuffix, required this.weekLabels, this.modeMonthText, this.modeYearText})`

内建预设构造（全字段必填，作为回退终点）。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `languageCode` | `String` | 可选 | — |
| `monthTitlePattern` | `String?` | 可选 | — |
| `todayText` | `String?` | 可选 | — |
| `confirmText` | `String?` | 可选 | — |
| `cancelText` | `String?` | 可选 | — |
| `yearSuffix` | `String?` | 可选 | — |
| `monthSuffix` | `String?` | 可选 | — |
| `weekLabels` | `List<String>?` | 可选 | — |
| `modeMonthText` | `String?` | 可选 | — |
| `modeYearText` | `String?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_fallback` | `AntCalendarLocale?` | 字段缺失时的一级回退预设（最终回退中文内置文案） |
| `cancelText` | `String?` | 取消按钮文案 |
| `confirmText` | `String?` | 确认按钮文案 |
| `languageCode` | `String` | 语言码，如 zh、en、zh-CN |
| `messages` | `Map<String, String>` | 自定义文案扩展表（key → 文案），经 text 读取 |
| `modeMonthText` | `String?` | 「月」面板模式标签（月/年切换器） |
| `modeYearText` | `String?` | 「年」面板模式标签（月/年切换器） |
| `monthSuffix` | `String?` | 月份后缀（年月跳转滚轮列，如「6月」「6월」） |
| `monthTitlePattern` | `String?` | 头部年月标题模板，{year} / {month} 为占位符 |
| `todayText` | `String?` | 「本月 / 回到今天」按钮文案 |
| `weekLabels` | `List<String>?` | 周标签（自周一起始的 7 个标签 |
| `yearSuffix` | `String?` | 年份后缀（年月跳转滚轮列，如「2024年」「2024년」） |
| `ar` | `AntCalendarLocale` | 阿拉伯语预设（RTL 语言，文案方向由组件树 Directionality 控制） |
| `de` | `AntCalendarLocale` | 德语预设 |
| `en` | `AntCalendarLocale` | 英语预设 |
| `es` | `AntCalendarLocale` | 西班牙语预设 |
| `fr` | `AntCalendarLocale` | 法语预设 |
| `id` | `AntCalendarLocale` | 印尼语预设 |
| `it` | `AntCalendarLocale` | 意大利语预设 |
| `ja` | `AntCalendarLocale` | 日语预设 |
| `ko` | `AntCalendarLocale` | 韩语预设 |
| `pt` | `AntCalendarLocale` | 葡萄牙语预设 |
| `ru` | `AntCalendarLocale` | 俄语预设 |
| `th` | `AntCalendarLocale` | 泰语预设 |
| `vi` | `AntCalendarLocale` | 越南语预设 |
| `zh` | `AntCalendarLocale` | 中文（简体）预设 — 默认，向后兼容既有文案 |
| `zhTw` | `AntCalendarLocale` | 中文（繁体）预设 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `effectiveCancelText` | `String` | 生效的取消文案 |
| `effectiveConfirmText` | `String` | 生效的确认文案 |
| `effectiveModeMonthText` | `String` | 生效的「月」面板模式标签 |
| `effectiveModeYearText` | `String` | 生效的「年」面板模式标签 |
| `effectiveMonthSuffix` | `String` | 生效的月份后缀 |
| `effectiveMonthTitlePattern` | `String` | 生效的月标题模板 |
| `effectiveTodayText` | `String` | 生效的「本月」文案 |
| `effectiveWeekLabels` | `List<String>` | 生效的周标签（自周一起始） |
| `effectiveYearSuffix` | `String` | 生效的年份后缀 |
| `hashCode` | `int` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `==` | `bool` | — |
| `monthLabel` | `String` | 年月跳转滚轮列月份文案（如「6月」） |
| `monthTitle` | `String` | 头部年月标题（模板占位符替换） |
| `text` | `String` | 读取自定义扩展文案，key 不存在时返回 fallbackText（默认 key 本身） |
| `weekLabelsFor` | `List<String>` | 按周起始约定返回周标签序列（周日起始时把周一标签轮转到末位） |
| `yearLabel` | `String` | 年月跳转滚轮列文案（如「2024年」「6月」） |
| `_listEquals` | `bool` | — |
| `fromLanguageCode` | `AntCalendarLocale` | 按语言码解析内建预设（大小写不敏感，支持 zhCN / zh-Hans 等分隔写法） |
| `maybeOf` | `AntCalendarLocale?` | 从组件树读取注入的 locale |
| `of` | `AntCalendarLocale` | 从组件树读取注入的 locale |

