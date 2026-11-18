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

/// ErHeader indicator.
abstract class ErHeader extends ErIndicator {
  const ErHeader({
    required super.triggerOffset,
    required super.clamping,
    super.processedDuration,
    super.spring,
    super.horizontalSpring,
    super.readySpringBuilder,
    super.horizontalReadySpringBuilder,
    super.springRebound,
    super.frictionFactor,
    super.horizontalFrictionFactor,
    super.safeArea,
    super.infiniteOffset,
    super.hitOver,
    super.infiniteHitOver,
    super.position,
    super.hapticFeedback,
    super.secondaryTriggerOffset,
    super.secondaryVelocity,
    super.secondaryDimension,
    super.secondaryCloseTriggerOffset,
    super.notifyWhenInvisible,
    super.listenable,
    super.triggerWhenReach,
    super.triggerWhenRelease,
    super.triggerWhenReleaseNoWait,
    super.maxOverOffset,
  });
}

/// Build header widget use [ErIndicatorBuilder].
class ErBuilderHeader extends ErHeader {
  /// ErHeader widget builder.
  final ErIndicatorBuilder builder;

  const ErBuilderHeader({
    required this.builder,
    required super.triggerOffset,
    required super.clamping,
    required super.position,
    super.processedDuration,
    super.spring,
    super.horizontalSpring,
    super.readySpringBuilder,
    super.horizontalReadySpringBuilder,
    super.springRebound,
    super.frictionFactor,
    super.horizontalFrictionFactor,
    super.safeArea,
    super.infiniteOffset,
    super.hitOver,
    super.infiniteHitOver,
    super.hapticFeedback,
    super.secondaryTriggerOffset,
    super.secondaryVelocity,
    super.secondaryDimension,
    super.secondaryCloseTriggerOffset,
    super.notifyWhenInvisible,
    super.listenable,
    super.triggerWhenReach,
    super.triggerWhenRelease,
    super.triggerWhenReleaseNoWait,
    super.maxOverOffset,
  });

  @override
  Widget build(BuildContext context, ErIndicatorState state) {
    return builder(context, state);
  }
}

/// Listener header.
/// Listen to the indicator state and respond anywhere.
class ErListenerHeader extends ErHeader {
  const ErListenerHeader({
    required ErIndicatorStateListenable super.listenable,
    required super.triggerOffset,
    super.clamping = true,
    super.processedDuration,
    super.spring,
    super.horizontalSpring,
    super.readySpringBuilder,
    super.horizontalReadySpringBuilder,
    super.springRebound,
    super.frictionFactor,
    super.horizontalFrictionFactor,
    super.safeArea,
    super.infiniteOffset,
    super.hitOver,
    super.infiniteHitOver,
    super.hapticFeedback,
    super.secondaryTriggerOffset,
    super.secondaryVelocity,
    super.secondaryDimension,
    super.secondaryCloseTriggerOffset,
    super.notifyWhenInvisible,
    super.triggerWhenReach,
    super.triggerWhenRelease,
    super.triggerWhenReleaseNoWait,
    super.maxOverOffset,
  }) : super(
          position: ErIndicatorPosition.custom,
        );

  @override
  Widget build(BuildContext context, ErIndicatorState state) {
    return const SizedBox();
  }
}

/// Secondary header.
/// Combine existing [ErHeader] with secondary.
abstract class ErSecondaryHeader extends ErHeader {
  /// Existing [ErHeader].
  final ErHeader header;

  ErSecondaryHeader({
    required this.header,
    required double super.secondaryTriggerOffset,
    super.secondaryVelocity,
    super.secondaryDimension,
    super.secondaryCloseTriggerOffset,
    ErIndicatorStateListenable? listenable,
  }) : super(
          triggerOffset: header.triggerOffset,
          clamping: header.clamping,
          processedDuration: header.processedDuration,
          spring: header.spring,
          horizontalSpring: header.horizontalSpring,
          readySpringBuilder: header.readySpringBuilder,
          horizontalReadySpringBuilder: header.horizontalReadySpringBuilder,
          springRebound: header.springRebound,
          frictionFactor: header.frictionFactor,
          horizontalFrictionFactor: header.horizontalFrictionFactor,
          safeArea: header.safeArea,
          infiniteOffset: header.infiniteOffset,
          hitOver: header.hitOver,
          infiniteHitOver: header.infiniteHitOver,
          position: header.position,
          hapticFeedback: header.hapticFeedback,
          notifyWhenInvisible: header.notifyWhenInvisible,
          listenable: listenable ?? header.listenable,
          triggerWhenReach: header.triggerWhenReach,
          triggerWhenRelease: header.triggerWhenRelease,
          triggerWhenReleaseNoWait: header.triggerWhenReleaseNoWait,
          maxOverOffset: header.maxOverOffset,
        );

  @override
  Widget build(BuildContext context, ErIndicatorState state) {
    return secondaryBuild(context, state, header);
  }

  Widget secondaryBuild(
      BuildContext context, ErIndicatorState state, ErIndicator indicator,);
}

/// Secondary builder header.
class ErSecondaryBuilderHeader extends ErSecondaryHeader {
  /// ErHeader widget builder.
  final ErSecondaryIndicatorBuilder builder;

  ErSecondaryBuilderHeader({
    required super.header,
    required this.builder,
    required super.secondaryTriggerOffset,
    super.secondaryVelocity,
    super.secondaryDimension,
    super.secondaryCloseTriggerOffset,
    super.listenable,
  });

  @override
  Widget secondaryBuild(
      BuildContext context, ErIndicatorState state, ErIndicator indicator,) {
    return builder(context, state, indicator);
  }
}

/// Parameters when [ErRefresh.onRefresh] is null.
/// Overscroll behavior of [ScrollView].
class ErNotRefreshHeader extends ErHeader {
  const ErNotRefreshHeader({
    super.clamping = false,
    super.position = ErIndicatorPosition.custom,
    super.spring,
    super.horizontalSpring,
    super.frictionFactor,
    super.horizontalFrictionFactor,
    super.hitOver,
    super.maxOverOffset,
  }) : super(
          triggerOffset: 0,
          infiniteOffset: null,
          processedDuration: const Duration(seconds: 0),
        );

  @override
  Widget build(BuildContext context, ErIndicatorState state) {
    return const SizedBox();
  }
}

/// Override the ErHeader parameter.
/// First of all you have to make it clear that this is feasible,
/// otherwise please don't use it.
class ErOverrideHeader extends ErHeader {
  /// ErHeader that needs to be overwritten.
  final ErHeader header;

  ErOverrideHeader({
    required this.header,
    double? triggerOffset,
    bool? clamping,
    ErIndicatorPosition? position,
    Duration? processedDuration,
    physics.SpringDescription? spring,
    physics.SpringDescription? horizontalSpring,
    ErSpringBuilder? readySpringBuilder,
    ErSpringBuilder? horizontalReadySpringBuilder,
    bool? springRebound,
    FrictionFactor? frictionFactor,
    FrictionFactor? horizontalFrictionFactor,
    bool? safeArea,
    double? infiniteOffset,
    bool? hitOver,
    bool? infiniteHitOver,
    bool? hapticFeedback,
    double? secondaryTriggerOffset,
    double? secondaryVelocity,
    double? secondaryDimension,
    double? secondaryCloseTriggerOffset,
    bool? notifyWhenInvisible,
    ErIndicatorStateListenable? listenable,
    bool? triggerWhenReach,
    bool? triggerWhenRelease,
    bool? triggerWhenReleaseNoWait,
    double? maxOverOffset,
  }) : super(
          triggerOffset: triggerOffset ?? header.triggerOffset,
          clamping: clamping ?? header.clamping,
          processedDuration: processedDuration ?? header.processedDuration,
          spring: spring ?? header.spring,
          horizontalSpring: horizontalSpring ?? header.horizontalSpring,
          readySpringBuilder: readySpringBuilder ?? header.readySpringBuilder,
          horizontalReadySpringBuilder: horizontalReadySpringBuilder ??
              header.horizontalReadySpringBuilder,
          springRebound: springRebound ?? header.springRebound,
          frictionFactor: frictionFactor ?? header.frictionFactor,
          horizontalFrictionFactor:
              horizontalFrictionFactor ?? header.horizontalFrictionFactor,
          safeArea: safeArea ?? header.safeArea,
          infiniteOffset: infiniteOffset ?? header.infiniteOffset,
          hitOver: hitOver ?? header.hitOver,
          infiniteHitOver: infiniteHitOver ?? header.infiniteHitOver,
          position: position ?? header.position,
          hapticFeedback: hapticFeedback ?? header.hapticFeedback,
          secondaryTriggerOffset:
              secondaryTriggerOffset ?? header.secondaryTriggerOffset,
          secondaryVelocity: secondaryVelocity ?? header.secondaryVelocity,
          secondaryDimension: secondaryDimension ?? header.secondaryDimension,
          secondaryCloseTriggerOffset:
              secondaryCloseTriggerOffset ?? header.secondaryCloseTriggerOffset,
          notifyWhenInvisible:
              notifyWhenInvisible ?? header.notifyWhenInvisible,
          listenable: listenable ?? header.listenable,
          triggerWhenReach: triggerWhenReach ?? header.triggerWhenReach,
          triggerWhenRelease: triggerWhenRelease ?? header.triggerWhenRelease,
          triggerWhenReleaseNoWait:
              triggerWhenReleaseNoWait ?? header.triggerWhenReleaseNoWait,
          maxOverOffset: maxOverOffset ?? header.maxOverOffset,
        );

  @override
  Widget build(BuildContext context, ErIndicatorState state) {
    return header.build(context, state);
  }
}
