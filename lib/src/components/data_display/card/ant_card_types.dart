/// AntCard 类型定义
library;

import 'package:flutter/widgets.dart';

/// 卡片尺寸。
enum AntCardSize {
  /// 默认
  standard,

  /// 小号
  small,
}

/// 卡片封面配置。
class AntCardCover {
  const AntCardCover({
    required this.child,
    this.height,
  });

  /// 封面内容（通常为图片）。
  final Widget child;

  /// 封面高度。
  final double? height;
}

/// 卡片操作按钮配置。
class AntCardAction {
  const AntCardAction({
    required this.child,
    this.onTap,
  });

  /// 按钮内容。
  final Widget child;

  /// 点击回调。
  final VoidCallback? onTap;
}