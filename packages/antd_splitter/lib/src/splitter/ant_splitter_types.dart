/// AntSplitter 类型定义
library;

/// 分隔器布局方向。
enum AntSplitterLayout {
  /// 水平布局 — 面板左右排列，拖拽器垂直。
  horizontal,

  /// 垂直布局 — 面板上下排列，拖拽器水平。
  vertical,
}

/// 折叠/展开回调。
///
/// - [collapsed] — 各面板折叠状态
/// - [sizes] — 各面板当前尺寸（逻辑像素）
typedef AntSplitterCollapseCallback = void Function(
  List<bool> collapsed,
  List<double> sizes,
);