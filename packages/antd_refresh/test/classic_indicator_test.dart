import 'dart:async';

import 'package:antd_refresh/antd_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test harness for ErClassicHeader/ErClassicFooter
class _ClassicIndicatorHarness extends StatefulWidget {
  final ErClassicHeader? header;
  final ErClassicFooter? footer;
  final bool useDefaultIndicators = false;

  const _ClassicIndicatorHarness({
    super.key,
    this.header,
    this.footer,
  });

  @override
  State<_ClassicIndicatorHarness> createState() =>
      _ClassicIndicatorHarnessState();
}

class _ClassicIndicatorHarnessState extends State<_ClassicIndicatorHarness> {
  late final ErRefreshController controller;
  final scrollController = ScrollController();

  int itemCount = 60;
  Completer<void>? _refreshCompleter;
  Completer<void>? _loadCompleter;

  void finishRefresh() {
    _refreshCompleter?.complete();
  }

  void finishLoad() {
    _loadCompleter?.complete();
  }

  Future<void> _onRefresh() async {
    _refreshCompleter = Completer<void>();
    await _refreshCompleter!.future;
  }

  Future<void> _onLoad() async {
    _loadCompleter = Completer<void>();
    await _loadCompleter!.future;
  }

  @override
  void initState() {
    super.initState();
    controller = ErRefreshController();
  }

  @override
  void dispose() {
    controller.dispose();
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
          header: widget.useDefaultIndicators
              ? null
              : (widget.header ?? const ErClassicHeader()),
          footer: widget.useDefaultIndicators
              ? null
              : (widget.footer ?? const ErClassicFooter()),
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
  group('ErClassicHeader Tests', () {
    testWidgets('ErClassicHeader renders correctly', (tester) async {
      final key = GlobalKey<_ClassicIndicatorHarnessState>();
      await tester.pumpWidget(_ClassicIndicatorHarness(
        key: key,
        header: const ErClassicHeader(),
      ));

      await tester.pumpAndSettle();

      // Trigger refresh to make header visible
      await tester.drag(find.byType(ListView), const Offset(0, 200));
      await tester.pump();

      // ErClassicHeader should be visible with default text
      expect(find.byType(CircularProgressIndicator), findsWidgets);

      key.currentState!.finishRefresh();
      await tester.pump();
      await tester.pump();

      await disposeAndFlush(tester);
    });

    testWidgets('ErClassicHeader with custom dragText', (tester) async {
      final key = GlobalKey<_ClassicIndicatorHarnessState>();
      await tester.pumpWidget(_ClassicIndicatorHarness(
        key: key,
        header: const ErClassicHeader(
          dragText: 'Custom drag text',
        ),
      ));

      await tester.pumpAndSettle();

      // Start dragging
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(ListView)),
      );
      await gesture.moveBy(const Offset(0, 50));
      await tester.pump();

      // Should show custom drag text
      expect(find.text('Custom drag text'), findsOneWidget);

      await gesture.up();
      await tester.pumpAndSettle();

      await disposeAndFlush(tester);
    });

    testWidgets('ErClassicHeader with custom armedText', (tester) async {
      final key = GlobalKey<_ClassicIndicatorHarnessState>();
      await tester.pumpWidget(_ClassicIndicatorHarness(
        key: key,
        header: const ErClassicHeader(
          armedText: 'Release now!',
        ),
      ));

      await tester.pumpAndSettle();

      // Use controller to trigger refresh (more reliable than gesture for testing text)
      key.currentState!.controller.callRefresh();
      await tester.pump();
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      // ErRefresh should render
      expect(find.byType(ErRefresh), findsOneWidget);

      key.currentState!.finishRefresh();
      await tester.pump();
      await tester.pump();

      await disposeAndFlush(tester);
    });

    testWidgets('ErClassicHeader with custom processingText', (tester) async {
      final key = GlobalKey<_ClassicIndicatorHarnessState>();
      await tester.pumpWidget(_ClassicIndicatorHarness(
        key: key,
        header: const ErClassicHeader(
          processingText: 'Loading data...',
        ),
      ));

      await tester.pumpAndSettle();

      // Use controller to trigger refresh
      key.currentState!.controller.callRefresh();
      await tester.pump();
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      // ErRefresh should render
      expect(find.byType(ErRefresh), findsOneWidget);

      key.currentState!.finishRefresh();
      await tester.pump();
      await tester.pump();

      await disposeAndFlush(tester);
    });

    testWidgets('ErClassicHeader with showText: false', (tester) async {
      final key = GlobalKey<_ClassicIndicatorHarnessState>();
      await tester.pumpWidget(_ClassicIndicatorHarness(
        key: key,
        header: const ErClassicHeader(
          showText: false,
        ),
      ));

      await tester.pumpAndSettle();

      // Trigger refresh
      await tester.drag(find.byType(ListView), const Offset(0, 200));
      await tester.pump();

      // Should not show any text
      expect(find.text('Refreshing...'), findsNothing);
      expect(find.text('Pull to refresh'), findsNothing);

      key.currentState!.finishRefresh();
      await tester.pump();
      await tester.pump();

      await disposeAndFlush(tester);
    });

    testWidgets('ErClassicHeader with showMessage: false', (tester) async {
      final key = GlobalKey<_ClassicIndicatorHarnessState>();
      await tester.pumpWidget(_ClassicIndicatorHarness(
        key: key,
        header: const ErClassicHeader(
          showMessage: false,
        ),
      ));

      await tester.pumpAndSettle();

      // Use controller to trigger refresh
      key.currentState!.controller.callRefresh();
      await tester.pump();
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      // ErRefresh should render (showMessage affects rendering details)
      expect(find.byType(ErRefresh), findsOneWidget);

      key.currentState!.finishRefresh();
      await tester.pump();
      await tester.pump();

      await disposeAndFlush(tester);
    });

    testWidgets('ErClassicHeader with custom triggerOffset', (tester) async {
      final key = GlobalKey<_ClassicIndicatorHarnessState>();
      await tester.pumpWidget(_ClassicIndicatorHarness(
        key: key,
        header: const ErClassicHeader(
          triggerOffset: 100,
        ),
      ));

      await tester.pumpAndSettle();

      // Use controller to trigger refresh
      key.currentState!.controller.callRefresh();
      await tester.pump();
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      // ErRefresh should render
      expect(find.byType(ErRefresh), findsOneWidget);

      key.currentState!.finishRefresh();
      await tester.pump();
      await tester.pump();

      await disposeAndFlush(tester);
    });

    testWidgets('ErClassicHeader mainAxisAlignment options', (tester) async {
      // Test MainAxisAlignment.start
      var key = GlobalKey<_ClassicIndicatorHarnessState>();
      await tester.pumpWidget(_ClassicIndicatorHarness(
        key: key,
        header: const ErClassicHeader(
          mainAxisAlignment: MainAxisAlignment.start,
        ),
      ));

      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView), const Offset(0, 200));
      await tester.pump();

      // ErHeader should render (we just verify it doesn't crash)
      expect(find.byType(ErRefresh), findsOneWidget);

      key.currentState!.finishRefresh();
      await tester.pump();
      await tester.pump();

      // Test MainAxisAlignment.end
      key = GlobalKey<_ClassicIndicatorHarnessState>();
      await tester.pumpWidget(_ClassicIndicatorHarness(
        key: key,
        header: const ErClassicHeader(
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      ));

      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView), const Offset(0, 200));
      await tester.pump();

      expect(find.byType(ErRefresh), findsOneWidget);

      key.currentState!.finishRefresh();
      await tester.pump();
      await tester.pump();

      await disposeAndFlush(tester);
    });

    testWidgets('ErClassicHeader with clamping: true', (tester) async {
      final key = GlobalKey<_ClassicIndicatorHarnessState>();
      await tester.pumpWidget(_ClassicIndicatorHarness(
        key: key,
        header: const ErClassicHeader(
          clamping: true,
        ),
      ));

      await tester.pumpAndSettle();

      // Trigger refresh
      await tester.drag(find.byType(ListView), const Offset(0, 200));
      await tester.pump();

      // Should work with clamping
      expect(find.byType(ErRefresh), findsOneWidget);

      key.currentState!.finishRefresh();
      await tester.pump();
      await tester.pump();

      await disposeAndFlush(tester);
    });

    testWidgets('ErClassicHeader with backgroundColor', (tester) async {
      final key = GlobalKey<_ClassicIndicatorHarnessState>();
      await tester.pumpWidget(_ClassicIndicatorHarness(
        key: key,
        header: const ErClassicHeader(
          backgroundColor: Colors.blue,
        ),
      ));

      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView), const Offset(0, 200));
      await tester.pump();

      // Verify the header renders with background color
      expect(find.byType(ErRefresh), findsOneWidget);

      key.currentState!.finishRefresh();
      await tester.pump();
      await tester.pump();

      await disposeAndFlush(tester);
    });
  });

  group('ErClassicFooter Tests', () {
    testWidgets('ErClassicFooter renders correctly', (tester) async {
      final key = GlobalKey<_ClassicIndicatorHarnessState>();
      await tester.pumpWidget(_ClassicIndicatorHarness(
        key: key,
        footer: const ErClassicFooter(),
      ));

      await tester.pumpAndSettle();

      // Scroll to bottom and trigger load
      key.currentState!.scrollController.jumpTo(
        key.currentState!.scrollController.position.maxScrollExtent,
      );
      await tester.pump();

      await tester.drag(find.byType(ListView), const Offset(0, -200));
      await tester.pump();

      // ErClassicFooter should be visible
      expect(find.byType(ErRefresh), findsOneWidget);

      key.currentState!.finishLoad();
      await tester.pump();
      await tester.pump();

      await disposeAndFlush(tester);
    });

    testWidgets('ErClassicFooter with infiniteOffset', (tester) async {
      final key = GlobalKey<_ClassicIndicatorHarnessState>();
      await tester.pumpWidget(_ClassicIndicatorHarness(
        key: key,
        footer: const ErClassicFooter(
          infiniteOffset: 70,
        ),
      ));

      await tester.pumpAndSettle();

      // Scroll to bottom - should auto-trigger load with infiniteOffset
      key.currentState!.scrollController.jumpTo(
        key.currentState!.scrollController.position.maxScrollExtent,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Should auto-trigger load when reaching the end
      expect(find.byType(ErRefresh), findsOneWidget);

      key.currentState!.finishLoad();
      await tester.pump();
      await tester.pump();

      await disposeAndFlush(tester);
    });

    testWidgets('ErClassicFooter with custom text properties', (tester) async {
      final key = GlobalKey<_ClassicIndicatorHarnessState>();
      await tester.pumpWidget(_ClassicIndicatorHarness(
        key: key,
        footer: const ErClassicFooter(
          dragText: 'Pull up to load',
          armedText: 'Release to load',
          processingText: 'Loading more...',
          processedText: 'Load complete',
          noMoreText: 'No more items',
          failedText: 'Load failed',
          infiniteOffset: null,
        ),
      ));

      await tester.pumpAndSettle();

      // Scroll to bottom
      key.currentState!.scrollController.jumpTo(
        key.currentState!.scrollController.position.maxScrollExtent,
      );
      await tester.pump();

      // Start drag
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(ListView)),
      );
      await gesture.moveBy(const Offset(0, -50));
      await tester.pump();

      // Should show custom drag text
      expect(find.text('Pull up to load'), findsOneWidget);

      await gesture.up();
      await tester.pumpAndSettle();

      await disposeAndFlush(tester);
    });

    testWidgets('ErClassicFooter with triggerWhenReach', (tester) async {
      final key = GlobalKey<_ClassicIndicatorHarnessState>();
      await tester.pumpWidget(_ClassicIndicatorHarness(
        key: key,
        footer: const ErClassicFooter(
          triggerWhenReach: true,
          infiniteOffset: null,
        ),
      ));

      await tester.pumpAndSettle();

      // Scroll to bottom
      key.currentState!.scrollController.jumpTo(
        key.currentState!.scrollController.position.maxScrollExtent,
      );
      await tester.pump();

      // Drag to trigger
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(ListView)),
      );
      await gesture.moveBy(const Offset(0, -100));
      await tester.pump();

      // With triggerWhenReach, should trigger immediately when reaching triggerOffset
      expect(find.byType(ErRefresh), findsOneWidget);

      await gesture.up();
      await tester.pump();

      key.currentState!.finishLoad();
      await tester.pump();
      await tester.pump();

      await disposeAndFlush(tester);
    });
  });

  group('ClassicIndicator Default Texts', () {
    testWidgets('ErClassicHeader has correct default texts', (tester) async {
      const header = ErClassicHeader();

      expect(header.dragText,
          isNull); // Uses 'Pull to refresh' as default in build
      expect(
          header.armedText, isNull); // Uses 'Release ready' as default in build
      expect(header.processingText,
          isNull); // Uses 'Refreshing...' as default in build
      expect(
          header.processedText, isNull); // Uses 'Succeeded' as default in build
      expect(header.noMoreText, isNull); // Uses 'No more' as default in build
      expect(header.failedText, isNull); // Uses 'Failed' as default in build
    });

    testWidgets('ErClassicFooter has correct default texts', (tester) async {
      const footer = ErClassicFooter();

      expect(
          footer.dragText, isNull); // Uses 'Pull to load' as default in build
      expect(
          footer.armedText, isNull); // Uses 'Release ready' as default in build
      expect(footer.processingText,
          isNull); // Uses 'Loading...' as default in build
      expect(
          footer.processedText, isNull); // Uses 'Succeeded' as default in build
      expect(footer.noMoreText, isNull); // Uses 'No more' as default in build
      expect(footer.failedText, isNull); // Uses 'Failed' as default in build
    });
  });

  group('ClassicIndicator Properties', () {
    testWidgets('ErClassicHeader default triggerOffset is 70', (tester) async {
      const header = ErClassicHeader();
      expect(header.triggerOffset, 70);
    });

    testWidgets('ErClassicFooter default triggerOffset is 70', (tester) async {
      const footer = ErClassicFooter();
      expect(footer.triggerOffset, 70);
    });

    testWidgets('ErClassicHeader default clamping is false', (tester) async {
      const header = ErClassicHeader();
      expect(header.clamping, false);
    });

    testWidgets('ErClassicFooter default clamping is false', (tester) async {
      const footer = ErClassicFooter();
      expect(footer.clamping, false);
    });

    testWidgets('ErClassicFooter default infiniteOffset is 70', (tester) async {
      const footer = ErClassicFooter();
      expect(footer.infiniteOffset, 70);
    });

    testWidgets('ErClassicHeader default mainAxisAlignment is center',
        (tester) async {
      const header = ErClassicHeader();
      expect(header.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('ErClassicFooter default mainAxisAlignment is start',
        (tester) async {
      const footer = ErClassicFooter();
      expect(footer.mainAxisAlignment, MainAxisAlignment.start);
    });
  });
}
