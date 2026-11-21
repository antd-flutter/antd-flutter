/// AntPopup 类型与默认值定义
library;

import 'package:flutter/widgets.dart';

/// 弹出层弹出方向。
enum AntPopupPosition {
  /// 底部弹出（默认）。
  bottom,

  /// 顶部弹出。
  top,

  /// 左侧弹出。
  left,

  /// 右侧弹出。
  right,
}

/// 弹出层动画时长。
const Duration kAntPopupAnimationDuration = Duration(milliseconds: 220);

/// 侧边弹出（left/right）默认宽度占屏宽比例。
const double kAntPopupSideWidthFactor = 0.7;

/// 纵向弹出（top/bottom）默认最大高度占屏高比例。
const double kAntPopupVerticalMaxHeightFactor = 0.8;

/// 关闭图标标记 key。
const Key kAntPopupCloseKey = ValueKey<String>('AntPopupClose');
