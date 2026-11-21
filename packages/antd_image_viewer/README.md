# antd_image_viewer

antd-mobile ImageViewer 组件的 Flutter 实现 — 全屏图片查看器，支持多图预览、双指缩放、平移、双击缩放（锚定点击位置）、PageView 左右切换、页码指示与受控开关，API 对齐 antd-mobile v5 ImageViewer / MultiImageViewer。

> 当前为预览版本。

> R33 判定：弹层预览类组件（Overlay 全屏浮层，非滚动场景），不需要 sliver 支持。

> R30.1 轮子决策：photo_view（License: MIT）仅作缩放手势算法参考，缩放/平移/双击缩放引擎已在包内基于 `InteractiveViewer` 完全吸收改造（双击缩放锚定点击位置），不直接依赖 photo_view，保持零额外三方依赖（仅 cached_network_image 用于网络图缓存加载）。

## 安装

```yaml
dependencies:
  antd_image_viewer: ^0.1.0-beta.1
```

## 用法

```dart
import 'package:antd_image_viewer/antd_image_viewer.dart';

// ── 多图预览（PreviewGroup 语义：一次传入多张，左右切换） ──
bool open = false;

AntImageViewer(
  images: [
    'https://example.com/a.png',
    'https://example.com/b.png',
  ],
  open: open,
  onClose: () => setState(() => open = false),
);

// ── 单图预览 + 自定义初始页 + 关闭后回调 ─────────────────
AntImageViewer(
  images: const ['assets/images/demo.png'],
  open: open,
  defaultIndex: 0,
  maxZoomRatio: 5,
  enableCompositeZoom: true,
  onClose: () => setState(() => open = false),
  afterClose: () {},
);
```

## 关键形态

| 形态 | 说明 |
| --- | --- |
| 单图预览 | 缩放 / 平移 / 双击缩放 / 轻点关闭 |
| 多图切换（PreviewGroup 语义） | images 列表 + PageView 左右切换 + 页码指示 |
| 受控开关 | `open` 受控 + `onClose` / `afterClose` 回调 |
| 自定义初始页 | `defaultIndex` 指定初始展示下标 |
| 缩放能力 | 双指缩放 / 平移（InteractiveViewer 引擎）+ 双击缩放（锚定点击位置，photo_view 算法吸收） |
| 自定义 UI 关闭交互 | 关闭按钮 / 遮罩轻点 / 单图轻点 / `maxZoomRatio` / `enableCompositeZoom` 配置 |

## 运行 example

```bash
cd packages/antd_image_viewer/example
flutter pub get
flutter run -d macos   # 或 -d chrome / 其他设备
```

## 与主包的关系

本组件已从主包 `antd_flutter_plus` 拆分（P08）；主包经 re-export 保持符号兼容，直接 `import 'package:antd_flutter_plus/antd_flutter_plus.dart'` 的存量代码无需改动。
