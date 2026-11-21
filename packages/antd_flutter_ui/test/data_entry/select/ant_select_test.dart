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

/// 字符串选项：label 即选项本身（最常见的简写形态）。
const _options = ['选项一', '选项二', '选项三'];

/// 自定义模型：用户用自己的领域对象驱动选择器。
class _User {
  const _User(this.id, this.name, {this.blocked = false});

  final String id;
  final String name;
  final bool blocked;
}

const _users = [
  _User('u1', '张三'),
  _User('u2', '李四'),
  _User('u3', '王五', blocked: true),
];

void main() {
  group('AntSelect', () {
    testWidgets('renders placeholder by default', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSelect<String>(options: _options, placeholder: '请选择')),
      );
      expect(find.text('请选择'), findsOneWidget);
    });

    testWidgets('renders default selected label', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSelect<String>(options: _options, defaultValue: '选项二')),
      );
      expect(find.text('选项二'), findsOneWidget);
    });

    testWidgets('disabled does not open dropdown', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSelect<String>(options: _options, disabled: true)),
      );
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pump();
      expect(find.text('选项一'), findsNothing);
    });

    testWidgets('tap opens dropdown and shows options', (tester) async {
      await tester
          .pumpWidget(_wrap(const AntSelect<String>(options: _options)));
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pump();
      expect(find.text('选项一'), findsOneWidget);
      expect(find.text('选项二'), findsOneWidget);
    });

    testWidgets('selecting an option calls onChange and closes',
        (tester) async {
      dynamic changed;
      await tester.pumpWidget(
        _wrap(
          AntSelect<String>(
            options: _options,
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pump();
      await tester.tap(find.text('选项二').last);
      await tester.pump();
      expect(changed, '选项二');
      expect(find.text('选项二'), findsOneWidget);
    });

    testWidgets('multiple mode toggles selections', (tester) async {
      dynamic changed;
      await tester.pumpWidget(
        _wrap(
          AntSelect<String>(
            mode: AntSelectMode.multiple,
            options: _options,
            onChangeMultiple: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pump();
      await tester.tap(find.text('选项一').last);
      await tester.pump();
      expect((changed as List).contains('选项一'), true);
      await tester.tap(find.text('选项三').last);
      await tester.pump();
      expect((changed as List).length, 2);
    });

    testWidgets('multiple mode deselect removes from list', (tester) async {
      dynamic changed;
      await tester.pumpWidget(
        _wrap(
          AntSelect<String>(
            mode: AntSelectMode.multiple,
            options: _options,
            defaultValues: const ['选项一', '选项二'],
            onChangeMultiple: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pump();
      await tester.tap(find.text('选项一').last);
      await tester.pump();
      expect((changed as List).contains('选项一'), false);
      expect((changed as List).contains('选项二'), true);
    });

    testWidgets('showSearch filters options', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSelect<String>(options: _options, showSearch: true)),
      );
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pump();
      await tester.enterText(find.byType(TextField), '二');
      await tester.pump();
      expect(find.text('选项二'), findsOneWidget);
      expect(find.text('选项一'), findsNothing);
    });

    testWidgets('allowClear clears value', (tester) async {
      dynamic changed;
      await tester.pumpWidget(
        _wrap(
          AntSelect<String>(
            options: _options,
            defaultValue: '选项一',
            allowClear: true,
            onChange: (v) => changed = v,
          ),
        ),
      );
      expect(find.text('选项一'), findsOneWidget);
      await tester.tap(find.byIcon(AntIcons.closeCircleFilled));
      await tester.pump();
      expect(changed, null);
      expect(find.text('请选择'), findsOneWidget);
    });

    testWidgets('loading shows spinner', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntSelect<String>(options: _options, loading: true)),
      );
      expect(find.byType(AntLoading), findsOneWidget);
    });

    testWidgets('自定义模型：labelOf/valueExtractor/disabledOf 驱动选择', (tester) async {
      _User? changed;
      await tester.pumpWidget(
        _wrap(
          AntSelect<_User>(
            options: _users,
            defaultValue: _users[0],
            labelOf: (user) => user.name,
            valueExtractor: (user) => user.id,
            disabledOf: (user) => user.blocked,
            showSearch: true,
            onChange: (user) => changed = user,
          ),
        ),
      );
      // 受控值按 valueExtractor 的 id 在 options 中匹配 label
      expect(find.text('张三'), findsOneWidget);
      await tester.tap(find.byType(AntSelect<_User>));
      await tester.pump();
      // 搜索按 labelOf 文本匹配（非 toString）
      await tester.enterText(find.byType(TextField), '李');
      await tester.pump();
      expect(find.text('李四'), findsOneWidget);
      // 搜索命中 labelOf 文本，未命中的选项被过滤
      expect(find.text('王五'), findsNothing);
      await tester.tap(find.text('李四').last);
      await tester.pump();
      expect(changed, isNotNull);
      expect(changed!.id, 'u2');
      expect(find.text('李四'), findsOneWidget);
      // 禁用项不触发选择
      await tester.tap(find.byType(AntSelect<_User>));
      await tester.pump();
      await tester.tap(find.text('王五').last);
      await tester.pump();
      expect(changed!.id, 'u2');
    });

    testWidgets('自定义模型：多选按 valueExtractor 去重', (tester) async {
      List<_User>? changed;
      await tester.pumpWidget(
        _wrap(
          AntSelect<_User>(
            mode: AntSelectMode.multiple,
            options: _users,
            values: [_users[0]],
            labelOf: (user) => user.name,
            valueExtractor: (user) => user.id,
            onChangeMultiple: (users) => changed = users,
          ),
        ),
      );
      expect(find.text('张三'), findsOneWidget);
      await tester.tap(find.byType(AntSelect<_User>));
      await tester.pump();
      await tester.tap(find.text('李四').last);
      await tester.pump();
      expect(changed!.map((u) => u.id), ['u1', 'u2']);
    });
  });

  group('AntSelect — popup_engine 边界（翻转/夹回）', () {
    testWidgets('视口下方放不下时面板翻转到上方', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Align(
            alignment: Alignment.bottomCenter,
            child: AntSelect<String>(options: _options),
          ),
        ),
      );
      await tester.tap(find.byType(AntSelect<String>));
      await tester.pumpAndSettle();
      final panel = tester.getRect(find.byKey(const Key('ant_select_panel')));
      final trigger = tester.getRect(find.byType(AntSelect<String>));
      // 触发元素贴近视口底部，面板应翻转到触发元素上方
      expect(panel.bottom, lessThanOrEqualTo(trigger.top + 0.01));
    });

    testWidgets('面板不溢出视口（滑动夹回）', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 60,
              child: AntSelect<String>(options: _options),
            ),
          ),
        ),
      );
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
      await tester.pumpWidget(
        _wrap(
          const AntSelect<String>(
            mode: AntSelectMode.multiple,
            options: _options,
          ),
        ),
      );
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
      await tester.pumpWidget(
        _wrap(
          const AntSelect<String>(options: _options, showSearch: true),
        ),
      );
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
