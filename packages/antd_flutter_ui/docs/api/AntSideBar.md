<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSideBar

> 种类：类

```dart
class AntSideBar
```

侧边导航栏 — 垂直排列的导航菜单，常用于分类筛选。

对齐 antd-mobile SideBar 组件，激活项左侧有高亮条，
白色背景 + colorPrimary 文字；非激活项灰色背景。

```dart
AntSideBar<Category>(
  items: categories,
  keyOf: (category) => category.id,
  titleBuilder: (context, category, index) => Text(category.name),
)
```

## 构造函数

### `AntSideBar({super.key, required this.items, this.keyOf, this.titleBuilder, this.badgeTextOf, this.badgeDotOf, this.disabledOf, this.activeKey, this.defaultActiveKey, this.onChange})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<T>` | 可选 | — |
| `keyOf` | `Object Function(T item)?` | 可选 | — |
| `titleBuilder` | `AntSideBarTitleBuilder<T>?` | 可选 | — |
| `badgeTextOf` | `String? Function(T item)?` | 可选 | — |
| `badgeDotOf` | `bool Function(T item)?` | 可选 | — |
| `disabledOf` | `bool Function(T item)?` | 可选 | — |
| `activeKey` | `Object?` | 可选 | — |
| `defaultActiveKey` | `Object?` | 可选 | — |
| `onChange` | `ValueChanged<T>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `activeKey` | `Object?` | 受控激活项 key |
| `badgeDotOf` | `bool Function(T item)?` | 圆点角标 |
| `badgeTextOf` | `String? Function(T item)?` | 文字角标 |
| `defaultActiveKey` | `Object?` | 非受控默认激活项 key |
| `disabledOf` | `bool Function(T item)?` | 是否禁用某项 |
| `items` | `List<T>` | 导航项列表 |
| `keyOf` | `Object Function(T item)?` | 提取唯一标识，默认使用下标 |
| `onChange` | `ValueChanged<T>?` | 切换回调 |
| `titleBuilder` | `AntSideBarTitleBuilder<T>?` | 标题构建器，未提供时回退为 Text('$item') |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntSideBar<T>>` | — |

