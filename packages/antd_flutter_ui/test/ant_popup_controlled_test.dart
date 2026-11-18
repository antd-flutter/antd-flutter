/// Popover / Popconfirm / Dropdown 受控 open 回归测试
///
/// 回归：受控 open 切换发生在父级 build 阶段（setState 联动），
/// didUpdateWidget 中直接 Overlay.insert 触发 markNeedsBuild during build；
/// 修复统一走 PopupOpenScheduler 帧末调度。
library;

import 'package:antd_flutter_ui/src/basic/button/ant_button.dart';
import 'package:antd_flutter_ui/src/display/popover/ant_popover.dart';
import 'package:antd_flutter_ui/src/display/popover/ant_popconfirm.dart';
import 'package:antd_flutter_ui/src/display/popover/ant_dropdown_types.dart';
import 'package:antd_flutter_ui/src/display/popover/ant_dropdown.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => AntScreenUtilInit(
      builder: (context, _) => MaterialApp(
        home: Scaffold(
          body: AntTheme(
            data: AntThemeData.light(),
            child: Material(child: child),
          ),
        ),
      ),
    );

void main() {
  testWidgets('Popover 受控 open false→true', (tester) async {
    bool open = false;
    late StateSetter setter;
    await tester.pumpWidget(_wrap(
      StatefulBuilder(builder: (context, s) {
        setter = s;
        return Column(children: [
          AntButton(
            onTap: () => setter(() => open = !open),
            child: Text(open ? '关' : '开'),
          ),
          AntPopover(
            open: open,
            onOpenChange: (v) => setter(() => open = v),
            content: const Text('受控气泡'),
            child: const Text('受控触发'),
          ),
        ],);
      },),
    ),);
    await tester.pumpAndSettle();
    expect(find.text('受控气泡'), findsNothing);
    await tester.tap(find.byType(AntButton));
    await tester.pumpAndSettle();
    expect(find.text('受控气泡'), findsOneWidget);
    await tester.tap(find.byType(AntButton));
    await tester.pumpAndSettle();
    expect(find.text('受控气泡'), findsNothing);
  });

  testWidgets('Popconfirm 受控 open false→true', (tester) async {
    bool open = false;
    late StateSetter setter;
    await tester.pumpWidget(_wrap(
      StatefulBuilder(builder: (context, s) {
        setter = s;
        return Column(children: [
          AntButton(
            onTap: () => setter(() => open = !open),
            child: Text(open ? '关' : '开'),
          ),
          AntPopconfirm(
            open: open,
            onOpenChange: (v) => setter(() => open = v),
            title: '受控确认',
            child: const Text('受控触发'),
          ),
        ],);
      },),
    ),);
    await tester.pumpAndSettle();
    expect(find.text('受控确认'), findsNothing);
    await tester.tap(find.byType(AntButton));
    await tester.pumpAndSettle();
    expect(find.text('受控确认'), findsOneWidget);
  });

  testWidgets('Dropdown 受控 open false→true', (tester) async {
    bool open = false;
    late StateSetter setter;
    await tester.pumpWidget(_wrap(
      StatefulBuilder(builder: (context, s) {
        setter = s;
        return Column(children: [
          AntButton(
            onTap: () => setter(() => open = !open),
            child: Text(open ? '关' : '开'),
          ),
          AntDropdown(
            open: open,
            onOpenChange: (v) => setter(() => open = v),
            items: const [AntDropdownItem(key: 'a', label: '菜单项')],
            child: const Text('受控触发'),
          ),
        ],);
      },),
    ),);
    await tester.pumpAndSettle();
    expect(find.text('菜单项'), findsNothing);
    await tester.tap(find.byType(AntButton));
    await tester.pumpAndSettle();
    expect(find.text('菜单项'), findsOneWidget);
  });
  testWidgets('Popover 受控切换触发 onOpenChange true/false 时序', (tester) async {
    final states = <bool>[];
    bool open = false;
    late StateSetter setter;
    await tester.pumpWidget(_wrap(
      StatefulBuilder(builder: (context, s) {
        setter = s;
        return Column(children: [
          AntButton(
            onTap: () => setter(() => open = !open),
            child: Text(open ? '关' : '开'),
          ),
          AntPopover(
            open: open,
            onOpenChange: (v) => setter(() {
              open = v;
              states.add(v);
            }),
            content: const Text('回调气泡'),
            child: const Text('受控触发'),
          ),
        ],);
      },),
    ),);
    await tester.pumpAndSettle();
    expect(states, isEmpty);

    await tester.tap(find.byType(AntButton));
    await tester.pumpAndSettle();
    expect(find.text('回调气泡'), findsOneWidget);

    // 点击空白处关闭：受控模式下组件上报 onOpenChange(false)
    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();
    expect(find.text('回调气泡'), findsNothing);
    expect(states, [false]);
  });
}
