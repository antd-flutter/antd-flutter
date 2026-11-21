<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntRefreshStrings

> 种类：类

```dart
class AntRefreshStrings
```

下拉刷新组件各阶段文案集合。

全部字段非空；内置各语言实例经 `AntRefreshStrings.resolve` 解析，
自定义覆写可基于 `AntRefreshStrings.copyWith` 修改个别字段。

## 构造函数

### `AntRefreshStrings({required this.pullingText, required this.releasingText, required this.finishingText, required this.completeText})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `pullingText` | `String` | 可选 | — |
| `releasingText` | `String` | 可选 | — |
| `finishingText` | `String` | 可选 | — |
| `completeText` | `String` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `completeText` | `String` | 刷新完成文案 |
| `finishingText` | `String` | 刷新中文案（伴随转圈显示） |
| `pullingText` | `String` | 下拉中（未达阈值）文案 |
| `releasingText` | `String` | 达到阈值释放即刷新文案 |
| `ar` | `AntRefreshStrings` | 阿拉伯语（RTL 语言，仅文案，不做镜像布局处理） |
| `builtIn` | `Map<String, AntRefreshStrings>` | 内置语言码 → 文案映射（zh 为默认回退） |
| `de` | `AntRefreshStrings` | 德语 |
| `en` | `AntRefreshStrings` | 英语 |
| `es` | `AntRefreshStrings` | 西班牙语 |
| `fr` | `AntRefreshStrings` | 法语 |
| `it` | `AntRefreshStrings` | 意大利语 |
| `ja` | `AntRefreshStrings` | 日语 |
| `ko` | `AntRefreshStrings` | 韩语 |
| `pt` | `AntRefreshStrings` | 葡萄牙语 |
| `ru` | `AntRefreshStrings` | 俄语 |
| `zh` | `AntRefreshStrings` | 中文（默认） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `copyWith` | `AntRefreshStrings` | 覆写个别字段，未指定的字段沿用当前实例 |
| `of` | `AntRefreshStrings` | 按 Locale 解析内置文案 |
| `resolve` | `AntRefreshStrings` | 按语言码解析内置文案 |
| `supportedLanguageCodes` | `List<String>` | 内置支持的语言码列表 |

