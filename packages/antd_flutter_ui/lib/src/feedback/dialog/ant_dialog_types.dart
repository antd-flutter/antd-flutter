/// AntDialog 类型与默认值定义
library;

import 'package:flutter/widgets.dart';

/// 默认确认按钮文案。
const String kAntDialogDefaultOkText = '确定';

/// 默认取消按钮文案。
const String kAntDialogDefaultCancelText = '取消';

/// 对话框卡片宽度占屏宽比例（移动端居中小卡片）。
const double kAntDialogDefaultWidthFactor = 0.7;

/// 对话框动画时长。
const Duration kAntDialogAnimationDuration = Duration(milliseconds: 200);

/// AntDialog 展示模式。
enum AntDialogMode {
  /// alert 风格：仅确认按钮。
  alert,

  /// confirm 风格：确认 + 取消双按钮。
  confirm,
}

/// AntDialog 自定义按钮项。
class AntDialogAction {
  const AntDialogAction({
    required this.text,
    this.onClick,
    this.bold = false,
    this.primary = false,
  });

  /// 按钮文案。
  final String text;

  /// 点击回调。
  final VoidCallback? onClick;

  /// 是否加粗（主操作）。
  final bool bold;

  /// 是否使用主色文字。
  final bool primary;
}
