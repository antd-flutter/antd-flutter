/// AntMask widget 测试
library;

import 'package:antd_flutter_plus/src/components/feedback/mask/ant_mask.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox.expand(child: child),
    ),
  );
}

void main() {
  testWidgets('visible=true 显示全屏遮罩', (tester) async {
    await tester.pumpWidget(_wrap(const AntMask(visible: true)));
    expect(find.byKey(kAntMaskKey), findsOneWidget);
  });

  testWidgets('点击遮罩触发 onAction', (tester) async {
    var actionCount = 0;
    await tester.pumpWidget(
      _wrap(AntMask(visible: true, onAction: () => actionCount++)),
    );
    await tester.tap(find.byKey(kAntMaskKey));
    await tester.pump();
    expect(actionCount, 1);
  });

  testWidgets('opacity 透传到遮罩透明度', (tester) async {
    await tester.pumpWidget(
      _wrap(const AntMask(visible: true, opacity: 0.75)),
    );
    // 完成淡入动画
    await tester.pump(kAntMaskAnimationDuration);
    final fade = tester.widget<AnimatedOpacity>(
      find.descendant(of: find.byKey(kAntMaskKey), matching: find.byType(AnimatedOpacity)).first,
    );
    expect(fade.opacity, 0.75);
  });

  testWidgets('color 自定义遮罩颜色', (tester) async {
    const customColor = Color(0xFF123456);
    await tester.pumpWidget(
      _wrap(const AntMask(visible: true, color: customColor)),
    );
    final coloredBox = tester.widget<ColoredBox>(
      find.descendant(of: find.byKey(kAntMaskKey), matching: find.byType(ColoredBox)).first,
    );
    expect(coloredBox.color, customColor);
  });

  testWidgets('淡入动画：入场过程中透明度渐增', (tester) async {
    await tester.pumpWidget(_wrap(const AntMask(visible: true)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    final fade = tester.widget<AnimatedOpacity>(
      find.descendant(of: find.byKey(kAntMaskKey), matching: find.byType(AnimatedOpacity)).first,
    );
    // 动画目标值为默认 0.5
    expect(fade.opacity, kAntMaskDefaultOpacity);
    expect(fade.duration, kAntMaskAnimationDuration);
  });

  testWidgets('visible=false 不显示遮罩且点击不触发 onAction', (tester) async {
    var actionCount = 0;
    await tester.pumpWidget(
      _wrap(AntMask(visible: false, onAction: () => actionCount++)),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(kAntMaskKey), findsNothing);
    await tester.tap(find.byType(Scaffold), warnIfMissed: false);
    await tester.pump();
    expect(actionCount, 0);
  });

  testWidgets('上层 child 渲染且点击 child 不触发遮罩 onAction', (tester) async {
    var maskAction = 0;
    var childTap = 0;
    await tester.pumpWidget(
      _wrap(AntMask(
        visible: true,
        opacity: 0.4,
        onAction: () => maskAction++,
        child: Center(
          child: ElevatedButton(
            key: const Key('mask-child-btn'),
            onPressed: () => childTap++,
            child: const Text('遮罩上层按钮'),
          ),
        ),
      ),),
    );
    expect(find.text('遮罩上层按钮'), findsOneWidget);
    // 点击上层内容区域：命中 child 按钮，不触发遮罩回调
    await tester.tap(find.byKey(const Key('mask-child-btn')));
    await tester.pump();
    expect(childTap, 1);
    expect(maskAction, 0);
    // 点击遮罩空白区域触发 onAction
    await tester.tapAt(const Offset(20, 20));
    await tester.pump();
    expect(maskAction, 1);
  });

  testWidgets('visible=false 隐藏后上层 child 不响应点击', (tester) async {
    var childTap = 0;
    await tester.pumpWidget(
      _wrap(AntMask(
        visible: false,
        child: Center(
          child: ElevatedButton(
            key: const Key('hidden-child-btn'),
            onPressed: () => childTap++,
            child: const Text('隐藏层按钮'),
          ),
        ),
      ),),
    );
    await tester.pumpAndSettle();
    expect(find.text('隐藏层按钮'), findsNothing);
  });

  testWidgets('destroyOnClose=true 关闭后销毁上层内容', (tester) async {
    var childTap = 0;
    await tester.pumpWidget(
      _wrap(AntMask(
        visible: true,
        destroyOnClose: true,
        child: Center(
          child: ElevatedButton(
            key: const Key('destroy-child-btn'),
            onPressed: () => childTap++,
            child: const Text('销毁按钮'),
          ),
        ),
      ),),
    );
    await tester.pumpAndSettle();
    expect(find.text('销毁按钮'), findsOneWidget);

    // 切换为隐藏后内容被销毁
    await tester.pumpWidget(
      _wrap(AntMask(
        visible: false,
        destroyOnClose: true,
        child: Center(
          child: ElevatedButton(
            key: const Key('destroy-child-btn'),
            onPressed: () => childTap++,
            child: const Text('销毁按钮'),
          ),
        ),
      ),),
    );
    await tester.pumpAndSettle();
    expect(find.text('销毁按钮'), findsNothing);
  });

  testWidgets('淡出动画后遮罩透明度归零且点击不再触发（关闭动画）', (tester) async {
    var actionCount = 0;
    await tester.pumpWidget(
      _wrap(AntMask(visible: true, onAction: () => actionCount++)),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(kAntMaskKey), findsOneWidget);

    // 切换为隐藏：动画进行中遮罩仍挂载（透明度渐降）
    await tester.pumpWidget(
      _wrap(AntMask(visible: false, onAction: () => actionCount++)),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byKey(kAntMaskKey), findsOneWidget);
    // 动画结束后透明度归零，且点击不再触发回调
    await tester.pumpAndSettle();
    final fade = tester.widget<AnimatedOpacity>(
      find.descendant(of: find.byKey(kAntMaskKey), matching: find.byType(AnimatedOpacity)).first,
    );
    expect(fade.opacity, 0);
    await tester.tap(find.byKey(kAntMaskKey), warnIfMissed: false);
    await tester.pump();
    expect(actionCount, 0);
  });

  testWidgets('forceRender=true 隐藏时仍渲染（但不可点击）', (tester) async {
    await tester.pumpWidget(
      _wrap(const AntMask(visible: false, forceRender: true)),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(kAntMaskKey), findsOneWidget);
  });
}
