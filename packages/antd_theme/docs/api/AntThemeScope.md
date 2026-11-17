<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntThemeScope

> 种类：类

```dart
class AntThemeScope
```

`AntTheme` 内部的 InheritedWidget，负责 `AntThemeData` 的就近读取与
数据变更通知（data 不相等时通知依赖方重建）。

## 构造函数

### `AntThemeScope({super.key, required this.data, required super.child})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `data` | `AntThemeData` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `data` | `AntThemeData` | 当前主题数据 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `updateShouldNotify` | `bool` | — |

