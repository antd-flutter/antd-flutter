<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTheme

> 种类：类

```dart
class AntTheme
```

AntTheme 主题注入 Widget。

职责：
1. 通过 `AntThemeScope`（InheritedWidget）注入 `AntThemeData`，
   后代通过 `AntTheme.of` 就近读取；
2. 自动将 antd 主题转换为 Flutter `ThemeData` 并注入 `Theme`，
   后代的 `Theme.of(context)` 即可取到 antd 派生的 Material 主题，
   原生 Material 控件自动呈现 antd 风格（包裹即覆盖，无开关参数）。

```dart
AntTheme(
  data: AntThemeData.light(),
  child: MaterialApp(theme: ..., home: ...),
)
```

## 构造函数

### `AntTheme({super.key, required this.data, required this.child})`

创建一个 AntTheme

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `data` | `AntThemeData` | 可选 | — |
| `child` | `Widget` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget` | 子组件 |
| `data` | `AntThemeData` | 当前主题数据 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |
| `of` | `AntThemeData` | 获取最近祖先 AntTheme 中的主题数据 |

