<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTableCellSpan

> 种类：类

```dart
class AntTableCellSpan
```

单元格合并配置（对齐 antd React `onCell` 返回的 rowSpan / colSpan）。

## 构造函数

### `AntTableCellSpan({this.rowSpan, this.colSpan})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `rowSpan` | `int?` | 可选 | — |
| `colSpan` | `int?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `colSpan` | `int?` | 横向合并列数 |
| `rowSpan` | `int?` | 纵向合并行数（0 表示该单元格不渲染） |

