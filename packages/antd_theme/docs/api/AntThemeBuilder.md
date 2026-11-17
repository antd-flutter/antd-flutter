<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntThemeBuilder

> 种类：类

```dart
class AntThemeBuilder
```

一个便捷的 Builder，在 build 时提供 `AntThemeData`。

```dart
AntThemeBuilder(builder: (context, theme) {
  return Text('Hello', style: theme.font.body1);
})
```

## 构造函数

### `AntThemeBuilder({super.key, required this.builder})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `builder` | `Widget Function(BuildContext context, AntThemeData theme)` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `builder` | `Widget Function(BuildContext context, AntThemeData theme)` | 构建回调 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

