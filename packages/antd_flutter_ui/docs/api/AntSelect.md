<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSelect

> 种类：类

```dart
class AntSelect
```

选择器 — 下拉选择器，支持单选、多选与搜索。

对齐 antd React Select 组件。

## 构造函数

### `AntSelect({super.key, this.mode = AntSelectMode.single, this.value, this.defaultValue, this.options = const [], this.onChange, this.showSearch = false, this.allowClear = false, this.placeholder, this.disabled = false, this.loading = false, this.size = AntSelectSize.middle, this.autofocus = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `mode` | `AntSelectMode` | = AntSelectMode.single | — |
| `value` | `Object?` | 可选 | — |
| `defaultValue` | `Object?` | 可选 | — |
| `options` | `List<AntSelectOption<T>>` | = const [] | — |
| `onChange` | `ValueChanged<Object?>?` | 可选 | — |
| `showSearch` | `bool` | = false | — |
| `allowClear` | `bool` | = false | — |
| `placeholder` | `String?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `loading` | `bool` | = false | — |
| `size` | `AntSelectSize` | = AntSelectSize.middle | — |
| `autofocus` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `allowClear` | `bool` | 是否允许清除 |
| `autofocus` | `bool` | 是否自动聚焦 |
| `defaultValue` | `Object?` | 非受控初始值 |
| `disabled` | `bool` | 是否禁用 |
| `loading` | `bool` | 是否加载中 |
| `mode` | `AntSelectMode` | 选择模式 |
| `onChange` | `ValueChanged<Object?>?` | 选中变化回调 |
| `options` | `List<AntSelectOption<T>>` | 选项列表 |
| `placeholder` | `String?` | 占位文本 |
| `showSearch` | `bool` | 是否可搜索 |
| `size` | `AntSelectSize` | 尺寸 |
| `value` | `Object?` | 受控选中值（单选为 T?，多选为 List<T>?） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntSelect<T>>` | — |

