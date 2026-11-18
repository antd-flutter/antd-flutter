/// AntPopover / AntPopconfirm / AntDropdown 触发弹出回归测试
///
/// 回归背景（P15 修复）：迁移统一弹层基座后，触发元素为 AntButton 等自带
/// GestureDetector 的组件时，外层 GestureDetector 的 tap 在手势竞技场中被
/// 内层识别器判负，导致点击不弹出。修复后基座触发区域改用 Listener
/// （AntPopupTriggerRegion，不参与手势竞技场），本文件锁定该行为。
library;

import 'package:antd_flutter_ui/src/basic/button/ant_button.dart';
import 'package:antd_flutter_ui/src/display/popover/ant_dropdown.dart';
import 'package:antd_flutter_ui/src/display/popover/ant_popconfirm.dart';
import 'package:antd_flutter_ui/src/display/popover/ant_popover.dart';
import 'package:antd_flutter_ui/src/display/popover/ant_dropdown_types.dart';
import 'package:antd_flutter_ui/src/display/popover/ant_popover_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

/// 触发元素定位辅助。
Finder findTrigger(String text) => find.text(text);

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: Center(
          child: AntTheme(
            data: AntThemeData.light(),
            child: Material(child: child),
          ),
        ),
      ),
    ),
  );
}

/// 桌面端鼠标悬停（MouseRegion 只响应 mouse 设备指针）。
Future<void> _hover(WidgetTester tester, Finder finder) async {
  final center = tester.getCenter(finder);
  final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
  addTearDown(gesture.removePointer);
  await gesture.addPointer(location: Offset.zero);
  await gesture.moveTo(center);
  await tester.pumpAndSettle();
}

void main() {
  group('AntPopover — 点击触发', () {
    testWidgets('AntButton 上点击弹出气泡', (tester) async {
      await tester.pumpWidget(_wrap(const AntPopover(
        trigger: AntPopoverTrigger.click,
        title: Text('标题'),
        content: Text('气泡内容'),
        arrow: true,
        child: AntButton(child: Text('触发')),
      ),),);
      await tester.pumpAndSettle();
      expect(find.text('气泡内容'), findsNothing);

      await tester.tap(findTrigger('触发'));
      await tester.pumpAndSettle();

      expect(find.text('标题'), findsOneWidget);
      expect(find.text('气泡内容'), findsOneWidget);
      expect(find.byKey(kAntPopoverBubbleKey), findsOneWidget);
      expect(find.byKey(kAntPopoverArrowKey), findsOneWidget);
    });

    testWidgets('点击空白处关闭气泡', (tester) async {
      await tester.pumpWidget(_wrap(const AntPopover(
        trigger: AntPopoverTrigger.click,
        content: Text('气泡内容'),
        child: AntButton(child: Text('触发')),
      ),),);
      await tester.pumpAndSettle();
      await tester.tap(findTrigger('触发'));
      await tester.pumpAndSettle();
      expect(find.text('气泡内容'), findsOneWidget);

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('气泡内容'), findsNothing);
    });

    testWidgets('再次点击触发元素关闭气泡', (tester) async {
      await tester.pumpWidget(_wrap(const AntPopover(
        trigger: AntPopoverTrigger.click,
        content: Text('气泡内容'),
        child: AntButton(child: Text('触发')),
      ),),);
      await tester.pumpAndSettle();
      await tester.tap(findTrigger('触发'));
      await tester.pumpAndSettle();
      expect(find.text('气泡内容'), findsOneWidget);

      await tester.tap(findTrigger('触发'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('气泡内容'), findsNothing);
    });

    testWidgets('hover 触发：鼠标移入弹出', (tester) async {
      await tester.pumpWidget(_wrap(const AntPopover(
        trigger: AntPopoverTrigger.hover,
        content: Text('气泡内容'),
        child: AntButton(child: Text('触发')),
      ),),);
      await tester.pumpAndSettle();

      await _hover(tester, findTrigger('触发'));
      expect(find.text('气泡内容'), findsOneWidget);
    });

    testWidgets('child 自带 onTap 的 AntButton 手势仍生效', (tester) async {
      var buttonTapped = false;
      await tester.pumpWidget(_wrap(AntPopover(
        trigger: AntPopoverTrigger.click,
        content: const Text('气泡内容'),
        child: AntButton(onTap: () => buttonTapped = true, child: const Text('触发')),
      ),),);
      await tester.pumpAndSettle();

      await tester.tap(findTrigger('触发'));
      await tester.pumpAndSettle();

      expect(buttonTapped, isTrue, reason: '弹层触发不应抢走子组件自身点击');
      expect(find.text('气泡内容'), findsOneWidget);
    });
  });

  group('AntPopconfirm — 点击触发', () {
    testWidgets('AntButton 上点击弹出确认气泡', (tester) async {
      await tester.pumpWidget(_wrap(const AntPopconfirm(
        title: '确定删除吗？',
        child: AntButton(child: Text('删除')),
      ),),);
      await tester.pumpAndSettle();
      expect(find.text('确定删除吗？'), findsNothing);

      await tester.tap(findTrigger('删除'));
      await tester.pumpAndSettle();

      expect(find.text('确定删除吗？'), findsOneWidget);
      expect(find.byKey(kAntPopconfirmBubbleKey), findsOneWidget);
      expect(find.byKey(kAntPopconfirmOkButtonKey), findsOneWidget);
      expect(find.byKey(kAntPopconfirmCancelButtonKey), findsOneWidget);
    });

    testWidgets('点击确定关闭并回调 onConfirm', (tester) async {
      var confirmed = false;
      await tester.pumpWidget(_wrap(AntPopconfirm(
        title: '确定吗',
        onConfirm: () => confirmed = true,
        child: const AntButton(child: Text('删除')),
      ),),);
      await tester.pumpAndSettle();
      await tester.tap(findTrigger('删除'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(kAntPopconfirmOkButtonKey));
      await tester.pumpAndSettle();

      expect(confirmed, isTrue);
      expect(find.text('确定吗'), findsNothing);
    });

    testWidgets('点击取消关闭并回调 onCancel', (tester) async {
      var cancelled = false;
      await tester.pumpWidget(_wrap(AntPopconfirm(
        title: '确定吗',
        onCancel: () => cancelled = true,
        child: const AntButton(child: Text('删除')),
      ),),);
      await tester.pumpAndSettle();
      await tester.tap(findTrigger('删除'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(kAntPopconfirmCancelButtonKey));
      await tester.pumpAndSettle();

      expect(cancelled, isTrue);
      expect(find.text('确定吗'), findsNothing);
    });
  });

  group('AntDropdown — 点击触发', () {
    testWidgets('AntButton 上点击弹出菜单', (tester) async {
      await tester.pumpWidget(_wrap(const AntDropdown(
        trigger: AntDropdownTrigger.click,
        items: [
          AntDropdownItem(key: '1', label: '菜单项一'),
          AntDropdownItem(key: '2', label: '菜单项二'),
        ],
        child: AntButton(child: Text('下拉菜单')),
      ),),);
      await tester.pumpAndSettle();
      expect(find.text('菜单项一'), findsNothing);

      await tester.tap(findTrigger('下拉菜单'));
      await tester.pumpAndSettle();

      expect(find.text('菜单项一'), findsOneWidget);
      expect(find.text('菜单项二'), findsOneWidget);
    });

    testWidgets('点击菜单项回调 onClick 并关闭', (tester) async {
      String? clickedKey;
      await tester.pumpWidget(_wrap(AntDropdown(
        trigger: AntDropdownTrigger.click,
        items: const [
          AntDropdownItem(key: '1', label: '菜单项一'),
        ],
        onClick: (key) => clickedKey = key,
        child: const AntButton(child: Text('下拉菜单')),
      ),),);
      await tester.pumpAndSettle();
      await tester.tap(findTrigger('下拉菜单'));
      await tester.pumpAndSettle();
      expect(find.text('菜单项一'), findsOneWidget);

      await tester.tap(find.text('菜单项一'));
      await tester.pumpAndSettle();

      expect(clickedKey, '1');
      expect(find.text('菜单项一'), findsNothing);
    });

    testWidgets('点击空白处关闭菜单', (tester) async {
      await tester.pumpWidget(_wrap(const AntDropdown(
        trigger: AntDropdownTrigger.click,
        items: [
          AntDropdownItem(key: '1', label: '菜单项一'),
        ],
        child: AntButton(child: Text('下拉菜单')),
      ),),);
      await tester.pumpAndSettle();
      await tester.tap(findTrigger('下拉菜单'));
      await tester.pumpAndSettle();
      expect(find.text('菜单项一'), findsOneWidget);

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('菜单项一'), findsNothing);
    });
  });
}
