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
part of '../../easy_refresh.dart';

/// The default opening speed of the secondary.
const kErDefaultSecondaryVelocity = 3000.0;

/// The default secondary close trigger offset.
const kErDefaultSecondaryCloseTriggerOffset = 70.0;

/// Build spring with [ErIndicatorMode] and offset.
/// [mode] ErIndicator mode.
/// [offset] ErIndicator offset.
/// [actualTriggerOffset] ErIndicator actual trigger offset.
/// [velocity] ErIndicator actual trigger offset.
typedef ErSpringBuilder = physics.SpringDescription Function({
  required ErIndicatorMode mode,
  required double offset,
  required double actualTriggerOffset,
  required double velocity,
});

/// The current state of the indicator ([ErHeader] or [ErFooter]).
enum ErIndicatorMode {
  /// Default state, without any trigger conditions.
  /// At this time [ErHeader] or [ErFooter] is not displayed.
  /// Return to this state after the task is completed.
  inactive,

  /// Overscroll but not reached the trigger mission distance.
  /// This state is released and the [Scrollable] is restored.
  drag,

  /// Overscroll and reach the trigger task distance.
  /// This state is released and the list triggers the task.
  armed,

  /// Overscroll and about to trigger a task.
  /// This state indicates that the user has released.
  ready,

  /// Task in progress.
  /// In progress until the task is completed.
  processing,

  /// Task completed.
  /// The task is over, but the whole process is not complete.
  /// Set the ending animation, which will be done after this state.
  processed,

  /// Overscroll and reach the secondary trigger task distance.
  /// This state is released, and open the secondary page.
  secondaryArmed,

  /// Overscroll and about to open the secondary page.
  /// This state indicates that the user has released.
  secondaryReady,

  /// Secondary page is open.
  secondaryOpen,

  /// Secondary page is closing.
  secondaryClosing,

  /// The whole process is done.
  /// When finished, go back to [inactive]
  done,
}

/// The status returned after the task is completed.
enum ErIndicatorResult {
  /// No state until the task is not triggered.
  none,

  /// Task succeeded.
  success,

  /// Task failed.
  fail,

  /// No more data.
  noMore,
}

/// The position of the indicator.
enum ErIndicatorPosition {
  /// Above the content.
  /// Above in [Stack] layout.
  above,

  /// Behind the content.
  /// Below in the [Stack] layout.
  behind,

  /// Use locator.
  /// Use [ErHeaderLocator] or [ErFooterLocator] in [ScrollView].
  locator,

  /// Customize the indicator anywhere.
  /// ErIndicator widget will not be build in ErRefresh.
  custom,
}

/// ErIndicator properties and state.
class ErIndicatorState {
  /// Refresh and loading indicator.
  final ErIndicator indicator;

  /// Refresh and loading notifier.
  final ErIndicatorNotifier notifier;

  /// User offset notifier.
  final ValueNotifier<bool> userOffsetNotifier;

  /// Refresh and loading state.
  final ErIndicatorMode mode;

  /// Task completion result.
  final ErIndicatorResult result;

  /// Overscroll offset.
  final double offset;

  /// Safe area offset.
  final double safeOffset;

  /// [Scrollable] axis.
  final Axis axis;

  /// [Scrollable] axis direction.
  final AxisDirection axisDirection;

  /// [Scrollable] viewport dimension.
  /// It's helpful for full screen indicator and second floor views.
  final double viewportDimension;

  /// The offset of the trigger task.
  double get triggerOffset => indicator.triggerOffset;

  /// Actual trigger offset.
  /// [triggerOffset] + [safeOffset]
  final double actualTriggerOffset;

  /// Trigger offset for secondary.
  double? get secondaryTriggerOffset => indicator.secondaryTriggerOffset;

  /// Actual secondary trigger offset.
  double? get actualSecondaryTriggerOffset =>
      notifier.actualSecondaryTriggerOffset;

  /// Whether the scroll view direction is reversed.
  /// [AxisDirection.up] or [AxisDirection.left]
  bool get reverse =>
      axisDirection == AxisDirection.up || axisDirection == AxisDirection.left;

  const ErIndicatorState({
    required this.indicator,
    required this.notifier,
    required this.userOffsetNotifier,
    required this.mode,
    required this.result,
    required this.offset,
    required this.safeOffset,
    required this.axis,
    required this.axisDirection,
    required this.viewportDimension,
    required this.actualTriggerOffset,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErIndicatorState &&
          runtimeType == other.runtimeType &&
          indicator == other.indicator &&
          notifier == other.notifier &&
          mode == other.mode &&
          result == other.result &&
          offset == other.offset &&
          safeOffset == other.safeOffset &&
          axis == other.axis &&
          axisDirection == other.axisDirection &&
          viewportDimension == other.viewportDimension &&
          actualTriggerOffset == other.actualTriggerOffset;

  @override
  int get hashCode =>
      indicator.hashCode ^
      notifier.hashCode ^
      mode.hashCode ^
      result.hashCode ^
      offset.hashCode ^
      safeOffset.hashCode ^
      axis.hashCode ^
      axisDirection.hashCode ^
      viewportDimension.hashCode ^
      actualTriggerOffset.hashCode;

  @override
  String toString() {
    return 'ErIndicatorState{indicator: $indicator, notifier: $notifier, userOffsetNotifier: $userOffsetNotifier, mode: $mode, result: $result, offset: $offset, safeOffset: $safeOffset, axis: $axis, axisDirection: $axisDirection, viewportDimension: $viewportDimension, actualTriggerOffset: $actualTriggerOffset}';
  }
}

/// ErIndicator widget builder.
typedef ErIndicatorBuilder = Widget Function(
    BuildContext context, ErIndicatorState state,);

/// Secondary indicator widget builder.
typedef ErSecondaryIndicatorBuilder = Widget Function(
    BuildContext context, ErIndicatorState state, ErIndicator indicator,);

/// ErIndicator state listenable.
class ErIndicatorStateListenable extends ValueListenable<ErIndicatorState?> {
  /// ErIndicator notifier.
  ErIndicatorNotifier? _indicatorNotifier;

  /// ErIndicator state listeners.
  final List<VoidCallback> _listeners = [];

  /// Bind [ErIndicatorNotifier].
  void _bind(ErIndicatorNotifier indicatorNotifier) {
    _indicatorNotifier = indicatorNotifier;
    if (_listeners.isNotEmpty) {
      indicatorNotifier.addListener(_onNotify);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _onNotify();
      });
    }
  }

  /// Unbind [ErIndicatorNotifier].
  void _unbind() {
    _indicatorNotifier?.removeListener(_onNotify);
    _indicatorNotifier = null;
  }

  /// Rebind [ErIndicatorNotifier].
  void _rebind(ErIndicatorNotifier indicatorNotifier) {
    if (_indicatorNotifier == indicatorNotifier) {
      return;
    }
    _unbind();
    _bind(indicatorNotifier);
  }

  /// Listen for notifications
  void _onNotify() {
    for (final listener in _listeners) {
      listener();
    }
  }

  @override
  void addListener(VoidCallback listener) {
    if (_listeners.isEmpty) {
      _indicatorNotifier?.addListener(_onNotify);
    }
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
    if (_listeners.isEmpty) {
      _indicatorNotifier?.removeListener(_onNotify);
    }
  }

  @override
  ErIndicatorState? get value => _indicatorNotifier?.indicatorState;
}

/// Refresh and loading indicator.
/// ErIndicator configuration and widget builder.
abstract class ErIndicator {
  /// The offset of the trigger task.
  final double triggerOffset;

  /// Hold to keep the [Scrollable] from going out of bounds.
  final bool clamping;

  /// Whether to calculate the safe area.
  final bool safeArea;

  /// Task completion delay.
  /// [ErIndicatorMode.processed] duration of state.
  final Duration processedDuration;

  /// Spring effect when scrollable goes back.
  final physics.SpringDescription? spring;

  /// Horizontal spring effect when scrollable goes back.
  final physics.SpringDescription? horizontalSpring;

  /// Spring effect when the mode is [ErIndicatorMode.ready].
  final ErSpringBuilder? readySpringBuilder;

  /// Horizontal spring effect when the mode is [ErIndicatorMode.ready].
  final ErSpringBuilder? horizontalReadySpringBuilder;

  /// Whether the spring can rebound.
  /// Only works with [readySpringBuilder].
  final bool springRebound;

  /// Friction factor when list is out of bounds.
  /// See [BouncingScrollPhysics.frictionFactor].
  final FrictionFactor? frictionFactor;

  /// Horizontal friction factor when list is out of bounds.
  /// See [BouncingScrollPhysics.frictionFactor].
  final FrictionFactor? horizontalFrictionFactor;

  /// Infinite scroll trigger offset.
  /// The relative offset of the [Scrollable] from the bounds (>= 0)
  /// When null, no infinite scroll.
  final double? infiniteOffset;

  /// Hit boundary over.
  /// When the [Scrollable] scrolls by itself, is it out of bounds.
  /// When [clamping] is false, it takes effect.
  final bool hitOver;

  /// Infinite scroll hits out of bounds.
  /// When the [Scrollable] scrolls by itself,
  /// whether the infinite scroll is out of bounds.
  /// When [clamping] is false, it takes effect.
  final bool infiniteHitOver;

  /// The position of the indicator.
  final ErIndicatorPosition position;

  /// Whether to enable haptic feedback.
  final bool hapticFeedback;

  /// Trigger offset for secondary.
  /// The indicator will expand and fill the scrollview area.
  /// Will not trigger when null.
  final double? secondaryTriggerOffset;

  /// Secondary opening speed.
  final double secondaryVelocity;

  /// Dimension of the second floor.
  /// The default value is [ScrollMetrics.viewportDimension].
  final double? secondaryDimension;

  /// Secondary close trigger offset.
  final double secondaryCloseTriggerOffset;

  /// Notify when invisible.
  /// When [ErIndicatorNotifier.offset] < 0, scrolling will also trigger notification.
  /// This might have extra performance overhead, but it's very useful when you need it.
  final bool notifyWhenInvisible;

  /// ErIndicator state listenable.
  /// Monitor state changes in real time.
  final ErIndicatorStateListenable? listenable;

  /// Trigger immediately when reaching the [triggerOffset].
  final bool triggerWhenReach;

  /// Over [triggerOffset], the release triggers immediately.
  final bool triggerWhenRelease;

  /// Over [triggerOffset], the release triggers immediately.
  /// No need to wait for task execution to complete,
  /// generally used for non-asynchronous events
  /// or external custom indicators.
  final bool triggerWhenReleaseNoWait;

  /// Maximum overscroll offset, will no longer scroll.
  /// When [double.infinity], no limit.
  final double maxOverOffset;

  const ErIndicator({
    required this.triggerOffset,
    required this.clamping,
    this.processedDuration = const Duration(seconds: 1),
    this.safeArea = true,
    this.spring,
    this.horizontalSpring,
    this.readySpringBuilder,
    this.horizontalReadySpringBuilder,
    this.springRebound = true,
    this.frictionFactor,
    this.horizontalFrictionFactor,
    this.infiniteOffset,
    bool? hitOver,
    bool? infiniteHitOver,
    this.position = ErIndicatorPosition.above,
    this.secondaryTriggerOffset,
    this.hapticFeedback = false,
    this.secondaryVelocity = kErDefaultSecondaryVelocity,
    this.secondaryDimension,
    this.secondaryCloseTriggerOffset = kErDefaultSecondaryCloseTriggerOffset,
    this.notifyWhenInvisible = false,
    this.listenable,
    this.triggerWhenReach = false,
    this.triggerWhenRelease = false,
    this.triggerWhenReleaseNoWait = false,
    this.maxOverOffset = double.infinity,
  })  : hitOver = hitOver ?? infiniteOffset != null,
        infiniteHitOver = infiniteHitOver ?? infiniteOffset == null,
        assert(infiniteOffset == null || infiniteOffset >= 0,
            'The infiniteOffset cannot be less than 0.',),
        assert(infiniteOffset == null || !clamping,
            'Cannot scroll indefinitely when clamping.',),
        assert(!(hitOver == false && infiniteOffset != null),
            'When hitOver is true, infinite scrolling cannot be used, please set infiniteHitOver.',),
        assert(
            secondaryTriggerOffset == null ||
                secondaryTriggerOffset > triggerOffset,
            'The secondaryTriggerOffset cannot be less than triggerOffset.',),
        assert(!(infiniteOffset != null && secondaryTriggerOffset != null),
            'Infinite scroll and secondary cannot be used together.',),
        assert(
            secondaryDimension == null ||
                secondaryDimension > (secondaryTriggerOffset ?? 0),
            'The secondaryDimension cannot be less than secondaryTriggerOffset.',),
        assert(maxOverOffset == double.infinity || maxOverOffset >= 0,
            'The maxOverOffset cannot be less than 0.',);

  /// Build indicator widget.
  Widget build(BuildContext context, ErIndicatorState state);
}
