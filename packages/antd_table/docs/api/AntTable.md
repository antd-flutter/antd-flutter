<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTable

> 种类：类

```dart
class AntTable
```

表格 — 展示行列数据。

对齐 antd React Table 组件核心 + 高级 API。

## 构造函数

### `AntTable({super.key, required this.columns, required this.dataSource, this.rowKey, this.scrollX, this.scrollY, this.pagination = false, this.pageSize = 10, this.size = AntTableSize.middle, this.bordered = false, this.loading = false, this.empty, this.rowSelection, this.expandedRowRender, this.defaultExpandAllRows = false, this.expandedRowKeys, this.onExpandedRowsChange, this.expandRowByClick = false, this.summary, this.onSortChange, this.onFilterChange, this.onPageChange})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `columns` | `List<AntTableColumn>` | 可选 | — |
| `dataSource` | `List<Map<String, dynamic>>` | 可选 | — |
| `rowKey` | `AntTableRowKeyFn?` | 可选 | — |
| `scrollX` | `double?` | 可选 | — |
| `scrollY` | `double?` | 可选 | — |
| `pagination` | `bool` | = false | — |
| `pageSize` | `int` | = 10 | — |
| `size` | `AntTableSize` | = AntTableSize.middle | — |
| `bordered` | `bool` | = false | — |
| `loading` | `bool` | = false | — |
| `empty` | `Widget?` | 可选 | — |
| `rowSelection` | `AntTableRowSelection?` | 可选 | — |
| `expandedRowRender` | `Widget? Function(Map<String, dynamic> record, int index)?` | 可选 | — |
| `defaultExpandAllRows` | `bool` | = false | — |
| `expandedRowKeys` | `List<Object>?` | 可选 | — |
| `onExpandedRowsChange` | `AntTableExpandChangeFn?` | 可选 | — |
| `expandRowByClick` | `bool` | = false | — |
| `summary` | `AntTableSummaryFn?` | 可选 | — |
| `onSortChange` | `AntTableSortChangeFn?` | 可选 | — |
| `onFilterChange` | `AntTableFilterChangeFn?` | 可选 | — |
| `onPageChange` | `void Function(int page, int pageSize)?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `bordered` | `bool` | 是否显示边框 |
| `columns` | `List<AntTableColumn>` | 列定义 |
| `dataSource` | `List<Map<String, dynamic>>` | 数据源（行记录为 Map<String, dynamic>，支持 children 树形数据） |
| `defaultExpandAllRows` | `bool` | 是否默认展开全部树形行 |
| `empty` | `Widget?` | 空数据占位（默认展示「暂无数据」） |
| `expandRowByClick` | `bool` | 点击行时切换展开态 |
| `expandedRowKeys` | `List<Object>?` | 受控展开行 key 集合（非 null 时展开由外部控制） |
| `expandedRowRender` | `Widget? Function(Map<String, dynamic> record, int index)?` | 展开行内容构建（非 null 时行首叶子列出现展开图标） |
| `loading` | `bool` | 是否显示加载遮罩 |
| `onExpandedRowsChange` | `AntTableExpandChangeFn?` | 展开行变化回调 |
| `onFilterChange` | `AntTableFilterChangeFn?` | 筛选变化回调（filteredValue 为 null 表示已重置） |
| `onPageChange` | `void Function(int page, int pageSize)?` | 分页变化回调 |
| `onSortChange` | `AntTableSortChangeFn?` | 排序变化回调（leafIndex 为叶子列序号，order 为 null 表示取消排序） |
| `pageSize` | `int` | 每页行数 |
| `pagination` | `bool` | 是否分页 |
| `rowKey` | `AntTableRowKeyFn?` | 行 key 提取函数（默认取 id 字段，缺省用行下标） |
| `rowSelection` | `AntTableRowSelection?` | 行选择配置 |
| `scrollX` | `double?` | 横向滚动内容宽度（大于可用宽度时出现横向滚动，固定列吸边） |
| `scrollY` | `double?` | 纵向滚动区域高度 |
| `size` | `AntTableSize` | 表格尺寸 |
| `summary` | `AntTableSummaryFn?` | 汇总行构建（对齐 antd summary） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntTable>` | — |

