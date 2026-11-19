<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTransfer

> 种类：类

```dart
class AntTransfer
```

穿梭框

## 构造函数

### `AntTransfer({super.key, required this.dataSource, this.targetKeys, this.defaultTargetKeys = const [], this.selectedKeys, this.defaultSelectedKeys = const [], this.onChange, this.onSelectChange, this.titles = const ['Source', 'Target'], this.operations = const ['', ''], this.disabled = false, this.showSearch = false, this.oneWay = false, this.filterOption, this.height, this.defaultExpandAll = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `dataSource` | `List<AntTransferItem>` | 可选 | — |
| `targetKeys` | `List<String>?` | 可选 | — |
| `defaultTargetKeys` | `List<String>` | = const [] | — |
| `selectedKeys` | `List<String>?` | 可选 | — |
| `defaultSelectedKeys` | `List<String>` | = const [] | — |
| `onChange` | `void Function(List<String> targetKeys, AntTransferDirection direction, List<String> moveKeys)?` | 可选 | — |
| `onSelectChange` | `void Function(List<String> sourceSelectedKeys, List<String> targetSelectedKeys)?` | 可选 | — |
| `titles` | `List<String>` | = const ['Source', 'Target'] | — |
| `operations` | `List<String>` | = const ['', ''] | — |
| `disabled` | `bool` | = false | — |
| `showSearch` | `bool` | = false | — |
| `oneWay` | `bool` | = false | — |
| `filterOption` | `bool Function(String inputValue, AntTransferItem item)?` | 可选 | — |
| `height` | `double?` | 可选 | — |
| `defaultExpandAll` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `dataSource` | `List<AntTransferItem>` | 数据源，包含全部数据项（含 children 时为树形模式） |
| `defaultExpandAll` | `bool` | 树形模式：是否默认展开全部节点，默认 false |
| `defaultSelectedKeys` | `List<String>` | 非受控：已选中项的 key 列表初始值 |
| `defaultTargetKeys` | `List<String>` | 非受控：右侧面板项的 key 列表初始值 |
| `disabled` | `bool` | 是否整体禁用 |
| `filterOption` | `bool Function(String inputValue, AntTransferItem item)?` | 自定义搜索过滤函数，返回 true 表示保留 |
| `height` | `double?` | 列表区域高度 |
| `onChange` | `void Function(List<String> targetKeys, AntTransferDirection direction, List<String> moveKeys)?` | 项在两面板间移动后的回调 参数依次为：移动后的 targetKeys、移动方向、被移动的 keys |
| `onSelectChange` | `void Function(List<String> sourceSelectedKeys, List<String> targetSelectedKeys)?` | 选中项变化时的回调 参数依次为：源面板选中 keys、目标面板选中 keys |
| `oneWay` | `bool` | 是否为单向模式（仅可移至右侧，不可移回） |
| `operations` | `List<String>` | 中间操作按钮文案，默认 '', ''（使用箭头图标） |
| `selectedKeys` | `List<String>?` | 受控：已选中项的 key 列表（树模式下仅包含叶子节点 key） |
| `showSearch` | `bool` | 是否显示搜索框 |
| `targetKeys` | `List<String>?` | 受控：右侧面板项的 key 列表 |
| `titles` | `List<String>` | 左右面板标题，默认 'Source', 'Target' |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntTransfer>` | — |

