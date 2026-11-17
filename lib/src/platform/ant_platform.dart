/// AntPlatform — 平台检测（实现已下沉 antd_theme）
///
/// 本文件仅为向后兼容的 re-export 垫片：
/// 实现迁移至 `package:antd_theme/src/ant_platform.dart`，
/// 经 `antd_theme` 包公开导出。
/// 所有既有 API（`AntPlatform.isOhos` / `isDesktop` / `supportsHover` 等）
/// 保持不变。
library;

export 'package:antd_theme/antd_theme.dart' show AntPlatform;
