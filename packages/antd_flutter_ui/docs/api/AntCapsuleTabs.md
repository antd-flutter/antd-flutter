<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCapsuleTabs

> 种类：类

```dart
class AntCapsuleTabs
```

胶囊选项卡 — 圆角胶囊形选项卡组。

对齐 antd-mobile CapsuleTabs：标签横向排列、均分宽度，
激活项主色胶囊 + 白字，超出宽度可横向滚动。

```dart
AntCapsuleTabs<Tag>(
  items: tags,
  keyOf: (tag) => tag.id,
  titleBuilder: (context, tag, index) => Text(tag.name),
  childBuilder: (context, tag, index) => Text(tag.description),
)
```

## 构造函数

### `AntCapsuleTabs({super.key, required this.items, this.keyOf, this.titleBuilder, this.childBuilder, this.disabledOf, this.activeKey, this.defaultActiveKey, this.onChange})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<T>` | 可选 | — |
| `keyOf` | `Object Function(T item)?` | 可选 | — |
| `titleBuilder` | `AntCapsuleTabsTitleBuilder<T>?` | 可选 | — |
| `childBuilder` | `AntCapsuleTabsChildBuilder<T>?` | 可选 | — |
| `disabledOf` | `bool Function(T item)?` | 可选 | — |
| `activeKey` | `Object?` | 可选 | — |
| `defaultActiveKey` | `Object?` | 可选 | — |
| `onChange` | `ValueChanged<T>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `activeKey` | `Object?` | 受控激活项 key |
| `childBuilder` | `AntCapsuleTabsChildBuilder<T>?` | 面板内容构建器 |
| `defaultActiveKey` | `Object?` | 非受控默认激活项 key |
| `disabledOf` | `bool Function(T item)?` | 是否禁用某项 |
| `items` | `List<T>` | 选项卡项列表 |
| `keyOf` | `Object Function(T item)?` | 提取唯一标识，默认使用下标 |
| `onChange` | `ValueChanged<T>?` | 切换回调 |
| `titleBuilder` | `AntCapsuleTabsTitleBuilder<T>?` | 标题构建器，未提供时回退为 Text('$item') |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntCapsuleTabs<T>>` | — |

