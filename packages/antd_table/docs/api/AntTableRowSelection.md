<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTableRowSelection

> 种类：类

```dart
class AntTableRowSelection
```

行选择配置（对齐 antd `rowSelection`）。

## 构造函数

### `AntTableRowSelection({this.selectedRowKeys, this.defaultSelectedRowKeys, this.onChange, this.getCheckboxProps, this.selections, this.columnWidth = 48, this.fixed = false, this.checkStrictly = false, this.hideSelectAll = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `selectedRowKeys` | `List<Object>?` | 可选 | — |
| `defaultSelectedRowKeys` | `List<Object>?` | 可选 | — |
| `onChange` | `ValueChanged<List<Object>>?` | 可选 | — |
| `getCheckboxProps` | `AntTableRowCheckboxProps Function(Map<String, dynamic> record)?` | 可选 | — |
| `selections` | `List<AntTableRowSelectionItem>?` | 可选 | — |
| `columnWidth` | `double` | = 48 | — |
| `fixed` | `bool` | = false | — |
| `checkStrictly` | `bool` | = false | — |
| `hideSelectAll` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `checkStrictly` | `bool` | 父子行选中是否不关联（antd checkStrictly |
| `columnWidth` | `double` | 选择列宽度 |
| `defaultSelectedRowKeys` | `List<Object>?` | 非受控初始选中行 key 集合 |
| `fixed` | `bool` | 选择列是否固定在左侧 |
| `getCheckboxProps` | `AntTableRowCheckboxProps Function(Map<String, dynamic> record)?` | 行复选框属性（禁用等） |
| `hideSelectAll` | `bool` | 是否隐藏表头全选框 |
| `onChange` | `ValueChanged<List<Object>>?` | 选中项变化回调 |
| `selectedRowKeys` | `List<Object>?` | 受控选中行 key 集合（非 null 时进入受控模式） |
| `selections` | `List<AntTableRowSelectionItem>?` | 自定义选择项（表头复选框旁出现下拉菜单） |

