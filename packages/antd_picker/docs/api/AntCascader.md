<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCascader

> 种类：类

```dart
class AntCascader
```

级联选择组件。

从一组关联层级数据中进行选择，如省/市/区。

## 构造函数

### `AntCascader({super.key, this.options = const [], this.value, this.defaultValue, this.onChange, this.placeholder, this.disabled = false, this.allowClear = false, this.changeOnSelect = false, this.size = AntCascaderSize.middle, this.expandTrigger = AntCascaderExpandTrigger.click})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `options` | `List<AntCascaderOption>` | = const [] | — |
| `value` | `List<String>?` | 可选 | — |
| `defaultValue` | `List<String>?` | 可选 | — |
| `onChange` | `ValueChanged<List<String>>?` | 可选 | — |
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
| `defaultValue` | `List<String>?` | 非受控默认值 |
| `disabled` | `bool` | 是否禁用 |
| `expandTrigger` | `AntCascaderExpandTrigger` | 次级菜单展开触发方式 |
| `onChange` | `ValueChanged<List<String>>?` | 值变化回调 |
| `options` | `List<AntCascaderOption>` | 级联选项树 |
| `placeholder` | `String?` | 占位文本 |
| `size` | `AntCascaderSize` | 尺寸 |
| `value` | `List<String>?` | 受控值（路径数组，如 'zj', 'hz', 'xh'） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntCascader>` | — |

