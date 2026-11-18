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

/// Cupertino header.
/// https://github.com/THEONE10211024/WaterDropListView
class CupertinoHeader extends ErHeader {
  final Key? key;

  /// ErIndicator foreground color.
  final Color? foregroundColor;

  /// Use WaterDrop style.
  final bool userWaterDrop;

  /// WaterDrop background color.
  final Color? backgroundColor;

  /// Empty widget.
  /// When result is [ErIndicatorResult.noMore].
  final Widget? emptyWidget;

  const CupertinoHeader({
    this.key,
    super.triggerOffset = 60,
    super.clamping = false,
    super.position = ErIndicatorPosition.behind,
    super.processedDuration = Duration.zero,
    super.spring,
    super.readySpringBuilder,
    super.springRebound = false,
    FrictionFactor? frictionFactor,
    super.safeArea,
    super.infiniteOffset,
    super.hitOver,
    super.infiniteHitOver,
    super.hapticFeedback,
    super.triggerWhenRelease,
    super.maxOverOffset,
    this.foregroundColor,
    this.userWaterDrop = true,
    this.backgroundColor,
    this.emptyWidget,
  }) : super(
          frictionFactor: frictionFactor ??
              (userWaterDrop && infiniteOffset == null
                  ? kCupertinoFrictionFactor
                  : null),
          horizontalFrictionFactor: kCupertinoHorizontalFrictionFactor,
        );

  @override
  Widget build(BuildContext context, ErIndicatorState state) {
    return _CupertinoIndicator(
      key: key,
      state: state,
      reverse: state.reverse,
      foregroundColor: foregroundColor,
      userWaterDrop: userWaterDrop,
      backgroundColor: backgroundColor,
      emptyWidget: emptyWidget,
    );
  }
}
