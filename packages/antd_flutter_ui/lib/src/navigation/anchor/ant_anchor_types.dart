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
  Object? _activeKey;

  /// 当前激活的锚点 key。
  Object? get activeKey => _activeKey;

  /// 设置激活的锚点 key，null 表示无激活项。
  void setActive(Object? key) {
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

/// 锚点标题构建器。未提供时回退为 `Text('$item')`。
typedef AntAnchorTitleBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  int index,
);
