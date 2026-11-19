<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntBreadcrumb

> 种类：类

```dart
class AntBreadcrumb
```

面包屑 — 显示当前页面在系统层级结构中的位置。

对齐 antd React Breadcrumb 组件，支持自定义分隔符、图标和点击回调。

```dart
AntBreadcrumb(items: [
  AntBreadcrumbItem(title: 'Home', onClick: () => goHome()),
  AntBreadcrumbItem(title: 'List', onClick: () => goList()),
  AntBreadcrumbItem(title: 'App'), // 当前页面
])
```

## 构造函数

### `AntBreadcrumb({super.key, this.items = const [], this.separator = '/', this.separatorWidget})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<AntBreadcrumbItem>` | = const [] | — |
| `separator` | `String` | = '/' | — |
| `separatorWidget` | `Widget?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `items` | `List<AntBreadcrumbItem>` | 面包屑项列表 |
| `separator` | `String` | 分隔符文字 |
| `separatorWidget` | `Widget?` | 自定义分隔符 Widget |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_buildItem` | `Widget` | — |
| `_buildSeparator` | `Widget` | — |
| `build` | `Widget` | — |

