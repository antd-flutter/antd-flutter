<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSearchBar

> 种类：类

```dart
class AntSearchBar
```

搜索栏 — 移动端搜索场景的输入组件。

## 构造函数

### `AntSearchBar({super.key, this.value, this.defaultValue, this.maxLength, this.placeholder, this.clearable = true, this.onlyShowClearWhenFocus = false, this.showCancelButton = AntSearchBarCancelMode.never, this.cancelText = '取消', this.searchIcon, this.clearOnCancel = true, this.onSearch, this.onChange, this.onCancel, this.onFocus, this.onBlur, this.onClear, this.autoFocus = false, this.focusNode, this.controller, this.height})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `String?` | 可选 | — |
| `defaultValue` | `String?` | 可选 | — |
| `maxLength` | `int?` | 可选 | — |
| `placeholder` | `String?` | 可选 | — |
| `clearable` | `bool` | = true | — |
| `onlyShowClearWhenFocus` | `bool` | = false | — |
| `showCancelButton` | `AntSearchBarCancelMode` | = AntSearchBarCancelMode.never | — |
| `cancelText` | `String` | = '取消' | — |
| `searchIcon` | `Widget?` | 可选 | — |
| `clearOnCancel` | `bool` | = true | — |
| `onSearch` | `ValueChanged<String>?` | 可选 | — |
| `onChange` | `ValueChanged<String>?` | 可选 | — |
| `onCancel` | `VoidCallback?` | 可选 | — |
| `onFocus` | `VoidCallback?` | 可选 | — |
| `onBlur` | `VoidCallback?` | 可选 | — |
| `onClear` | `VoidCallback?` | 可选 | — |
| `autoFocus` | `bool` | = false | — |
| `focusNode` | `FocusNode?` | 可选 | — |
| `controller` | `TextEditingController?` | 可选 | — |
| `height` | `double?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `autoFocus` | `bool` | 自动聚焦 |
| `cancelText` | `String` | 取消按钮文本 |
| `clearOnCancel` | `bool` | 取消时是否清空输入 |
| `clearable` | `bool` | 是否允许清除 |
| `controller` | `TextEditingController?` | 外部传入的文本控制器 |
| `defaultValue` | `String?` | 非受控初始值 |
| `focusNode` | `FocusNode?` | 外部传入的焦点节点 |
| `height` | `double?` | 自定义高度 |
| `maxLength` | `int?` | 最大输入长度 |
| `onBlur` | `VoidCallback?` | 失焦回调 |
| `onCancel` | `VoidCallback?` | 点击取消按钮回调 |
| `onChange` | `ValueChanged<String>?` | 输入变化回调 |
| `onClear` | `VoidCallback?` | 点击清除按钮回调 |
| `onFocus` | `VoidCallback?` | 聚焦回调 |
| `onSearch` | `ValueChanged<String>?` | 按下搜索键（回车）回调 |
| `onlyShowClearWhenFocus` | `bool` | 是否仅在聚焦时显示清除按钮 |
| `placeholder` | `String?` | 占位提示文本 |
| `searchIcon` | `Widget?` | 自定义搜索图标 |
| `showCancelButton` | `AntSearchBarCancelMode` | 取消按钮显示策略 |
| `value` | `String?` | 受控值 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntSearchBar>` | — |

