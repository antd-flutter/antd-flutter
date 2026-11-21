<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntConfigLocale

> 种类：类

```dart
class AntConfigLocale
```

AntConfigProvider 国际化配置。

由语言码 + 自定义文案 Map 组成，`messages` 作为文案扩展位，
组件可通过 `locale.messages['key']` 读取自定义文案。

## 构造函数

### `AntConfigLocale({required this.languageCode, this.messages = const {}})`

创建国际化配置。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `languageCode` | `String` | 可选 | — |
| `messages` | `Map<String, String>` | = const {} | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `languageCode` | `String` | 语言码，如 zh、en、zh-CN |
| `messages` | `Map<String, String>` | 自定义文案表（key → 文案） |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `hashCode` | `int` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `==` | `bool` | — |
| `text` | `String` | 读取文案，key 不存在时返回 fallback（默认为 key 本身） |
| `_mapEquals` | `bool` | — |

