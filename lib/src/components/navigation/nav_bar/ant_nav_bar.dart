/// AntNavBar — antd-mobile NavBar 导航栏的 Flutter 实现
///
/// API 与 antd-mobile NavBar 对齐：
/// - [child] — 标题内容
/// - [back] — 是否显示返回箭头（默认 true）
/// - [backArrow] — 自定义返回箭头
/// - [left] — 左侧附加内容
/// - [right] — 右侧内容
/// - [onBack] — 点击返回回调
/// - [border] — 底部边框（默认 true）
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

// ============================================================
// AntNavBar
// ============================================================

/// 导航栏 — 移动端页面顶部导航。
///
/// 对齐 antd-mobile NavBar 组件，标题居中，左侧返回箭头与附加内容，
/// 右侧操作区域，底部 0.5px 分割线。
///
/// ```dart
/// AntNavBar(
///   child: Text('页面标题'),
///   onBack: () => Navigator.of(context).pop(),
/// )
/// ```
class AntNavBar extends StatelessWidget {
  const AntNavBar({
    super.key,
    required this.child,
    this.back = true,
    this.backArrow,
    this.left,
    this.right,
    this.onBack,
    this.border = true,
  });

  /// 标题内容。
  final Widget child;

  /// 是否显示返回箭头区域。
  final bool back;

  /// 自定义返回箭头（默认左箭头图标）。
  final Widget? backArrow;

  /// 左侧附加内容（与返回箭头并排）。
  final Widget? left;

  /// 右侧内容。
  final Widget? right;

  /// 点击返回回调。
  final VoidCallback? onBack;

  /// 是否显示底部边框。
  final bool border;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);

    final leftSide = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (back)
          GestureDetector(
            onTap: onBack,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: backArrow ??
                  Icon(
                    Icons.arrow_back_ios_new,
                    size: 18.sp,
                    color: t.colorText,
                  ),
            ),
          ),
        if (left != null) left!,
      ],
    );

    return Container(
      height: 45.w,
      decoration: BoxDecoration(
        color: t.colorBgContainer,
        border: border
            ? Border(bottom: BorderSide(color: t.colorSplit, width: 0.5.w))
            : null,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          Expanded(
            child: Align(alignment: Alignment.centerLeft, child: leftSide),
          ),
          Flexible(
            child: Center(
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 15.sp,
                  color: t.colorText,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                child: child,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: right ?? const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}