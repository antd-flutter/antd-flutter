<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTableColumn

> 种类：类

```dart
class AntTableColumn
```

列定义。

对齐 antd React Table `ColumnType` 核心 API。

## 构造函数

### `AntTableColumn({required this.title, this.dataIndex, this.width, this.fixed, this.align = AntTableAlign.left, this.sorter, this.filters, this.onFilter, this.render, this.ellipsis = false, this.children, this.defaultSortOrder, this.sortOrder, this.sortDirections = const [AntTableSortOrder.ascend, AntTableSortOrder.descend], this.sortPriority, this.defaultFilteredValue, this.filteredValue, this.filterMultiple = true, this.onCell})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `title` | `String` | 可选 | — |
| `dataIndex` | `String?` | 可选 | — |
| `width` | `double?` | 可选 | — |
| `fixed` | `AntTableFixed?` | 可选 | — |
| `align` | `AntTableAlign` | = AntTableAlign.left | — |
| `sorter` | `AntTableSorter?` | 可选 | — |
| `filters` | `List<AntTableFilterItem>?` | 可选 | — |
| `onFilter` | `AntTableFilterFn?` | 可选 | — |
| `render` | `AntTableRenderFn?` | 可选 | — |
| `ellipsis` | `bool` | = false | — |
| `children` | `List<AntTableColumn>?` | 可选 | — |
| `defaultSortOrder` | `AntTableSortOrder?` | 可选 | — |
| `sortOrder` | `AntTableSortOrder?` | 可选 | — |
| `sortDirections` | `List<AntTableSortOrder>` | = const [AntTableSortOrder.ascend, AntTableSortOrder.descend] | — |
| `sortPriority` | `int?` | 可选 | — |
| `defaultFilteredValue` | `List<Object>?` | 可选 | — |
| `filteredValue` | `List<Object>?` | 可选 | — |
| `filterMultiple` | `bool` | = true | — |
| `onCell` | `AntTableCellSpanFn?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `align` | `AntTableAlign` | 对齐方式 |
| `children` | `List<AntTableColumn>?` | 子列（非空时本列为表头分组列，展开为多级表头 |
| `dataIndex` | `String?` | 列数据在记录中的字段名 |
| `defaultFilteredValue` | `List<Object>?` | 非受控初始筛选值 |
| `defaultSortOrder` | `AntTableSortOrder?` | 非受控初始排序方向 |
| `ellipsis` | `bool` | 超出宽度是否省略（单行 + ellipsis 截断） |
| `filterMultiple` | `bool` | 筛选面板是否多选（false 时为单选，对齐 antd filterMultiple） |
| `filteredValue` | `List<Object>?` | 受控筛选值（非 null 时筛选由外部控制，变更触发 AntTable.onFilterChange） |
| `filters` | `List<AntTableFilterItem>?` | 筛选项列表，传入后表头出现筛选图标 |
| `fixed` | `AntTableFixed?` | 固定列方向 |
| `onCell` | `AntTableCellSpanFn?` | 合并单元格配置（rowSpan / colSpan） |
| `onFilter` | `AntTableFilterFn?` | 过滤判定函数 |
| `render` | `AntTableRenderFn?` | 自定义单元格渲染 |
| `sortDirections` | `List<AntTableSortOrder>` | 点击表头的排序方向循环顺序 |
| `sortOrder` | `AntTableSortOrder?` | 受控排序方向（非 null 时排序由外部控制，点击触发 AntTable.onSortChange） |
| `sortPriority` | `int?` | 多列排序优先级（antd sorter.multiple |
| `sorter` | `AntTableSorter?` | 排序比较函数，传入后表头可点击排序（升序 → 降序 → 取消） |
| `title` | `String` | 列头文本 |
| `width` | `double?` | 列宽（设计稿逻辑像素，内部按 .w 缩放 |

