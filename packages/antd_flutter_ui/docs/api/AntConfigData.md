<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntConfigData

> 种类：类

```dart
class AntConfigData
```

AntConfigProvider 注入的配置数据。

## 构造函数

### `AntConfigData({this.antdTheme, this.locale, this.direction = AntConfigDirection.ltr})`

创建配置快照。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `antdTheme` | `AntThemeData?` | 可选 | — |
| `locale` | `AntConfigLocale?` | 可选 | — |
| `direction` | `AntConfigDirection` | = AntConfigDirection.ltr | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `antdTheme` | `AntThemeData?` | 主题数据 |
| `direction` | `AntConfigDirection` | 文本方向，默认 ltr |
| `locale` | `AntConfigLocale?` | 国际化配置 |
| `fallback` | `AntConfigData` | 无 Provider 时的默认配置 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `text` | `String` | 便捷读取：文案（无 locale 时回退 key） |

