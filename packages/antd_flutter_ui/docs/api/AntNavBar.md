<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntNavBar

> 种类：类

```dart
class AntNavBar
```

导航栏 — 移动端页面顶部导航。

对齐 antd-mobile NavBar 组件，标题居中，左侧返回箭头与附加内容，
右侧操作区域，底部 0.5px 分割线。

```dart
AntNavBar(
  child: Text('页面标题'),
  onBack: () => Navigator.of(context).pop(),
)
```

## 构造函数

### `AntNavBar({super.key, required this.child, this.back = true, this.backArrow, this.left, this.right, this.onBack, this.border = true})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `child` | `Widget` | 可选 | — |
| `back` | `bool` | = true | — |
| `backArrow` | `Widget?` | 可选 | — |
| `left` | `Widget?` | 可选 | — |
| `right` | `Widget?` | 可选 | — |
| `onBack` | `VoidCallback?` | 可选 | — |
| `border` | `bool` | = true | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `back` | `bool` | 是否显示返回箭头区域 |
| `backArrow` | `Widget?` | 自定义返回箭头（默认左箭头图标） |
| `border` | `bool` | 是否显示底部边框 |
| `child` | `Widget` | 标题内容 |
| `left` | `Widget?` | 左侧附加内容（与返回箭头并排） |
| `onBack` | `VoidCallback?` | 点击返回回调 |
| `right` | `Widget?` | 右侧内容 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

