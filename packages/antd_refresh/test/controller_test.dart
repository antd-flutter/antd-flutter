import 'dart:async';

import 'package:antd_refresh/antd_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test harness for controller functionality
class _ControllerHarness extends StatefulWidget {
  final bool controlFinishRefresh;
  final bool controlFinishLoad;
  final ErRefreshController? externalController;

  const _ControllerHarness({
    super.key,
    this.controlFinishRefresh = false,
    this.controlFinishLoad = false,
    this.externalController,
  });

  @override
  State<_ControllerHarness> createState() => _ControllerHarnessState();
}

class _ControllerHarnessState extends State<_ControllerHarness> {
  late final ErRefreshController controller;
  final scrollController = ScrollController();
  final headerListenable = ErIndicatorStateListenable();
  final footerListenable = ErIndicatorStateListenable();

  int itemCount = 60;
  bool refreshCalled = false;
  bool loadCalled = false;

  Completer<void>? _refreshCompleter;
  Completer<void>? _loadCompleter;

  ErIndicatorState? get headerState => headerListenable.value;
  ErIndicatorState? get footerState => footerListenable.value;

  void appendItems([int delta = 10]) {
    setState(() {
      itemCount += delta;
    });
  }

  void resetItems([int count = 10]) {
    setState(() {
      itemCount = count;
    });
  }

  Future<void> _onRefresh() async {
    refreshCalled = true;
    if (widget.controlFinishRefresh) {
      return;
    }
    _refreshCompleter ??= Completer<void>();
    await _refreshCompleter!.future;
  }

  Future<void> _onLoad() async {
    loadCalled = true;
    if (widget.controlFinishLoad) {
      return;
    }
    _loadCompleter ??= Completer<void>();
    await _loadCompleter!.future;
  }

  void completeRefresh() {
    _refreshCompleter?.complete();
  }

  void completeLoad() {
    _loadCompleter?.complete();
  }

  @override
  void initState() {
    super.initState();
    controller = widget.externalController ??
        ErRefreshController(
          controlFinishRefresh: widget.controlFinishRefresh,
          controlFinishLoad: widget.controlFinishLoad,
        );
  }

  @override
  void dispose() {
    if (widget.externalController == null) {
      controller.dispose();
    }
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ErRefresh(
          controller: controller,
          scrollController: scrollController,
          header: ErBuilderHeader(
            listenable: headerListenable,
            triggerOffset: 70,
            clamping: false,
            processedDuration: Duration.zero,
            position: ErIndicatorPosition.above,
            builder: (context, state) => Container(
              height: state.offset,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'header:${state.mode.name}:${state.result.name}',
                key: const Key('header-debug'),
              ),
            ),
          ),
          footer: ErBuilderFooter(
            listenable: footerListenable,
            triggerOffset: 70,
            clamping: false,
            processedDuration: Duration.zero,
            infiniteOffset: null,
            builder: (context, state) => Container(
              height: state.offset,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'footer:${state.mode.name}:${state.result.name}',
                key: const Key('footer-debug'),
              ),
            ),
          ),
          onRefresh: _onRefresh,
          onLoad: _onLoad,
          child: ListView.builder(
            controller: scrollController,
            itemExtent: 50,
            itemCount: itemCount,
            itemBuilder: (context, index) => ListTile(
              key: Key('item-$index'),
              title: Text('Item $index'),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> disposeAndFlush(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 1));
}

void main() {
  group('Controller Creation Tests', () {
    testWidgets(
        'ErRefreshController creation with controlFinishRefresh: false',
        (tester) async {
      final controller = ErRefreshController(controlFinishRefresh: false);
      expect(controller.controlFinishRefresh, isFalse);
      controller.dispose();
    });

    testWidgets(
        'ErRefreshController creation with controlFinishRefresh: true',
        (tester) async {
      final controller = ErRefreshController(controlFinishRefresh: true);
      expect(controller.controlFinishRefresh, isTrue);
      controller.dispose();
    });

    testWidgets('ErRefreshController creation with controlFinishLoad: false',
        (tester) async {
      final controller = ErRefreshController(controlFinishLoad: false);
      expect(controller.controlFinishLoad, isFalse);
      controller.dispose();
    });

    testWidgets('ErRefreshController creation with controlFinishLoad: true',
        (tester) async {
      final controller = ErRefreshController(controlFinishLoad: true);
      expect(controller.controlFinishLoad, isTrue);
      controller.dispose();
    });
  });

  group('Controller callRefresh Tests', () {
    testWidgets('controller.callRefresh() triggers programmatic refresh',
        (tester) async {
      final key = GlobalKey<_ControllerHarnessState>();
      await tester.pumpWidget(_ControllerHarness(
        key: key,
        controlFinishRefresh: true,
      ));
      final state = key.currentState!;

      await tester.pumpAndSettle();

      expect(state.refreshCalled, isFalse);

      // Call refresh programmatically
      state.controller.callRefresh();
      await tester.pumpAndSettle();

      expect(state.refreshCalled, isTrue);
      expect(state.headerState, isNotNull);
      expect(state.headerState!.mode, ErIndicatorMode.processing);

      // Finish refresh
      state.controller.finishRefresh();
      await tester.pump();
      await tester.pump();

      // Mode should be done or inactive after finishing
      final headerMode = state.headerState!.mode;
      expect(
          headerMode == ErIndicatorMode.inactive ||
              headerMode == ErIndicatorMode.done,
          isTrue);

      await disposeAndFlush(tester);
    });

    testWidgets(
        'controller.callRefresh(scrollController: ...) is ignored before notifier caches position',
        (tester) async {
      final key = GlobalKey<_ControllerHarnessState>();
      await tester.pumpWidget(_ControllerHarness(
        key: key,
        controlFinishRefresh: true,
      ));
      final state = key.currentState!;

      await tester.pump();

      state.controller.callRefresh(scrollController: state.scrollController);
      await tester.pump();

      expect(state.refreshCalled, isFalse);
      expect(state.headerState?.mode, isNot(ErIndicatorMode.processing));

      await disposeAndFlush(tester);
    });

    testWidgets(
        'controller.callRefresh(scrollController: ...) works when controller matches cached position',
        (tester) async {
      final key = GlobalKey<_ControllerHarnessState>();
      await tester.pumpWidget(_ControllerHarness(
        key: key,
        controlFinishRefresh: true,
      ));
      final state = key.currentState!;

      await tester.pumpAndSettle();

      state.controller.callRefresh(scrollController: state.scrollController);
      await tester.pumpAndSettle();

      expect(state.refreshCalled, isTrue);
      expect(state.headerState, isNotNull);
      expect(state.headerState!.mode, ErIndicatorMode.processing);

      state.controller.finishRefresh();
      await tester.pump();
      await tester.pump();

      await disposeAndFlush(tester);
    });

    testWidgets('controller.callRefresh() with custom overOffset',
        (tester) async {
      final key = GlobalKey<_ControllerHarnessState>();
      await tester.pumpWidget(_ControllerHarness(
        key: key,
        controlFinishRefresh: true,
      ));
      final state = key.currentState!;

      await tester.pumpAndSettle();

      // Call refresh with custom overOffset
      state.controller.callRefresh(overOffset: 50);
      await tester.pumpAndSettle();

      expect(state.refreshCalled, isTrue);

      state.controller.finishRefresh();
      await tester.pump();
      await tester.pump();

      await disposeAndFlush(tester);
    });
  });

  group('Controller callLoad Tests', () {
    testWidgets('controller.callLoad() triggers programmatic load',
        (tester) async {
      final key = GlobalKey<_ControllerHarnessState>();
      await tester.pumpWidget(_ControllerHarness(
        key: key,
        controlFinishLoad: true,
      ));
      final state = key.currentState!;

      await tester.pumpAndSettle();

      expect(state.loadCalled, isFalse);

      // Call load programmatically
      state.controller.callLoad();
      await tester.pumpAndSettle();

      expect(state.loadCalled, isTrue);
      expect(state.footerState, isNotNull);
      expect(state.footerState!.mode, ErIndicatorMode.processing);

      // Finish load
      state.controller.finishLoad();
      await tester.pump();
      await tester.pump();

      // Mode should be done or inactive after finishing
      final footerMode = state.footerState!.mode;
      expect(
          footerMode == ErIndicatorMode.inactive ||
              footerMode == ErIndicatorMode.done,
          isTrue);

      await disposeAndFlush(tester);
    });

    testWidgets(
        'controller.callLoad(scrollController: ...) is ignored before notifier caches position',
        (tester) async {
      final key = GlobalKey<_ControllerHarnessState>();
      await tester.pumpWidget(_ControllerHarness(
        key: key,
        controlFinishLoad: true,
      ));
      final state = key.currentState!;

      await tester.pump();

      state.controller.callLoad(scrollController: state.scrollController);
      await tester.pump();

      expect(state.loadCalled, isFalse);
      expect(state.footerState?.mode, isNot(ErIndicatorMode.processing));

      await disposeAndFlush(tester);
    });

    testWidgets(
        'controller.callLoad(scrollController: ...) works when controller matches cached position',
        (tester) async {
      final key = GlobalKey<_ControllerHarnessState>();
      await tester.pumpWidget(_ControllerHarness(
        key: key,
        controlFinishLoad: true,
      ));
      final state = key.currentState!;

      await tester.pumpAndSettle();

      state.controller.callLoad(scrollController: state.scrollController);
      await tester.pumpAndSettle();

      expect(state.loadCalled, isTrue);
      expect(state.footerState, isNotNull);
      expect(state.footerState!.mode, ErIndicatorMode.processing);

      state.controller.finishLoad();
      await tester.pump();
      await tester.pump();

      await disposeAndFlush(tester);
    });

    testWidgets(
        'controller.callRefresh() and callLoad() ignore unattached external scrollController',
        (tester) async {
      final key = GlobalKey<_ControllerHarnessState>();
      await tester.pumpWidget(_ControllerHarness(
        key: key,
        controlFinishRefresh: true,
        controlFinishLoad: true,
      ));
      final state = key.currentState!;
      final detachedController = ScrollController();

      await tester.pump();

      state.controller.callRefresh(scrollController: detachedController);
      await tester.pump();
      expect(state.refreshCalled, isFalse);
      expect(state.headerState?.mode, isNot(ErIndicatorMode.processing));

      state.controller.callLoad(scrollController: detachedController);
      await tester.pump();
      expect(state.loadCalled, isFalse);
      expect(state.footerState?.mode, isNot(ErIndicatorMode.processing));

      detachedController.dispose();
      await disposeAndFlush(tester);
    });
  });

  group('Controller finishRefresh Tests', () {
    testWidgets('controller.finishRefresh() completes refresh task',
        (tester) async {
      final key = GlobalKey<_ControllerHarnessState>();
      await tester.pumpWidget(_ControllerHarness(
        key: key,
        controlFinishRefresh: true,
      ));
      final state = key.currentState!;

      await tester.pumpAndSettle();

      state.controller.callRefresh();
      await tester.pumpAndSettle();

      expect(state.headerState!.mode, ErIndicatorMode.processing);

      // Finish with default success
      state.controller.finishRefresh();
      await tester.pump();

      expect(state.headerState!.result, ErIndicatorResult.success);

      await tester.pump();
      // Mode should be done or inactive after finishing
      final headerMode = state.headerState!.mode;
      expect(
          headerMode == ErIndicatorMode.inactive ||
              headerMode == ErIndicatorMode.done,
          isTrue);

      await disposeAndFlush(tester);
    });

    testWidgets('controller.finishRefresh() with ErIndicatorResult.fail',
        (tester) async {
      final key = GlobalKey<_ControllerHarnessState>();
      await tester.pumpWidget(_ControllerHarness(
        key: key,
        controlFinishRefresh: true,
      ));
      final state = key.currentState!;

      await tester.pumpAndSettle();

      state.controller.callRefresh();
      await tester.pumpAndSettle();

      // Finish with fail
      state.controller.finishRefresh(ErIndicatorResult.fail);
      await tester.pump();

      expect(state.headerState!.result, ErIndicatorResult.fail);

      await disposeAndFlush(tester);
    });
  });

  group('Controller finishLoad Tests', () {
    testWidgets('controller.finishLoad() with different IndicatorResults',
        (tester) async {
      final key = GlobalKey<_ControllerHarnessState>();
      await tester.pumpWidget(_ControllerHarness(
        key: key,
        controlFinishLoad: true,
      ));
      final state = key.currentState!;

      await tester.pumpAndSettle();

      // Test success
      state.controller.callLoad();
      await tester.pumpAndSettle();
      state.controller.finishLoad(ErIndicatorResult.success);
      await tester.pump();
      expect(state.footerState!.result, ErIndicatorResult.success);
      await tester.pump();

      await disposeAndFlush(tester);
    });

    testWidgets('controller.finishLoad() with ErIndicatorResult.noMore',
        (tester) async {
      final key = GlobalKey<_ControllerHarnessState>();
      await tester.pumpWidget(_ControllerHarness(
        key: key,
        controlFinishLoad: true,
      ));
      final state = key.currentState!;

      await tester.pumpAndSettle();

      state.controller.callLoad();
      await tester.pumpAndSettle();
      state.controller.finishLoad(ErIndicatorResult.noMore);
      await tester.pump();

      expect(state.footerState!.result, ErIndicatorResult.noMore);

      await disposeAndFlush(tester);
    });
  });

  group('Controller resetFooter Tests', () {
    testWidgets('controller.resetFooter() resets noMore state', (tester) async {
      final key = GlobalKey<_ControllerHarnessState>();
      await tester.pumpWidget(_ControllerHarness(
        key: key,
        controlFinishLoad: true,
      ));
      final state = key.currentState!;

      await tester.pumpAndSettle();

      // Set footer to noMore state
      state.controller.callLoad();
      await tester.pumpAndSettle();
      state.controller.finishLoad(ErIndicatorResult.noMore);
      await tester.pump();

      expect(state.footerState!.result, ErIndicatorResult.noMore);

      // Reset footer
      state.controller.resetFooter();
      await tester.pump();

      expect(state.footerState!.result, ErIndicatorResult.none);

      await disposeAndFlush(tester);
    });
  });

  group('Controller headerState and footerState Tests', () {
    testWidgets('controller provides access to header and footer state',
        (tester) async {
      final controller = ErRefreshController(
        controlFinishRefresh: true,
        controlFinishLoad: true,
      );

      final key = GlobalKey<_ControllerHarnessState>();
      await tester.pumpWidget(_ControllerHarness(
        key: key,
        controlFinishRefresh: true,
        controlFinishLoad: true,
        externalController: controller,
      ));

      await tester.pumpAndSettle();

      // Initially states may be null or inactive
      // final headerState = controller.headerState;
      // final footerState = controller.footerState;

      // Trigger refresh to verify state access
      controller.callRefresh();
      await tester.pumpAndSettle();

      expect(controller.headerState, isNotNull);
      expect(controller.headerState!.mode, ErIndicatorMode.processing);

      controller.finishRefresh();
      await tester.pump();
      await tester.pump();

      controller.dispose();
      await disposeAndFlush(tester);
    });
  });

  group('Controller with async callbacks', () {
    testWidgets('waiting for task result when controlFinishRefresh is false',
        (tester) async {
      final key = GlobalKey<_ControllerHarnessState>();
      await tester.pumpWidget(_ControllerHarness(
        key: key,
        controlFinishRefresh: false,
      ));
      final state = key.currentState!;

      await tester.pumpAndSettle();

      // Trigger refresh via drag and wait for it to process
      await tester.drag(find.byType(ListView), const Offset(0, 200));
      await tester.pump();
      // Wait for refresh to actually trigger
      for (int i = 0; i < 50 && !state.refreshCalled; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      // Should be processing or ready
      expect(state.refreshCalled, isTrue);

      // Complete the refresh task
      state.completeRefresh();
      await tester.pump();
      await tester.pump();

      // Mode should be done or inactive after finishing
      final headerMode = state.headerState!.mode;
      expect(
          headerMode == ErIndicatorMode.inactive ||
              headerMode == ErIndicatorMode.done,
          isTrue);

      await disposeAndFlush(tester);
    });
  });
}
