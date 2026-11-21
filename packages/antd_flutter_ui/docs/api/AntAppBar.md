<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntAppBar

> 种类：类

```dart
class AntAppBar
```

Ant Design 风格的 AppBar 别名（内部委托 `AntNavBar`）。

Flutter 生态习惯把顶部导航栏叫 `AppBar`，此组件提供同样的命名与
`title/leading/actions` 参数形态，便于从 Material `AppBar` 迁移；
尺寸、边框与主题仍由 AntNavBar / AntTheme 决定。

```dart
AntAppBar(
  title: const Text('标题'),
  actions: [
    IconButton(onPressed: onSearch, icon: const Icon(AntIcons.searchOutlined)),
  ],
)
```

## 构造函数

### `AntAppBar({super.key, this.title, this.leading, this.actions, this.automaticallyImplyLeading = true, this.onBack, this.border = true})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `title` | `Widget?` | 可选 | — |
| `leading` | `Widget?` | 可选 | — |
| `actions` | `List<Widget>?` | 可选 | — |
| `automaticallyImplyLeading` | `bool` | = true | — |
| `onBack` | `VoidCallback?` | 可选 | — |
| `border` | `bool` | = true | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `actions` | `List<Widget>?` | 右侧操作区，按顺序横向排列 |
| `automaticallyImplyLeading` | `bool` | 未显式提供 leading 时，若当前路由可返回则自动显示返回箭头 |
| `border` | `bool` | 是否显示底部边框 |
| `leading` | `Widget?` | 左侧自定义内容 |
| `onBack` | `VoidCallback?` | 点击返回箭头回调 |
| `title` | `Widget?` | 标题，居中展示 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

