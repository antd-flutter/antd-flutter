/// AntRate — antd React Rate 的 Flutter 实现
///
/// API 与 antd React Rate 对齐：
/// - [value] / [defaultValue] — 受控/非受控评分
/// - [count] — 星星总数
/// - [onChange] — 评分变化回调
/// - [allowHalf] — 是否允许半选
/// - [allowClear] — 是否允许再次点击清除
/// - [disabled] — 是否禁用
/// - [character] — 自定义字符图标
///
/// ```dart
/// AntRate(
///   defaultValue: 3,
///   allowHalf: true,
///   onChange: (v) => print(v),
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_plus/src/components/data_entry/rate/ant_rate_types.dart';
import 'package:flutter/material.dart';

// ============================================================
// AntRate
// ============================================================

/// 评分 — 评分组件，支持半星与自定义图标。
///
/// 对齐 antd React Rate 组件。
class AntRate extends StatefulWidget {
  const AntRate({
    super.key,
    this.value,
    this.defaultValue = 0,
    this.count = 5,
    this.onChange,
    this.allowHalf = false,
    this.allowClear = false,
    this.disabled = false,
    this.character,
    this.autofocus = false,
  });

  /// 受控评分值。
  final double? value;

  /// 非受控初始评分。
  final double defaultValue;

  /// 星星总数。
  final int count;

  /// 评分变化回调。
  final ValueChanged<double>? onChange;

  /// 是否允许半选。
  final bool allowHalf;

  /// 是否允许再次点击清除。
  final bool allowClear;

  /// 是否禁用。
  final bool disabled;

  /// 自定义字符图标。
  final IconData? character;

  /// 是否自动聚焦。
  final bool autofocus;

  @override
  State<AntRate> createState() => _AntRateState();
}

class _AntRateState extends State<AntRate> {
  double _internalValue = 0;
  double _hoverValue = 0;

  double get _currentValue => widget.value ?? _internalValue;

  double get _displayValue =>
      _hoverValue > 0 ? _hoverValue : _currentValue;

  @override
  void initState() {
    super.initState();
    _internalValue = widget.defaultValue;
  }

  void _handleTap(int index, bool isLeftHalf) {
    if (widget.disabled) return;
    var newValue = (index + 1).toDouble();
    if (widget.allowHalf && isLeftHalf) {
      newValue = index + 0.5;
    }
    if (widget.allowClear && newValue == _currentValue) {
      newValue = 0;
    }
    _internalValue = newValue;
    widget.onChange?.call(newValue);
    if (mounted) setState(() {});
  }

  void _handleHover(int index, bool isLeftHalf) {
    if (widget.disabled) return;
    var value = (index + 1).toDouble();
    if (widget.allowHalf && isLeftHalf) {
      value = index + 0.5;
    }
    if (value != _hoverValue) {
      setState(() => _hoverValue = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final starSize = 20.w;
    final icon = widget.character ?? Icons.star;
    final activeColor =
        widget.disabled ? theme.colorTextDisabled : theme.colorWarning;
    final inactiveColor = theme.colorFillSecondary;

    return MouseRegion(
      onExit: widget.disabled
          ? null
          : (_) {
              if (_hoverValue != 0) setState(() => _hoverValue = 0);
            },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.count, (index) {
          final starValue = _displayValue - index;
          final filled = starValue >= 1;
          final half = starValue > 0 && starValue < 1;

          return MouseRegion(
            onHover: widget.disabled
                ? null
                : (event) {
                    final isLeftHalf =
                        event.localPosition.dx < starSize / 2;
                    _handleHover(index, isLeftHalf);
                  },
            child: GestureDetector(
              onTapUp: widget.disabled
                  ? null
                  : (details) {
                      final isLeftHalf =
                          details.localPosition.dx < starSize / 2;
                      _handleTap(index, isLeftHalf);
                    },
              onHorizontalDragUpdate: widget.disabled
                  ? null
                  : (details) {
                      final isLeftHalf =
                          details.localPosition.dx < starSize / 2;
                      _handleHover(index, isLeftHalf);
                    },
              child: Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: SizedBox(
                  width: starSize,
                  height: starSize,
                  child: _StarIcon(
                    icon: icon,
                    size: starSize,
                    filled: filled,
                    half: half,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ============================================================
// _StarIcon — 星星图标（支持半星）
// ============================================================

class _StarIcon extends StatelessWidget {
  const _StarIcon({
    required this.icon,
    required this.size,
    required this.filled,
    required this.half,
    required this.activeColor,
    required this.inactiveColor,
  });

  final IconData icon;
  final double size;
  final bool filled;
  final bool half;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return Icon(icon, size: size, color: activeColor);
    }
    if (half) {
      return Stack(
        children: [
          Icon(icon, size: size, color: inactiveColor),
          ClipRect(
            clipper: _HalfClipper(),
            child: Icon(icon, size: size, color: activeColor),
          ),
        ],
      );
    }
    return Icon(icon, size: size, color: inactiveColor);
  }
}

class _HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width / 2, size.height);
  }

  @override
  bool shouldReclip(covariant _HalfClipper oldClipper) => false;
}