<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTreeSelect

> 种类：类

```dart
class AntTreeSelect
```

树选择组件（泛型数据源）。

类似 Select 的下拉，但选项为树形结构。受控/非受控的“值”都是
`keyOf` 从用户模型提取的 key：单选为单个 key，多选为 `List<Object>`。

## 构造函数

### `AntTreeSelect({super.key, this.dataSource = const <Never>[], this.keyOf, this.labelOf, this.titleBuilder, this.childrenOf, this.disabledOf, this.value, this.defaultValue, this.onChange, this.placeholder, this.disabled = false, this.allowClear = false, this.treeDefaultExpandAll = false, this.multiple = false, this.size = AntTreeSelectSize.middle, this.height, this.width, this.dropdownHeight})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `dataSource` | `List<T>` | = const <Never>[] | — |
| `keyOf` | `AntTreeSelectKeyOf<T>?` | 可选 | — |
| `labelOf` | `AntTreeSelectLabelOf<T>?` | 可选 | — |
| `titleBuilder` | `AntTreeSelectTitleBuilder<T>?` | 可选 | — |
| `childrenOf` | `AntTreeSelectChildrenOf<T>?` | 可选 | — |
| `disabledOf` | `AntTreeSelectDisabledOf<T>?` | 可选 | — |
| `value` | `Object?` | 可选 | — |
| `defaultValue` | `Object?` | 可选 | — |
| `onChange` | `ValueChanged<Object?>?` | 可选 | — |
| `placeholder` | `String?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `allowClear` | `bool` | = false | — |
| `treeDefaultExpandAll` | `bool` | = false | — |
| `multiple` | `bool` | = false | — |
| `size` | `AntTreeSelectSize` | = AntTreeSelectSize.middle | — |
| `height` | `double?` | 可选 | — |
| `width` | `double?` | 可选 | — |
| `dropdownHeight` | `double?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `allowClear` | `bool` | 是否显示清除按钮 |
| `childrenOf` | `AntTreeSelectChildrenOf<T>?` | 读取子节点 |
| `dataSource` | `List<T>` | 树节点数据（用户模型） |
| `defaultValue` | `Object?` | 非受控默认值 |
| `disabled` | `bool` | 是否禁用 |
| `disabledOf` | `AntTreeSelectDisabledOf<T>?` | 判断节点是否禁用 |
| `dropdownHeight` | `double?` | 下拉面板最大高度（逻辑像素） |
| `height` | `double?` | 触发器自定义高度（逻辑像素），设置后覆盖 size 对应高度 |
| `keyOf` | `AntTreeSelectKeyOf<T>?` | 从数据项提取唯一 key |
| `labelOf` | `AntTreeSelectLabelOf<T>?` | 触发器展示用的纯文本标签 |
| `multiple` | `bool` | 多选模式 |
| `onChange` | `ValueChanged<Object?>?` | 值变化回调（单选 key / 多选 List<Object>） |
| `placeholder` | `String?` | 占位文本 |
| `size` | `AntTreeSelectSize` | 尺寸 |
| `titleBuilder` | `AntTreeSelectTitleBuilder<T>?` | 下拉行标题构建器 |
| `treeDefaultExpandAll` | `bool` | 默认展开全部节点 |
| `value` | `Object?` | 受控值（单选 key / 多选 List<Object>） |
| `width` | `double?` | 触发器自定义宽度（逻辑像素） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntTreeSelect<T>>` | — |

