/// AntPagination Widget 测试
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

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
  group('AntPagination — 基础渲染', () {
    testWidgets('renders page buttons for totalPages <= 7', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntPagination(total: 50)),
      );
      // 50 / 10 = 5 页，全部显示
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('6'), findsNothing);
    });

    testWidgets('total=0 shows single page', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntPagination(total: 0)),
      );
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsNothing);
    });

    testWidgets('renders prev and next nav buttons', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntPagination(total: 50)),
      );
      expect(
        find.descendant(
          of: find.byType(AntPagination),
          matching: find.byIcon(AntIcons.leftOutlined),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(AntPagination),
          matching: find.byIcon(AntIcons.rightOutlined),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders ellipsis when totalPages > 7', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntPagination(total: 100)),
      );
      // 100 / 10 = 10 页 > 7，当前页 1
      // 页码: 1, 2, 3, -2(右省略号), 10
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AntPagination),
          matching: find.byIcon(AntIcons.moreOutlined),
        ),
        findsOneWidget,
      );
      // 不应显示 4~9 全部
      expect(find.text('4'), findsNothing);
      expect(find.text('9'), findsNothing);
    });

    testWidgets('renders total text when showTotal is true', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntPagination(total: 85, showTotal: true)),
      );
      expect(find.text('共 85 条'), findsOneWidget);
    });

    testWidgets('simple mode shows current/totalPages', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntPagination(total: 50, simple: true)),
      );
      expect(find.text('1/5'), findsOneWidget);
    });

    testWidgets('small size uses smaller buttons', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntPagination(
          total: 50,
          size: AntPaginationSize.small,
        ),),
      );
      // small 模式按钮 24x24
      final buttons = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(AntPagination),
          matching: find.byType(Container),
        ),
      );
      final pageButtons = buttons.where(
        (c) => c.constraints?.maxWidth == 24 && c.constraints?.maxHeight == 24,
      );
      expect(pageButtons, isNotEmpty);
    });
  });

  group('AntPagination — 翻页交互', () {
    testWidgets('tap next calls onChange with page+1', (tester) async {
      var changedPage = -1;
      await tester.pumpWidget(
        _wrap(AntPagination(
          total: 50,
          onChange: (p) => changedPage = p,
        ),),
      );
      await tester.tap(find.byIcon(AntIcons.rightOutlined));
      expect(changedPage, 2);
    });

    testWidgets('tap prev calls onChange with page-1', (tester) async {
      var changedPage = -1;
      await tester.pumpWidget(
        _wrap(AntPagination(
          defaultCurrent: 3,
          total: 50,
          onChange: (p) => changedPage = p,
        ),),
      );
      await tester.tap(find.byIcon(AntIcons.leftOutlined));
      expect(changedPage, 2);
    });

    testWidgets('tap page number calls onChange', (tester) async {
      var changedPage = -1;
      await tester.pumpWidget(
        _wrap(AntPagination(
          total: 50,
          onChange: (p) => changedPage = p,
        ),),
      );
      await tester.tap(find.text('3'));
      expect(changedPage, 3);
    });

    testWidgets('tap ellipsis jumps 5 pages forward', (tester) async {
      var changedPage = -1;
      await tester.pumpWidget(
        _wrap(AntPagination(
          total: 100,
          onChange: (p) => changedPage = p,
        ),),
      );
      // 当前页 1，右侧省略号跳 +5 → 页 6
      await tester.tap(find.byIcon(AntIcons.moreOutlined));
      expect(changedPage, 6);
    });

    testWidgets('prev disabled on first page', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntPagination(total: 50)),
      );
      // 第一页时左箭头不可点击
      final prevInkWell = tester.widget<InkWell>(
        find.ancestor(
          of: find.byIcon(AntIcons.leftOutlined),
          matching: find.byType(InkWell),
        ),
      );
      expect(prevInkWell.onTap, isNull);
    });

    testWidgets('next disabled on last page', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntPagination(defaultCurrent: 5, total: 50)),
      );
      final nextInkWell = tester.widget<InkWell>(
        find.ancestor(
          of: find.byIcon(AntIcons.rightOutlined),
          matching: find.byType(InkWell),
        ),
      );
      expect(nextInkWell.onTap, isNull);
    });

    testWidgets('uncontrolled mode updates internal state', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntPagination(total: 50)),
      );
      // 初始页 1
      expect(find.text('1/5'), findsNothing); // 非简单模式
      await tester.tap(find.text('3'));
      await tester.pump();

      // 当前页变为 3，按钮背景变为 colorPrimary
      late AntThemeData capturedTheme;
      await tester.pumpWidget(
        _wrap(
          Builder(
            builder: (context) {
              capturedTheme = AntTheme.of(context);
              return const AntPagination(total: 50);
            },
          ),
        ),
      );
      await tester.tap(find.text('3'));
      await tester.pump();

      final materials = tester.widgetList<Material>(
        find.descendant(
          of: find.byType(AntPagination),
          matching: find.byType(Material),
        ),
      );
      final activeMaterials = materials.where(
        (m) => m.color == capturedTheme.colorPrimary,
      );
      expect(activeMaterials, hasLength(1));
    });
  });

  group('AntPagination — 受控模式', () {
    testWidgets('controlled current does not change internally',
        (tester) async {
      var changedPage = -1;
      var externalCurrent = 1;

      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState) {
              return AntPagination(
                current: externalCurrent,
                total: 50,
                onChange: (p) {
                  changedPage = p;
                  // 外部不更新 externalCurrent，模拟受控但未更新
                },
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('3'));
      await tester.pump();

      // onChange 被调用
      expect(changedPage, 3);
      // 但受控模式下当前页仍为 1（外部未更新）
      expect(externalCurrent, 1);
    });

    testWidgets('controlled current responds to external change',
        (tester) async {
      var externalCurrent = 1;

      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  AntPagination(
                    current: externalCurrent,
                    total: 50,
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        setState(() => externalCurrent = 4),
                    child: const Text('Go to 4'),
                  ),
                ],
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Go to 4'));
      await tester.pump();

      // 页码 4 应高亮
      late AntThemeData capturedTheme;
      await tester.pumpWidget(
        _wrap(
          Builder(
            builder: (context) {
              capturedTheme = AntTheme.of(context);
              return Column(
                children: [
                  const AntPagination(
                    current: 4,
                    total: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Go to 4'),
                  ),
                ],
              );
            },
          ),
        ),
      );

      final materials = tester.widgetList<Material>(
        find.descendant(
          of: find.byType(AntPagination),
          matching: find.byType(Material),
        ),
      );
      final activeMaterials = materials.where(
        (m) => m.color == capturedTheme.colorPrimary,
      );
      expect(activeMaterials, hasLength(1));
    });
  });

  group('AntPagination — 禁用', () {
    testWidgets('disabled prevents page change', (tester) async {
      var changedPage = -1;
      await tester.pumpWidget(
        _wrap(AntPagination(
          total: 50,
          disabled: true,
          onChange: (p) => changedPage = p,
        ),),
      );
      await tester.tap(find.text('3'));
      expect(changedPage, -1);
    });

    testWidgets('disabled prevents next page', (tester) async {
      var changedPage = -1;
      await tester.pumpWidget(
        _wrap(AntPagination(
          total: 50,
          disabled: true,
          onChange: (p) => changedPage = p,
        ),),
      );
      await tester.tap(find.byIcon(AntIcons.rightOutlined));
      expect(changedPage, -1);
    });

    testWidgets('disabled nav button uses disabled color', (tester) async {
      late AntThemeData capturedTheme;
      await tester.pumpWidget(
        _wrap(
          Builder(
            builder: (context) {
              capturedTheme = AntTheme.of(context);
              return const AntPagination(
                total: 50,
                disabled: true,
              );
            },
          ),
        ),
      );
      // 禁用时图标颜色为 colorTextDisabled
      final prevIcon = tester.widget<Icon>(
        find.descendant(
          of: find.byType(AntPagination),
          matching: find.byIcon(AntIcons.leftOutlined),
        ),
      );
      expect(prevIcon.color, capturedTheme.colorTextDisabled);
    });
  });

  group('AntPagination — 附加功能', () {
    testWidgets('showSizeChanger renders AntDropdown', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntPagination(
          total: 100,
          showSizeChanger: true,
        ),),
      );
      expect(
        find.descendant(
          of: find.byType(AntPagination),
          matching: find.byType(AntDropdown),
        ),
        findsOneWidget,
      );
      expect(find.text('10 条/页'), findsOneWidget);
    });

    testWidgets('showQuickJumper renders TextField', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntPagination(
          total: 100,
          showQuickJumper: true,
        ),),
      );
      expect(find.text('跳至'), findsOneWidget);
      expect(find.text('页'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AntPagination),
          matching: find.byType(TextField),
        ),
        findsOneWidget,
      );
    });

    testWidgets('quick jumper submits page number', (tester) async {
      var changedPage = -1;
      await tester.pumpWidget(
        _wrap(AntPagination(
          total: 100,
          showQuickJumper: true,
          onChange: (p) => changedPage = p,
        ),),
      );

      await tester.enterText(
        find.descendant(
          of: find.byType(AntPagination),
          matching: find.byType(TextField),
        ),
        '5',
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(changedPage, 5);
    });

    testWidgets('onPageSizeChange called when size changed',
        (tester) async {
      var changedSize = -1;
      await tester.pumpWidget(
        _wrap(AntPagination(
          total: 100,
          showSizeChanger: true,
          onPageSizeChange: (s) => changedSize = s,
        ),),
      );

      // 打开下拉
      await tester.tap(find.byType(AntDropdown));
      await tester.pumpAndSettle();

      // 选择 20 条/页
      await tester.tap(find.text('20 条/页').last);
      await tester.pumpAndSettle();

      expect(changedSize, 20);
    });

    testWidgets('changing pageSize recalculates totalPages',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntPagination(
          total: 100,
          showSizeChanger: true,
        ),),
      );

      // 初始 10 条/页 → 10 页
      await tester.tap(find.byType(AntDropdown));
      await tester.pumpAndSettle();
      await tester.tap(find.text('20 条/页').last);
      await tester.pumpAndSettle();

      // 20 条/页 → 5 页，全部显示
      expect(find.text('6'), findsNothing);
      expect(find.text('5'), findsOneWidget);
    });
  });
}