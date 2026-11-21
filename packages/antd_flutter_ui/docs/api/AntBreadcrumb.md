<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntBreadcrumb

> 种类：类

```dart
class AntBreadcrumb
```

面包屑 — 显示当前页面在系统层级结构中的位置。

对齐 antd React Breadcrumb 组件，支持自定义分隔符、图标和点击回调。

```dart
AntBreadcrumb<Crumb>(
  items: crumbs,
  titleBuilder: (context, crumb, index) => Text(crumb.title),
  onTap: (crumb) => go(crumb.path),
)
```

## 构造函数

### `AntBreadcrumb({super.key, this.items = const [], this.titleBuilder, this.iconBuilder, this.onTap, this.clickableOf, this.separator = '/', this.separatorWidget})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<T>` | = const [] | — |
| `titleBuilder` | `AntBreadcrumbTitleBuilder<T>?` | 可选 | — |
| `iconBuilder` | `AntBreadcrumbIconBuilder<T>?` | 可选 | — |
| `onTap` | `ValueChanged<T>?` | 可选 | — |
| `clickableOf` | `bool Function(T item)?` | 可选 | — |
| `separator` | `String` | = '/' | — |
| `separatorWidget` | `Widget?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `clickableOf` | `bool Function(T item)?` | 指定某些项是否可点击（仍受最后一项不可点击限制） |
| `iconBuilder` | `AntBreadcrumbIconBuilder<T>?` | 图标构建器，显示在标题左侧 |
| `items` | `List<T>` | 面包屑项列表 |
| `onTap` | `ValueChanged<T>?` | 点击回调 |
| `separator` | `String` | 分隔符文字 |
| `separatorWidget` | `Widget?` | 自定义分隔符 Widget |
| `titleBuilder` | `AntBreadcrumbTitleBuilder<T>?` | 标题构建器，未提供时回退为 Text('$item') |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_buildContent` | `Widget` | — |
| `_buildItem` | `Widget` | — |
| `_buildSeparator` | `Widget` | — |
| `build` | `Widget` | — |

