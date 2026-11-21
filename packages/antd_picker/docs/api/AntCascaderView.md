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

### `AntCascaderView({super.key, this.options = const [], this.value, this.defaultValue = const [], this.onChange, this.placeholder = '请选择', this.onTabsChange, this.activeIcon, this.height})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `options` | `List<AntCascaderOption>` | = const [] | — |
| `value` | `List<String>?` | 可选 | — |
| `defaultValue` | `List<String>` | = const [] | — |
| `onChange` | `void Function(List<String> value, List<AntCascaderOption?> items)?` | 可选 | — |
| `placeholder` | `String` | = '请选择' | — |
| `onTabsChange` | `ValueChanged<int>?` | 可选 | — |
| `activeIcon` | `Widget?` | 可选 | — |
| `height` | `double?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `activeIcon` | `Widget?` | 自定义选中图标 |
| `defaultValue` | `List<String>` | 非受控默认值 |
| `height` | `double?` | 内容区高度 |
| `onChange` | `void Function(List<String> value, List<AntCascaderOption?> items)?` | 值变化回调，附带已选选项数组（未选层级为 null） |
| `onTabsChange` | `ValueChanged<int>?` | 切换层级 Tab 回调 |
| `options` | `List<AntCascaderOption>` | 级联选项树 |
| `placeholder` | `String` | 未选择层级的占位文本 |
| `value` | `List<String>?` | 受控值（路径数组，如 'zj', 'hz'） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntCascaderView>` | — |

