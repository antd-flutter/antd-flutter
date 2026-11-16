import 'package:antd_flutter_plus/src/components/feedback/action_sheet/ant_action_sheet.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Builder(builder: (context) => Material(child: child)),
        ),
      ),
    ),
  );
}

const List<ActionSheetAction> kDefaultActions = [
  ActionSheetAction(text: '操作一'),
  ActionSheetAction(text: '操作二'),
  ActionSheetAction(text: '操作三'),
];

void main() {
  group('AntActionSheet', () {
    testWidgets('hidden when visible false', (tester) async {
      await tester.pumpWidget(_wrap(const AntActionSheet(
        visible: false,
        actions: kDefaultActions,
      ),),);
      await tester.pumpAndSettle();
      expect(find.text('操作一'), findsNothing);
    });

    testWidgets('visible shows actions after animation', (tester) async {
      // 首帧后经 postFrameCallback 插入浮层，再播放动画
      await tester.pumpWidget(_wrap(const AntActionSheet(
        visible: true,
        actions: kDefaultActions,
      ),),);
      await tester.pump();
      expect(find.text('操作一'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byKey(kAntActionSheetPanelKey), findsOneWidget);
      expect(find.text('操作一'), findsOneWidget);
      expect(find.text('操作二'), findsOneWidget);
      expect(find.text('操作三'), findsOneWidget);
    });

    testWidgets('renders all action entries', (tester) async {
      await tester.pumpWidget(_wrap(const AntActionSheet(
        visible: true,
        actions: kDefaultActions,
      ),),);
      await tester.pumpAndSettle();
      expect(find.text('操作一'), findsOneWidget);
      expect(find.text('操作二'), findsOneWidget);
      expect(find.text('操作三'), findsOneWidget);
    });

    testWidgets('renders description under text', (tester) async {
      await tester.pumpWidget(_wrap(const AntActionSheet(
        visible: true,
        actions: [
          ActionSheetAction(text: '操作一', description: '这是描述'),
        ],
      ),),);
      await tester.pumpAndSettle();
      expect(find.text('这是描述'), findsOneWidget);
    });

    testWidgets('danger action uses error color', (tester) async {
      await tester.pumpWidget(_wrap(const AntActionSheet(
        visible: true,
        actions: [ActionSheetAction(text: '删除', danger: true)],
      ),),);
      await tester.pumpAndSettle();
      final text = tester.widget<Text>(find.text('删除'));
      expect(text.style?.color, AntThemeData.light().colorError);
    });

    testWidgets('disabled action cannot be tapped', (tester) async {
      var clicked = false;
      await tester.pumpWidget(_wrap(AntActionSheet(
        visible: true,
        actions: [
          ActionSheetAction(
            text: '禁用项',
            disabled: true,
            onClick: (_) => clicked = true,
          ),
        ],
      ),),);
      await tester.pumpAndSettle();
      await tester.tap(find.text('禁用项'));
      await tester.pumpAndSettle();
      expect(clicked, isFalse);
      // 面板仍显示
      expect(find.text('禁用项'), findsOneWidget);
    });

    testWidgets('disabled action is grey', (tester) async {
      await tester.pumpWidget(_wrap(const AntActionSheet(
        visible: true,
        actions: [ActionSheetAction(text: '禁用项', disabled: true)],
      ),),);
      await tester.pumpAndSettle();
      final text = tester.widget<Text>(find.text('禁用项'));
      expect(text.style?.color, AntThemeData.light().colorTextQuaternary);
    });

    testWidgets('onClick fires with action and stays open by default',
        (tester) async {
      ActionSheetAction? clicked;
      var closed = false;
      await tester.pumpWidget(_wrap(AntActionSheet(
        visible: true,
        actions: [
          ActionSheetAction(text: '操作一', onClick: (action) => clicked = action),
        ],
        onClose: () => closed = true,
      ),),);
      await tester.pumpAndSettle();
      await tester.tap(find.text('操作一'));
      await tester.pumpAndSettle();
      expect(clicked?.text, '操作一');
      // 默认 closeOnAction=false，面板不关闭
      expect(closed, isFalse);
      expect(find.text('操作一'), findsOneWidget);
    });

    testWidgets('closeOnAction true closes after click', (tester) async {
      var clicked = false;
      var closed = false;
      await tester.pumpWidget(_wrap(AntActionSheet(
        visible: true,
        closeOnAction: true,
        actions: [
          ActionSheetAction(text: '操作一', onClick: (_) => clicked = true),
        ],
        onClose: () => closed = true,
      ),),);
      await tester.pumpAndSettle();
      await tester.tap(find.text('操作一'));
      await tester.pumpAndSettle();
      expect(clicked, isTrue);
      expect(closed, isTrue);
      expect(find.byKey(kAntActionSheetPanelKey), findsNothing);
    });

    testWidgets('cancelText renders cancel button', (tester) async {
      await tester.pumpWidget(_wrap(const AntActionSheet(
        visible: true,
        actions: kDefaultActions,
        cancelText: '取消',
      ),),);
      await tester.pumpAndSettle();
      expect(find.byKey(kAntActionSheetCancelKey), findsOneWidget);
      expect(find.text('取消'), findsOneWidget);
    });

    testWidgets('tap cancel fires onClose and closes', (tester) async {
      var closed = false;
      await tester.pumpWidget(_wrap(AntActionSheet(
        visible: true,
        actions: kDefaultActions,
        cancelText: '取消',
        onClose: () => closed = true,
      ),),);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(kAntActionSheetCancelKey));
      await tester.pumpAndSettle();
      expect(closed, isTrue);
      expect(find.byKey(kAntActionSheetPanelKey), findsNothing);
    });

    testWidgets('tap mask fires onClose and closes', (tester) async {
      var closed = false;
      await tester.pumpWidget(_wrap(AntActionSheet(
        visible: true,
        actions: kDefaultActions,
        onClose: () => closed = true,
      ),),);
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(50, 50));
      await tester.pumpAndSettle();
      expect(closed, isTrue);
      expect(find.byKey(kAntActionSheetPanelKey), findsNothing);
    });

    testWidgets('extraDescription renders at top', (tester) async {
      await tester.pumpWidget(_wrap(const AntActionSheet(
        visible: true,
        actions: kDefaultActions,
        extraDescription: '请选择要执行的操作',
      ),),);
      await tester.pumpAndSettle();
      expect(find.text('请选择要执行的操作'), findsOneWidget);
    });

    testWidgets('visible toggling removes panel', (tester) async {
      var visible = true;
      await tester.pumpWidget(_wrap(StatefulBuilder(
        builder: (context, setState) => AntActionSheet(
          visible: visible,
          actions: kDefaultActions,
          onClose: () => setState(() => visible = false),
        ),
      ),),);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(kAntActionSheetMaskKey));
      await tester.pumpAndSettle();
      expect(visible, isFalse);
      expect(find.byKey(kAntActionSheetPanelKey), findsNothing);
    });

    testWidgets('safeArea defaults true', (tester) async {
      const sheet = AntActionSheet(visible: false, actions: []);
      expect(sheet.safeArea, isTrue);
      expect(sheet.closeOnAction, isFalse);
    });
  });
}
