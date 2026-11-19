# antd_floating

Ant Design v6 Floating 组件的 Flutter 实现 — 可拖拽的底部浮动面板（AntFloatingPanel）与可拖拽悬浮气泡（AntFloatingBubble），API 对齐 antd-mobile v5 FloatingPanel / FloatingBubble。

> 当前为预览版本。

> R33 判定：浮动面板/气泡为 overlay 悬浮类组件（Stack/Overlay 内悬浮定位，非文档流），不参与 CustomScrollView 滚动组合，**不需要 sliver 变体**。

> R35 判定（Controller 评估）：浮动面板/气泡的拖拽定位/吸附/显示隐藏具有明确的程序化操作语义——位置状态外部可控是浮动组件的常见需求（如业务侧按钮触发面板展开/收起、气泡回到边缘、广告位气泡显示/隐藏）。
> **已落地 Controller**：
> - [AntFloatingPanelController] — `snapToAnchorAt(index)` 吸附到指定锚点、`expand()` 展开到最高锚点、`collapse()` 收起到最低锚点、`resetToInitial()` 重置初始位置；`heightRatio` 读取当前高度比例（0~1），`addListener` 监听变化。
> - [AntFloatingBubbleController] — `show()` / `hide()` 显示隐藏、`moveTo(offset)` 移动到指定位置、`snapToEdge(edge)` / `snapToNearestEdge()` 边缘磁吸、`resetPosition()` 重置初始位置；`visible` / `position` 读取状态，`addListener` 监听变化。
> 未挂接（面板/气泡未挂载或已销毁）时调用为安全空操作。

## 安装

```yaml
dependencies:
  antd_floating: ^0.1.0-beta.1
```

## 用法

```dart
import 'package:antd_floating/antd_floating.dart';

// ── 浮动面板：把手拖拽 + 松手动画吸附最近锚点 ──────────
final panelController = AntFloatingPanelController();
AntFloatingPanel(
  anchors: [0.3, 0.6, 1],
  controller: panelController,
  onHeightChange: (p) => print('高度比例: $p'),
  child: ListView(children: [Text('内容')]),
);
panelController.expand();   // 程序化展开到最高锚点
panelController.collapse(); // 程序化收起到最低锚点

// ── 悬浮气泡：拖拽 + 点击回调 + 边缘磁吸 ───────────────
final bubbleController = AntFloatingBubbleController();
AntFloatingBubble(
  axis: AntFloatingBubbleAxis.both,
  initialPos: const Offset(300, 500),
  controller: bubbleController,
  onClick: () => print('气泡点击'),
  child: const Icon(Icons.edit),
);
bubbleController.snapToNearestEdge(); // 吸附到最近左/右边缘
bubbleController.hide();              // 程序化隐藏

// ── 悬浮气泡菜单：点击展开动作列表 ─────────────────────
AntFloatingBubble(
  menu: [
    AntFloatingBubbleMenuAction(label: '新建', onClick: () {}),
    AntFloatingBubbleMenuAction(label: '搜索', icon: Icon(Icons.search)),
  ],
);
```

## 组件

| 组件 | 说明 |
| --- | --- |
| `AntFloatingPanel` | 可拖拽底部浮动面板，锚点间平滑移动并动画吸附 |
| `AntFloatingPanelController` | 面板程序化控制器（吸附锚点/展开/收起/重置） |
| `AntFloatingBubble` | 可拖拽悬浮气泡，支持菜单展开与边缘吸附 |
| `AntFloatingBubbleController` | 气泡程序化控制器（显示/隐藏/移动/边缘吸附/重置） |

## 依赖方向

`antd_floating` → `antd_theme`（+ material_ui），不依赖主包 `antd_flutter_plus`；主包通过 export re-export 保持符号兼容。
