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

/// ErFooter indicator.
abstract class ErFooter extends ErIndicator {
  const ErFooter({
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
    super.infiniteOffset = 0,
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

/// Build footer widget use [ErIndicatorBuilder].
class ErBuilderFooter extends ErFooter {
  /// ErFooter widget builder.
  final ErIndicatorBuilder builder;

  const ErBuilderFooter({
    required this.builder,
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

  @override
  Widget build(BuildContext context, ErIndicatorState state) {
    return builder(context, state);
  }
}

/// Listener footer.
/// Listen to the indicator state and respond anywhere.
class ErListenerFooter extends ErFooter {
  const ErListenerFooter({
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

/// Secondary footer.
/// Combine existing [ErFooter] with secondary.
abstract class ErSecondaryFooter extends ErFooter {
  /// Existing [ErFooter].
  final ErFooter footer;

  ErSecondaryFooter({
    required this.footer,
    required double super.secondaryTriggerOffset,
    super.secondaryVelocity,
    super.secondaryDimension,
    super.secondaryCloseTriggerOffset,
    ErIndicatorStateListenable? listenable,
  }) : super(
          triggerOffset: footer.triggerOffset,
          clamping: footer.clamping,
          processedDuration: footer.processedDuration,
          spring: footer.spring,
          horizontalSpring: footer.horizontalSpring,
          readySpringBuilder: footer.readySpringBuilder,
          horizontalReadySpringBuilder: footer.horizontalReadySpringBuilder,
          springRebound: footer.springRebound,
          frictionFactor: footer.frictionFactor,
          horizontalFrictionFactor: footer.horizontalFrictionFactor,
          safeArea: footer.safeArea,
          infiniteOffset: footer.infiniteOffset,
          hitOver: footer.hitOver,
          infiniteHitOver: footer.infiniteHitOver,
          position: footer.position,
          hapticFeedback: footer.hapticFeedback,
          notifyWhenInvisible: footer.notifyWhenInvisible,
          listenable: listenable ?? footer.listenable,
          triggerWhenReach: footer.triggerWhenReach,
          triggerWhenRelease: footer.triggerWhenRelease,
          triggerWhenReleaseNoWait: footer.triggerWhenReleaseNoWait,
          maxOverOffset: footer.maxOverOffset,
        );

  @override
  Widget build(BuildContext context, ErIndicatorState state) {
    return secondaryBuild(context, state, footer);
  }

  Widget secondaryBuild(
      BuildContext context, ErIndicatorState state, ErIndicator indicator,);
}

/// Secondary builder footer.
class ErSecondaryBuilderFooter extends ErSecondaryFooter {
  /// ErFooter widget builder.
  final ErSecondaryIndicatorBuilder builder;

  ErSecondaryBuilderFooter({
    required super.footer,
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

/// Parameters when [ErRefresh.onLoad] is null.
/// Overscroll behavior of [ScrollView].
class ErNotLoadFooter extends ErFooter {
  const ErNotLoadFooter({
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

/// Override the ErFooter parameter.
/// First of all you have to make it clear that this is feasible,
/// otherwise please don't use it.
class ErOverrideFooter extends ErFooter {
  /// ErFooter that needs to be overwritten.
  final ErFooter footer;

  ErOverrideFooter({
    required this.footer,
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
          triggerOffset: triggerOffset ?? footer.triggerOffset,
          clamping: clamping ?? footer.clamping,
          processedDuration: processedDuration ?? footer.processedDuration,
          spring: spring ?? footer.spring,
          horizontalSpring: horizontalSpring ?? footer.horizontalSpring,
          readySpringBuilder: readySpringBuilder ?? footer.readySpringBuilder,
          horizontalReadySpringBuilder: horizontalReadySpringBuilder ??
              footer.horizontalReadySpringBuilder,
          springRebound: springRebound ?? footer.springRebound,
          frictionFactor: frictionFactor ?? footer.frictionFactor,
          horizontalFrictionFactor:
              horizontalFrictionFactor ?? footer.horizontalFrictionFactor,
          safeArea: safeArea ?? footer.safeArea,
          infiniteOffset: infiniteOffset ?? footer.infiniteOffset,
          hitOver: hitOver ?? footer.hitOver,
          infiniteHitOver: infiniteHitOver ?? footer.infiniteHitOver,
          position: position ?? footer.position,
          hapticFeedback: hapticFeedback ?? footer.hapticFeedback,
          secondaryTriggerOffset:
              secondaryTriggerOffset ?? footer.secondaryTriggerOffset,
          secondaryVelocity: secondaryVelocity ?? footer.secondaryVelocity,
          secondaryDimension: secondaryDimension ?? footer.secondaryDimension,
          secondaryCloseTriggerOffset:
              secondaryCloseTriggerOffset ?? footer.secondaryCloseTriggerOffset,
          notifyWhenInvisible:
              notifyWhenInvisible ?? footer.notifyWhenInvisible,
          listenable: listenable ?? footer.listenable,
          triggerWhenReach: triggerWhenReach ?? footer.triggerWhenReach,
          triggerWhenRelease: triggerWhenRelease ?? footer.triggerWhenRelease,
          triggerWhenReleaseNoWait:
              triggerWhenReleaseNoWait ?? footer.triggerWhenReleaseNoWait,
          maxOverOffset: maxOverOffset ?? footer.maxOverOffset,
        );

  @override
  Widget build(BuildContext context, ErIndicatorState state) {
    return footer.build(context, state);
  }
}
