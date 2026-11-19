<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntFloatingBubble

> 种类：类

```dart
class AntFloatingBubble
```

Ant Design 悬浮气泡。

自身渲染为撑满父容器的透明层（Stack/Overlay 内放置，
非 bubble 区域使用 `IgnorePointer` 穿透手势），
气泡按 `initialPos` 定位并支持 `axis` 轴向拖拽，
拖拽范围默认约束在父容器边界内（`constraint`）。

## 构造函数

### `AntFloatingBubble({super.key, this.axis = AntFloatingBubbleAxis.both, this.initialPos = Offset.zero, this.constraint = true, this.autoSnapToEdge = false, this.menu, this.onClick, this.controller, this.child, this.backgroundColor, this.size})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `axis` | `AntFloatingBubbleAxis` | = AntFloatingBubbleAxis.both | — |
| `initialPos` | `Offset` | = Offset.zero | — |
| `constraint` | `bool` | = true | — |
| `autoSnapToEdge` | `bool` | = false | — |
| `menu` | `List<AntFloatingBubbleMenuAction>?` | 可选 | — |
| `onClick` | `VoidCallback?` | 可选 | — |
| `controller` | `AntFloatingBubbleController?` | 可选 | — |
| `child` | `Widget?` | 可选 | — |
| `backgroundColor` | `Color?` | 可选 | — |
| `size` | `double?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `autoSnapToEdge` | `bool` | 拖拽松手后是否自动吸附到最近的水平边缘（默认 false） |
| `axis` | `AntFloatingBubbleAxis` | 可拖拽轴向 |
| `backgroundColor` | `Color?` | 自定义背景色（默认主题主色） |
| `child` | `Widget?` | 自定义图标内容 |
| `constraint` | `bool` | 是否约束在父容器边界内（默认 true） |
| `controller` | `AntFloatingBubbleController?` | 程序化控制器（R35）：显示/隐藏/移动/边缘吸附/重置位置 |
| `initialPos` | `Offset` | 初始位置（逻辑像素，内部 .w 缩放） |
| `menu` | `List<AntFloatingBubbleMenuAction>?` | 菜单项列表（非空时点击气泡展开/收起菜单） |
| `onClick` | `VoidCallback?` | 气泡点击回调（配置 menu 时在展开/收起切换之外仍会触发） |
| `size` | `double?` | 气泡尺寸（逻辑像素，默认 48） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntFloatingBubble>` | — |

