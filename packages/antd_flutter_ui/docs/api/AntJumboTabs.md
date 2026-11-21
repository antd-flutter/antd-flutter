<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntJumboTabs

> 种类：类

```dart
class AntJumboTabs
```

大选项卡 — 主标题 + 描述的大尺寸选项卡，常用于服务分类。

对齐 antd-mobile JumboTabs 组件，每个选项卡含主标题与描述，
激活项主标题高亮 + 底部指示条。

```dart
AntJumboTabs<Category>(
  items: categories,
  keyOf: (category) => category.id,
  titleBuilder: (context, category, index) => Text(category.name),
  descriptionBuilder: (context, category, index) => Text(category.desc),
)
```

## 构造函数

### `AntJumboTabs({super.key, required this.items, this.keyOf, this.titleBuilder, this.descriptionBuilder, this.disabledOf, this.activeKey, this.defaultActiveKey, this.onChange})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<T>` | 可选 | — |
| `keyOf` | `Object Function(T item)?` | 可选 | — |
| `titleBuilder` | `AntJumboTabsTitleBuilder<T>?` | 可选 | — |
| `descriptionBuilder` | `AntJumboTabsDescriptionBuilder<T>?` | 可选 | — |
| `disabledOf` | `bool Function(T item)?` | 可选 | — |
| `activeKey` | `Object?` | 可选 | — |
| `defaultActiveKey` | `Object?` | 可选 | — |
| `onChange` | `ValueChanged<T>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `activeKey` | `Object?` | 受控激活项 key |
| `defaultActiveKey` | `Object?` | 非受控默认激活项 key |
| `descriptionBuilder` | `AntJumboTabsDescriptionBuilder<T>?` | 描述构建器，返回 null 时不展示描述 |
| `disabledOf` | `bool Function(T item)?` | 是否禁用某项 |
| `items` | `List<T>` | 选项卡项列表 |
| `keyOf` | `Object Function(T item)?` | 提取唯一标识，默认使用下标 |
| `onChange` | `ValueChanged<T>?` | 切换回调 |
| `titleBuilder` | `AntJumboTabsTitleBuilder<T>?` | 主标题构建器，未提供时回退为 Text('$item') |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntJumboTabs<T>>` | — |

