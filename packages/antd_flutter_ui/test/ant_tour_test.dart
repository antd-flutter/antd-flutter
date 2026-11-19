/// AntTour widget 测试
library;

import 'package:antd_flutter_ui/src/display/tour/ant_tour.dart';
import 'package:antd_flutter_ui/src/display/tour/ant_tour_types.dart';
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
            const AntTourStep(title: 'C', description: 'c'),
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

    // 目标位于屏幕下部：上方空间充足，topCenter 卡片应在目标上方
    await tester.pumpWidget(
      _wrap(
        Column(
          children: [
            const Spacer(),
            Container(
              key: t1,
              width: 100,
              height: 40,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            AntTour(
              open: true,
              steps: [
                AntTourStep(
                  target: t1,
                  title: '上',
                  description: '方向验证',
                  placement: AntTourPlacement.topCenter,
                ),
              ],
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    final cardRect = tester.getRect(find.byKey(kAntTourCardKey));
    final targetRect = tester.getRect(find.byKey(t1));
    expect(cardRect.bottom, lessThan(targetRect.top));
    // 箭头在卡片底边外侧（向下指向挖孔）
    final arrowRect = tester.getRect(find.byKey(kAntTourArrowKey));
    expect(arrowRect.top, greaterThan(cardRect.bottom - 12));

    // 目标位于屏幕左部：右侧空间充足，rightCenter 卡片应在目标右侧
    await tester.pumpWidget(
      _wrap(
        Stack(
          children: [
            Positioned(
              left: 40,
              top: 280,
              child: Container(
                key: t1,
                width: 100,
                height: 40,
                color: Colors.blue,
              ),
            ),
            AntTour(
              open: true,
              steps: [
                AntTourStep(
                  target: t1,
                  title: '右',
                  description: '方向验证',
                  placement: AntTourPlacement.rightCenter,
                ),
              ],
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    final cardRect2 = tester.getRect(find.byKey(kAntTourCardKey));
    final targetRect2 = tester.getRect(find.byKey(t1));
    expect(cardRect2.left, greaterThan(targetRect2.right));
    // 箭头在卡片左边缘外侧（向左指向挖孔）
    final arrowRect2 = tester.getRect(find.byKey(kAntTourArrowKey));
    expect(arrowRect2.right, lessThan(cardRect2.left + 12));
  });

  testWidgets('R30.1 探针：挖孔上半部 → 卡片翻到下方 + 箭头贴卡片顶边',
      (tester) async {
    final t1 = GlobalKey();
    await tester.pumpWidget(
      _wrap(
        _host(
          target1Key: t1,
          tour: AntTour(
            open: true,
            adaptivePosition: false,
            steps: [
              AntTourStep(
                target: t1,
                title: '上',
                description: '挖孔在上半部',
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // adaptivePosition=false 时保持请求的 bottomCenter：卡片在目标下方
    final cardRect = tester.getRect(find.byKey(kAntTourCardKey));
    final targetRect = tester.getRect(find.byKey(t1));
    expect(cardRect.top, greaterThan(targetRect.bottom));
    // 箭头贴卡片顶边外侧（向上指向挖孔）
    final arrowRect = tester.getRect(find.byKey(kAntTourArrowKey));
    expect(arrowRect.bottom, lessThan(cardRect.top + 12));
    // 箭头 tip 对齐挖孔中心 x
    expect(
      (arrowRect.center.dx - targetRect.center.dx).abs(),
      lessThan(20),
    );
  });

  testWidgets('R30.1 探针：挖孔下半部 + topCenter → 自适应翻到上方 + 箭头贴底边',
      (tester) async {
    final t1 = GlobalKey();
    await tester.pumpWidget(
      _wrap(
        Stack(
          children: [
            Positioned(
              left: 100,
              top: 500,
              child: Container(
                key: t1,
                width: 100,
                height: 40,
                color: Colors.blue,
              ),
            ),
            AntTour(
              open: true,
              steps: [
                AntTourStep(
                  target: t1,
                  title: '下',
                  description: '挖孔在下半部',
                ),
              ],
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    final cardRect = tester.getRect(find.byKey(kAntTourCardKey));
    final targetRect = tester.getRect(find.byKey(t1));
    // 下方放不下 → 自适应翻到目标上方
    expect(cardRect.bottom, lessThan(targetRect.top));
    // 箭头贴卡片底边外侧（向下指向挖孔）
    final arrowRect = tester.getRect(find.byKey(kAntTourArrowKey));
    expect(arrowRect.top, greaterThan(cardRect.bottom - 12));
  });

  testWidgets('R30.1 探针：挖孔右缘 + rightCenter → 自适应翻到左侧 + 箭头贴右边缘',
      (tester) async {
    final t1 = GlobalKey();
    await tester.pumpWidget(
      _wrap(
        Stack(
          children: [
            Positioned(
              left: 680,
              top: 280,
              child: Container(
                key: t1,
                width: 100,
                height: 40,
                color: Colors.blue,
              ),
            ),
            AntTour(
              open: true,
              steps: [
                AntTourStep(
                  target: t1,
                  title: '右缘',
                  description: '右侧放不下',
                  placement: AntTourPlacement.rightCenter,
                ),
              ],
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    final cardRect = tester.getRect(find.byKey(kAntTourCardKey));
    final targetRect = tester.getRect(find.byKey(t1));
    // 右侧放不下 → 卡片翻到目标左侧
    expect(cardRect.right, lessThan(targetRect.left));
    // 箭头贴卡片右边缘外侧（向右指向挖孔）
    final arrowRect = tester.getRect(find.byKey(kAntTourArrowKey));
    expect(arrowRect.right, greaterThan(cardRect.right - 12));
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

  testWidgets('R30.1 skipConfirm：跳过弹出确认框，确认后关闭', (tester) async {
    final t1 = GlobalKey();
    bool closed = false;
    await tester.pumpWidget(
      _wrap(
        _host(
          target1Key: t1,
          tour: AntTour(
            open: true,
            skipConfirm: true,
            steps: [AntTourStep(target: t1, title: 'A', description: 'a')],
            onClose: () => closed = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(kAntTourSkipButtonKey));
    await tester.pumpAndSettle();
    // 确认弹窗出现，引导未关闭
    expect(find.text('确定要结束引导吗？'), findsOneWidget);
    expect(closed, isFalse);

    await tester.tap(find.text('取消'));
    await tester.pumpAndSettle();
    // 取消 → 引导恢复，未关闭
    expect(closed, isFalse);
    expect(find.byKey(kAntTourCardKey), findsOneWidget);

    // 再次跳过并确认 → 关闭
    await tester.tap(find.byKey(kAntTourSkipButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.text('确定'));
    await tester.pumpAndSettle();
    expect(closed, isTrue);
  });

  testWidgets('R30.1 skipConfirm=false：跳过直接关闭（默认行为兼容）',
      (tester) async {
    final t1 = GlobalKey();
    bool closed = false;
    await tester.pumpWidget(
      _wrap(
        _host(
          target1Key: t1,
          tour: AntTour(
            open: true,
            steps: [AntTourStep(target: t1, title: 'A', description: 'a')],
            onClose: () => closed = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(kAntTourSkipButtonKey));
    await tester.pumpAndSettle();
    expect(closed, isTrue);
  });

  testWidgets('R30.1 adaptivePosition：上方空间不足时卡片翻到目标下方',
      (tester) async {
    final t1 = GlobalKey();
    await tester.pumpWidget(
      _wrap(
        _host(
          target1Key: t1,
          tour: AntTour(
            open: true,
            adaptivePosition: true,
            steps: [
              AntTourStep(
                target: t1,
                title: '自适应',
                description: '避让',
                placement: AntTourPlacement.topCenter,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final cardRect = tester.getRect(find.byKey(kAntTourCardKey));
    final targetRect = tester.getRect(find.byKey(t1));
    expect(cardRect.top, greaterThan(targetRect.bottom));
  });
}
