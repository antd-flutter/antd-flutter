/// AntFloatingPanel 类型定义
library;

/// 浮动面板高度变化回调签名。
///
/// [heightPercent] 为当前面板高度相对基准高度（[AntFloatingPanel.contentHeight]
/// 或父容器高度）的比例，取值 0~1。
typedef AntFloatingPanelHeightChange = void Function(double heightPercent);
