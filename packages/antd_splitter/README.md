# antd_splitter

Ant Design v6 Splitter 组件的 Flutter 实现 — 可拖拽分隔面板容器，支持水平/垂直布局、面板尺寸约束、折叠面板、受控尺寸与懒拖拽，API 对齐 antd React Splitter。

> 当前为预览版本。

> R33 判定：分割器为固定布局类组件（拖拽调整面板尺寸，非滚动场景），不需要 sliver 支持。

## 安装

```yaml
dependencies:
  antd_splitter: ^0.1.0-beta.1
```

## 用法

```dart
import 'package:antd_splitter/antd_splitter.dart';

// ── 基础用法（水平分割） ─────────────────────────────────
SizedBox(
  height: 200,
  child: AntSplitter(
    layout: AntSplitterLayout.horizontal,
    children: [
      AntSplitterPanel(defaultSize: 200, min: 120, child: LeftPane()),
      AntSplitterPanel(child: RightPane()),
    ],
  ),
);

// ── 垂直布局 ─────────────────────────────────────────────
SizedBox(
  height: 300,
  child: AntSplitter(
    layout: AntSplitterLayout.vertical,
    children: [
      AntSplitterPanel(defaultSize: 160, child: TopPane()),
      AntSplitterPanel(child: BottomPane()),
    ],
  ),
);

// ── 可折叠面板 ───────────────────────────────────────────
AntSplitter(
  onCollapse: (collapsed, sizes) {}, // 折叠/展开回调
  children: [
    AntSplitterPanel(collapsible: true, child: Sidebar()),
    AntSplitterPanel(child: Content()),
  ],
);

// ── 受控模式 + 懒拖拽 ────────────────────────────────────
AntSplitter(
  lazy: true,                         // 拖拽释放时才更新尺寸
  onResize: (sizes) => setState(() => controlledSize = sizes[0]),
  onResizeStart: () {},
  onResizeEnd: () {},
  children: [
    AntSplitterPanel(size: controlledSize, resizable: true, child: PaneA()),
    AntSplitterPanel(child: PaneB()),
  ],
);
```

## 文档与演示

- [API 文档总览](docs/api-index.md)
- 在线演示：<https://antd-flutter.github.io/antd-flutter/splitter/>

## License

MIT License，详见仓库根 [LICENSE](../../LICENSE)。
