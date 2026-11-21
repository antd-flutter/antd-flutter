/// antd_image_viewer — antd-mobile ImageViewer 独立组件包（弹层预览类，无 sliver 依赖）
///
/// 从主包 antd_flutter_plus 拆分的独立组件包：
/// - [AntImageViewer] — 全屏图片查看器（多图预览，对齐 antd-mobile ImageViewer / MultiImageViewer API）
/// - [AntImageViewerDefaults] — 默认配置与公共构建器
///
/// 能力：双指缩放 / 平移 / 双击缩放（缩放引擎参照 photo_view（MIT）算法
/// 在包内完全吸收改造，基于 InteractiveViewer 实现，不直接依赖 photo_view）。
///
/// 依赖方向约定：antd_image_viewer → antd_theme（+ material_ui / cached_network_image），
/// 不依赖其他独立组件包。
/// 弹层预览类组件（Overlay 全屏浮层，非滚动场景），不需要 sliver 支持（R33）。
/// 主包 antd_flutter_plus 经 re-export 保持对外兼容。
library;

export 'src/image_viewer/ant_image_viewer.dart';
export 'src/image_viewer/ant_image_viewer_types.dart';
