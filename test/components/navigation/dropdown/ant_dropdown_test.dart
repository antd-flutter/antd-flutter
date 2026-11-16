/// AntDropdown widget 测试
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

void main() {
  group('AntDropdown — 渲染', () {
    testWidgets('渲染触发元素', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDropdown(
            items: [AntDropdownItem(key: '1', label: '菜单项')],
            child: Text('触发'),
          ),
        ),
      );
      expect(find.text('触发'), findsOneWidget);
      expect(find.text('菜单项'), findsNothing);
    });

    testWidgets('空 items 不弹出', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDropdown(
            trigger: AntDropdownTrigger.click,
            child: Text('触发'),
          ),
        ),
      );
      await tester.tap(find.text('触发'));
      await tester.pumpAndSettle();
      // 无 items，不弹出浮层
      expect(find.byType(OverlayEntry), findsNothing);
    });
  });

  group('AntDropdown — 点击触发', () {
    testWidgets('点击打开浮层', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDropdown(
            trigger: AntDropdownTrigger.click,
            items: [
              AntDropdownItem(key: '1', label: '菜单项一'),
              AntDropdownItem(key: '2', label: '菜单项二'),
            ],
            child: Text('下拉'),
          ),
        ),
      );
      expect(find.text('菜单项一'), findsNothing);

      await tester.tap(find.text('下拉'));
      await tester.pumpAndSettle();

      expect(find.text('菜单项一'), findsOneWidget);
      expect(find.text('菜单项二'), findsOneWidget);
    });

    testWidgets('再次点击关闭浮层', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDropdown(
            trigger: AntDropdownTrigger.click,
            items: [AntDropdownItem(key: '1', label: '菜单项')],
            child: Text('下拉'),
          ),
        ),
      );
      await tester.tap(find.text('下拉'));
      await tester.pumpAndSettle();
      expect(find.text('菜单项'), findsOneWidget);

      await tester.tap(find.text('下拉'));
      await tester.pumpAndSettle();
      expect(find.text('菜单项'), findsNothing);
    });

    testWidgets('点击菜单项触发 onClick 并关闭', (tester) async {
      String? clickedKey;
      await tester.pumpWidget(
        _wrap(
          AntDropdown(
            trigger: AntDropdownTrigger.click,
            items: const [
              AntDropdownItem(key: '1', label: '菜单项一'),
              AntDropdownItem(key: '2', label: '菜单项二'),
            ],
            child: const Text('下拉'),
            onClick: (key) => clickedKey = key,
          ),
        ),
      );
      await tester.tap(find.text('下拉'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('菜单项二'));
      await tester.pumpAndSettle();

      expect(clickedKey, '2');
      expect(find.text('菜单项一'), findsNothing);
    });

    testWidgets('onOpenChange 回调', (tester) async {
      final states = <bool>[];
      await tester.pumpWidget(
        _wrap(
          AntDropdown(
            trigger: AntDropdownTrigger.click,
            items: const [AntDropdownItem(key: '1', label: '菜单项')],
            child: const Text('下拉'),
            onOpenChange: (open) => states.add(open),
          ),
        ),
      );
      await tester.tap(find.text('下拉'));
      await tester.pumpAndSettle();
      expect(states, contains(true));

      await tester.tap(find.text('下拉'));
      await tester.pumpAndSettle();
      expect(states, contains(false));
    });

    testWidgets('disabled 不打开', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDropdown(
            trigger: AntDropdownTrigger.click,
            disabled: true,
            items: [AntDropdownItem(key: '1', label: '菜单项')],
            child: Text('下拉'),
          ),
        ),
      );
      await tester.tap(find.text('下拉'));
      await tester.pumpAndSettle();
      expect(find.text('菜单项'), findsNothing);
    });
  });

  group('AntDropdown — 悬停触发', () {
    testWidgets('悬停打开，移出关闭', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDropdown(
            trigger: AntDropdownTrigger.hover,
            items: [AntDropdownItem(key: '1', label: '悬停项')],
            child: Text('悬停'),
          ),
        ),
      );
      expect(find.text('悬停项'), findsNothing);

      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(
        location: tester.getCenter(find.text('悬停')),
      );
      await tester.pumpAndSettle();
      expect(find.text('悬停项'), findsOneWidget);

      await gesture.moveTo(const Offset(500, 500));
      await tester.pumpAndSettle();
      expect(find.text('悬停项'), findsNothing);
    });
  });

  group('AntDropdown — 受控模式', () {
    testWidgets('open=true 显示浮层', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDropdown(
            open: true,
            items: [AntDropdownItem(key: '1', label: '受控项')],
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('受控项'), findsOneWidget);
    });

    testWidgets('open=false 不显示浮层', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDropdown(
            open: false,
            trigger: AntDropdownTrigger.click,
            items: [AntDropdownItem(key: '1', label: '受控项')],
            child: Text('触发'),
          ),
        ),
      );
      await tester.tap(find.text('触发'));
      await tester.pumpAndSettle();
      // 受控模式点击不改变
      expect(find.text('受控项'), findsNothing);
    });
  });

  group('AntDropdown — 菜单项样式', () {
    testWidgets('分割线渲染', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDropdown(
            open: true,
            items: [
              AntDropdownItem(key: '1', label: '项一'),
              AntDropdownItem(key: 'd', type: AntDropdownItemType.divider),
              AntDropdownItem(key: '2', label: '项二'),
            ],
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('项一'), findsOneWidget);
      expect(find.text('项二'), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('danger 项文字为红色', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDropdown(
            open: true,
            items: [
              AntDropdownItem(key: '1', label: '危险项', danger: true),
            ],
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final theme = AntThemeData.light();
      final text = tester.widget<Text>(find.text('危险项'));
      expect(text.style?.color, theme.colorError);
    });

    testWidgets('disabled 项不可点击', (tester) async {
      String? clickedKey;
      await tester.pumpWidget(
        _wrap(
          AntDropdown(
            open: true,
            items: const [
              AntDropdownItem(key: '1', label: '禁用项', disabled: true),
            ],
            child: const Text('触发'),
            onClick: (key) => clickedKey = key,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('禁用项'));
      await tester.pumpAndSettle();

      expect(clickedKey, isNull);
    });

    testWidgets('labelWidget 优先于 label', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDropdown(
            open: true,
            items: [
              AntDropdownItem(
                key: '1',
                label: '文字',
                labelWidget: Text('自定义'),
              ),
            ],
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('自定义'), findsOneWidget);
      expect(find.text('文字'), findsNothing);
    });

    testWidgets('带图标渲染', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntDropdown(
            open: true,
            items: [
              AntDropdownItem(key: '1', label: '图标项', icon: Icons.star),
            ],
            child: Text('触发'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.text('图标项'), findsOneWidget);
    });
  });
}