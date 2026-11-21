import 'package:antd_flutter_ui/src/data_entry/select/ant_select.dart';
import 'package:antd_flutter_ui/src/feedback/loading/ant_loading.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/foundation.dart';
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

const _options = [
  AntSelectOption(value: 'a', label: '选项一'),
  AntSelectOption(value: 'b', label: '选项二'),
  AntSelectOption(value: 'c', label: '选项三'),
];

void main() {
  group('AntSelect', () {
    testWidgets('renders placeholder by default', (tester) async {
      await tester.pumpWidget(_wrap(const AntSelect<String>(
        options: _options,
        placeholder: '请选择',
      ),),);
      expect(find.text('请选择'), findsOneWidget);
    });

    testWidgets('renders default selected label', (tester) async {
      await tester.pumpWidget(_wrap(const AntSelect<String>(
        options: _options,
        defaultValue: 'b',
      ),),);
      expect(find.text('选项二'), findsOneWidget);
    });

    testWidgets('disabled does not open dropdown', (tester) async {
      await tester.pumpWidget(_wrap(const AntSelect<String>(
        options: _options,
        disabled: true,
      ),),);
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pump();
      expect(find.text('选项一'), findsNothing);
    });

    testWidgets('tap opens dropdown and shows options', (tester) async {
      await tester.pumpWidget(_wrap(const AntSelect<String>(
        options: _options,
      ),),);
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pump();
      expect(find.text('选项一'), findsOneWidget);
      expect(find.text('选项二'), findsOneWidget);
    });

    testWidgets('selecting an option calls onChange and closes',
        (tester) async {
      dynamic changed;
      await tester.pumpWidget(_wrap(AntSelect<String>(
        options: _options,
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pump();
      await tester.tap(find.text('选项二').last);
      await tester.pump();
      expect(changed, 'b');
      expect(find.text('选项二'), findsOneWidget);
    });

    testWidgets('multiple mode toggles selections', (tester) async {
      dynamic changed;
      await tester.pumpWidget(_wrap(AntSelect<String>(
        mode: AntSelectMode.multiple,
        options: _options,
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pump();
      await tester.tap(find.text('选项一').last);
      await tester.pump();
      expect((changed as List).contains('a'), true);
      await tester.tap(find.text('选项三').last);
      await tester.pump();
      expect((changed as List).length, 2);
    });

    testWidgets('multiple mode deselect removes from list', (tester) async {
      dynamic changed;
      await tester.pumpWidget(_wrap(AntSelect<String>(
        mode: AntSelectMode.multiple,
        options: _options,
        defaultValue: ['a', 'b'],
        onChange: (v) => changed = v,
      ),),);
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pump();
      await tester.tap(find.text('选项一').last);
      await tester.pump();
      expect((changed as List).contains('a'), false);
      expect((changed as List).contains('b'), true);
    });

    testWidgets('showSearch filters options', (tester) async {
      await tester.pumpWidget(_wrap(const AntSelect<String>(
        options: _options,
        showSearch: true,
      ),),);
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pump();
      await tester.enterText(find.byType(TextField), '二');
      await tester.pump();
      expect(find.text('选项二'), findsOneWidget);
      expect(find.text('选项一'), findsNothing);
    });

    testWidgets('allowClear clears value', (tester) async {
      dynamic changed;
      await tester.pumpWidget(_wrap(AntSelect<String>(
        options: _options,
        defaultValue: 'a',
        allowClear: true,
        onChange: (v) => changed = v,
      ),),);
      expect(find.text('选项一'), findsOneWidget);
      await tester.tap(find.byIcon(AntIcons.closeCircleFilled));
      await tester.pump();
      expect(changed, null);
      expect(find.text('请选择'), findsOneWidget);
    });

    testWidgets('loading shows spinner', (tester) async {
      await tester.pumpWidget(_wrap(const AntSelect<String>(
        options: _options,
        loading: true,
      ),),);
      expect(find.byType(AntLoading), findsOneWidget);
    });
  });

  group('AntSelect — popup_engine 边界（翻转/夹回）', () {
    testWidgets('视口下方放不下时面板翻转到上方', (tester) async {
      await tester.pumpWidget(_wrap(
        const Align(
          alignment: Alignment.bottomCenter,
          child: AntSelect<String>(options: _options),
        ),
      ),);
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pumpAndSettle();
      final panel = tester.getRect(find.byKey(const Key('ant_select_panel')));
      final trigger = tester.getRect(find.byType(AntSelect<String>));
      // 触发元素贴近视口底部，面板应翻转到触发元素上方
      expect(panel.bottom, lessThanOrEqualTo(trigger.top + 0.01));
    });

    testWidgets('面板不溢出视口（滑动夹回）', (tester) async {
      await tester.pumpWidget(_wrap(
        const Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 60,
            child: AntSelect<String>(options: _options),
          ),
        ),
      ),);
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pumpAndSettle();
      final panel = tester.getRect(find.byKey(const Key('ant_select_panel')));
      final screen = tester.view.physicalSize / tester.view.devicePixelRatio;
      // 夹回：面板左缘不小于安全边距，右缘不超视口
      expect(panel.left, greaterThanOrEqualTo(0));
      expect(panel.right, lessThanOrEqualTo(screen.width + 0.01));
    });
  });

  group('AntSelect — 验收回归（多选面板刷新 / 移动端搜索）', () {
    testWidgets('多选选择后面板内勾选态即时更新', (tester) async {
      await tester.pumpWidget(_wrap(const AntSelect<String>(
        mode: AntSelectMode.multiple,
        options: _options,
      ),),);
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pumpAndSettle();
      // 初始全部未勾选
      expect(find.byIcon(AntIcons.checkSquareFilled), findsNothing);
      // 面板内勾选「选项一」→ 面板勾选态刷新（不复选框停留旧值）
      await tester.tap(find.text('选项一').last);
      await tester.pumpAndSettle();
      expect(find.byIcon(AntIcons.checkSquareFilled), findsOneWidget);
      expect(find.byIcon(AntIcons.borderOutlined), findsNWidgets(2));
      // 取消勾选 → 面板同步回未勾选
      await tester.tap(find.text('选项一').last);
      await tester.pumpAndSettle();
      expect(find.byIcon(AntIcons.checkSquareFilled), findsNothing);
      expect(find.byIcon(AntIcons.borderOutlined), findsNWidgets(3));
    });

    testWidgets('移动端键盘唤起：搜索输入不关弹窗，面板上移到键盘上方', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() {
        debugDefaultTargetPlatformOverride = null;
        tester.view.resetViewInsets();
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(400, 800);
      tester.view.viewInsets = const FakeViewPadding(bottom: 300); // 软键盘
      await tester.pumpWidget(_wrap(const AntSelect<String>(
        options: _options,
        showSearch: true,
      ),),);
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('ant_select_panel')), findsOneWidget);
      // 点击面板内搜索框并输入 → 弹窗保持打开、过滤正常
      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), '二');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('ant_select_panel')), findsOneWidget);
      expect(find.text('选项二'), findsOneWidget);
      expect(find.text('选项一'), findsNothing);
      // 面板不被键盘遮挡：底缘高于键盘顶（视口高 800 - 键盘 300）
      final panel = tester.getRect(find.byKey(const Key('ant_select_panel')));
      expect(panel.bottom, lessThanOrEqualTo(500 + 0.01));
    });
  });
}
