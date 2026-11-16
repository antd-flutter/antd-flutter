/// AntSpace — antd React Space 的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [direction] — 排列方向（horizontal / vertical）
/// - [size] — 间距（预设 small / middle / large，单值，或水平垂直分别设置）
/// - [align] — 交叉轴对齐（start / end / center / baseline）
/// - [wrap] — 是否换行
/// - [split] — 子元素之间的分隔符
/// - [children] — 子元素
///
/// 间距令牌：small = marginXS(8)，middle = margin(16)，large = marginLG(24)。
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

import 'ant_space_types.dart';

// ============================================================
// AntSpace
// ============================================================

/// 间距 — 组件间设置间距，支持排列方向、间距大小和分隔符。
///
/// 对齐 antd React Space 组件，提供简洁的间距布局能力。
///
/// ```dart
/// AntSpace(children: [Text('A'), Text('B')]) // 水平间距
/// AntSpace(direction: AntSpaceDirection.vertical, children: [...]) // 垂直间距
/// AntSpace(size: AntSpaceSize.large(), children: [...]) // 大间距
/// AntSpace(split: AntDivider(type: AntDividerType.vertical), children: [...]) // 带分隔符
/// ```
class AntSpace extends StatelessWidget {
  const AntSpace({
    super.key,
    this.direction = AntSpaceDirection.horizontal,
    this.size,
    this.align,
    this.wrap = false,
    this.split,
    this.children = const [],
  });

  /// 排列方向。horizontal 为水平排列，vertical 为垂直排列。
  final AntSpaceDirection direction;

  /// 间距配置。支持预设尺寸、单值和水平垂直分别设置。
  final AntSpaceSize? size;

  /// 交叉轴对齐方式。默认 horizontal 为 center，vertical 为 start。
  final AntSpaceAlign? align;

  /// 是否换行。为 true 时子元素溢出后自动换行/换列。
  final bool wrap;

  /// 子元素之间的分隔符。
  final Widget? split;

  /// 子元素列表。
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final (hGap, vGap) = _resolveSize(theme);
    final isVertical = direction == AntSpaceDirection.vertical;

    // 有分隔符时手动插入间距和分隔符
    if (split != null) {
      final spacedChildren = _insertGapAndSplit(hGap, vGap);
      if (wrap) {
        return Wrap(
          direction: isVertical ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: _mapWrapCrossAlignment(align, isVertical),
          spacing: 0,
          runSpacing: 0,
          children: spacedChildren,
        );
      }
      return Flex(
        direction: isVertical ? Axis.vertical : Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: _mapCrossAxisAlignment(align, isVertical),
        textBaseline: align == AntSpaceAlign.baseline
            ? TextBaseline.alphabetic
            : null,
        children: spacedChildren,
      );
    }

    // 无分隔符
    if (wrap) {
      return Wrap(
        direction: isVertical ? Axis.vertical : Axis.horizontal,
        crossAxisAlignment: _mapWrapCrossAlignment(align, isVertical),
        spacing: (isVertical ? vGap : hGap) ?? 0,
        runSpacing: (isVertical ? hGap : vGap) ?? 0,
        children: children,
      );
    }

    return Flex(
      direction: isVertical ? Axis.vertical : Axis.horizontal,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: _mapCrossAxisAlignment(align, isVertical),
      textBaseline: align == AntSpaceAlign.baseline
          ? TextBaseline.alphabetic
          : null,
      children: _insertGap(hGap, vGap),
    );
  }

  /// 解析 size 配置为实际像素值（含 screenutil 缩放）。
  (double?, double?) _resolveSize(AntThemeData theme) {
    if (size == null) return (null, null);

    if (size!.preset != null) {
      final base = switch (size!.preset!) {
        AntSpaceGapSize.small => theme.marginXS,
        AntSpaceGapSize.middle => theme.margin,
        AntSpaceGapSize.large => theme.marginLG,
      };
      final value = base.w;
      return (value, value);
    }

    return (size!.horizontalValue?.w, size!.verticalValue?.w);
  }

  /// 在子元素间插入间距（无分隔符模式）。
  List<Widget> _insertGap(double? hGap, double? vGap) {
    if (children.length < 2) return children;

    final isVertical = direction == AntSpaceDirection.vertical;
    final effectiveGap = isVertical ? vGap : hGap;
    if (effectiveGap == null || effectiveGap <= 0) return children;

    final result = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        result.add(
          isVertical
              ? SizedBox(height: effectiveGap)
              : SizedBox(width: effectiveGap),
        );
      }
      result.add(children[i]);
    }
    return result;
  }

  /// 在子元素间插入间距和分隔符。
  ///
  /// 分隔符两侧各占间距的一半，总间距保持不变。
  List<Widget> _insertGapAndSplit(double? hGap, double? vGap) {
    if (children.length < 2) return children;

    final isVertical = direction == AntSpaceDirection.vertical;
    final effectiveGap = isVertical ? vGap : hGap;
    final halfGap =
        (effectiveGap != null && effectiveGap > 0) ? effectiveGap / 2 : 0.0;

    final result = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        if (halfGap > 0) {
          result.add(
            isVertical
                ? SizedBox(height: halfGap)
                : SizedBox(width: halfGap),
          );
        }
        result.add(split!);
        if (halfGap > 0) {
          result.add(
            isVertical
                ? SizedBox(height: halfGap)
                : SizedBox(width: halfGap),
          );
        }
      }
      result.add(children[i]);
    }
    return result;
  }

  /// 映射交叉轴对齐方式。
  ///
  /// 默认值：horizontal 为 center，vertical 为 start（对齐 antd React）。
  static CrossAxisAlignment _mapCrossAxisAlignment(
    AntSpaceAlign? align,
    bool isVertical,
  ) {
    if (align == null) {
      return isVertical ? CrossAxisAlignment.start : CrossAxisAlignment.center;
    }
    return switch (align) {
      AntSpaceAlign.start => CrossAxisAlignment.start,
      AntSpaceAlign.end => CrossAxisAlignment.end,
      AntSpaceAlign.center => CrossAxisAlignment.center,
      AntSpaceAlign.baseline => CrossAxisAlignment.baseline,
    };
  }

  /// 映射 Wrap 交叉轴对齐方式。
  ///
  /// Wrap 不支持 baseline，映射到 start。
  static WrapCrossAlignment _mapWrapCrossAlignment(
    AntSpaceAlign? align,
    bool isVertical,
  ) {
    if (align == null) {
      return isVertical ? WrapCrossAlignment.start : WrapCrossAlignment.center;
    }
    return switch (align) {
      AntSpaceAlign.start => WrapCrossAlignment.start,
      AntSpaceAlign.end => WrapCrossAlignment.end,
      AntSpaceAlign.center => WrapCrossAlignment.center,
      AntSpaceAlign.baseline => WrapCrossAlignment.start,
    };
  }
}