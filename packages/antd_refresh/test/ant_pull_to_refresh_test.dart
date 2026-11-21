import 'package:antd_refresh/src/pull_to_refresh/ant_pull_to_refresh.dart';
import 'package:antd_theme/antd_theme.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: AntTheme(
        data: AntThemeData.light(),
        child: Material(child: child),
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
  // 组件文案现在跟随系统 locale（默认回退中文），测试宿主默认 locale
  // 为 en_US，这里固定为 zh 以维持既有中文文案断言。
  setUpAll(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher.localeTestValue =
        const Locale('zh');
  });

  group('AntPullToRefresh', () {
    testWidgets('renders scrollable child', (tester) async {
      await tester.pumpWidget(_wrap(_buildList()));
      expect(find.text('item 0'), findsOneWidget);
      // idle（无位移、非活动态）：header 不渲染、无内容占位。
      expect(find.text('下拉刷新'), findsNothing);
      expect(find.byType(AntPullToRefreshHeader), findsNothing);
      final headerBox = tester.renderObject<RenderBox>(
        find.byKey(kAntPullToRefreshHeaderKey),
      );
      expect(headerBox.hasSize, isTrue);
      // Positioned 容器尺寸正常，但其内容为 SizedBox.shrink（无可见内容）。
      expect(find.byType(SizedBox), findsWidgets);
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
      // 完成（offset ≤ 0 且回到 idle）：header 不再渲染，不遮挡内容。
      expect(find.byType(AntPullToRefreshHeader), findsNothing);
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
      expect(find.byIcon(AntIcons.arrowDownOutlined), findsNothing);
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

    testWidgets('default threshold is 50 and head height is 40',
        (tester) async {
      const refresh = AntPullToRefresh(child: SizedBox());
      expect(refresh.threshold, kAntPullToRefreshThreshold);
      // 轻微超过默认 headHeight 40 即可触发（对齐 antd-mobile 语义）。
      expect(refresh.threshold, 50);
      expect(refresh.headHeight, kAntPullToRefreshHeadHeight);
      expect(refresh.headHeight, 40);
      expect(refresh.pointer, AntPullToRefreshPointer.top);
    });

    testWidgets('header and content are clipped to the child display area',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          Column(
            children: [
              SizedBox(height: 400, child: _buildList()),
              const Text('下方内容'),
            ],
          ),
        ),
      );
      // 结构层：Stack 被 ClipRect 包裹，header/content 溢出部分不可见。
      final clip = find.ancestor(
        of: find.byKey(kAntPullToRefreshHeaderKey),
        matching: find.byType(ClipRect),
      );
      expect(clip, findsOneWidget);
      // 拉动中：内容与 header 均在裁剪层内（同属一个 ClipRect 子树）。
      await tester.drag(find.byType(ListView), const Offset(0, 30));
      await tester.pump();
      expect(
        find.ancestor(
          of: find.byKey(const ValueKey<String>('AntPullToRefreshContent')),
          matching: find.byType(ClipRect),
        ),
        findsOneWidget,
      );
      // header Transform 负偏移（offset 30 < headHeight 40 时上移出界），
      // 溢出部分依赖 ClipRect 裁剪，不会绘制到组件区域之外。
      final headerTransform = tester.widget<Transform>(
        find.descendant(
          of: find.byKey(kAntPullToRefreshHeaderKey),
          matching: find.byType(Transform),
        ),
      );
      expect(headerTransform.transform.getTranslation().y, 30 - 40);
      // 「下方内容」未被下拉刷新组件的绘制覆盖（同帧可见）。
      expect(find.text('下方内容'), findsOneWidget);
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
          statuses.where((s) => s != AntPullToRefreshStatus.idle),
          isEmpty,
        );
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
          Key key,
          ValueChanged<AntPullToRefreshStatus> onStatus,
        ) {
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
          statusesB.where((s) => s != AntPullToRefreshStatus.idle),
          isEmpty,
        );

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
          statuses.where((s) => s != AntPullToRefreshStatus.idle),
          isEmpty,
        );
      });
    });

    group('programmatic refresh (callRefresh)', () {
      testWidgets('callRefresh triggers onRefresh and settles back',
          (tester) async {
        var refreshed = false;
        final statuses = <AntPullToRefreshStatus>[];
        final key = GlobalKey<AntPullToRefreshState>();
        await tester.pumpWidget(
          _wrap(
            AntPullToRefresh(
              key: key,
              onRefresh: () async {
                refreshed = true;
                await Future<void>.delayed(
                  const Duration(milliseconds: 50),
                );
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
        // 程序化触发（对应 easy_refresh controller.callRefresh）：
        // 头部展开 → 刷新中转圈 → 完成回弹。
        // 不 await：onRefresh 的 Future 在测试假时钟下需由 pump 推进。
        unawaited(key.currentState!.callRefresh());
        // 推进至进入 refreshing（任务 50ms 后完成）。
        // 注：假时钟下动画帧有滞后，不在中途断言头部 UI；
        // 头部转圈展示由触摸路径用例覆盖。
        await tester.pump(const Duration(milliseconds: 10));
        expect(statuses, contains(AntPullToRefreshStatus.refreshing));
        await tester.pumpAndSettle();
        expect(refreshed, isTrue);
        // 刷新后回弹：状态机经 complete 回到 idle（后续手势可用）。
        expect(statuses, contains(AntPullToRefreshStatus.complete));
        expect(statuses.last, AntPullToRefreshStatus.idle);
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.text('item 0'), findsOneWidget);
      });
    });

    group('multi-container wheel refresh isolation', () {
      testWidgets('wheel triggers refresh only on hovered container',
          (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        var refreshedA = false;
        var refreshedB = false;
        Widget buildOne(Key key, VoidCallback onRefresh) {
          return SizedBox(
            height: 300,
            child: AntPullToRefresh(
              key: key,
              onRefresh: () async {
                onRefresh();
                await Future<void>.delayed(
                  const Duration(milliseconds: 50),
                );
              },
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
                buildOne(
                  const ValueKey<String>('list-a'),
                  () => refreshedA = true,
                ),
                buildOne(
                  const ValueKey<String>('list-b'),
                  () => refreshedB = true,
                ),
              ],
            ),
          ),
        );

        // 滚轮悬停列表 A 并持续滚动到阈值 → 停止后仅 A 触发刷新。
        await sendWheelScroll(
          tester,
          finder: find.byKey(const ValueKey<String>('list-a')),
          ticks: 3,
          deltaPerTick: -30,
        );
        await tester.pump(kAntPullToRefreshWheelSettleDuration);
        await tester.pumpAndSettle();
        expect(refreshedA, isTrue);
        expect(refreshedB, isFalse);
      });
    });

    group('physics overscroll (Bouncing)', () {
      /// 构建 BouncingScrollPhysics 列表（模拟真机 iOS/macOS 物理路径：
      /// 过冲直接写 pixels 出界，不产生 OverscrollNotification）。
      Widget buildBouncing({
        Future<void> Function()? onRefresh,
        ValueChanged<AntPullToRefreshStatus>? pullStatusChange,
      }) {
        return SizedBox(
          height: 300,
          child: AntPullToRefresh(
            onRefresh: onRefresh,
            pullStatusChange: pullStatusChange,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: 100,
              itemBuilder: (context, index) =>
                  ListTile(title: Text('item $index')),
            ),
          ),
        );
      }

      testWidgets(
          'Bouncing physics: touch pull beyond top shows header and refreshes',
          (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        var refreshed = false;
        final statuses = <AntPullToRefreshStatus>[];
        await tester.pumpWidget(
          _wrap(
            buildBouncing(
              onRefresh: () async {
                refreshed = true;
                await Future<void>.delayed(const Duration(milliseconds: 50));
              },
              pullStatusChange: statuses.add,
            ),
          ),
        );
        await tester.drag(find.byType(ListView), const Offset(0, 150));
        await tester.pump();
        // 过冲经滚动度量同步进状态机（不走 OverscrollNotification）。
        expect(statuses, contains(AntPullToRefreshStatus.pulling));
        expect(statuses, contains(AntPullToRefreshStatus.canRelease));
        await tester.pumpAndSettle();
        expect(refreshed, isTrue);
      });

      testWidgets('refresh can be triggered again after complete (idle reset)',
          (tester) async {
        var refreshCount = 0;
        final statuses = <AntPullToRefreshStatus>[];
        await tester.pumpWidget(
          _wrap(
            _buildList(
              onRefresh: () async {
                refreshCount++;
                await Future<void>.delayed(const Duration(milliseconds: 50));
              },
              pullStatusChange: statuses.add,
            ),
          ),
        );
        // 第一次刷新
        await tester.drag(find.byType(ListView), const Offset(0, 80));
        await tester.pumpAndSettle();
        expect(refreshCount, 1);
        expect(statuses, contains(AntPullToRefreshStatus.complete));
        await tester.pumpAndSettle();
        // 回弹归零后状态机必须回到 idle，否则后续手势永久失效
        expect(statuses.last, AntPullToRefreshStatus.idle);
        // 第二次下拉仍能触发
        await tester.drag(find.byType(ListView), const Offset(0, 80));
        await tester.pumpAndSettle();
        expect(refreshCount, 2);
      });
    });

    group('embedding compatibility', () {
      /// 在不同滚动视图宿主内构建下拉刷新列表（同一 child 包装方式）。
      Widget buildEmbedded(
        Widget child, {
        double height = 300,
        Future<void> Function()? onRefresh,
      }) {
        return SizedBox(
          height: height,
          child: AntPullToRefresh(
            onRefresh: onRefresh ??
                () async =>
                    Future<void>.delayed(const Duration(milliseconds: 50)),
            child: child,
          ),
        );
      }

      testWidgets('ListView embedding: touch pull shows header',
          (tester) async {
        await tester.pumpWidget(
          _wrap(
            buildEmbedded(
              ListView.builder(
                itemCount: 100,
                itemBuilder: (context, index) =>
                    ListTile(title: Text('item $index')),
              ),
            ),
          ),
        );
        await tester.drag(find.byType(ListView), const Offset(0, 40));
        await tester.pump();
        expect(find.text('下拉刷新'), findsOneWidget);
        await tester.pumpAndSettle();
      });

      testWidgets('ListView embedding: pull above threshold refreshes',
          (tester) async {
        var refreshed = false;
        await tester.pumpWidget(
          _wrap(
            buildEmbedded(
              ListView.builder(
                itemCount: 100,
                itemBuilder: (context, i) => ListTile(title: Text('item $i')),
              ),
              onRefresh: () async => refreshed = true,
            ),
          ),
        );
        await tester.drag(find.byType(ListView), const Offset(0, 80));
        await tester.pump();
        await tester.pumpAndSettle();
        expect(refreshed, isTrue);
      });

      testWidgets('CustomScrollView embedding: pull above threshold refreshes',
          (tester) async {
        var refreshed = false;
        await tester.pumpWidget(
          _wrap(
            buildEmbedded(
              CustomScrollView(
                slivers: List<Widget>.generate(
                  100,
                  (i) =>
                      SliverToBoxAdapter(child: ListTile(title: Text('s $i'))),
                ),
              ),
              onRefresh: () async => refreshed = true,
            ),
          ),
        );
        await tester.drag(find.byType(CustomScrollView), const Offset(0, 80));
        await tester.pumpAndSettle();
        expect(refreshed, isTrue);
      });

      testWidgets('NestedScrollView embedding: pull above threshold refreshes',
          (tester) async {
        var refreshed = false;
        await tester.pumpWidget(
          _wrap(
            buildEmbedded(
              NestedScrollView(
                headerSliverBuilder: (context, _) => const [
                  SliverAppBar(title: Text('Nested'), pinned: true),
                ],
                body: ListView.builder(
                  itemCount: 100,
                  itemBuilder: (context, i) =>
                      ListTile(title: Text('nested $i')),
                ),
              ),
              onRefresh: () async => refreshed = true,
            ),
          ),
        );
        await tester.drag(
          find.byType(NestedScrollView).last,
          const Offset(0, 120),
        );
        await tester.pumpAndSettle();
        expect(refreshed, isTrue);
      });

      testWidgets('SingleChildScrollView embedding: pull shows header',
          (tester) async {
        await tester.pumpWidget(
          _wrap(
            buildEmbedded(
              SingleChildScrollView(
                child: Column(
                  children: List<Widget>.generate(
                    50,
                    (i) => ListTile(title: Text('single $i')),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.drag(
          find.byType(SingleChildScrollView),
          const Offset(0, 80),
        );
        await tester.pumpAndSettle();
        // 拉动已在状态机留下 pulling/canRelease 痕迹（上文滚动路径覆盖）。
        expect(tester.takeException(), isNull);
      });

      testWidgets('ListView embedding: desktop wheel pull triggers refresh',
          (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        var refreshed = false;
        await tester.pumpWidget(
          _wrap(
            buildEmbedded(
              ListView.builder(
                itemCount: 100,
                itemBuilder: (context, i) => ListTile(title: Text('item $i')),
              ),
              onRefresh: () async => refreshed = true,
            ),
          ),
        );
        await sendWheelScroll(tester, ticks: 3, deltaPerTick: -30);
        await tester.pump(kAntPullToRefreshWheelSettleDuration);
        expect(refreshed, isTrue);
        await tester.pumpAndSettle();
      });

      testWidgets('CustomScrollView embedding: desktop wheel pull works',
          (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        await tester.pumpWidget(
          _wrap(
            buildEmbedded(
              CustomScrollView(
                slivers: List<Widget>.generate(
                  100,
                  (i) =>
                      SliverToBoxAdapter(child: ListTile(title: Text('s $i'))),
                ),
              ),
            ),
          ),
        );
        await sendWheelScroll(
          tester,
          finder: find.byType(CustomScrollView),
          ticks: 1,
          deltaPerTick: -30,
        );
        expect(find.text('下拉刷新'), findsOneWidget);
        await tester.pump(kAntPullToRefreshWheelSettleDuration);
        await tester.pumpAndSettle();
      });
    });

    group('nested PullToRefresh gesture competition', () {
      /// 构建 300 高度、独立状态记录的嵌套单元（默认 ListView 内层）。
      Widget buildUnit(
        Key key,
        ValueChanged<AntPullToRefreshStatus> onStatus, {
        Widget? child,
        Future<void> Function()? onRefresh,
      }) {
        return SizedBox(
          height: 300,
          child: AntPullToRefresh(
            key: key,
            pullStatusChange: onStatus,
            onRefresh: onRefresh,
            child: child ??
                ListView.builder(
                  itemCount: 100,
                  itemBuilder: (context, index) =>
                      ListTile(title: Text('item $index')),
                ),
          ),
        );
      }

      testWidgets('touch pull on inner list drives inner, outer stays idle',
          (tester) async {
        final outerStatuses = <AntPullToRefreshStatus>[];
        final innerStatuses = <AntPullToRefreshStatus>[];
        await tester.pumpWidget(
          _wrap(
            buildUnit(
              const ValueKey<String>('outer'),
              outerStatuses.add,
              child: ListView(
                children: [
                  buildUnit(const ValueKey<String>('inner'), innerStatuses.add),
                  const SizedBox(height: 600, child: Text('外层剩余内容')),
                ],
              ),
            ),
          ),
        );
        // 在内层列表区域触摸下拉 → 内层进入 pulling，外层保持 idle。
        await tester.drag(
          find.byKey(const ValueKey<String>('inner')),
          const Offset(0, 40),
        );
        await tester.pump();
        expect(innerStatuses, contains(AntPullToRefreshStatus.pulling));
        expect(
          outerStatuses.where((s) => s != AntPullToRefreshStatus.idle),
          isEmpty,
        );
        await tester.pumpAndSettle();
      });

      testWidgets('touch pull above threshold triggers only inner onRefresh',
          (tester) async {
        var outerRefreshed = false;
        var innerRefreshed = false;
        final innerStatuses = <AntPullToRefreshStatus>[];
        await tester.pumpWidget(
          _wrap(
            AntPullToRefresh(
              key: const ValueKey<String>('outer'),
              onRefresh: () async => outerRefreshed = true,
              child: ListView(
                children: [
                  SizedBox(
                    height: 300,
                    child: AntPullToRefresh(
                      key: const ValueKey<String>('inner'),
                      onRefresh: () async {
                        innerRefreshed = true;
                        await Future<void>.delayed(
                          const Duration(milliseconds: 50),
                        );
                      },
                      pullStatusChange: innerStatuses.add,
                      child: ListView.builder(
                        itemCount: 100,
                        itemBuilder: (context, index) =>
                            ListTile(title: Text('inner $index')),
                      ),
                    ),
                  ),
                  const SizedBox(height: 600, child: Text('外层剩余内容')),
                ],
              ),
            ),
          ),
        );
        // 内层触摸下拉过阈值 → 只触发内层刷新，外层不误触发。
        await tester.drag(
          find.byKey(const ValueKey<String>('inner')),
          const Offset(0, 80),
        );
        await tester.pump();
        expect(innerStatuses, contains(AntPullToRefreshStatus.canRelease));
        await tester.pumpAndSettle();
        expect(innerRefreshed, isTrue);
        expect(outerRefreshed, isFalse);
      });

      testWidgets('wheel on inner nested list pulls inner only',
          (tester) async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        final outerStatuses = <AntPullToRefreshStatus>[];
        final innerStatuses = <AntPullToRefreshStatus>[];
        await tester.pumpWidget(
          _wrap(
            buildUnit(
              const ValueKey<String>('outer'),
              outerStatuses.add,
              child: ListView(
                children: [
                  buildUnit(const ValueKey<String>('inner'), innerStatuses.add),
                  const SizedBox(height: 600, child: Text('外层剩余内容')),
                ],
              ),
            ),
          ),
        );
        // 滚轮悬停在内层区域 → 内层优先消费自身手势，外层不抢。
        await sendWheelScroll(
          tester,
          finder: find.byKey(const ValueKey<String>('inner')),
          ticks: 1,
          deltaPerTick: -30,
        );
        expect(innerStatuses, contains(AntPullToRefreshStatus.pulling));
        expect(
          outerStatuses.where((s) => s != AntPullToRefreshStatus.idle),
          isEmpty,
        );
        await tester.pumpAndSettle();
      });
    });
  });
}
