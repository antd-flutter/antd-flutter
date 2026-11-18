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

/// 发送一串鼠标滚轮事件（桌面端），可指定目标组件。
Future<void> sendWheelScroll(
  WidgetTester tester, {
  Finder? finder,
  required int ticks,
  required double deltaPerTick,
  bool settleAfter = false,
}) async {
  final pointer = TestPointer(1, PointerDeviceKind.mouse);
  // 鼠标滚轮需要先 hover 到列表上，确定事件位置
  final target = finder ?? find.byType(ListView).first;
  final center = tester.getCenter(target);
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
      await tester.pumpWidget(
        _wrap(
          _buildList(
            pullStatusChange: statuses.add,
          ),
        ),
      );
      await tester.drag(find.byType(ListView), const Offset(0, 30));
      await tester.pump();
      expect(find.text('下拉刷新'), findsOneWidget);
      expect(statuses, contains(AntPullToRefreshStatus.pulling));
    });

    testWidgets('release below threshold bounces back without refresh',
        (tester) async {
      var refreshed = false;
      await tester.pumpWidget(
        _wrap(
          _buildList(
            onRefresh: () async => refreshed = true,
          ),
        ),
      );
      await tester.drag(find.byType(ListView), const Offset(0, 40));
      await tester.pumpAndSettle();
      expect(refreshed, isFalse);
      expect(find.text('下拉刷新'), findsNothing);
    });

    testWidgets('release above threshold triggers onRefresh', (tester) async {
      var refreshed = false;
      final statuses = <AntPullToRefreshStatus>[];
      await tester.pumpWidget(
        _wrap(
          _buildList(
            onRefresh: () async {
              refreshed = true;
              await Future<void>.delayed(const Duration(milliseconds: 50));
            },
            pullStatusChange: statuses.add,
          ),
        ),
      );
      await tester.drag(find.byType(ListView), const Offset(0, 80));
      await tester.pump();
      expect(statuses, contains(AntPullToRefreshStatus.canRelease));
      await tester.pumpAndSettle();
      expect(refreshed, isTrue);
    });

    testWidgets('shows spinner while refreshing', (tester) async {
      var refreshed = false;
      await tester.pumpWidget(
        _wrap(
          _buildList(
            onRefresh: () async {
              refreshed = true;
              await Future<void>.delayed(const Duration(milliseconds: 50));
            },
          ),
        ),
      );
      await tester.drag(find.byType(ListView), const Offset(0, 80));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
      expect(refreshed, isTrue);
    });

    testWidgets('bounces back after refresh completes', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _buildList(
            onRefresh: () async =>
                Future<void>.delayed(const Duration(milliseconds: 50)),
          ),
        ),
      );
      await tester.drag(find.byType(ListView), const Offset(0, 80));
      await tester.pumpAndSettle();
      // 回弹后头部与转圈均消失，内容回到原位
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('刷新完成'), findsNothing);
      expect(find.text('item 0'), findsOneWidget);
    });

    testWidgets('custom pulling text', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _buildList(
            pullingText: '继续拉',
            threshold: kAntPullToRefreshThreshold,
          ),
        ),
      );
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
      await tester.pumpWidget(
        _wrap(
          _buildList(
            header: const Text('自定义头部'),
          ),
        ),
      );
      await tester.drag(find.byType(ListView), const Offset(0, 30));
      await tester.pump();
      expect(find.text('自定义头部'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_downward), findsNothing);
    });

    testWidgets('onRefresh error still bounces back', (tester) async {
      var refreshed = false;
      await tester.pumpWidget(
        _wrap(
          _buildList(
            onRefresh: () async {
              refreshed = true;
              throw Exception('refresh failed');
            },
          ),
        ),
      );
      await tester.drag(find.byType(ListView), const Offset(0, 80));
      await tester.pumpAndSettle();
      expect(refreshed, isTrue);
      // 异常被吞掉，组件照常回弹，不残留加载状态
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('custom threshold requires longer drag', (tester) async {
      var refreshed = false;
      await tester.pumpWidget(
        _wrap(
          _buildList(
            threshold: 120,
            onRefresh: () async => refreshed = true,
          ),
        ),
      );
      // 80 < 120，不触发
      await tester.drag(find.byType(ListView), const Offset(0, 80));
      await tester.pumpAndSettle();
      expect(refreshed, isFalse);
      expect(find.text('释放刷新'), findsNothing);
    });

    testWidgets('default threshold is 60 and head height is 40',
        (tester) async {
      const refresh = AntPullToRefresh(child: SizedBox());
      expect(refresh.threshold, kAntPullToRefreshThreshold);
      expect(refresh.threshold, 60);
      expect(refresh.headHeight, kAntPullToRefreshHeadHeight);
      expect(refresh.headHeight, 40);
      expect(refresh.pointer, AntPullToRefreshPointer.top);
    });

    group('desktop wheel pull', () {
      testWidgets('wheel scroll at top accumulates pull offset',
          (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        final statuses = <AntPullToRefreshStatus>[];
        await tester.pumpWidget(
          _wrap(
            _buildList(
              pullStatusChange: statuses.add,
            ),
          ),
        );
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
        await tester.pumpWidget(
          _wrap(
            _buildList(
              onRefresh: () async {
                refreshed = true;
                await Future<void>.delayed(const Duration(milliseconds: 50));
              },
              pullStatusChange: statuses.add,
            ),
          ),
        );
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
        await tester.pumpWidget(
          _wrap(
            _buildList(
              onRefresh: () async => refreshed = true,
            ),
          ),
        );
        await sendWheelScroll(tester, ticks: 1, deltaPerTick: -30);
        await tester.pump(kAntPullToRefreshWheelSettleDuration);
        await tester.pumpAndSettle();
        expect(refreshed, isFalse);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('reverse wheel scroll retracts pull offset', (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        await tester.pumpWidget(
          _wrap(_buildList()),
        );
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
        await tester.pumpWidget(
          _wrap(
            _buildList(
              onRefresh: () async =>
                  Future<void>.delayed(const Duration(milliseconds: 50)),
            ),
          ),
        );
        await sendWheelScroll(tester, ticks: 3, deltaPerTick: -30);
        await tester.pump(kAntPullToRefreshWheelSettleDuration);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pumpAndSettle();
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('wheel scroll ignored on mobile platform', (tester) async {
        // 默认测试平台为 android（移动端），滚轮不应触发拉动
        final statuses = <AntPullToRefreshStatus>[];
        await tester.pumpWidget(
          _wrap(
            _buildList(
              pullStatusChange: statuses.add,
            ),
          ),
        );
        await sendWheelScroll(tester, ticks: 3, deltaPerTick: -30);
        expect(find.text('下拉刷新'), findsNothing);
        expect(
            statuses.where((s) => s != AntPullToRefreshStatus.idle), isEmpty,);
      });
    });

    group('multi-container wheel isolation', () {
      testWidgets('two pull-to-refresh lists pull independently via wheel',
          (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        final statusesA = <AntPullToRefreshStatus>[];
        final statusesB = <AntPullToRefreshStatus>[];
        Widget buildOne(
            Key key, ValueChanged<AntPullToRefreshStatus> onStatus,) {
          return SizedBox(
            height: 300,
            child: AntPullToRefresh(
              key: key,
              pullStatusChange: onStatus,
              child: ListView.builder(
                itemCount: 100,
                itemBuilder: (context, index) =>
                    ListTile(title: Text('item $index')),
              ),
            ),
          );
        }

        await tester.pumpWidget(
          _wrap(
            Column(
              children: [
                buildOne(const ValueKey<String>('list-a'), statusesA.add),
                buildOne(const ValueKey<String>('list-b'), statusesB.add),
              ],
            ),
          ),
        );

        // 滚轮悬停在列表 A 上 → 只有 A 进入拉动，B 保持 idle。
        await sendWheelScroll(
          tester,
          finder: find.byKey(const ValueKey<String>('list-a')),
          ticks: 1,
          deltaPerTick: -30,
        );
        expect(find.text('下拉刷新'), findsOneWidget);
        expect(statusesA, contains(AntPullToRefreshStatus.pulling));
        expect(
            statusesB.where((s) => s != AntPullToRefreshStatus.idle), isEmpty,);

        // 滚轮悬停在列表 B 上 → 只有 B 进入拉动，A 不受影响。
        await sendWheelScroll(
          tester,
          finder: find.byKey(const ValueKey<String>('list-b')),
          ticks: 1,
          deltaPerTick: -30,
        );
        expect(statusesB, contains(AntPullToRefreshStatus.pulling));
        expect(statusesA, hasLength(1));
      });

      testWidgets('wheel inside outer page scroll does not scroll page at edge',
          (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        final outerController = ScrollController();
        addTearDown(outerController.dispose);
        final statuses = <AntPullToRefreshStatus>[];
        await tester.pumpWidget(
          _wrap(
            // 外层为页面级滚动容器，内层是下拉刷新列表。
            SizedBox(
              height: 400,
              child: ListView(
                controller: outerController,
                children: [
                  SizedBox(
                    height: 300,
                    child: AntPullToRefresh(
                      pullStatusChange: statuses.add,
                      child: ListView.builder(
                        itemCount: 100,
                        itemBuilder: (context, index) =>
                            ListTile(title: Text('item $index')),
                      ),
                    ),
                  ),
                  const SizedBox(height: 600, child: Text('页面底部内容')),
                ],
              ),
            ),
          ),
        );
        // 内层在顶部边缘滚滚轮：应触发下拉，且外层页面不滚动。
        await sendWheelScroll(tester, ticks: 1, deltaPerTick: -30);
        expect(find.text('下拉刷新'), findsOneWidget);
        expect(outerController.offset, 0);
        expect(statuses, contains(AntPullToRefreshStatus.pulling));
      });

      testWidgets('wheel scrolls inner list normally when not at edge',
          (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        final innerController = ScrollController();
        addTearDown(innerController.dispose);
        final statuses = <AntPullToRefreshStatus>[];
        await tester.pumpWidget(
          _wrap(
            SizedBox(
              height: 300,
              child: AntPullToRefresh(
                pullStatusChange: statuses.add,
                child: ListView.builder(
                  controller: innerController,
                  itemCount: 100,
                  itemBuilder: (context, index) =>
                      ListTile(title: Text('item $index')),
                ),
              ),
            ),
          ),
        );
        // 先滚动到中部（离开顶部边缘）。
        await tester.drag(find.byType(ListView), const Offset(0, -200));
        await tester.pumpAndSettle();
        final offsetBefore = innerController.offset;
        expect(offsetBefore, greaterThan(0));
        // 未到边缘：滚轮让位给内层滚动，不触发下拉。
        await sendWheelScroll(tester, ticks: 1, deltaPerTick: -30);
        expect(innerController.offset, offsetBefore - 30);
        expect(find.text('下拉刷新'), findsNothing);
        expect(
            statuses.where((s) => s != AntPullToRefreshStatus.idle), isEmpty,);
      });
    });

    group('load more', () {
      /// 构建启用加载更多的列表（10 项内容，保证可滚动到底部边缘）
      Widget buildLoadMoreList({
        required Future<AntPullToRefreshLoadResult> Function() onLoadMore,
        bool enableLoadMore = true,
        String? noMoreText,
        String? failedText,
        String? retryText,
        Widget? footer,
      }) {
        return SizedBox(
          height: 300,
          child: AntPullToRefresh(
            enableLoadMore: enableLoadMore,
            onLoadMore: onLoadMore,
            noMoreText: noMoreText,
            failedText: failedText,
            retryText: retryText,
            footer: footer,
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) =>
                  ListTile(title: Text('item $index')),
            ),
          ),
        );
      }

      /// 向下滚动到底部边缘（触发 ScrollEndNotification）。
      Future<void> scrollToEnd(WidgetTester tester) async {
        await tester.drag(find.byType(ListView), const Offset(0, -2000));
        await tester.pumpAndSettle();
      }

      testWidgets('auto triggers onLoadMore at bottom edge', (tester) async {
        var loadCount = 0;
        await tester.pumpWidget(
          _wrap(buildLoadMoreList(
            onLoadMore: () async {
              loadCount++;
              return AntPullToRefreshLoadResult.more;
            },
          ),),
        );
        await scrollToEnd(tester);
        expect(loadCount, 1);
        // 结果为 more：footer 回到 idle，不再展示。
        expect(find.text('加载中...'), findsNothing);
        expect(find.byKey(kAntPullToRefreshFooterKey), findsOneWidget);
      });

      testWidgets('noMore result stops further triggering', (tester) async {
        var loadCount = 0;
        await tester.pumpWidget(
          _wrap(buildLoadMoreList(
            noMoreText: '到底啦',
            onLoadMore: () async {
              loadCount++;
              return AntPullToRefreshLoadResult.noMore;
            },
          ),),
        );
        await scrollToEnd(tester);
        expect(loadCount, 1);
        expect(find.text('到底啦'), findsOneWidget);
        // 再次滚动到底不再触发。
        await tester.drag(find.byType(ListView), const Offset(0, 100));
        await tester.pumpAndSettle();
        await scrollToEnd(tester);
        expect(loadCount, 1);
        expect(find.text('到底啦'), findsOneWidget);
      });

      testWidgets('failed result shows retry and tapping retriggers',
          (tester) async {
        var loadCount = 0;
        var fail = true;
        await tester.pumpWidget(
          _wrap(buildLoadMoreList(
            failedText: '加载出错了',
            retryText: '重试一下',
            onLoadMore: () async {
              loadCount++;
              if (fail) return AntPullToRefreshLoadResult.failed;
              // 成功路径留耗时，确保 loading 帧可被断言。
              await Future<void>.delayed(const Duration(milliseconds: 100));
              return AntPullToRefreshLoadResult.more;
            },
          ),),
        );
        await scrollToEnd(tester);
        expect(loadCount, 1);
        expect(find.text('加载出错了'), findsOneWidget);
        expect(find.text('重试一下'), findsOneWidget);
        // 点击重试 → loading → 成功后 footer 回 idle。
        fail = false;
        await tester.tap(find.byKey(kAntPullToRefreshFooterRetryKey));
        await tester.pump();
        expect(find.text('加载中...'), findsOneWidget);
        await tester.pumpAndSettle();
        expect(loadCount, 2);
        expect(find.text('加载出错了'), findsNothing);
      });

      testWidgets('custom loading text and default noMore text',
          (tester) async {
        await tester.pumpWidget(
          _wrap(buildLoadMoreList(
            onLoadMore: () => Future<AntPullToRefreshLoadResult>.delayed(
              const Duration(milliseconds: 200),
              () => AntPullToRefreshLoadResult.more,
            ),
          ),),
        );
        await tester.drag(find.byType(ListView), const Offset(0, -2000));
        await tester.pump();
        // 滚动结束触发 loading，展示默认加载文案。
        expect(find.text('加载中...'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pumpAndSettle();
        expect(find.text('加载中...'), findsNothing);
      });

      testWidgets('enableLoadMore false never triggers', (tester) async {
        var loadCount = 0;
        await tester.pumpWidget(
          _wrap(buildLoadMoreList(
            enableLoadMore: false,
            onLoadMore: () async {
              loadCount++;
              return AntPullToRefreshLoadResult.more;
            },
          ),),
        );
        await scrollToEnd(tester);
        expect(loadCount, 0);
        expect(find.byType(AntPullToRefreshFooter), findsNothing);
      });

      testWidgets('custom footer replaces default', (tester) async {
        await tester.pumpWidget(
          _wrap(buildLoadMoreList(
            footer: const Text('自定义底部'),
            onLoadMore: () async => AntPullToRefreshLoadResult.noMore,
          ),),
        );
        await scrollToEnd(tester);
        expect(find.text('自定义底部'), findsOneWidget);
        expect(find.byType(AntPullToRefreshFooter), findsNothing);
      });
    });
  });
}
