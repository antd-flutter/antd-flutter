<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCascader

> 种类：类

```dart
class AntCascader
```

级联选择组件。

从一组关联层级数据中进行选择，如省/市/区。

## 构造函数

### `AntCascader({super.key, required this.keyOf, this.dataSource = const [], this.childrenOf, this.labelBuilder, this.disabledOf, this.value, this.defaultValue, this.onChange, this.placeholder, this.disabled = false, this.allowClear = false, this.changeOnSelect = false, this.size = AntCascaderSize.middle, this.expandTrigger = AntCascaderExpandTrigger.click})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `keyOf` | `AntCascaderKeyOf<T>` | 可选 | — |
| `dataSource` | `List<T>` | = const [] | — |
| `childrenOf` | `AntCascaderChildrenOf<T>?` | 可选 | — |
| `labelBuilder` | `AntCascaderLabelBuilder<T>?` | 可选 | — |
| `disabledOf` | `AntCascaderDisabledOf<T>?` | 可选 | — |
| `value` | `List<Object>?` | 可选 | — |
| `defaultValue` | `List<Object>?` | 可选 | — |
| `onChange` | `ValueChanged<List<T>>?` | 可选 | — |
| `placeholder` | `String?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `allowClear` | `bool` | = false | — |
| `changeOnSelect` | `bool` | = false | — |
| `size` | `AntCascaderSize` | = AntCascaderSize.middle | — |
| `expandTrigger` | `AntCascaderExpandTrigger` | = AntCascaderExpandTrigger.click | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `allowClear` | `bool` | 是否显示清除按钮 |
| `changeOnSelect` | `bool` | 允许选择任意层级（否则仅叶子节点触发 onChange） |
| `childrenOf` | `AntCascaderChildrenOf<T>?` | 从模型取子节点 |
| `dataSource` | `List<T>` | 级联选项树 |
| `defaultValue` | `List<Object>?` | 非受控默认值（路径数组，元素可为 T 或 key） |
| `disabled` | `bool` | 是否禁用 |
| `disabledOf` | `AntCascaderDisabledOf<T>?` | 选项禁用判断 |
| `expandTrigger` | `AntCascaderExpandTrigger` | 次级菜单展开触发方式 |
| `keyOf` | `AntCascaderKeyOf<T>` | 从模型取唯一标识 |
| `labelBuilder` | `AntCascaderLabelBuilder<T>?` | 选项自定义渲染 |
| `onChange` | `ValueChanged<List<T>>?` | 值变化回调（返回选中的模型路径） |
| `placeholder` | `String?` | 占位文本 |
| `size` | `AntCascaderSize` | 尺寸 |
| `value` | `List<Object>?` | 受控值（路径数组，元素可为 T 或 key） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntCascader<T>>` | — |

