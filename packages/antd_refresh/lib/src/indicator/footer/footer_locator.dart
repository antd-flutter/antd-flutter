// Copyright (c) 2021 xuelongqy (easy_refresh authors)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//
// 来源：easy_refresh v3.5.0 (https://pub.dev/packages/easy_refresh)，MIT License。
// 完整移植复刻到 antd_refresh 包，类名加 Er 前缀以隔离命名空间。
part of '../../../easy_refresh.dart';

/// Find ErFooter's Location
/// Put the last item in the list
/// it will smartly show ErFooter
class ErFooterLocator extends StatelessWidget {
  final bool _isSliver;

  /// Link [SliverGeometry.paintExtent].
  /// Extent that is always maintained.
  final double paintExtent;

  /// Whether to calculate the extent.
  /// When true, extent is always 0.
  final bool clearExtent;

  /// Use in Box
  const ErFooterLocator({
    super.key,
    this.paintExtent = 0,
    this.clearExtent = true,
  }) : _isSliver = false;

  /// User in Sliver
  const ErFooterLocator.sliver({
    super.key,
    this.paintExtent = 0,
    this.clearExtent = true,
  }) : _isSliver = true;

  @override
  Widget build(BuildContext context) {
    final footerNotifier = ErRefresh.of(context).footerNotifier;
    assert(
        footerNotifier.iPosition == ErIndicatorPosition.locator ||
            footerNotifier.iPosition == ErIndicatorPosition.custom,
        'Cannot use ErFooterLocator when header position is not ErIndicatorPosition.locator.',);
    return ValueListenableBuilder(
      valueListenable: footerNotifier.listenable(),
      builder: (ctx, notifier, _) {
        if (footerNotifier.axis != null) {
          // Axis and direction.
          final axis = footerNotifier.axis!;
          final axisDirection = footerNotifier.axisDirection!;
          // Set safe area offset.
          final safePadding = MediaQuery.of(context).padding;
          footerNotifier._safeOffset = axis == Axis.vertical
              ? axisDirection == AxisDirection.down
                  ? safePadding.bottom
                  : safePadding.top
              : axisDirection == AxisDirection.right
                  ? safePadding.right
                  : safePadding.left;
        }
        final footerWidget = footerNotifier._build(context);
        if (!clearExtent) {
          return _isSliver
              ? SliverToBoxAdapter(
                  child: footerWidget,
                )
              : footerWidget;
        }
        return _FooterLocatorRenderWidget(
          isSliver: _isSliver,
          paintExtent: paintExtent,
          child: footerWidget,
        );
      },
    );
  }
}

class _FooterLocatorRenderWidget extends SingleChildRenderObjectWidget {
  final bool isSliver;

  final double paintExtent;

  const _FooterLocatorRenderWidget({
    required super.child,
    required this.isSliver,
    required this.paintExtent,
  });

  @override
  RenderObject createRenderObject(BuildContext context) => isSliver
      ? _FooterLocatorRenderSliver(
          context: context,
          paintExtent: paintExtent,
        )
      : _FooterLocatorRenderBox(
          context: context,
          paintExtent: paintExtent,
        );
}

/// User in Box
class _FooterLocatorRenderBox extends RenderProxyBox {
  final BuildContext context;

  final double paintExtent;

  _FooterLocatorRenderBox({
    required this.context,
    required this.paintExtent,
    RenderBox? child,
  }) : super(child);

  @override
  final bool needsCompositing = true;

  @override
  void performLayout() {
    final footerNotifier = ErRefresh.of(context).footerNotifier;
    final axis = footerNotifier.axis;
    final double extend = paintExtent == 0
        ? (footerNotifier.offset == 0 ? 0 : 0.0000000001)
        : paintExtent;
    if (axis == null) {
      size = constraints.smallest;
    } else {
      size = Size(
        constraints
            .constrainWidth(axis == Axis.vertical ? double.infinity : extend),

        /// Not 0 will be paint
        constraints
            .constrainHeight(axis == Axis.vertical ? extend : double.infinity),
      );
    }
    if (child != null) {
      child!.layout(constraints, parentUsesSize: true);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final footerNotifier = ErRefresh.of(this.context).footerNotifier;
    final axis = footerNotifier.axis;
    final axisDirection = footerNotifier.axisDirection;
    final extend = footerNotifier.offset;
    Offset mOffset;
    if (axis == null || axisDirection == null) {
      mOffset = offset;
    } else {
      final double dx = axis == Axis.vertical
          ? 0
          : axisDirection == AxisDirection.left
              ? -extend
              : 0;
      final double dy = axis == Axis.horizontal
          ? 0
          : axisDirection == AxisDirection.up
              ? -extend
              : 0;
      mOffset = Offset(dx, dy);
    }
    if (child != null) {
      context.paintChild(child!, mOffset);
    }
  }
}

/// User in Sliver
class _FooterLocatorRenderSliver extends RenderSliverSingleBoxAdapter {
  final BuildContext context;

  final double paintExtent;

  _FooterLocatorRenderSliver({
    required this.context,
    required this.paintExtent,
    // ignore: unused_element_parameter
    super.child,
  });

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    final SliverConstraints constraints = this.constraints;
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0, to: childExtent);
    // final double cacheExtent =
    //     calculateCacheOffset(constraints, from: 0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0);
    final footerNotifier = ErRefresh.of(context).footerNotifier;
    geometry = SliverGeometry(
      scrollExtent: 0,
      paintExtent: math.min(childExtent, paintExtent),
      paintOrigin: constraints.axisDirection == AxisDirection.down ||
              constraints.axisDirection == AxisDirection.right
          ? 0
          : math.min(footerNotifier.offset, constraints.remainingPaintExtent),
      // No cache extent.
      cacheExtent: math.min(childExtent, paintExtent),
      maxPaintExtent: math.max(childExtent, paintExtent),
      hitTestExtent: math.max(childExtent, paintedChildSize),
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0,
      visible: true,
    );
    setChildParentData(child!, constraints.copyWith(), geometry!);
  }
}
