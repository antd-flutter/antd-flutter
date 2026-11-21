<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTreeSelect

> 种类：类

```dart
class AntTreeSelect
```

树选择组件。

类似 Select 的下拉，但选项为树形结构。

## 构造函数

### `AntTreeSelect({super.key, this.treeData = const [], this.value, this.defaultValue, this.onChange, this.placeholder, this.disabled = false, this.allowClear = false, this.treeDefaultExpandAll = false, this.multiple = false, this.size = AntTreeSelectSize.middle, this.height, this.width, this.dropdownHeight})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `treeData` | `List<AntTreeSelectOption>` | = const [] | — |
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
| `defaultValue` | `Object?` | 非受控默认值 |
| `disabled` | `bool` | 是否禁用 |
| `dropdownHeight` | `double?` | 下拉面板最大高度（逻辑像素） |
| `height` | `double?` | 触发器自定义高度（逻辑像素），设置后覆盖 size 对应高度 |
| `multiple` | `bool` | 多选模式 |
| `onChange` | `ValueChanged<Object?>?` | 值变化回调 |
| `placeholder` | `String?` | 占位文本 |
| `size` | `AntTreeSelectSize` | 尺寸 |
| `treeData` | `List<AntTreeSelectOption>` | 树节点数据 |
| `treeDefaultExpandAll` | `bool` | 默认展开全部节点 |
| `value` | `Object?` | 受控值（单选 String / 多选 List<String>） |
| `width` | `double?` | 触发器自定义宽度（逻辑像素） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntTreeSelect>` | — |

