import 'package:antd_pull_to_refresh/src/pull_to_refresh/ant_pull_to_refresh.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
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

/// 构建一个可下拉的刷新组件（child 必须是可滚动组件）。
Widget _buildList({
  Future<void> Function()? onRefresh,
  ValueChanged<AntPullToRefreshStatus>? pullStatusChange,
  double headHeight = kAntPullToRefreshHeadHeight,
  double threshold = kAntPullToRefreshThreshold,
  String? pullingText,
  Widget? header,
}) {
  return AntPullToRefresh(
    onRefresh: onRefresh,
    pullStatusChange: pullStatusChange,
    headHeight: headHeight,
    threshold: threshold,
    pullingText: pullingText,
    header: header,
    child: ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) => ListTile(title: Text('item $index')),
    ),
  );
}

void main() {
  group('AntPullToRefresh', () {
    testWidgets('renders scrollable child', (tester) async {
      await tester.pumpWidget(_wrap(_buildList()));
      expect(find.text('item 0'), findsOneWidget);
      expect(find.text('下拉刷新'), findsNothing);
    });

    testWidgets('pull offset follows drag and shows pulling text',
        (tester) async {
      final statuses = <AntPullToRefreshStatus>[];
      await tester.pumpWidget(_wrap(_buildList(
        pullStatusChange: statuses.add,
      ),),);
      await tester.drag(find.byType(ListView), const Offset(0, 30));
      await tester.pump();
      expect(find.text('下拉刷新'), findsOneWidget);
      expect(statuses, contains(AntPullToRefreshStatus.pulling));
    });

    testWidgets('release below threshold bounces back without refresh',
        (tester) async {
      var refreshed = false;
      await tester.pumpWidget(_wrap(_buildList(
        onRefresh: () async => refreshed = true,
      ),),);
      await tester.drag(find.byType(ListView), const Offset(0, 40));
      await tester.pumpAndSettle();
      expect(refreshed, isFalse);
      expect(find.text('下拉刷新'), findsNothing);
    });

    testWidgets('release above threshold triggers onRefresh',
        (tester) async {
      var refreshed = false;
      final statuses = <AntPullToRefreshStatus>[];
      await tester.pumpWidget(_wrap(_buildList(
        onRefresh: () async {
          refreshed = true;
          await Future<void>.delayed(const Duration(milliseconds: 50));
        },
        pullStatusChange: statuses.add,
      ),),);
      await tester.drag(find.byType(ListView), const Offset(0, 80));
      await tester.pump();
      expect(statuses, contains(AntPullToRefreshStatus.canRelease));
      await tester.pumpAndSettle();
      expect(refreshed, isTrue);
    });

    testWidgets('shows spinner while refreshing', (tester) async {
      var refreshed = false;
      await tester.pumpWidget(_wrap(_buildList(
        onRefresh: () async {
          refreshed = true;
          await Future<void>.delayed(const Duration(milliseconds: 50));
        },
      ),),);
      await tester.drag(find.byType(ListView), const Offset(0, 80));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      expect(refreshed, isTrue);
    });

    testWidgets('bounces back after refresh completes', (tester) async {
      await tester.pumpWidget(_wrap(_buildList(
        onRefresh: () async =>
            Future<void>.delayed(const Duration(milliseconds: 50)),
      ),),);
      await tester.drag(find.byType(ListView), const Offset(0, 80));
      await tester.pumpAndSettle();
      // 回弹后头部与转圈均消失，内容回到原位
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('刷新完成'), findsNothing);
      expect(find.text('item 0'), findsOneWidget);
    });

    testWidgets('custom pulling text', (tester) async {
      await tester.pumpWidget(_wrap(_buildList(
        pullingText: '继续拉',
        threshold: kAntPullToRefreshThreshold,
      ),),);
      await tester.drag(find.byType(ListView), const Offset(0, 30));
      await tester.pump();
      expect(find.text('继续拉'), findsOneWidget);
      expect(find.text('下拉刷新'), findsNothing);
    });

    testWidgets('custom head height applies', (tester) async {
      await tester.pumpWidget(_wrap(_buildList(headHeight: 60)));
      final positioned = tester.widget<Positioned>(
        find.byKey(kAntPullToRefreshHeaderKey),
      );
      expect(positioned.height, 60);
    });

    testWidgets('custom header content replaces default', (tester) async {
      await tester.pumpWidget(_wrap(_buildList(
        header: const Text('自定义头部'),
      ),),);
      await tester.drag(find.byType(ListView), const Offset(0, 30));
      await tester.pump();
      expect(find.text('自定义头部'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_downward), findsNothing);
    });

    testWidgets('onRefresh error still bounces back', (tester) async {
      var refreshed = false;
      await tester.pumpWidget(_wrap(_buildList(
        onRefresh: () async {
          refreshed = true;
          throw Exception('refresh failed');
        },
      ),),);
      await tester.drag(find.byType(ListView), const Offset(0, 80));
      await tester.pumpAndSettle();
      expect(refreshed, isTrue);
      // 异常被吞掉，组件照常回弹，不残留加载状态
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('custom threshold requires longer drag', (tester) async {
      var refreshed = false;
      await tester.pumpWidget(_wrap(_buildList(
        threshold: 120,
        onRefresh: () async => refreshed = true,
      ),),);
      // 80 < 120，不触发
      await tester.drag(find.byType(ListView), const Offset(0, 80));
      await tester.pumpAndSettle();
      expect(refreshed, isFalse);
      expect(find.text('释放刷新'), findsNothing);
    });

    testWidgets('default threshold is 60 and head height is 40', (tester) async {
      const refresh = AntPullToRefresh(child: SizedBox());
      expect(refresh.threshold, kAntPullToRefreshThreshold);
      expect(refresh.threshold, 60);
      expect(refresh.headHeight, kAntPullToRefreshHeadHeight);
      expect(refresh.headHeight, 40);
      expect(refresh.pointer, AntPullToRefreshPointer.top);
    });

    group('desktop wheel pull', () {
      /// 发送一串鼠标滚轮事件（桌面端）。
      Future<void> sendWheelScroll(
        WidgetTester tester, {
        required int ticks,
        required double deltaPerTick,
        bool settleAfter = false,
      }) async {
        final pointer = TestPointer(1, PointerDeviceKind.mouse);
        // 鼠标滚轮需要先 hover 到列表上，确定事件位置
        final center = tester.getCenter(find.byType(ListView).first);
        await tester.sendEventToBinding(pointer.hover(center));
        await tester.pump();
        for (var i = 0; i < ticks; i++) {
          await tester.sendEventToBinding(
            pointer.scroll(Offset(0, deltaPerTick)),
          );
          await tester.pump();
        }
        if (settleAfter) await tester.pumpAndSettle();
      }

      testWidgets('wheel scroll at top accumulates pull offset',
          (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        final statuses = <AntPullToRefreshStatus>[];
        await tester.pumpWidget(_wrap(_buildList(
          pullStatusChange: statuses.add,
        ),),);
        // 顶部继续向上滚滚轮 → 累积下拉位移
        await sendWheelScroll(tester, ticks: 1, deltaPerTick: -30);
        expect(find.text('下拉刷新'), findsOneWidget);
        expect(statuses, contains(AntPullToRefreshStatus.pulling));

        await sendWheelScroll(tester, ticks: 1, deltaPerTick: -30);
        expect(find.text('释放刷新'), findsOneWidget);
        expect(statuses, contains(AntPullToRefreshStatus.canRelease));
      });

      testWidgets('wheel scroll triggers onRefresh after settle',
          (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        var refreshed = false;
        final statuses = <AntPullToRefreshStatus>[];
        await tester.pumpWidget(_wrap(_buildList(
          onRefresh: () async {
            refreshed = true;
            await Future<void>.delayed(const Duration(milliseconds: 50));
          },
          pullStatusChange: statuses.add,
        ),),);
        // 3 × 30 = 90 > threshold(60)
        await sendWheelScroll(tester, ticks: 3, deltaPerTick: -30);
        // 停止滚动 400ms → 触发刷新
        await tester.pump(kAntPullToRefreshWheelSettleDuration);
        expect(statuses.last, AntPullToRefreshStatus.refreshing);
        await tester.pumpAndSettle();
        expect(refreshed, isTrue);
      });

      testWidgets('wheel scroll below threshold then settle bounces back',
          (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        var refreshed = false;
        await tester.pumpWidget(_wrap(_buildList(
          onRefresh: () async => refreshed = true,
        ),),);
        await sendWheelScroll(tester, ticks: 1, deltaPerTick: -30);
        await tester.pump(kAntPullToRefreshWheelSettleDuration);
        await tester.pumpAndSettle();
        expect(refreshed, isFalse);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('reverse wheel scroll retracts pull offset', (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        await tester.pumpWidget(_wrap(_buildList()),);
        await sendWheelScroll(tester, ticks: 2, deltaPerTick: -30);
        expect(find.text('释放刷新'), findsOneWidget);
        // 反向滚动回退位移
        await sendWheelScroll(tester, ticks: 2, deltaPerTick: 30);
        expect(find.text('下拉刷新'), findsNothing);
        expect(find.text('释放刷新'), findsNothing);
      });

      testWidgets('wheel pull shows spinner while refreshing', (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        await tester.pumpWidget(_wrap(_buildList(
          onRefresh: () async =>
              Future<void>.delayed(const Duration(milliseconds: 50)),
        ),),);
        await sendWheelScroll(tester, ticks: 3, deltaPerTick: -30);
        await tester.pump(kAntPullToRefreshWheelSettleDuration);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pumpAndSettle();
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('wheel scroll ignored on mobile platform', (tester) async {
        // 默认测试平台为 android（移动端），滚轮不应触发拉动
        final statuses = <AntPullToRefreshStatus>[];
        await tester.pumpWidget(_wrap(_buildList(
          pullStatusChange: statuses.add,
        ),),);
        await sendWheelScroll(tester, ticks: 3, deltaPerTick: -30);
        expect(find.text('下拉刷新'), findsNothing);
        expect(statuses.where((s) => s != AntPullToRefreshStatus.idle), isEmpty);
      });
    });
  });
}
