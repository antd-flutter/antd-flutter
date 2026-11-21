<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntDrawer

> 种类：类

```dart
class AntDrawer
```

抽屉 — 从屏幕边缘滑出的浮层面板。

对齐 antd React Drawer 组件：支持四方向滑入、滑入/滑出动画、
遮罩淡入淡出、受控 open、标题/关闭按钮/底部操作区、
内容滚动与遮罩配置。关闭动画播放完毕后才移除浮层。

## 构造函数

### `AntDrawer({super.key, required this.open, required this.child, this.placement = AntDrawerPlacement.right, this.width = 378, this.height = 378, this.title, this.closable = true, this.onClose, this.footer, this.mask = true, this.maskClosable = true, this.pushOffset = 0})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `open` | `bool` | 可选 | — |
| `child` | `Widget` | 可选 | — |
| `placement` | `AntDrawerPlacement` | = AntDrawerPlacement.right | — |
| `width` | `double` | = 378 | — |
| `height` | `double` | = 378 | — |
| `title` | `Widget?` | 可选 | — |
| `closable` | `bool` | = true | — |
| `onClose` | `VoidCallback?` | 可选 | — |
| `footer` | `Widget?` | 可选 | — |
| `mask` | `bool` | = true | — |
| `maskClosable` | `bool` | = true | — |
| `pushOffset` | `double` | = 0 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget` | 内容区（超出时自动滚动） |
| `closable` | `bool` | 是否显示右上角关闭按钮 |
| `footer` | `Widget?` | 底部操作区 |
| `height` | `double` | 面板高度（top / bottom 方向生效） |
| `mask` | `bool` | 是否显示遮罩 |
| `maskClosable` | `bool` | 点击遮罩是否关闭抽屉 |
| `onClose` | `VoidCallback?` | 关闭回调（关闭按钮 / 遮罩点击触发，外部应将 open 置为 false） |
| `open` | `bool` | 受控显示状态 |
| `placement` | `AntDrawerPlacement` | 滑出方向 |
| `pushOffset` | `double` | 多层抽屉堆叠偏移（向内收缩的像素数，简化实现） |
| `title` | `Widget?` | 标题区 |
| `width` | `double` | 面板宽度（left / right 方向生效） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntDrawer>` | — |

