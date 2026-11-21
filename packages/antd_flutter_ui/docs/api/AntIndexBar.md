<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntIndexBar

> 种类：类

```dart
class AntIndexBar
```

索引栏 — 通讯录式字母索引导航。

需要外层给定高度（内部自管理滚动区域）。

```dart
SizedBox(
  height: 400,
  child: AntIndexBar<Contact>(
    items: contacts,
    keyOf: (contact) => contact.initial,
    titleBuilder: (context, contact, index) => Text(contact.initial),
    childBuilder: (context, contact) => Text(contact.name),
  ),
)
```

## 构造函数

### `AntIndexBar({super.key, required this.items, this.keyOf, this.titleBuilder, this.briefBuilder, this.childBuilder, this.sticky = true, this.controller, this.onChange})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<T>` | 可选 | — |
| `keyOf` | `Object Function(T item)?` | 可选 | — |
| `titleBuilder` | `AntIndexBarTitleBuilder<T>?` | 可选 | — |
| `briefBuilder` | `AntIndexBarBriefBuilder<T>?` | 可选 | — |
| `childBuilder` | `AntIndexBarChildBuilder<T>?` | 可选 | — |
| `sticky` | `bool` | = true | — |
| `controller` | `AntIndexBarController?` | 可选 | — |
| `onChange` | `ValueChanged<Object>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `briefBuilder` | `AntIndexBarBriefBuilder<T>?` | 右侧索引字母构建器，未提供时取索引首字符 |
| `childBuilder` | `AntIndexBarChildBuilder<T>?` | 分组内容构建器 |
| `controller` | `AntIndexBarController?` | 控制器，可调用 AntIndexBarController.scrollTo 跳转分组 |
| `items` | `List<T>` | 分组项列表 |
| `keyOf` | `Object Function(T item)?` | 提取分组索引（如 'A'、'B'），默认使用下标 |
| `onChange` | `ValueChanged<Object>?` | 当前索引变化回调（点击、拖动或滚动均会触发） |
| `sticky` | `bool` | 分组标题是否吸顶 |
| `titleBuilder` | `AntIndexBarTitleBuilder<T>?` | 分组标题构建器，未提供时回退为 Text('$item') |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntIndexBar<T>>` | — |

