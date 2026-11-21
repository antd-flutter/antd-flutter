<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCascaderView

> 种类：类

```dart
class AntCascaderView
```

级联选择视图。

以 Tab + 选项列表的形式逐级选择关联层级数据，
选择某项后自动展开下一层级。

## 构造函数

### `AntCascaderView({super.key, required this.keyOf, this.dataSource = const [], this.childrenOf, this.labelBuilder, this.disabledOf, this.value, this.defaultValue = const [], this.onChange, this.placeholder = '请选择', this.onTabsChange, this.activeIcon, this.height})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `keyOf` | `AntCascaderKeyOf<T>` | 可选 | — |
| `dataSource` | `List<T>` | = const [] | — |
| `childrenOf` | `AntCascaderChildrenOf<T>?` | 可选 | — |
| `labelBuilder` | `AntCascaderLabelBuilder<T>?` | 可选 | — |
| `disabledOf` | `AntCascaderDisabledOf<T>?` | 可选 | — |
| `value` | `List<Object>?` | 可选 | — |
| `defaultValue` | `List<Object>` | = const [] | — |
| `onChange` | `AntCascaderViewOnChange<T>?` | 可选 | — |
| `placeholder` | `String` | = '请选择' | — |
| `onTabsChange` | `ValueChanged<int>?` | 可选 | — |
| `activeIcon` | `Widget?` | 可选 | — |
| `height` | `double?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `activeIcon` | `Widget?` | 自定义选中图标 |
| `childrenOf` | `AntCascaderChildrenOf<T>?` | 从模型取子节点 |
| `dataSource` | `List<T>` | 级联选项树 |
| `defaultValue` | `List<Object>` | 非受控默认值（路径数组，元素可为 T 或 key） |
| `disabledOf` | `AntCascaderDisabledOf<T>?` | 选项禁用判断 |
| `height` | `double?` | 内容区高度 |
| `keyOf` | `AntCascaderKeyOf<T>` | 从模型取唯一标识 |
| `labelBuilder` | `AntCascaderLabelBuilder<T>?` | 选项自定义渲染 |
| `onChange` | `AntCascaderViewOnChange<T>?` | 值变化回调，附带逐层已选模型（未选层级为 null） |
| `onTabsChange` | `ValueChanged<int>?` | 切换层级 Tab 回调 |
| `placeholder` | `String` | 未选择层级的占位文本 |
| `value` | `List<Object>?` | 受控值（路径数组，元素可为 T 或 key） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntCascaderView<T>>` | — |

