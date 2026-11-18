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
part of '../../../../easy_refresh.dart';

/// Bezier footer.
class BezierFooter extends ErFooter {
  final Key? key;

  /// Show the ball during the pull.
  final bool showBalls;

  /// Spin widget.
  final Widget? spinWidget;

  /// No more widget.
  final Widget? noMoreWidget;

  /// Spin widget builder.
  final BezierSpinBuilder? spinBuilder;

  /// Foreground color.
  final Color? foregroundColor;

  /// Background color.
  final Color? backgroundColor;

  /// Whether the spin widget is in the center.
  final bool spinInCenter;

  /// Only display the spin.
  /// When true, the balls are no longer displayed.
  final bool onlySpin;

  const BezierFooter({
    this.key,
    super.triggerOffset = 100,
    super.clamping = false,
    super.position,
    super.processedDuration = kBezierBackgroundDisappearDuration,
    super.spring,
    ErSpringBuilder super.readySpringBuilder = kBezierSpringBuilder,
    super.springRebound = false,
    FrictionFactor super.frictionFactor = kBezierFrictionFactor,
    super.safeArea,
    super.infiniteOffset = null,
    super.hitOver,
    super.infiniteHitOver,
    super.hapticFeedback,
    this.showBalls = true,
    this.spinInCenter = true,
    this.onlySpin = false,
    this.spinWidget,
    this.noMoreWidget,
    this.spinBuilder,
    this.foregroundColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, ErIndicatorState state) {
    return _BezierIndicator(
      key: key,
      state: state,
      reverse: !state.reverse,
      processedDuration: processedDuration,
      showBalls: showBalls,
      spinInCenter: spinInCenter,
      onlySpin: onlySpin,
      spinWidget: spinWidget,
      noMoreWidget: noMoreWidget,
      spinBuilder: spinBuilder,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
    );
  }
}
