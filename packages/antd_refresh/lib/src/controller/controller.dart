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

/// Controls a ErRefresh widget.
/// Control refresh, loading and indicator states.
class ErRefreshController {
  /// Take over the completion event of the refresh task.
  /// Finish the refresh with [finishRefresh] and return the result.
  final bool controlFinishRefresh;

  /// Take over the completion event of the load task.
  /// Finish the load with [finishLoad] and return the result.
  final bool controlFinishLoad;

  /// [ErRefresh] sate.
  _ErRefreshState? _state;

  ErRefreshController({
    this.controlFinishRefresh = false,
    this.controlFinishLoad = false,
  });

  /// Binding with ErRefresh.
  void _bind(_ErRefreshState state) {
    _state = state;
  }

  /// Automatically trigger refresh.
  /// [overOffset] Offset beyond the trigger offset, must be greater than 0.
  /// [duration] See [ScrollPosition.animateTo].
  /// [curve] See [ScrollPosition.animateTo].
  /// [scrollController] When position is not [ScrollPosition], you can use [ScrollController].
  /// [force] Enforce execution even if the task is in progress. But you have to handle the completion event.
  Future callRefresh({
    double? overOffset,
    Duration? duration = const Duration(milliseconds: 200),
    Curve curve = Curves.linear,
    ScrollController? scrollController,
    bool force = false,
  }) async {
    await _state?._callRefresh(
      overOffset: overOffset,
      duration: duration,
      curve: curve,
      scrollController: scrollController,
      force: force,
    );
  }

  /// Automatically trigger load.
  /// [overOffset] Offset beyond the trigger offset, must be greater than 0.
  /// [duration] See [ScrollPosition.animateTo].
  /// [curve] See [ScrollPosition.animateTo].
  /// [scrollController] When position is not [ScrollPosition], you can use [ScrollController].
  /// [force] Enforce execution even if the task is in progress. But you have to handle the completion event.
  Future callLoad({
    double? overOffset,
    Duration? duration = const Duration(milliseconds: 300),
    Curve curve = Curves.linear,
    ScrollController? scrollController,
    bool force = false,
  }) async {
    await _state?._callLoad(
      overOffset: overOffset,
      duration: duration,
      curve: curve,
      scrollController: scrollController,
      force: force,
    );
  }

  /// Open header secondary.
  /// [duration] See [ScrollPosition.animateTo].
  /// [curve] See [ScrollPosition.animateTo].
  /// [scrollController] When position is not [ScrollPosition], you can use [ScrollController].
  Future openHeaderSecondary({
    Duration? duration = const Duration(milliseconds: 200),
    Curve curve = Curves.linear,
    ScrollController? scrollController,
  }) async {
    if (_state == null) {
      return;
    }
    if (_state!._header.secondaryTriggerOffset != null) {
      final headerNotifier = _state!._headerNotifier;
      if (headerNotifier.modeLocked ||
          headerNotifier.noMoreLocked ||
          headerNotifier.secondaryLocked ||
          !headerNotifier._canProcess) {
        return;
      }
      await headerNotifier.animateToOffset(
        offset: headerNotifier.secondaryDimension,
        mode: ErIndicatorMode.secondaryOpen,
        duration: duration,
        curve: curve,
        scrollController: scrollController ?? _state?.widget.scrollController,
      );
    }
  }

  /// Close header secondary.
  /// [duration] See [ScrollPosition.animateTo].
  /// [curve] See [ScrollPosition.animateTo].
  /// [scrollController] When position is not [ScrollPosition], you can use [ScrollController].
  Future closeHeaderSecondary({
    Duration? duration = const Duration(milliseconds: 200),
    Curve curve = Curves.linear,
    ScrollController? scrollController,
  }) async {
    if (_state == null) {
      return;
    }
    if (_state!._header.secondaryTriggerOffset != null) {
      final headerNotifier = _state!._headerNotifier;
      if (headerNotifier.mode != ErIndicatorMode.secondaryOpen) {
        return;
      }
      await headerNotifier.animateToOffset(
        offset: 0,
        mode: ErIndicatorMode.inactive,
        jumpToEdge: false,
        duration: duration,
        curve: curve,
        scrollController: scrollController ?? _state?.widget.scrollController,
      );
    }
  }

  /// Open footer secondary.
  /// [duration] See [ScrollPosition.animateTo].
  /// [curve] See [ScrollPosition.animateTo].
  Future openFooterSecondary({
    Duration? duration = const Duration(milliseconds: 200),
    Curve curve = Curves.linear,
  }) async {
    if (_state == null) {
      return;
    }
    if (_state!._footer.secondaryTriggerOffset != null) {
      final footerNotifier = _state!._footerNotifier;
      if (footerNotifier.modeLocked ||
          footerNotifier.noMoreLocked ||
          footerNotifier.secondaryLocked ||
          !footerNotifier._canProcess) {
        return;
      }
      await footerNotifier.animateToOffset(
        offset: footerNotifier.secondaryDimension,
        mode: ErIndicatorMode.secondaryOpen,
        jumpToEdge: false,
        duration: duration,
        curve: curve,
      );
    }
  }

  /// Close footer secondary.
  /// [duration] See [ScrollPosition.animateTo].
  /// [curve] See [ScrollPosition.animateTo].
  Future closeFooterSecondary({
    Duration? duration = const Duration(milliseconds: 200),
    Curve curve = Curves.linear,
  }) async {
    if (_state == null) {
      return;
    }
    if (_state!._footer.secondaryTriggerOffset != null) {
      final footerNotifier = _state!._footerNotifier;
      if (footerNotifier.mode != ErIndicatorMode.secondaryOpen) {
        return;
      }
      await footerNotifier.animateToOffset(
        offset: 0,
        mode: ErIndicatorMode.inactive,
        duration: duration,
        curve: curve,
      );
    }
  }

  /// Reset ErHeader indicator state.
  void resetHeader() {
    _state?._headerNotifier._reset();
  }

  /// Reset ErFooter indicator state.
  void resetFooter() {
    _state?._footerNotifier._reset();
  }

  /// Finish the refresh task and return the result.
  /// [result] Result of task completion.
  /// [force] Enforced, used to modify the result.
  void finishRefresh(
      [ErIndicatorResult result = ErIndicatorResult.success, bool force = false,]) {
    assert(controlFinishRefresh || force,
        'Please set controlFinishRefresh to true, then use. If you want to modify the result, you can set force to true.',);
    _state?._headerNotifier._finishTask(result);
  }

  /// Finish the load task and return the result.
  /// [result] Result of task completion.
  /// [force] Enforced, used to modify the result.
  void finishLoad(
      [ErIndicatorResult result = ErIndicatorResult.success, bool force = false,]) {
    assert(controlFinishLoad || force,
        'Please set controlFinishLoad to true, then use. If you want to modify the result, you can set force to true.',);
    _state?._footerNotifier._finishTask(result);
  }

  /// Unbind.
  void dispose() {
    _state = null;
  }

  /// Get header state.
  ErIndicatorState? get headerState => _state?._headerNotifier.indicatorState;

  /// Get footer state.
  ErIndicatorState? get footerState => _state?._footerNotifier.indicatorState;
}
