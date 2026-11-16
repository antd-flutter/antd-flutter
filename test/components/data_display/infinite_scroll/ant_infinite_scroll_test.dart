import 'dart:async';

import 'package:antd_flutter_plus/src/components/data_display/infinite_scroll/ant_infinite_scroll.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    ),
  );
}

/// 构建可滚动测试内容：固定高度列表项 + 可选滚动容器。
Widget _scrollable({
  required Widget child,
  double height = 300,
  ScrollController? controller,
}) {
  return SizedBox(
    height: height,
    child: SingleChildScrollView(
      controller: controller,
      child: child,
    ),
  );
}

void main() {
  group('AntInfiniteScroll', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(_wrap(
        _scrollable(
          child: AntInfiniteScroll(
            loadMore: () async => true,
            child: const Column(children: [Text('条目一'), Text('条目二')]),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('条目一'), findsOneWidget);
      expect(find.text('条目二'), findsOneWidget);
    });

    testWidgets('auto loads once on mount when at bottom', (tester) async {
      var callCount = 0;
      await tester.pumpWidget(_wrap(
        _scrollable(
          child: AntInfiniteScroll(
            loadMore: () async {
              callCount++;
              return false;
            },
            child: const Column(children: [Text('内容')]),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      // 内容不足一屏（maxScrollExtent = 0），初始自动加载一次。
      expect(callCount, 1);
      expect(find.text('没有更多了'), findsOneWidget);
    });

    testWidgets('does not auto load when content far from bottom',
        (tester) async {
      var callCount = 0;
      await tester.pumpWidget(_wrap(
        _scrollable(
          height: 200,
          child: AntInfiniteScroll(
            loadMore: () async {
              callCount++;
              return true;
            },
            // 内容远超视口：初始滚动位置距底部很远，不触发。
            child: Container(
              height: 2000,
              alignment: Alignment.topCenter,
              child: const Text('首屏'),
            ),
          ),
        ),
      ));
      await tester.pump();
      expect(callCount, 0);
      expect(find.text('首屏'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('triggers loadMore when scrolled to bottom',
        (tester) async {
      var callCount = 0;
      await tester.pumpWidget(_wrap(
        _scrollable(
          height: 200,
          child: AntInfiniteScroll(
            loadMore: () async {
              callCount++;
              return true;
            },
            child: Container(
              height: 600,
              alignment: Alignment.bottomCenter,
              child: const Text('长内容'),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(callCount, 0);

      final scrollable = find.byType(Scrollable).first;
      final position = tester.state<ScrollableState>(scrollable).position;
      position.jumpTo(position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(callCount, 1);
    });

    testWidgets('shows no more text and stops triggering after hasMore=false',
        (tester) async {
      var callCount = 0;
      await tester.pumpWidget(_wrap(
        _scrollable(
          height: 200,
          child: AntInfiniteScroll(
            loadMore: () async {
              callCount++;
              return false;
            },
            child: Container(
              height: 600,
              alignment: Alignment.bottomCenter,
              child: const Text('长内容'),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(callCount, 0);

      final position =
          tester.state<ScrollableState>(find.byType(Scrollable).first)
              .position;
      position.jumpTo(position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(callCount, 1);
      expect(find.text('没有更多了'), findsOneWidget);

      // 再次滚动到底不再触发。
      position.jumpTo(position.maxScrollExtent - 50);
      await tester.pumpAndSettle();
      position.jumpTo(position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(callCount, 1);
    });

    testWidgets('shows loading text while loading', (tester) async {
      // 永不完成的 Future，保持加载态。
      final completer = Completer<bool>();
      await tester.pumpWidget(_wrap(
        _scrollable(
          child: AntInfiniteScroll(
            loadMore: () => completer.future,
            child: const Column(children: [Text('内容')]),
          ),
        ),
      ));
      await tester.pump();
      expect(find.text('加载中'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      completer.complete(false);
      await tester.pumpAndSettle();
      expect(find.text('加载中'), findsNothing);
    });

    testWidgets('shows retry UI on load failure', (tester) async {
      await tester.pumpWidget(_wrap(
        _scrollable(
          child: AntInfiniteScroll(
            loadMore: () async => throw Exception('网络错误'),
            child: const Column(children: [Text('内容')]),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('加载失败'), findsOneWidget);
      expect(find.text('点击重试'), findsOneWidget);
    });

    testWidgets('tap retry invokes loadMore again', (tester) async {
      var callCount = 0;
      var shouldFail = true;
      await tester.pumpWidget(_wrap(
        _scrollable(
          child: AntInfiniteScroll(
            loadMore: () async {
              callCount++;
              if (shouldFail) throw Exception('网络错误');
              return false;
            },
            child: const Column(children: [Text('内容')]),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(callCount, 1);
      expect(find.text('点击重试'), findsOneWidget);

      shouldFail = false;
      await tester.tap(find.text('点击重试'));
      await tester.pumpAndSettle();
      expect(callCount, 2);
      expect(find.text('点击重试'), findsNothing);
      expect(find.text('没有更多了'), findsOneWidget);
    });

    testWidgets('threshold triggers load earlier', (tester) async {
      var callCount = 0;
      await tester.pumpWidget(_wrap(
        _scrollable(
          height: 200,
          child: AntInfiniteScroll(
            threshold: 500,
            loadMore: () async {
              callCount++;
              return true;
            },
            child: Container(
              height: 600,
              alignment: Alignment.bottomCenter,
              child: const Text('长内容'),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      // 阈值 500 大于总可滚动距离，首帧即进入阈值范围自动触发。
      expect(callCount, 1);
    });

    testWidgets('default threshold does not trigger before bottom',
        (tester) async {
      var callCount = 0;
      await tester.pumpWidget(_wrap(
        _scrollable(
          height: 200,
          child: AntInfiniteScroll(
            loadMore: () async {
              callCount++;
              return true;
            },
            child: Container(
              height: 6000,
              alignment: Alignment.bottomCenter,
              child: const Text('超长内容'),
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      final position =
          tester.state<ScrollableState>(find.byType(Scrollable).first)
              .position;
      position.jumpTo(position.maxScrollExtent - 100);
      await tester.pumpAndSettle();
      // 距底部还有 100 > 默认阈值 0，未触发。
      expect(callCount, 0);
    });

    testWidgets('supports custom texts', (tester) async {
      final completer = Completer<bool>();
      await tester.pumpWidget(_wrap(
        _scrollable(
          child: AntInfiniteScroll(
            loadMore: () => completer.future,
            loadingText: '努力加载中',
            hasMoreText: '上拉看更多',
            noMoreText: '到底啦',
            loadFailedText: '加载出错了',
            loadFailedRetryText: '重新加载',
            child: const Column(children: [Text('内容')]),
          ),
        ),
      ));
      await tester.pump();
      expect(find.text('努力加载中'), findsOneWidget);

      completer.complete(false);
      await tester.pumpAndSettle();
      expect(find.text('到底啦'), findsOneWidget);
    });

    testWidgets('shows custom failed texts and retry', (tester) async {
      await tester.pumpWidget(_wrap(
        _scrollable(
          child: AntInfiniteScroll(
            loadMore: () async => throw Exception('网络错误'),
            loadFailedText: '加载出错了',
            loadFailedRetryText: '重新加载',
            child: const Column(children: [Text('内容')]),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('加载出错了'), findsOneWidget);
      expect(find.text('重新加载'), findsOneWidget);
    });
  });
}
