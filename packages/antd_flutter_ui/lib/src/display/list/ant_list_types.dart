/// AntList 类型定义
library;

import 'package:material_ui/material_ui.dart';

/// 列表尺寸。
enum AntListSize {
  /// 大
  large,

  /// 中（默认）
  middle,

  /// 小
  small,
}

/// 列表条目操作项。
class AntListAction {
  const AntListAction({required this.child, this.onTap});

  /// 操作内容。
  final Widget child;

  /// 点击回调。
  final VoidCallback? onTap;
}
