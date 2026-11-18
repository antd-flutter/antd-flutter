import 'dart:async';

import 'package:antd_refresh/src/infinite_scroll/ant_infinite_scroll.dart';
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

/// 构建可滚动测试内容：固定高度列表项 + 可选滚动容器（宿主页面）。
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

/// AntInfiniteScroll 的 child 必须自带滚动组件（触发只属于自己的包裹对象）。
/// 该 helper 模拟「child 内含滚动视图」的标准用法（固定视口高度）。
Widget _childScroll(
  Widget child, {
  ScrollController? controller,
  double height = 300,
}) {
  return SizedBox(
    height: height,
    child: SingleChildScrollView(controller: controller, child: child),
  );
}

void main() {
  group('AntInfiniteScroll', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _scrollable(
            child: AntInfiniteScroll(
              loadMore: () async => true,
              child: const Column(children: [Text('条目一'), Text('条目二')]),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('条目一'), findsOneWidget);
      expect(find.text('条目二'), findsOneWidget);
    });

    testWidgets('auto loads once on mount when at bottom', (tester) async {
      var callCount = 0;
      await tester.pumpWidget(
        _wrap(
          _scrollable(
            child: AntInfiniteScroll(
              loadMore: () async {
                callCount++;
                return false;
              },
              child: _childScroll(const Column(children: [Text('内容')])),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // 内容不足一屏（maxScrollExtent = 0），初始自动加载一次。
      expect(callCount, 1);
      expect(find.text('没有更多了'), findsOneWidget);
    });

    testWidgets('does not auto load when content far from bottom',
        (tester) async {
      var callCount = 0;
      await tester.pumpWidget(
        _wrap(
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
        ),
      );
      await tester.pump();
      expect(callCount, 0);
      expect(find.text('首屏'), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('triggers loadMore when scrolled to bottom', (tester) async {
      var callCount = 0;
      final childController = ScrollController();
      await tester.pumpWidget(
        _wrap(
          _scrollable(
            height: 200,
            child: AntInfiniteScroll(
              loadMore: () async {
                callCount++;
                return true;
              },
              child: _childScroll(
                Container(
                  height: 600,
                  alignment: Alignment.bottomCenter,
                  child: const Text('长内容'),
                ),
                controller: childController,
                height: 200,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(callCount, 0);

      childController.jumpTo(childController.position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(callCount, 1);
    });

    testWidgets('shows no more text and stops triggering after hasMore=false',
        (tester) async {
      var callCount = 0;
      final childController = ScrollController();
      await tester.pumpWidget(
        _wrap(
          _scrollable(
            height: 200,
            child: AntInfiniteScroll(
              loadMore: () async {
                callCount++;
                return false;
              },
              child: _childScroll(
                Container(
                  height: 600,
                  alignment: Alignment.bottomCenter,
                  child: const Text('长内容'),
                ),
                controller: childController,
                height: 200,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(callCount, 0);

      childController.jumpTo(childController.position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(callCount, 1);
      expect(find.text('没有更多了'), findsOneWidget);

      // 再次滚动到底不再触发。
      childController.jumpTo(childController.position.maxScrollExtent - 50);
      await tester.pumpAndSettle();
      childController.jumpTo(childController.position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(callCount, 1);
    });

    testWidgets('shows loading text while loading', (tester) async {
      // 永不完成的 Future，保持加载态。
      final completer = Completer<bool>();
      await tester.pumpWidget(
        _wrap(
          _scrollable(
            child: AntInfiniteScroll(
              loadMore: () => completer.future,
              child: _childScroll(const Column(children: [Text('内容')])),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('加载中'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      completer.complete(false);
      await tester.pumpAndSettle();
      expect(find.text('加载中'), findsNothing);
    });

    testWidgets('shows retry UI on load failure', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _scrollable(
            child: AntInfiniteScroll(
              loadMore: () async => throw Exception('网络错误'),
              child: _childScroll(const Column(children: [Text('内容')])),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('加载失败'), findsOneWidget);
      expect(find.text('点击重试'), findsOneWidget);
    });

    testWidgets('tap retry invokes loadMore again', (tester) async {
      var callCount = 0;
      var shouldFail = true;
      await tester.pumpWidget(
        _wrap(
          _scrollable(
            child: AntInfiniteScroll(
              loadMore: () async {
                callCount++;
                if (shouldFail) throw Exception('网络错误');
                return false;
              },
              // 缩小 child 视口，让 footer 重试按钮留在可视区内便于点击。
              child: _childScroll(
                const Column(children: [Text('内容')]),
                height: 100,
              ),
            ),
          ),
        ),
      );
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
      final childController = ScrollController();
      await tester.pumpWidget(
        _wrap(
          _scrollable(
            height: 200,
            child: AntInfiniteScroll(
              threshold: 500,
              loadMore: () async {
                callCount++;
                return true;
              },
              child: _childScroll(
                Container(
                  height: 600,
                  alignment: Alignment.bottomCenter,
                  child: const Text('长内容'),
                ),
                controller: childController,
                height: 200,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // 阈值 500 大于总可滚动距离，首帧即进入阈值范围自动触发。
      expect(callCount, 1);
    });

    testWidgets('default threshold does not trigger before bottom',
        (tester) async {
      var callCount = 0;
      final childController = ScrollController();
      await tester.pumpWidget(
        _wrap(
          _scrollable(
            height: 200,
            child: AntInfiniteScroll(
              loadMore: () async {
                callCount++;
                return true;
              },
              child: _childScroll(
                height: 200,
                controller: childController,
                Container(
                  height: 6000,
                  alignment: Alignment.bottomCenter,
                  child: const Text('超长内容'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      childController.jumpTo(childController.position.maxScrollExtent - 100);
      await tester.pumpAndSettle();
      // 距底部还有 100 > 默认阈值 0，未触发。
      expect(callCount, 0);
    });

    testWidgets('idle with more data does not render persistent footer',
        (tester) async {
      // 短列表：初始自动加载一次后正确复位，footer 不常驻。
      var loadCount = 0;
      await tester.pumpWidget(
        _wrap(
          _scrollable(
            child: AntInfiniteScroll(
              hasMoreText: '上拉看更多',
              loadMore: () async {
                loadCount++;
                return true;
              },
              child: _childScroll(const Column(children: [Text('内容')])),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // 首帧在底部（内容不足一屏）触发一次加载。
      expect(loadCount, 1);
      // 加载完成回 idle：不渲染常驻「还有更多」footer。
      expect(find.text('上拉看更多'), findsNothing);
    });

    testWidgets(
        'page scroll to bottom with non-scrollable child does not trigger',
        (tester) async {
      // child 无滚动组件（组件整体嵌在宿主页面滚动里）：
      // 页面滚动到底不触发加载（触发只属于自己的包裹对象）。
      var callCount = 0;
      final pageController = ScrollController();
      await tester.pumpWidget(
        _wrap(
          _scrollable(
            height: 200,
            controller: pageController,
            child: AntInfiniteScroll(
              loadMore: () async {
                callCount++;
                return true;
              },
              child: Container(
                height: 600,
                alignment: Alignment.bottomCenter,
                child: const Text('短列表'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(callCount, 0);

      pageController.jumpTo(pageController.position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(callCount, 0);
    });

    testWidgets('child ListView reaches bottom triggers, host page stays',
        (tester) async {
      var callCount = 0;
      final pageController = ScrollController();
      final listController = ScrollController();
      await tester.pumpWidget(
        _wrap(
          SingleChildScrollView(
            controller: pageController,
            child: SizedBox(
              height: 300,
              child: AntInfiniteScroll(
                loadMore: () async {
                  callCount++;
                  return true;
                },
                // child 滚动组件需由使用方给定视口高度（组件内部为
                // min-size Column，不在无界约束下展开子组件）；
                // 并关闭 Android 拉伸过冲指示器避免嵌套视口崩溃。
                child: SizedBox(
                  height: 300,
                  child: ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: ListView.builder(
                      controller: listController,
                      itemCount: 30,
                      itemBuilder: (_, i) => const SizedBox(
                        height: 20,
                        child: Text('条目 \$i'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(callCount, 0);

      // 在 child ListView 上持续拖拽到底部边缘并继续拖（过冲）：
      // 触发加载，且外层页面不跟随滚动。
      await tester.drag(find.byType(ListView), const Offset(0, -1000));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView), const Offset(0, -1000));
      await tester.pumpAndSettle();

      // 列表内容未增长时停驻底部，多次进入阈值会持续触发（对齐
      // antd-mobile：加载完成仍在阈值范围内会再次加载）。
      expect(callCount, greaterThan(0));
      expect(
        listController.offset,
        moreOrLessEquals(listController.position.maxScrollExtent),
      );
      expect(pageController.offset, 0);
    });

    testWidgets('shows loading spinner footer while loading', (tester) async {
      final completer = Completer<bool>();
      await tester.pumpWidget(
        _wrap(
          _scrollable(
            child: AntInfiniteScroll(
              loadMore: () => completer.future,
              child: _childScroll(
                const Column(children: [Text('内容')]),
                height: 100,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      // loading 态 footer 真实渲染转圈指示器。
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      completer.complete(false);
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('multiple instances on one page stay isolated', (tester) async {
      // 同一滚动页放 3 个实例：静态 child 实例不误触发，
      // 可滚动 child 实例各自独立触发，互不干扰。
      var scrollableA = 0;
      var staticB = 0;
      var scrollableC = 0;
      final controllerA = ScrollController();
      final controllerC = ScrollController();
      await tester.pumpWidget(
        _wrap(
          SingleChildScrollView(
            child: Column(
              children: [
                AntInfiniteScroll(
                  loadMore: () async {
                    scrollableA++;
                    return false;
                  },
                  child: SizedBox(
                    height: 100,
                    child: ListView(
                      controller: controllerA,
                      children: List.generate(
                        10,
                        (i) => const SizedBox(height: 20, child: Text('A\$i')),
                      ),
                    ),
                  ),
                ),
                AntInfiniteScroll(
                  loadMore: () async {
                    staticB++;
                    return false;
                  },
                  child: const SizedBox(height: 100, child: Text('B 静态区块')),
                ),
                AntInfiniteScroll(
                  loadMore: () async {
                    scrollableC++;
                    return false;
                  },
                  child: SizedBox(
                    height: 100,
                    child: ListView(
                      controller: controllerC,
                      children: const [Text('C')],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // A 内容超一屏（不在阈值内）不触发；C 内容不足一屏初始触发一次；
      // 静态 child 实例 B 永不触发。
      expect(scrollableA, 0);
      expect(staticB, 0);
      expect(scrollableC, 1);

      // 页面滚动不触发任何实例。
      final pagePosition = tester
          .state<ScrollableState>(
            find
                .descendant(
                  of: find.byType(SingleChildScrollView),
                  matching: find.byType(Scrollable),
                )
                .first,
          )
          .position;
      pagePosition.jumpTo(pagePosition.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(scrollableA, 0);
      expect(staticB, 0);
      expect(scrollableC, 1);

      // 滚动实例 A 到底 → 只触发 A。
      controllerA.jumpTo(controllerA.position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(scrollableA, 1);
      expect(scrollableC, 1);
    });

    testWidgets('supports custom texts', (tester) async {
      final completer = Completer<bool>();
      await tester.pumpWidget(
        _wrap(
          _scrollable(
            child: AntInfiniteScroll(
              loadMore: () => completer.future,
              loadingText: '努力加载中',
              hasMoreText: '上拉看更多',
              noMoreText: '到底啦',
              loadFailedText: '加载出错了',
              loadFailedRetryText: '重新加载',
              child: _childScroll(const Column(children: [Text('内容')])),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('努力加载中'), findsOneWidget);

      completer.complete(false);
      await tester.pumpAndSettle();
      expect(find.text('到底啦'), findsOneWidget);
    });

    testWidgets('shows custom failed texts and retry', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _scrollable(
            child: AntInfiniteScroll(
              loadMore: () async => throw Exception('网络错误'),
              loadFailedText: '加载出错了',
              loadFailedRetryText: '重新加载',
              child: _childScroll(const Column(children: [Text('内容')])),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('加载出错了'), findsOneWidget);
      expect(find.text('重新加载'), findsOneWidget);
    });
  });
}
