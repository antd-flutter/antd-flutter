# antd_image_viewer example

AntImageViewer 组件演示画廊（全平台：Android / iOS / macOS / Web / Windows / Linux）。

## 运行

```bash
flutter pub get
flutter run -d macos   # 或 -d chrome / 其他已连接设备
```

## 覆盖形态

| Tab | 形态 |
| --- | --- |
| 单图预览 | 双指缩放 / 拖拽平移 / 双击缩放 / 轻点关闭 |
| 多图切换 | PreviewGroup 语义：缩略图入口 + PageView 左右切换 + 页码指示 |
| 受控开关 | `open` 受控 + `onClose` / `afterClose` 回调时序演示 |
| 自定义初始页 | `defaultIndex` 动态调节 |
| 自定义缩放 | `maxZoomRatio` 上限 + `enableCompositeZoom` 双击开关 |
| 组合入口 | 卡片点击打开全屏预览 |

## 说明

- 主题经 antd_theme（path 依赖）注入，支持亮/暗切换（AppBar 右上角按钮）
- 图片源为 picsum.photos 网络图，需网络可达；加载失败显示组件内置占位
- 图标/应用名按 R32.2 规范由 `scripts/setup_example_identity.sh` 生成（AntdImageViewer）
