<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTableSummaryCell

> 种类：类

```dart
class AntTableSummaryCell
```

汇总行单元格。

## 构造函数

### `AntTableSummaryCell({required this.columnIndex, this.colSpan = 1, required this.child})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `columnIndex` | `int` | 可选 | — |
| `colSpan` | `int` | = 1 | — |
| `child` | `Widget` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget` | 单元格内容 |
| `colSpan` | `int` | 横向合并列数 |
| `columnIndex` | `int` | 对应叶子列下标（按 columns 展开后的叶子顺序） |

