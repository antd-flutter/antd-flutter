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

/// Pull icon widget builder.
typedef ErCIPullIconBuilder = Widget Function(
    BuildContext context, ErIndicatorState state, double animation,);

/// Text widget builder.
typedef ErCITextBuilder = Widget Function(
    BuildContext context, ErIndicatorState state, String text,);

/// Message widget builder.
typedef ErCIMessageBuilder = Widget Function(
    BuildContext context, ErIndicatorState state, String text, DateTime dateTime,);

/// Default progress indicator size.
const _kDefaultProgressIndicatorSize = 20.0;

/// Default progress indicator stroke width.
const _kDefaultProgressIndicatorStrokeWidth = 2.0;

/// Classic indicator.
/// Base widget for [ErClassicHeader] and [ErClassicFooter].
class _ErClassicIndicator extends StatefulWidget {
  /// ErIndicator properties and state.
  final ErIndicatorState state;

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
  final String dragText;

  /// Text on [ErIndicatorMode.armed].
  final String armedText;

  /// Text on [ErIndicatorMode.ready].
  final String readyText;

  /// Text on [ErIndicatorMode.processing].
  final String processingText;

  /// Text on [ErIndicatorMode.processed].
  final String processedText;

  /// Text on [ErIndicatorResult.noMore].
  final String noMoreText;

  /// Text on [ErIndicatorResult.fail].
  final String failedText;

  /// Whether to display text.
  final bool showText;

  /// Message text.
  /// %T will be replaced with the last time.
  final String messageText;

  /// Whether to display message.
  final bool showMessage;

  /// The dimension of the text area.
  /// When less than 0, calculate the length of the text widget.
  final double? textDimension;

  /// The dimension of the icon area.
  final double iconDimension;

  /// Spacing between text and icon.
  final double spacing;

  /// True for up and left.
  /// False for down and right.
  final bool reverse;

  /// Icon when [ErIndicatorResult.success].
  final Widget? succeededIcon;

  /// Icon when [ErIndicatorResult.fail].
  final Widget? failedIcon;

  /// Icon when [ErIndicatorResult.noMore].
  final Widget? noMoreIcon;

  /// Icon on pull builder.
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

  const _ErClassicIndicator({
    super.key,
    required this.state,
    required this.mainAxisAlignment,
    this.backgroundColor,
    this.boxDecoration,
    required this.dragText,
    required this.armedText,
    required this.readyText,
    required this.processingText,
    required this.processedText,
    required this.noMoreText,
    required this.failedText,
    this.showText = true,
    required this.messageText,
    required this.reverse,
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
  }) : assert(
            mainAxisAlignment == MainAxisAlignment.start ||
                mainAxisAlignment == MainAxisAlignment.center ||
                mainAxisAlignment == MainAxisAlignment.end,
            'Only supports [MainAxisAlignment.center], [MainAxisAlignment.start] and [MainAxisAlignment.end].',);

  @override
  State<_ErClassicIndicator> createState() => _ClassicIndicatorState();
}

class _ClassicIndicatorState extends State<_ErClassicIndicator>
    with TickerProviderStateMixin<_ErClassicIndicator> {
  /// Icon [AnimatedSwitcher] switch key.
  late GlobalKey _iconAnimatedSwitcherKey;

  /// Update time.
  late DateTime _updateTime;

  /// Icon animation controller.
  late AnimationController _iconAnimationController;

  MainAxisAlignment get _mainAxisAlignment => widget.mainAxisAlignment;

  Axis get _axis => widget.state.axis;

  double get _offset => widget.state.offset;

  double get _actualTriggerOffset => widget.state.actualTriggerOffset;

  double get _triggerOffset => widget.state.triggerOffset;

  double get _safeOffset => widget.state.safeOffset;

  ErIndicatorMode get _mode => widget.state.mode;

  ErIndicatorResult get _result => widget.state.result;

  @override
  void initState() {
    super.initState();
    _iconAnimatedSwitcherKey = GlobalKey();
    _updateTime = DateTime.now();
    _iconAnimationController = AnimationController(
      value: 0,
      vsync: this,
      duration: const Duration(microseconds: 200),
    );
    _iconAnimationController.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(_ErClassicIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update time.
    if (widget.state.mode == ErIndicatorMode.processed &&
        oldWidget.state.mode != ErIndicatorMode.processed) {
      _updateTime = DateTime.now();
    }
    if (widget.state.mode == ErIndicatorMode.armed &&
        oldWidget.state.mode == ErIndicatorMode.drag) {
      // Armed animation.
      _iconAnimationController.animateTo(1,
          duration: const Duration(milliseconds: 200),);
    } else if (widget.state.mode == ErIndicatorMode.drag &&
        oldWidget.state.mode == ErIndicatorMode.armed) {
      // Recovery animation.
      _iconAnimationController.animateBack(0,
          duration: const Duration(milliseconds: 200),);
    } else if (widget.state.mode == ErIndicatorMode.processing &&
        oldWidget.state.mode != ErIndicatorMode.processing) {
      // Reset animation.
      _iconAnimationController.reset();
    }
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  /// The text of the current state.
  String get _currentText {
    if (_result == ErIndicatorResult.noMore) {
      return widget.noMoreText;
    }
    switch (_mode) {
      case ErIndicatorMode.drag:
        return widget.dragText;
      case ErIndicatorMode.armed:
        return widget.armedText;
      case ErIndicatorMode.ready:
        return widget.readyText;
      case ErIndicatorMode.processing:
        return widget.processingText;
      case ErIndicatorMode.processed:
      case ErIndicatorMode.done:
        if (_result == ErIndicatorResult.fail) {
          return widget.failedText;
        } else {
          return widget.processedText;
        }
      default:
        return widget.dragText;
    }
  }

  /// Message text.
  String get _messageText {
    if (widget.messageText.contains('%T')) {
      String fillChar = _updateTime.minute < 10 ? "0" : "";
      return widget.messageText.replaceAll(
          "%T", "${_updateTime.hour}:$fillChar${_updateTime.minute}",);
    }
    return widget.messageText;
  }

  /// Build icon.
  Widget _buildIcon() {
    if (widget.pullIconBuilder != null) {
      return widget.pullIconBuilder!
          .call(context, widget.state, _iconAnimationController.value);
    }
    Widget icon;
    final iconTheme = widget.iconTheme ?? Theme.of(context).iconTheme;
    ValueKey iconKey;
    if (_result == ErIndicatorResult.noMore) {
      iconKey = const ValueKey(ErIndicatorResult.noMore);
      icon = SizedBox(
        child: widget.noMoreIcon ??
            const Icon(
              Icons.inbox_outlined,
            ),
      );
    } else if (_mode == ErIndicatorMode.processing ||
        _mode == ErIndicatorMode.ready) {
      iconKey = const ValueKey(ErIndicatorMode.processing);
      final progressIndicatorSize =
          widget.progressIndicatorSize ?? _kDefaultProgressIndicatorSize;
      icon = SizedBox(
        width: progressIndicatorSize,
        height: progressIndicatorSize,
        child: CircularProgressIndicator(
          strokeWidth: widget.progressIndicatorStrokeWidth ??
              _kDefaultProgressIndicatorStrokeWidth,
          color: iconTheme.color,
        ),
      );
    } else if (_mode == ErIndicatorMode.processed ||
        _mode == ErIndicatorMode.done) {
      if (_result == ErIndicatorResult.fail) {
        iconKey = const ValueKey(ErIndicatorResult.fail);
        icon = SizedBox(
          child: widget.failedIcon ??
              const Icon(
                Icons.error_outline,
              ),
        );
      } else {
        iconKey = const ValueKey(ErIndicatorResult.success);
        icon = SizedBox(
          child: widget.succeededIcon ??
              Transform.rotate(
                angle: _axis == Axis.vertical ? 0 : -math.pi / 2,
                child: const Icon(
                  Icons.done,
                ),
              ),
        );
      }
    } else {
      iconKey = const ValueKey(ErIndicatorMode.drag);
      icon = SizedBox(
        child: Transform.rotate(
          angle: -math.pi * _iconAnimationController.value,
          child: Icon(widget.reverse
              ? (_axis == Axis.vertical ? Icons.arrow_upward : Icons.arrow_back)
              : (_axis == Axis.vertical
                  ? Icons.arrow_downward
                  : Icons.arrow_forward),),
        ),
      );
    }
    return AnimatedSwitcher(
      key: _iconAnimatedSwitcherKey,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      child: IconTheme(
        key: iconKey,
        data: iconTheme,
        child: icon,
      ),
    );
  }

  /// Build text.
  Widget _buildText() {
    return widget.textBuilder?.call(context, widget.state, _currentText) ??
        Text(
          _currentText,
          style: widget.textStyle ?? Theme.of(context).textTheme.titleMedium,
        );
  }

  /// Build text.
  Widget _buildMessage() {
    return widget.messageBuilder
            ?.call(context, widget.state, widget.messageText, _updateTime) ??
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            _messageText,
            style: widget.messageStyle ?? Theme.of(context).textTheme.bodySmall,
          ),
        );
  }

  /// When the list direction is vertically.
  Widget _buildVerticalWidget() {
    return Stack(
      clipBehavior: widget.clipBehavior,
      children: [
        if (_mainAxisAlignment == MainAxisAlignment.center)
          Positioned(
            left: 0,
            right: 0,
            top: _offset < _actualTriggerOffset
                ? -(_actualTriggerOffset -
                        _offset +
                        (widget.reverse ? _safeOffset : -_safeOffset)) /
                    2
                : (!widget.reverse ? _safeOffset : 0),
            bottom: _offset < _actualTriggerOffset
                ? null
                : (widget.reverse ? _safeOffset : 0),
            height:
                _offset < _actualTriggerOffset ? _actualTriggerOffset : null,
            child: Center(
              child: _buildVerticalBody(),
            ),
          ),
        if (_mainAxisAlignment != MainAxisAlignment.center)
          Positioned(
            left: 0,
            right: 0,
            top: _mainAxisAlignment == MainAxisAlignment.start
                ? (!widget.reverse ? _safeOffset : 0)
                : null,
            bottom: _mainAxisAlignment == MainAxisAlignment.end
                ? (widget.reverse ? _safeOffset : 0)
                : null,
            child: _buildVerticalBody(),
          ),
      ],
    );
  }

  /// The body when the list is vertically direction.
  Widget _buildVerticalBody() {
    return Container(
      alignment: Alignment.center,
      height: _triggerOffset,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            width: widget.iconDimension,
            child: _buildIcon(),
          ),
          if (widget.showText)
            Container(
              margin: EdgeInsets.only(left: widget.spacing),
              width: widget.textDimension,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildText(),
                  if (widget.showMessage) _buildMessage(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// When the list direction is horizontally.
  Widget _buildHorizontalWidget() {
    return Stack(
      clipBehavior: widget.clipBehavior,
      children: [
        if (_mainAxisAlignment == MainAxisAlignment.center)
          Positioned(
            left: _offset < _actualTriggerOffset
                ? -(_actualTriggerOffset -
                        _offset +
                        (widget.reverse ? _safeOffset : -_safeOffset)) /
                    2
                : (!widget.reverse ? _safeOffset : 0),
            right: _offset < _actualTriggerOffset
                ? null
                : (widget.reverse ? _safeOffset : 0),
            top: 0,
            bottom: 0,
            width: _offset < _actualTriggerOffset ? _actualTriggerOffset : null,
            child: Center(
              child: _buildHorizontalBody(),
            ),
          ),
        if (_mainAxisAlignment != MainAxisAlignment.center)
          Positioned(
            left: _mainAxisAlignment == MainAxisAlignment.start
                ? (!widget.reverse ? _safeOffset : 0)
                : null,
            right: _mainAxisAlignment == MainAxisAlignment.end
                ? (widget.reverse ? _safeOffset : 0)
                : null,
            top: 0,
            bottom: 0,
            child: _buildHorizontalBody(),
          ),
      ],
    );
  }

  /// The body when the list is horizontal direction.
  Widget _buildHorizontalBody() {
    return Container(
      alignment: Alignment.center,
      width: _triggerOffset,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.showText)
            Container(
              margin: EdgeInsets.only(bottom: widget.spacing),
              width: widget.textDimension,
              child: RotatedBox(
                quarterTurns: -1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildText(),
                    if (widget.showMessage) _buildMessage(),
                  ],
                ),
              ),
            ),
          Container(
            alignment: Alignment.center,
            height: widget.iconDimension,
            child: _buildIcon(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double offset = _offset;
    if (widget.state.indicator.infiniteOffset != null &&
        widget.state.indicator.position == ErIndicatorPosition.locator &&
        (_mode != ErIndicatorMode.inactive ||
            _result == ErIndicatorResult.noMore)) {
      offset = _actualTriggerOffset;
    }
    return Container(
      color: widget.boxDecoration == null ? widget.backgroundColor : null,
      decoration: widget.boxDecoration,
      width: _axis == Axis.vertical ? double.infinity : offset,
      height: _axis == Axis.horizontal ? double.infinity : offset,
      child: _axis == Axis.vertical
          ? _buildVerticalWidget()
          : _buildHorizontalWidget(),
    );
  }
}
