import 'dart:async';

import 'package:antd_refresh/antd_refresh.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
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

/// 构建挂载 controller 的 InfiniteScroll：child 自带定高滚动视图
///（组件 Column 布局要求 child 有界高度）。
Widget _buildScroll(
  AntInfiniteScrollController controller, {
  required Future<bool> Function() loadMore,
}) {
  return _wrap(
    SizedBox(
      height: 400,
      child: AntInfiniteScroll(
        controller: controller,
        loadMore: loadMore,
        child: SizedBox(
          height: 280,
          child: ListView.builder(
            itemCount: 100,
            itemBuilder: (context, index) => ListTile(title: Text('$index')),
          ),
        ),
      ),
    ),
  );
}

void main() {
  group('AntRefreshController（R35.2 Controller 优先）', () {
    testWidgets('AntPullToRefreshController.callRefresh 程序化触发刷新',
        (tester) async {
      var refreshed = false;
      final statuses = <AntPullToRefreshStatus>[];
      final controller = AntPullToRefreshController();
      await tester.pumpWidget(
        _wrap(
          AntPullToRefresh(
            controller: controller,
            onRefresh: () async {
              refreshed = true;
              await Future<void>.delayed(const Duration(milliseconds: 50));
            },
            pullStatusChange: statuses.add,
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) =>
                  ListTile(title: Text('item $index')),
            ),
          ),
        ),
      );
      expect(controller.isAttached, isTrue);

      unawaited(controller.callRefresh());
      await tester.pump(const Duration(milliseconds: 10));
      expect(statuses, contains(AntPullToRefreshStatus.refreshing));
      await tester.pumpAndSettle();
      expect(refreshed, isTrue);
      expect(statuses.last, AntPullToRefreshStatus.idle);
    });

    testWidgets('controller 换绑：旧 controller detach、新 controller attach',
        (tester) async {
      var refreshed = false;
      Future<void> onRefresh() async => refreshed = true;
      Widget build(AntPullToRefreshController? controller) => _wrap(
            AntPullToRefresh(
              key: const ValueKey<String>('same'),
              controller: controller,
              onRefresh: onRefresh,
              child: ListView.builder(
                itemCount: 100,
                itemBuilder: (context, index) =>
                    ListTile(title: Text('item $index')),
              ),
            ),
          );

      final first = AntPullToRefreshController();
      final second = AntPullToRefreshController();
      await tester.pumpWidget(build(first));
      expect(first.isAttached, isTrue);
      expect(second.isAttached, isFalse);

      // 换绑 controller（不换 key，State 保留，走 didUpdateWidget）。
      await tester.pumpWidget(build(second));
      expect(first.isAttached, isFalse);
      expect(second.isAttached, isTrue);

      unawaited(second.callRefresh());
      await tester.pumpAndSettle();
      expect(refreshed, isTrue);
    });

    testWidgets('未挂载时 callRefresh 抛 StateError', (tester) async {
      final controller = AntPullToRefreshController();
      expect(controller.isAttached, isFalse);
      expect(() => controller.callRefresh(), throwsStateError);
    });

    testWidgets('组件 dispose 后 controller 自动 detach', (tester) async {
      final controller = AntPullToRefreshController();
      await tester.pumpWidget(
        _wrap(
          AntPullToRefresh(
            controller: controller,
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => ListTile(title: Text('$index')),
            ),
          ),
        ),
      );
      expect(controller.isAttached, isTrue);
      await tester.pumpWidget(_wrap(const SizedBox.shrink()));
      expect(controller.isAttached, isFalse);
    });
  });

  group('AntInfiniteScrollController（R35.2 Controller 优先）', () {
    testWidgets('callLoadMore 程序化触发加载', (tester) async {
      var loadCalls = 0;
      final controller = AntInfiniteScrollController();
      await tester.pumpWidget(
        _buildScroll(
          controller,
          loadMore: () async {
            loadCalls++;
            return true;
          },
        ),
      );
      expect(controller.isAttached, isTrue);
      // 内容超出一屏，初始不在阈值内，不会自动触发。
      await tester.pumpAndSettle();
      final before = loadCalls;
      await controller.callLoadMore();
      await tester.pumpAndSettle();
      expect(loadCalls, before + 1);
    });

    testWidgets('加载失败后 reset 恢复「还有更多」并可重新加载', (tester) async {
      var fail = true;
      var loadCalls = 0;
      final controller = AntInfiniteScrollController();
      await tester.pumpWidget(
        _buildScroll(
          controller,
          loadMore: () async {
            loadCalls++;
            if (fail) throw Exception('network error');
            return true;
          },
        ),
      );
      expect(controller.isAttached, isTrue);
      // 初始不在阈值内不会自动触发，经 controller 程序化触发首次加载（失败）。
      await controller.callLoadMore();
      await tester.pumpAndSettle();
      // 进入失败态：footer 展示重试文案。
      expect(find.text('点击重试'), findsOneWidget);

      controller.reset();
      await tester.pumpAndSettle();
      expect(find.text('点击重试'), findsNothing);

      fail = false;
      await controller.callLoadMore();
      await tester.pumpAndSettle();
      expect(loadCalls, 2);
    });

    testWidgets('未挂载时 callLoadMore/reset 抛 StateError', (tester) async {
      final controller = AntInfiniteScrollController();
      expect(() => controller.callLoadMore(), throwsStateError);
      expect(() => controller.reset(), throwsStateError);
    });
  });
}
