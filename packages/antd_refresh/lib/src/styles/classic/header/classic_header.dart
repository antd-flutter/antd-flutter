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

/// Classic header.
class ErClassicHeader extends ErHeader {
  final Key? key;

  /// The location of the widget.
  /// Only supports [MainAxisAlignment.center],
  /// [MainAxisAlignment.start] and [MainAxisAlignment.end].
  final MainAxisAlignment mainAxisAlignment;

  /// Background color.
  /// Ignored if [boxDecoration] is not null.
  final Color? backgroundColor;

  /// Box decoration.
  final BoxDecoration? boxDecoration;

  /// Text on [ErIndicatorMode.drag].
  final String? dragText;

  /// Text on [ErIndicatorMode.armed].
  final String? armedText;

  /// Text on [ErIndicatorMode.ready].
  final String? readyText;

  /// Text on [ErIndicatorMode.processing].
  final String? processingText;

  /// Text on [ErIndicatorMode.processed].
  final String? processedText;

  /// Text on [ErIndicatorResult.noMore].
  final String? noMoreText;

  /// Text on [ErIndicatorResult.fail].
  final String? failedText;

  /// Whether to display text.
  final bool showText;

  /// Message text.
  /// %T will be replaced with the last time.
  final String? messageText;

  /// Whether to display message.
  final bool showMessage;

  /// The dimension of the text area.
  /// When less than 0, calculate the length of the text widget.
  final double? textDimension;

  /// The dimension of the icon area.
  final double iconDimension;

  /// Spacing between text and icon.
  final double spacing;

  /// Icon when [ErIndicatorResult.success].
  final Widget? succeededIcon;

  /// Icon when [ErIndicatorResult.fail].
  final Widget? failedIcon;

  /// Icon when [ErIndicatorResult.noMore].
  final Widget? noMoreIcon;

  /// Icon on pull.
  final ErCIPullIconBuilder? pullIconBuilder;

  /// Text style.
  final TextStyle? textStyle;

  /// Build text.
  final ErCITextBuilder? textBuilder;

  /// Text style.
  final TextStyle? messageStyle;

  /// Build message.
  final ErCIMessageBuilder? messageBuilder;

  /// Link [Stack.clipBehavior].
  final Clip clipBehavior;

  /// Icon style.
  final IconThemeData? iconTheme;

  /// Progress indicator size.
  final double? progressIndicatorSize;

  /// Progress indicator stroke width.
  /// See [CircularProgressIndicator.strokeWidth].
  final double? progressIndicatorStrokeWidth;

  const ErClassicHeader({
    this.key,
    super.triggerOffset = 70,
    super.clamping = false,
    super.position,
    super.processedDuration,
    super.spring,
    super.readySpringBuilder,
    super.springRebound,
    super.frictionFactor,
    super.safeArea,
    super.infiniteOffset,
    super.hitOver,
    super.infiniteHitOver,
    super.hapticFeedback,
    super.triggerWhenReach,
    super.triggerWhenRelease,
    super.maxOverOffset,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.backgroundColor,
    this.boxDecoration,
    this.dragText,
    this.armedText,
    this.readyText,
    this.processingText,
    this.processedText,
    this.noMoreText,
    this.failedText,
    this.showText = true,
    this.messageText,
    this.showMessage = true,
    this.textDimension,
    this.iconDimension = 24,
    this.spacing = 16,
    this.succeededIcon,
    this.failedIcon,
    this.noMoreIcon,
    this.pullIconBuilder,
    this.textStyle,
    this.textBuilder,
    this.messageStyle,
    this.messageBuilder,
    this.clipBehavior = Clip.hardEdge,
    this.iconTheme,
    this.progressIndicatorSize,
    this.progressIndicatorStrokeWidth,
  });

  @override
  Widget build(BuildContext context, ErIndicatorState state) {
    return _ErClassicIndicator(
      key: key,
      state: state,
      backgroundColor: backgroundColor,
      boxDecoration: boxDecoration,
      mainAxisAlignment: mainAxisAlignment,
      dragText: dragText ?? 'Pull to refresh',
      armedText: armedText ?? 'Release ready',
      readyText: readyText ?? 'Refreshing...',
      processingText: processingText ?? 'Refreshing...',
      processedText: processedText ?? 'Succeeded',
      noMoreText: noMoreText ?? 'No more',
      failedText: failedText ?? 'Failed',
      showText: showText,
      messageText: messageText ?? 'Last updated at %T',
      showMessage: showMessage,
      textDimension: textDimension,
      iconDimension: iconDimension,
      spacing: spacing,
      reverse: state.reverse,
      succeededIcon: succeededIcon,
      failedIcon: failedIcon,
      noMoreIcon: noMoreIcon,
      pullIconBuilder: pullIconBuilder,
      textStyle: textStyle,
      textBuilder: textBuilder,
      messageStyle: messageStyle,
      messageBuilder: messageBuilder,
      clipBehavior: clipBehavior,
      iconTheme: iconTheme,
      progressIndicatorSize: progressIndicatorSize,
      progressIndicatorStrokeWidth: progressIndicatorStrokeWidth,
    );
  }
}
