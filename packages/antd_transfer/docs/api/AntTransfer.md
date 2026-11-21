<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTransfer

> 种类：类

```dart
class AntTransfer
```

穿梭框（泛型数据源）。

## 构造函数

### `AntTransfer({super.key, required this.dataSource, required this.keyOf, this.titleBuilder, this.descriptionOf, this.childrenOf, this.disabledOf, this.searchTextOf, this.targetKeys, this.defaultTargetKeys = const <Object>[], this.selectedKeys, this.defaultSelectedKeys = const <Object>[], this.onChange, this.onSelectChange, this.titles = const ['Source', 'Target'], this.operations = const ['', ''], this.disabled = false, this.showSearch = false, this.oneWay = false, this.filterOption, this.height, this.defaultExpandAll = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `dataSource` | `List<T>` | 可选 | — |
| `keyOf` | `AntTransferKeyOf<T>` | 可选 | — |
| `titleBuilder` | `AntTransferTitleBuilder<T>?` | 可选 | — |
| `descriptionOf` | `AntTransferDescriptionOf<T>?` | 可选 | — |
| `childrenOf` | `AntTransferChildrenOf<T>?` | 可选 | — |
| `disabledOf` | `AntTransferDisabledOf<T>?` | 可选 | — |
| `searchTextOf` | `AntTransferSearchTextOf<T>?` | 可选 | — |
| `targetKeys` | `List<Object>?` | 可选 | — |
| `defaultTargetKeys` | `List<Object>` | = const <Object>[] | — |
| `selectedKeys` | `List<Object>?` | 可选 | — |
| `defaultSelectedKeys` | `List<Object>` | = const <Object>[] | — |
| `onChange` | `AntTransferOnChange?` | 可选 | — |
| `onSelectChange` | `AntTransferOnSelectChange?` | 可选 | — |
| `titles` | `List<String>` | = const ['Source', 'Target'] | — |
| `operations` | `List<String>` | = const ['', ''] | — |
| `disabled` | `bool` | = false | — |
| `showSearch` | `bool` | = false | — |
| `oneWay` | `bool` | = false | — |
| `filterOption` | `bool Function(String inputValue, T item)?` | 可选 | — |
| `height` | `double?` | 可选 | — |
| `defaultExpandAll` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `childrenOf` | `AntTransferChildrenOf<T>?` | 读取子节点 |
| `dataSource` | `List<T>` | 数据源，包含全部数据项（提供 childrenOf 且返回非空时为树形模式） |
| `defaultExpandAll` | `bool` | 树形模式：是否默认展开全部节点，默认 false |
| `defaultSelectedKeys` | `List<Object>` | 非受控：已选中项的 key 列表初始值 |
| `defaultTargetKeys` | `List<Object>` | 非受控：右侧面板项的 key 列表初始值 |
| `descriptionOf` | `AntTransferDescriptionOf<T>?` | 行描述文本 |
| `disabled` | `bool` | 是否整体禁用 |
| `disabledOf` | `AntTransferDisabledOf<T>?` | 判断数据项是否禁用 |
| `filterOption` | `bool Function(String inputValue, T item)?` | 自定义搜索过滤函数，返回 true 表示保留 |
| `height` | `double?` | 列表区域高度 |
| `keyOf` | `AntTransferKeyOf<T>` | 从数据项提取唯一 key |
| `onChange` | `AntTransferOnChange?` | 项在两面板间移动后的回调 |
| `onSelectChange` | `AntTransferOnSelectChange?` | 选中项变化时的回调 |
| `oneWay` | `bool` | 是否为单向模式（仅可移至右侧，不可移回） |
| `operations` | `List<String>` | 中间操作按钮文案，默认 '', ''（使用箭头图标） |
| `searchTextOf` | `AntTransferSearchTextOf<T>?` | 默认搜索使用的纯文本 |
| `selectedKeys` | `List<Object>?` | 受控：已选中项的 key 列表（树模式下仅包含叶子节点 key） |
| `showSearch` | `bool` | 是否显示搜索框 |
| `targetKeys` | `List<Object>?` | 受控：右侧面板项的 key 列表 |
| `titleBuilder` | `AntTransferTitleBuilder<T>?` | 行标题构建器 |
| `titles` | `List<String>` | 左右面板标题，默认 'Source', 'Target' |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntTransfer<T>>` | — |

