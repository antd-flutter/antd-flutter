<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntConfigProvider

> 种类：类

```dart
class AntConfigProvider
```

全局化配置入口 — 为组件树注入主题 / 国际化 / 文本方向。

对齐 antd React ConfigProvider 组件。

## 构造函数

### `AntConfigProvider({super.key, this.antdTheme, this.locale, this.direction, required this.child})`

创建 AntConfigProvider。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `antdTheme` | `AntThemeData?` | 可选 | — |
| `locale` | `AntConfigLocale?` | 可选 | — |
| `direction` | `AntConfigDirection?` | 可选 | — |
| `child` | `Widget` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `antdTheme` | `AntThemeData?` | 注入的主题数据 |
| `child` | `Widget` | 被包裹的组件树 |
| `direction` | `AntConfigDirection?` | 文本方向 |
| `locale` | `AntConfigLocale?` | 国际化配置 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |
| `of` | `AntConfigData` | 获取最近祖先 AntConfigProvider 的配置 |

