/// AntFlex — antd React Flex 的 Flutter 实现
///
/// API 与 antd React 对齐：
/// - [vertical] — 垂直排列（true 为 Column 方向，false 为 Row 方向）
/// - [wrap] — 是否换行
/// - [justify] — 主轴对齐（start / end / center / spaceBetween / spaceAround / spaceEvenly）
/// - [align] — 交叉轴对齐（start / end / center / baseline / stretch）
/// - [gap] — 间距（预设 small / middle / large，单值，或行列分别设置）
/// - [mainAxisSize] — 主轴尺寸（Flutter 扩展，max 占满 / min 紧贴子元素）
/// - [children] — 子元素
///
/// 间距令牌：small = marginXS(8)，middle = margin(16)，large = marginLG(24)。
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_flex_types.dart';

// ============================================================
// AntFlex
// ============================================================

/// 弹性布局 — 高效的对齐、间隔和分布子元素容器。
///
/// 对齐 antd React Flex 组件，提供简洁的 flex 布局能力。
///
/// ```dart
/// AntFlex(children: [Text('A'), Text('B')]) // 水平排列
/// AntFlex(vertical: true, gap: AntFlexGap.middle(), children: [...]) // 垂直排列带间距
/// AntFlex(justify: AntFlexJustify.center, align: AntFlexAlign.center, children: [...]) // 居中
/// AntFlex(wrap: true, gap: AntFlexGap.all(8), children: [...]) // 换行
/// ```
class AntFlex extends StatelessWidget {
  const AntFlex({
    super.key,
    this.vertical = false,
    this.wrap = false,
    this.justify = AntFlexJustify.start,
    this.align = AntFlexAlign.start,
    this.gap,
    this.mainAxisSize = MainAxisSize.max,
    this.children = const [],
  });

  /// 是否垂直排列。true 时主轴为垂直方向，false 为水平方向。
  final bool vertical;

  /// 是否换行。为 true 时子元素溢出后自动换行/换列。
  final bool wrap;

  /// 主轴对齐方式。
  final AntFlexJustify justify;

  /// 交叉轴对齐方式。
  final AntFlexAlign align;

  /// 间距配置。支持预设尺寸、单值和行列分别设置。
  final AntFlexGap? gap;

  /// 主轴尺寸。max 占满主轴可用空间，min 紧贴子元素。
  final MainAxisSize mainAxisSize;

  /// 子元素列表。
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final (rowGap, columnGap) = _resolveGap(theme);

    if (wrap) {
      return Wrap(
        direction: vertical ? Axis.vertical : Axis.horizontal,
        alignment: _mapWrapAlignment(justify),
        crossAxisAlignment: _mapWrapCrossAlignment(align),
        spacing: (vertical ? rowGap : columnGap) ?? 0,
        runSpacing: (vertical ? columnGap : rowGap) ?? 0,
        children: children,
      );
    }

    return Flex(
      direction: vertical ? Axis.vertical : Axis.horizontal,
      mainAxisAlignment: _mapMainAxisAlignment(justify),
      crossAxisAlignment: _mapCrossAxisAlignment(align),
      mainAxisSize: mainAxisSize,
      textBaseline: align == AntFlexAlign.baseline
          ? TextBaseline.alphabetic
          : null,
      children: _insertGap(rowGap, columnGap),
    );
  }

  /// 解析 gap 配置为实际像素值（含 screenutil 缩放）。
  (double?, double?) _resolveGap(AntThemeData theme) {
    if (gap == null) return (null, null);

    if (gap!.size != null) {
      final base = switch (gap!.size!) {
        AntFlexGapSize.small => theme.marginXS,
        AntFlexGapSize.middle => theme.margin,
        AntFlexGapSize.large => theme.marginLG,
      };
      final value = base.w;
      return (value, value);
    }

    return (gap!.rowValue?.w, gap!.columnValue?.w);
  }

  /// 在子元素间插入间距（非换行模式）。
  List<Widget> _insertGap(double? rowGap, double? columnGap) {
    if (children.length < 2) return children;

    final effectiveGap = vertical ? rowGap : columnGap;
    if (effectiveGap == null || effectiveGap <= 0) return children;

    final result = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        result.add(
          vertical
              ? SizedBox(height: effectiveGap)
              : SizedBox(width: effectiveGap),
        );
      }
      result.add(children[i]);
    }
    return result;
  }

  /// 映射主轴对齐方式。
  static MainAxisAlignment _mapMainAxisAlignment(AntFlexJustify justify) {
    return switch (justify) {
      AntFlexJustify.start => MainAxisAlignment.start,
      AntFlexJustify.end => MainAxisAlignment.end,
      AntFlexJustify.center => MainAxisAlignment.center,
      AntFlexJustify.spaceBetween => MainAxisAlignment.spaceBetween,
      AntFlexJustify.spaceAround => MainAxisAlignment.spaceAround,
      AntFlexJustify.spaceEvenly => MainAxisAlignment.spaceEvenly,
    };
  }

  /// 映射交叉轴对齐方式。
  static CrossAxisAlignment _mapCrossAxisAlignment(AntFlexAlign align) {
    return switch (align) {
      AntFlexAlign.start => CrossAxisAlignment.start,
      AntFlexAlign.end => CrossAxisAlignment.end,
      AntFlexAlign.center => CrossAxisAlignment.center,
      AntFlexAlign.baseline => CrossAxisAlignment.baseline,
      AntFlexAlign.stretch => CrossAxisAlignment.stretch,
    };
  }

  /// 映射 Wrap 主轴对齐方式。
  static WrapAlignment _mapWrapAlignment(AntFlexJustify justify) {
    return switch (justify) {
      AntFlexJustify.start => WrapAlignment.start,
      AntFlexJustify.end => WrapAlignment.end,
      AntFlexJustify.center => WrapAlignment.center,
      AntFlexJustify.spaceBetween => WrapAlignment.spaceBetween,
      AntFlexJustify.spaceAround => WrapAlignment.spaceAround,
      AntFlexJustify.spaceEvenly => WrapAlignment.spaceEvenly,
    };
  }

  /// 映射 Wrap 交叉轴对齐方式。
  ///
  /// Wrap 不支持 baseline 和 stretch，映射到 start。
  static WrapCrossAlignment _mapWrapCrossAlignment(AntFlexAlign align) {
    return switch (align) {
      AntFlexAlign.start => WrapCrossAlignment.start,
      AntFlexAlign.end => WrapCrossAlignment.end,
      AntFlexAlign.center => WrapCrossAlignment.center,
      AntFlexAlign.baseline => WrapCrossAlignment.start,
      AntFlexAlign.stretch => WrapCrossAlignment.start,
    };
  }
}