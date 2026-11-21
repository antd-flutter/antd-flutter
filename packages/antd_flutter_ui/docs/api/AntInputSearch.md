<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntInputSearch

> 种类：类

```dart
class AntInputSearch
```

搜索框 — 带搜索按钮的输入框。

对齐 antd React Input.Search，支持 enterButton、onSearch。

```dart
AntInputSearch(
  placeholder: '搜索',
  onSearch: (v) => print(v),
)
```

## 构造函数

### `AntInputSearch({super.key, this.value, this.defaultValue, this.onChange, this.onSearch, this.disabled = false, this.placeholder, this.enterButton = false, this.size = AntInputSize.middle, this.loading = false, this.controller, this.focusNode, this.autofocus = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `String?` | 可选 | — |
| `defaultValue` | `String?` | 可选 | — |
| `onChange` | `ValueChanged<String>?` | 可选 | — |
| `onSearch` | `ValueChanged<String>?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `placeholder` | `String?` | 可选 | — |
| `enterButton` | `dynamic` | = false | — |
| `size` | `AntInputSize` | = AntInputSize.middle | — |
| `loading` | `bool` | = false | — |
| `controller` | `TextEditingController?` | 可选 | — |
| `focusNode` | `FocusNode?` | 可选 | — |
| `autofocus` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `autofocus` | `bool` | 是否自动聚焦 |
| `controller` | `TextEditingController?` | 文本控制器 |
| `defaultValue` | `String?` | 非受控初始值 |
| `disabled` | `bool` | 是否禁用 |
| `enterButton` | `dynamic` | 是否将搜索按钮替换为文字按钮（true 为"搜索"，或传入自定义文案） |
| `focusNode` | `FocusNode?` | 焦点节点 |
| `loading` | `bool` | 是否加载中 |
| `onChange` | `ValueChanged<String>?` | 输入变化回调 |
| `onSearch` | `ValueChanged<String>?` | 搜索回调（回车或点击搜索按钮触发） |
| `placeholder` | `String?` | 占位文本 |
| `size` | `AntInputSize` | 尺寸 |
| `value` | `String?` | 受控值 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntInputSearch>` | — |

