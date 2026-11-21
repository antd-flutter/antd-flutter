<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPickerColumn

> 种类：类

```dart
class AntPickerColumn
```

单列滚轮数据（泛型）。

一列滚轮直接吃使用者的模型 `T`：

```dart
AntPickerColumn<Season>(
  dataSource: seasons,
  keyOf: (s) => s.id,
  labelBuilder: (context, s) => Text(s.name),
)
```

## 构造函数

### `AntPickerColumn({required this.dataSource, this.labelBuilder, this.keyOf})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `dataSource` | `List<T>` | 可选 | — |
| `labelBuilder` | `Widget Function(BuildContext context, T item)?` | 可选 | — |
| `keyOf` | `Object Function(T item)?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `dataSource` | `List<T>` | 列数据 |
| `keyOf` | `Object Function(T item)?` | 选项唯一标识 |
| `labelBuilder` | `Widget Function(BuildContext context, T item)?` | 选项自定义渲染 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `keyAt` | `Object` | 选项标识（缺省下标） |

