<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntStatistic

> 种类：类

```dart
class AntStatistic
```

统计数值 — 展示统计数值。

对齐 antd React Statistic 组件。

## 构造函数

### `AntStatistic({super.key, this.title, this.value, this.valueString, this.precision, this.prefix, this.suffix, this.valueStyle, this.decimalStyle, this.groupSeparator = ',', this.loading = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `title` | `String?` | 可选 | — |
| `value` | `num?` | 可选 | — |
| `valueString` | `String?` | 可选 | — |
| `precision` | `int?` | 可选 | — |
| `prefix` | `Widget?` | 可选 | — |
| `suffix` | `Widget?` | 可选 | — |
| `valueStyle` | `TextStyle?` | 可选 | — |
| `decimalStyle` | `TextStyle?` | 可选 | — |
| `groupSeparator` | `String` | = ',' | — |
| `loading` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `decimalStyle` | `TextStyle?` | 小数部分独立样式（小数点后的数字） |
| `groupSeparator` | `String` | 千分位分隔符 |
| `loading` | `bool` | 是否加载中 |
| `precision` | `int?` | 小数位数 |
| `prefix` | `Widget?` | 前缀 |
| `suffix` | `Widget?` | 后缀 |
| `title` | `String?` | 标题 |
| `value` | `num?` | 数值 |
| `valueString` | `String?` | 字符串值（优先于 value） |
| `valueStyle` | `TextStyle?` | 数值样式 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_buildSkeleton` | `Widget` | — |
| `_formatValue` | `String` | — |
| `build` | `Widget` | — |
| `buildValueSpans` | `List<InlineSpan>` | 格式化数值为字符串 |

