/// AntAnchor 类型定义 — antd React Anchor 的 Flutter 实现
library;

import 'package:flutter/widgets.dart';

// ============================================================
// AntAnchorDirection — 锚点方向
// ============================================================

/// 锚点方向。
enum AntAnchorDirection {
  /// 垂直排列（默认）。
  vertical,

  /// 水平排列。
  horizontal,
}

// ============================================================
// AntAnchorItem — 锚点链接项
// ============================================================

/// 锚点链接项。
///
/// 对齐 antd React Anchor 的 items 属性中的链接项：
/// - [key] — 唯一标识
/// - [title] — 文字标题
/// - [titleWidget] — 自定义标题 Widget（优先于 [title]）
/// - [children] — 子链接
class AntAnchorItem {
  const AntAnchorItem({
    required this.key,
    this.title,
    this.titleWidget,
    this.children = const [],
  });

  /// 唯一标识。
  final String key;

  /// 文字标题。
  final String? title;

  /// 自定义标题 Widget（优先于 [title]）。
  final Widget? titleWidget;

  /// 子链接。
  final List<AntAnchorItem> children;
}

// ============================================================
// AntAnchorController — 锚点控制器
// ============================================================

/// 锚点控制器 — 管理当前激活的锚点 key。
///
/// 可用于受控模式，或与外部 ScrollController 联动：
///
/// ```dart
/// final controller = AntAnchorController();
/// // 滚动时更新激活项
/// scrollController.addListener(() {
///   controller.setActive(_computeActiveKey(scrollController));
/// });
/// ```
class AntAnchorController extends ChangeNotifier {
  String? _activeKey;

  /// 当前激活的锚点 key。
  String? get activeKey => _activeKey;

  /// 设置激活的锚点 key，null 表示无激活项。
  void setActive(String? key) {
    if (_activeKey == key) return;
    _activeKey = key;
    notifyListeners();
  }

  @override
  void dispose() {
    _activeKey = null;
    super.dispose();
  }
}