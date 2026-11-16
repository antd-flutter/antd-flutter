/// AntTour widget 测试
library;

import 'package:antd_flutter_plus/src/components/data_display/tour/ant_tour.dart';
import 'package:antd_flutter_plus/src/components/data_display/tour/ant_tour_types.dart';
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

/// 带两个引导目标的宿主布局。
Widget _host({
  required Widget tour,
  Key? target1Key,
  Key? target2Key,
}) {
  return _wrap(
    Column(
      children: [
        const SizedBox(height: 100),
        Container(
          key: target1Key ?? const Key('tour-target-1'),
          width: 100,
          height: 40,
          color: Colors.blue,
        ),
        const SizedBox(height: 60),
        Container(
          key: target2Key ?? const Key('tour-target-2'),
          width: 100,
          height: 40,
          color: Colors.green,
        ),
        tour,
      ],
    ),
  );
}

void main() {
  testWidgets('open=true 显示第一步卡片与遮罩', (tester) async {
    final t1 = GlobalKey();
    final t2 = GlobalKey();
    await tester.pumpWidget(
      _host(
        target1Key: t1,
        target2Key: t2,
        tour: AntTour(
          open: true,
          steps: [
            AntTourStep(
              target: t1,
              title: '第一步标题',
              description: '第一步描述',
            ),
            AntTourStep(target: t2, title: '第二步标题', description: '第二步描述'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(kAntTourCardKey), findsOneWidget);
    expect(find.byKey(kAntTourMaskKey), findsOneWidget);
    expect(find.text('第一步标题'), findsOneWidget);
    expect(find.text('第一步描述'), findsOneWidget);
  });

  testWidgets('open=false 不显示引导', (tester) async {
    final t1 = GlobalKey();
    await tester.pumpWidget(
      _host(
        target1Key: t1,
        tour: AntTour(
          open: false,
          steps: [AntTourStep(target: t1, title: '未打开', description: '内容')],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(kAntTourCardKey), findsNothing);
    expect(find.byKey(kAntTourMaskKey), findsNothing);
  });

  testWidgets('target 定位：卡片出现在目标附近（下方 placement）', (tester) async {
    final t1 = GlobalKey();
    await tester.pumpWidget(
      _host(
        target1Key: t1,
        tour: AntTour(
          open: true,
          steps: [
            AntTourStep(
              target: t1,
              title: '定位步骤',
              description: '卡片在目标下方',
              placement: AntTourPlacement.bottomCenter,
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    final cardRect = tester.getRect(find.byKey(kAntTourCardKey));
    final targetRect = tester.getRect(find.byKey(t1));
    expect(cardRect.top, greaterThan(targetRect.bottom));
    // 卡片水平覆盖目标区域附近
    expect(cardRect.left, lessThan(targetRect.center.dx));
    expect(cardRect.right, greaterThan(targetRect.center.dx));
  });

  testWidgets('无 target 全屏居中', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const AntTour(
          open: true,
          steps: [
            AntTourStep(title: '居中步骤', description: '没有目标元素'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    final cardRect = tester.getRect(find.byKey(kAntTourCardKey));
    final screen = tester.getRect(find.byType(Scaffold));
    expect(
      (cardRect.center.dx - screen.center.dx).abs(),
      lessThan(20),
    );
    expect(
      (cardRect.center.dy - screen.center.dy).abs(),
      lessThan(20),
    );
    expect(find.text('居中步骤'), findsOneWidget);
  });

  testWidgets('title 与 description 渲染', (tester) async {
    final t1 = GlobalKey();
    await tester.pumpWidget(
      _host(
        target1Key: t1,
        tour: AntTour(
          open: true,
          steps: [
            AntTourStep(target: t1, title: '引导标题', description: '引导描述内容'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('引导标题'), findsOneWidget);
    expect(find.text('引导描述内容'), findsOneWidget);
  });

  testWidgets('步骤指示显示 1 / N', (tester) async {
    final t1 = GlobalKey();
    final t2 = GlobalKey();
    await tester.pumpWidget(
      _host(
        target1Key: t1,
        target2Key: t2,
        tour: AntTour(
          open: true,
          steps: [
            AntTourStep(target: t1, title: 'A', description: 'a'),
            AntTourStep(target: t2, title: 'B', description: 'b'),
            AntTourStep(title: 'C', description: 'c'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('1 / 3'), findsOneWidget);
  });

  testWidgets('下一步进入第二步并触发 onStepChange', (tester) async {
    final t1 = GlobalKey();
    final t2 = GlobalKey();
    final changed = <int>[];
    await tester.pumpWidget(
      _host(
        target1Key: t1,
        target2Key: t2,
        tour: AntTour(
          open: true,
          onStepChange: changed.add,
          steps: [
            AntTourStep(target: t1, title: 'A', description: 'a'),
            AntTourStep(target: t2, title: 'B', description: 'b'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(kAntTourNextButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('2 / 2'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(changed, [1]);
  });

  testWidgets('上一步返回第一步', (tester) async {
    final t1 = GlobalKey();
    final t2 = GlobalKey();
    await tester.pumpWidget(
      _host(
        target1Key: t1,
        target2Key: t2,
        tour: AntTour(
          open: true,
          steps: [
            AntTourStep(target: t1, title: 'A', description: 'a'),
            AntTourStep(target: t2, title: 'B', description: 'b'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    // 第一步无上一步按钮
    expect(find.byKey(kAntTourPrevButtonKey), findsNothing);
    await tester.tap(find.byKey(kAntTourNextButtonKey));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntTourPrevButtonKey), findsOneWidget);
    await tester.tap(find.byKey(kAntTourPrevButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('1 / 2'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
  });

  testWidgets('最后一步显示完成按钮，点击触发 onFinish', (tester) async {
    final t1 = GlobalKey();
    var finished = false;
    await tester.pumpWidget(
      _host(
        target1Key: t1,
        tour: AntTour(
          open: true,
          onFinish: () => finished = true,
          steps: [AntTourStep(target: t1, title: 'A', description: 'a')],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(kAntTourFinishLabel), findsOneWidget);
    expect(find.byKey(kAntTourCardKey), findsOneWidget);
    await tester.tap(find.byKey(kAntTourNextButtonKey));
    await tester.pumpAndSettle();
    expect(finished, isTrue);
    expect(find.byKey(kAntTourCardKey), findsNothing);
  });

  testWidgets('跳过按钮触发 onClose 并关闭引导', (tester) async {
    final t1 = GlobalKey();
    var closed = false;
    await tester.pumpWidget(
      _host(
        target1Key: t1,
        tour: AntTour(
          open: true,
          onClose: () => closed = true,
          steps: [AntTourStep(target: t1, title: 'A', description: 'a')],
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(kAntTourSkipButtonKey));
    await tester.pumpAndSettle();
    expect(closed, isTrue);
    expect(find.byKey(kAntTourCardKey), findsNothing);
  });

  testWidgets('maskClosable=true 点击遮罩关闭，false 不关闭', (tester) async {
    final t1 = GlobalKey();
    // 可关闭
    var closed = false;
    await tester.pumpWidget(
      _host(
        target1Key: t1,
        tour: AntTour(
          key: const Key('tour-mask-closable'),
          open: true,
          maskClosable: true,
          onClose: () => closed = true,
          steps: [AntTourStep(target: t1, title: 'A', description: 'a')],
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 400));
    await tester.pumpAndSettle();
    expect(closed, isTrue);
    expect(find.byKey(kAntTourCardKey), findsNothing);

    // 不可关闭（默认）
    await tester.pumpWidget(
      _host(
        target1Key: t1,
        tour: AntTour(
          key: const Key('tour-mask-fixed'),
          open: true,
          steps: [AntTourStep(target: t1, title: 'B', description: 'b')],
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 400));
    await tester.pumpAndSettle();
    expect(find.byKey(kAntTourCardKey), findsOneWidget);
  });

  testWidgets('mask=false 无遮罩', (tester) async {
    final t1 = GlobalKey();
    await tester.pumpWidget(
      _host(
        target1Key: t1,
        tour: AntTour(
          key: const Key('tour-mask-off'),
          open: true,
          mask: false,
          steps: [AntTourStep(target: t1, title: 'A', description: 'a')],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(kAntTourCardKey), findsOneWidget);
    expect(find.byKey(kAntTourMaskKey), findsNothing);
  });

  testWidgets('arrow=false 无箭头，默认显示箭头', (tester) async {
    final t1 = GlobalKey();
    await tester.pumpWidget(
      _host(
        target1Key: t1,
        tour: AntTour(
          key: const Key('tour-arrow-off'),
          open: true,
          arrow: false,
          steps: [AntTourStep(target: t1, title: 'A', description: 'a')],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(kAntTourArrowKey), findsNothing);

    await tester.pumpWidget(
      _host(
        target1Key: t1,
        tour: AntTour(
          key: const Key('tour-arrow-on'),
          open: true,
          arrow: true,
          steps: [AntTourStep(target: t1, title: 'A2', description: 'a2')],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(kAntTourArrowKey), findsOneWidget);
  });

  testWidgets('placement 方向：卡片在目标上方 / 右侧', (tester) async {
    final t1 = GlobalKey();
    Future<void> pumpPlacement(
      AntTourPlacement placement,
      String title,
    ) async {
      await tester.pumpWidget(
        _host(
          target1Key: t1,
          tour: AntTour(
            open: true,
            steps: [
              AntTourStep(
                target: t1,
                title: title,
                description: '方向验证',
                placement: placement,
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    await pumpPlacement(AntTourPlacement.topCenter, '上');
    final cardRect = tester.getRect(find.byKey(kAntTourCardKey));
    final targetRect = tester.getRect(find.byKey(t1));
    expect(cardRect.bottom, lessThan(targetRect.top));

    await pumpPlacement(AntTourPlacement.rightCenter, '右');
    final cardRect2 = tester.getRect(find.byKey(kAntTourCardKey));
    expect(cardRect2.left, greaterThan(targetRect.right));
  });

  testWidgets('受控 current：外部控制当前步索引', (tester) async {
    final t1 = GlobalKey();
    final t2 = GlobalKey();
    int current = 0;
    late StateSetter setState;
    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, s) {
            setState = s;
            return _host(
              target1Key: t1,
              target2Key: t2,
              tour: AntTour(
                open: true,
                current: current,
                steps: [
                  AntTourStep(target: t1, title: 'A', description: 'a'),
                  AntTourStep(target: t2, title: 'B', description: 'b'),
                ],
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('1 / 2'), findsOneWidget);

    // 内部点击下一步不改变受控索引
    await tester.tap(find.byKey(kAntTourNextButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('1 / 2'), findsOneWidget);

    // 外部更新 current 后切换到第二步
    setState(() => current = 1);
    await tester.pumpAndSettle();
    expect(find.text('2 / 2'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
  });

  testWidgets('open 变化：false→true 打开引导', (tester) async {
    final t1 = GlobalKey();
    bool open = false;
    late StateSetter setState;
    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, s) {
            setState = s;
            return _host(
              target1Key: t1,
              tour: AntTour(
                open: open,
                steps: [AntTourStep(target: t1, title: 'A', description: 'a')],
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(kAntTourCardKey), findsNothing);

    setState(() => open = true);
    await tester.pumpAndSettle();
    expect(find.byKey(kAntTourCardKey), findsOneWidget);
  });
}
