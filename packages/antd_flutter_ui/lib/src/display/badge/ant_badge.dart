/// AntBadge — antd React Badge 的 Flutter 实现
///
/// API 与 antd React Badge 对齐：
/// - [count] — 数字徽标
/// - [dot] — 红点模式
/// - [overflowCount] — 超出显示 +N 的阈值
/// - [showZero] — 是否显示 0
/// - [offset] — 偏移量 [x, y]
/// - [color] — 自定义颜色
/// - [status] — 状态点
/// - [text] — 状态文字
/// - [child] — 包裹的内容
///
/// ```dart
/// AntBadge(count: 5, child: AntButton(child: Text('消息')))
/// AntBadge(dot: true, child: Icon(Icons.notifications))
/// AntBadge(status: AntBadgeStatus.success, text: '成功')
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'ant_badge_types.dart';
export 'ant_badge_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntBadge
// ============================================================

/// 徽标 — 图标右上角展示消息数或状态点。
///
/// 对齐 antd React Badge 组件。
class AntBadge extends StatelessWidget {
  const AntBadge({
    super.key,
    this.count,
    this.dot = false,
    this.overflowCount = 99,
    this.showZero = false,
    this.offset,
    this.color,
    this.status,
    this.text,
    this.child,
    this.size = 20,
  });

  /// 数字徽标值。
  final int? count;

  /// 是否显示红点。
  final bool dot;

  /// 超出此值显示 +N。
  final int overflowCount;

  /// count 为 0 时是否显示。
  final bool showZero;

  /// 徽标偏移 [x, y]。
  final List<double>? offset;

  /// 自定义徽标颜色。
  final Color? color;

  /// 状态点模式。
  final AntBadgeStatus? status;

  /// 状态文字（配合 status 使用）。
  final String? text;

  /// 包裹的内容。
  final Widget? child;

  /// 徽标数字容器尺寸。
  final double size;

  Color _resolveColor(AntThemeData theme) {
    if (color != null) return color!;
    if (status != null) {
      switch (status!) {
        case AntBadgeStatus.success:
          return theme.colorSuccess;
        case AntBadgeStatus.processing:
          return theme.colorPrimary;
        case AntBadgeStatus.standard:
          return theme.colorTextQuaternary;
        case AntBadgeStatus.error:
          return theme.colorError;
        case AntBadgeStatus.warning:
          return theme.colorWarning;
      }
    }
    return theme.colorError;
  }

  bool get _shouldShowCount {
    if (count == null) return false;
    if (count == 0 && !showZero) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final badgeColor = _resolveColor(theme);

    // 纯状态点 + 文字模式（无 child）
    if (status != null && child == null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
          ),
          if (text != null) ...[
            const SizedBox(width: 6),
            Text(
              text!,
              style: TextStyle(
                fontSize: theme.fontSizeSM,
                color: theme.colorText,
              ),
            ),
          ],
        ],
      );
    }

    if (child == null) {
      // 无 child 且无 status，返回纯徽标
      return _buildBadge(theme, badgeColor);
    }

    final dx = offset != null && offset!.isNotEmpty ? offset![0] : 0.0;
    final dy = offset != null && offset!.length >= 2 ? offset![1] : 0.0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        Positioned(
          top: -size * 0.35 + dy,
          right: -size * 0.35 + dx,
          child: _buildBadge(theme, badgeColor),
        ),
      ],
    );
  }

  Widget _buildBadge(AntThemeData theme, Color badgeColor) {
    if (dot) {
      return Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: badgeColor,
          shape: BoxShape.circle,
        ),
      );
    }

    if (!_shouldShowCount) return const SizedBox.shrink();

    final displayCount = count! > overflowCount ? '$overflowCount+' : '$count';

    return Container(
      constraints: BoxConstraints(
        minWidth: size,
        minHeight: size,
      ),
      padding: EdgeInsets.symmetric(horizontal: size * 0.2),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      alignment: Alignment.center,
      child: Text(
        displayCount,
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.6,
          fontWeight: FontWeight.w500,
          height: 1,
        ),
        maxLines: 1,
        textAlign: TextAlign.center,
      ),
    );
  }
}