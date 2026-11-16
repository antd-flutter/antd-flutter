/// AntSafeArea — antd React SafeArea 的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [position] — 安全区位置（top / bottom / both）
/// - [child] — 子组件（可选；为 null 时渲染安全区占位）
///
/// 扩展能力（Flutter 场景）：
/// - [child] 为 null 时渲染安全区高度的占位 SizedBox（对齐 antd React 占位模式）
/// - [child] 不为 null 时包装子组件并添加安全区内边距（对齐 Flutter SafeArea）
/// - [maintainBottomViewPadding] — 键盘弹出时保持底部内边距
/// - [minimum] — 最小内边距
/// - [left] / [right] — 是否应用左右安全区
library;

import 'package:material_ui/material_ui.dart';

import 'ant_safe_area_types.dart';

// ============================================================
// AntSafeArea
// ============================================================

/// 安全区 — 适配顶部/底部安全区，支持占位模式与包装模式。
///
/// 对齐 antd React SafeArea 组件，在刘海屏、全面屏等设备上
/// 避免内容被状态栏或底部指示条遮挡。
///
/// ```dart
/// AntSafeArea(position: AntSafeAreaPosition.top) // 顶部安全区占位
/// AntSafeArea(position: AntSafeAreaPosition.bottom) // 底部安全区占位
/// AntSafeArea(child: myContent) // 包装子组件并添加安全区内边距
/// ```
class AntSafeArea extends StatelessWidget {
  const AntSafeArea({
    super.key,
    this.position = AntSafeAreaPosition.both,
    this.child,
    this.maintainBottomViewPadding = false,
    this.minimum = EdgeInsets.zero,
    this.left = true,
    this.right = true,
  });

  /// 安全区位置。top 仅顶部，bottom 仅底部，both 顶部和底部。
  final AntSafeAreaPosition position;

  /// 子组件。为 null 时渲染安全区高度的占位 SizedBox。
  final Widget? child;

  /// 键盘弹出时是否仍保持底部内边距。仅包装模式生效。
  final bool maintainBottomViewPadding;

  /// 最小内边距。安全区内边距不小于此值。仅包装模式生效。
  final EdgeInsets minimum;

  /// 是否应用左侧安全区内边距。仅包装模式生效。
  final bool left;

  /// 是否应用右侧安全区内边距。仅包装模式生效。
  final bool right;

  bool get _applyTop =>
      position == AntSafeAreaPosition.top ||
      position == AntSafeAreaPosition.both;

  bool get _applyBottom =>
      position == AntSafeAreaPosition.bottom ||
      position == AntSafeAreaPosition.both;

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return SafeArea(
        top: _applyTop,
        bottom: _applyBottom,
        left: left,
        right: right,
        maintainBottomViewPadding: maintainBottomViewPadding,
        minimum: minimum,
        child: child!,
      );
    }

    // 占位模式 — 渲染安全区高度的 SizedBox
    final mediaQuery = MediaQuery.of(context);
    var height = 0.0;
    if (_applyTop) {
      height += mediaQuery.padding.top;
    }
    if (_applyBottom) {
      height += maintainBottomViewPadding
          ? mediaQuery.viewPadding.bottom
          : mediaQuery.padding.bottom;
    }
    return SizedBox(height: height);
  }
}