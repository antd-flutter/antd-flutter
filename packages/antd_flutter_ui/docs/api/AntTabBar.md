<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTabBar

> 种类：类

```dart
class AntTabBar
```

底部标签栏 — 移动端页面底部 Tab 切换。

对齐 antd-mobile TabBar 组件，图标 + 标题 + 角标，
激活项高亮 colorPrimary，支持受控与非受控模式。

```dart
AntTabBar<Tab>(
  items: tabs,
  keyOf: (tab) => tab.id,
  titleBuilder: (context, tab, index) => Text(tab.label),
  iconBuilder: (context, tab) => Icon(tab.icon),
)
```

## 构造函数

### `AntTabBar({super.key, required this.items, this.keyOf, this.titleBuilder, this.iconBuilder, this.activeIconBuilder, this.badgeTextOf, this.badgeDotOf, this.activeKey, this.defaultActiveKey, this.onChange, this.border = true, this.safeArea = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<T>` | 可选 | — |
| `keyOf` | `Object Function(T item)?` | 可选 | — |
| `titleBuilder` | `AntTabBarTitleBuilder<T>?` | 可选 | — |
| `iconBuilder` | `AntTabBarIconBuilder<T>?` | 可选 | — |
| `activeIconBuilder` | `AntTabBarActiveIconBuilder<T>?` | 可选 | — |
| `badgeTextOf` | `String? Function(T item)?` | 可选 | — |
| `badgeDotOf` | `bool Function(T item)?` | 可选 | — |
| `activeKey` | `Object?` | 可选 | — |
| `defaultActiveKey` | `Object?` | 可选 | — |
| `onChange` | `ValueChanged<T>?` | 可选 | — |
| `border` | `bool` | = true | — |
| `safeArea` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `activeIconBuilder` | `AntTabBarActiveIconBuilder<T>?` | 激活态图标构建器，未提供时复用普通图标 |
| `activeKey` | `Object?` | 受控激活项 key |
| `badgeDotOf` | `bool Function(T item)?` | 红点角标 |
| `badgeTextOf` | `String? Function(T item)?` | 文字角标（如 '5'、'99+'） |
| `border` | `bool` | 是否显示顶部边框 |
| `defaultActiveKey` | `Object?` | 非受控默认激活项 key |
| `iconBuilder` | `AntTabBarIconBuilder<T>?` | 图标构建器 |
| `items` | `List<T>` | 标签项列表 |
| `keyOf` | `Object Function(T item)?` | 提取唯一标识，默认使用下标 |
| `onChange` | `ValueChanged<T>?` | 切换回调 |
| `safeArea` | `bool` | 是否适配底部安全区 |
| `titleBuilder` | `AntTabBarTitleBuilder<T>?` | 标题构建器，未提供时回退为 Text('$item') |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntTabBar<T>>` | — |

