/// AntGrid — antd React Grid (Row/Col) 的 Flutter 实现
///
/// 24 栅格布局系统，API 与 antd React 对齐：
/// - [AntRow] — 栅格行容器
///   - [AntRow.align] — 垂直对齐（top / middle / bottom）
///   - [AntRow.justify] — 水平分布（start / end / center / spaceAround / spaceBetween）
///   - [AntRow.gutter] — 栅格间距（水平方向）
///   - [AntRow.verticalGutter] — 垂直间距（wrap 换行时生效）
///   - [AntRow.wrap] — 是否允许换行
/// - [AntCol] — 栅格列
///   - [AntCol.span] — 栅格占位（1-24）
///   - [AntCol.offset] — 栅格左侧偏移（0-24）
///   - [AntCol.flex] — flex 弹性布局（设置后忽略 span）
///
/// 栅格宽度基于行宽的 span/24 比例计算；gutter 通过列内边距实现。
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_grid_types.dart';

// ============================================================
// AntRow
// ============================================================

/// 栅格行 — 24 栅格系统的行容器。
///
/// 对齐 antd React Row 组件，配合 [AntCol] 实现栅格布局。
///
/// ```dart
/// AntRow(
///   gutter: 16,
///   children: [
///     AntCol(span: 12, child: Text('左半')),
///     AntCol(span: 12, child: Text('右半')),
///   ],
/// )
/// ```
class AntRow extends StatelessWidget {
  const AntRow({
    super.key,
    this.align = AntRowAlign.top,
    this.justify = AntRowJustify.start,
    this.gutter = 0,
    this.verticalGutter,
    this.wrap = false,
    this.children = const [],
  });

  /// 垂直对齐方式。默认 top。
  final AntRowAlign align;

  /// 水平分布方式。默认 start。
  final AntRowJustify justify;

  /// 栅格间距（水平方向，逻辑像素，自动缩放）。
  final double gutter;

  /// 垂直间距（wrap 换行时行与行之间的间距）。
  final double? verticalGutter;

  /// 是否允许换行。总 span 超过 24 时自动换行。
  final bool wrap;

  /// 子元素列表，通常为 [AntCol]。
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final hGutter = gutter.w;
    final vGutter = (verticalGutter ?? 0).w;

    return LayoutBuilder(
      builder: (context, constraints) {
        return _AntGridScope(
          rowWidth: constraints.maxWidth,
          gutter: hGutter,
          verticalGutter: vGutter,
          child: wrap
              ? Wrap(
                  alignment: _mapWrapAlignment(justify),
                  crossAxisAlignment: _mapWrapCrossAlignment(align),
                  children: children,
                )
              : Row(
                  mainAxisAlignment: _mapMainAxisAlignment(justify),
                  crossAxisAlignment: _mapCrossAxisAlignment(align),
                  children: children,
                ),
        );
      },
    );
  }

  /// 映射主轴分布方式。
  static MainAxisAlignment _mapMainAxisAlignment(AntRowJustify justify) {
    return switch (justify) {
      AntRowJustify.start => MainAxisAlignment.start,
      AntRowJustify.end => MainAxisAlignment.end,
      AntRowJustify.center => MainAxisAlignment.center,
      AntRowJustify.spaceAround => MainAxisAlignment.spaceAround,
      AntRowJustify.spaceBetween => MainAxisAlignment.spaceBetween,
    };
  }

  /// 映射交叉轴对齐方式。
  static CrossAxisAlignment _mapCrossAxisAlignment(AntRowAlign align) {
    return switch (align) {
      AntRowAlign.top => CrossAxisAlignment.start,
      AntRowAlign.middle => CrossAxisAlignment.center,
      AntRowAlign.bottom => CrossAxisAlignment.end,
    };
  }

  /// 映射 Wrap 主轴分布方式。
  static WrapAlignment _mapWrapAlignment(AntRowJustify justify) {
    return switch (justify) {
      AntRowJustify.start => WrapAlignment.start,
      AntRowJustify.end => WrapAlignment.end,
      AntRowJustify.center => WrapAlignment.center,
      AntRowJustify.spaceAround => WrapAlignment.spaceAround,
      AntRowJustify.spaceBetween => WrapAlignment.spaceBetween,
    };
  }

  /// 映射 Wrap 交叉轴对齐方式。
  static WrapCrossAlignment _mapWrapCrossAlignment(AntRowAlign align) {
    return switch (align) {
      AntRowAlign.top => WrapCrossAlignment.start,
      AntRowAlign.middle => WrapCrossAlignment.center,
      AntRowAlign.bottom => WrapCrossAlignment.end,
    };
  }
}

// ============================================================
// AntCol
// ============================================================

/// 栅格列 — 24 栅格系统的列容器。
///
/// 对齐 antd React Col 组件，须在 [AntRow] 内使用。
///
/// ```dart
/// AntCol(span: 8, child: Text('1/3'))
/// AntCol(span: 8, offset: 8, child: Text('偏移1/3'))
/// AntCol(flex: 1, child: Text('弹性'))
/// ```
class AntCol extends StatelessWidget {
  const AntCol({
    super.key,
    this.span,
    this.offset = 0,
    this.flex,
    this.child,
  });

  /// 栅格占位，取值 1-24。为 null 时列宽由内容决定。
  final int? span;

  /// 栅格左侧偏移，取值 0-24。默认 0。
  final int offset;

  /// flex 弹性值。设置后列按 flex 比例分配剩余空间，忽略 span。
  final double? flex;

  /// 子元素。
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final scope = _AntGridScope.maybeOf(context);

    Widget content = child ?? const SizedBox.shrink();

    // 不在 AntRow 内 — 按内容尺寸渲染
    if (scope == null) {
      return content;
    }

    // gutter 通过列内边距实现（与 antd 一致）
    if (scope.gutter > 0 || scope.verticalGutter > 0) {
      content = Padding(
        padding: EdgeInsets.symmetric(
          horizontal: scope.gutter / 2,
          vertical: scope.verticalGutter / 2,
        ),
        child: content,
      );
    }

    // flex 模式 — 按比例分配剩余空间
    final flexValue = flex;
    if (flexValue != null) {
      return Flexible(
        flex: flexValue.round().clamp(1, 10000),
        child: content,
      );
    }

    // span 模式 — 固定宽度 = 行宽 × span / 24
    final spanValue = span;
    if (spanValue != null && scope.rowWidth.isFinite) {
      final colWidth = scope.rowWidth * spanValue / 24;
      Widget result = SizedBox(width: colWidth, child: content);
      if (offset > 0) {
        result = Padding(
          padding: EdgeInsets.only(left: scope.rowWidth * offset / 24),
          child: result,
        );
      }
      return result;
    }

    return content;
  }
}

// ============================================================
// _AntGridScope — 行信息传递
// ============================================================

class _AntGridScope extends InheritedWidget {
  const _AntGridScope({
    required this.rowWidth,
    required this.gutter,
    required this.verticalGutter,
    required super.child,
  });

  /// 行可用宽度。
  final double rowWidth;

  /// 水平间距（已缩放）。
  final double gutter;

  /// 垂直间距（已缩放）。
  final double verticalGutter;

  static _AntGridScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_AntGridScope>();
  }

  @override
  bool updateShouldNotify(_AntGridScope oldWidget) {
    return rowWidth != oldWidget.rowWidth ||
        gutter != oldWidget.gutter ||
        verticalGutter != oldWidget.verticalGutter;
  }
}