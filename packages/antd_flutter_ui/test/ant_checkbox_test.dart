import 'package:antd_flutter_ui/src/data_entry/checkbox/ant_checkbox.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    );
}

/// 字符串选项 → 大写 label。
String _upLabel(String value) => value.toUpperCase();

/// 自定义模型：角色（名称 / 禁用由模型描述）。
class _Role {
  const _Role(this.id, this.name, {this.disabled = false});

  final String id;
  final String name;
  final bool disabled;
}

const _roles = [
  _Role('admin', '管理员'),
  _Role('editor', '编辑', disabled: true),
  _Role('viewer', '访客'),
];

void main() {
  group('AntCheckbox', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(_wrap(const AntCheckbox(child: Text('选项A'))));
      expect(find.text('选项A'), findsOneWidget);
    });

    testWidgets('defaultChecked initializes checked', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntCheckbox(
            defaultChecked: true,
            child: Text('A'),
          ),
        ),
      );
      expect(find.byIcon(AntIcons.checkOutlined), findsOneWidget);
    });

    testWidgets('unchecked shows no check icon', (tester) async {
      await tester.pumpWidget(_wrap(const AntCheckbox(child: Text('A'))));
      expect(find.byIcon(AntIcons.checkOutlined), findsNothing);
    });

    testWidgets('tap toggles checked state', (tester) async {
      bool? changed;
      await tester.pumpWidget(
        _wrap(
          AntCheckbox(
            child: const Text('A'),
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, true);
      expect(find.byIcon(AntIcons.checkOutlined), findsOneWidget);
    });

    testWidgets('tap again unchecks', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntCheckbox(
            defaultChecked: true,
            child: Text('A'),
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(find.byIcon(AntIcons.checkOutlined), findsNothing);
    });

    testWidgets('controlled checked updates', (tester) async {
      late StateSetter setState;
      bool val = false;
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, s) {
              setState = s;
              return AntCheckbox(checked: val, child: const Text('A'));
            },
          ),
        ),
      );
      expect(find.byIcon(AntIcons.checkOutlined), findsNothing);
      setState(() => val = true);
      await tester.pump();
      expect(find.byIcon(AntIcons.checkOutlined), findsOneWidget);
    });

    testWidgets('disabled prevents toggle', (tester) async {
      bool? changed;
      await tester.pumpWidget(
        _wrap(
          AntCheckbox(
            disabled: true,
            child: const Text('A'),
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, null);
      expect(find.byIcon(AntIcons.checkOutlined), findsNothing);
    });

    testWidgets('indeterminate shows minus icon', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntCheckbox(
            indeterminate: true,
            child: Text('A'),
          ),
        ),
      );
      expect(find.byIcon(AntIcons.minusOutlined), findsOneWidget);
    });

    testWidgets('tapping indeterminate converts to checked and clears it',
        (tester) async {
      var changed = false;
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState) => AntCheckbox(
              indeterminate: true,
              onChange: (v) => setState(() => changed = v),
              child: const Text('A'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pump();
      // 半选点击 → 全选（非 false），半选标记清除
      expect(changed, isTrue);
      expect(find.byIcon(AntIcons.checkOutlined), findsOneWidget);
      expect(find.byIcon(AntIcons.minusOutlined), findsNothing);
    });
  });

  group('AntCheckboxGroup', () {
    testWidgets('renders options', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntCheckboxGroup<String>(
            options: ['a', 'b'],
            labelOf: _upLabel,
          ),
        ),
      );
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('selecting option fires onChange', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          AntCheckboxGroup<String>(
            options: const ['a', 'b'],
            labelOf: _upLabel,
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, ['a']);
    });

    testWidgets('selecting multiple options accumulates', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          AntCheckboxGroup<String>(
            options: const ['a', 'b'],
            labelOf: _upLabel,
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pump();
      await tester.tap(find.text('B'));
      await tester.pump();
      expect(changed, ['a', 'b']);
    });

    testWidgets('deselecting removes value', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          AntCheckboxGroup<String>(
            defaultValue: ['a'],
            options: const ['a', 'b'],
            labelOf: _upLabel,
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, isEmpty);
    });

    testWidgets('defaultValue shows checked', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntCheckboxGroup<String>(
            defaultValue: ['b'],
            options: ['a', 'b'],
            labelOf: _upLabel,
          ),
        ),
      );
      // b 应该选中
      expect(find.byIcon(AntIcons.checkOutlined), findsOneWidget);
    });

    testWidgets('controlled value updates', (tester) async {
      late StateSetter setState;
      List<String> val = [];
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, s) {
              setState = s;
              return AntCheckboxGroup<String>(
                value: val,
                options: const ['a'],
                labelOf: _upLabel,
              );
            },
          ),
        ),
      );
      expect(find.byIcon(AntIcons.checkOutlined), findsNothing);
      setState(() => val = ['a']);
      await tester.pump();
      expect(find.byIcon(AntIcons.checkOutlined), findsOneWidget);
    });

    testWidgets('group disabled prevents toggle', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          AntCheckboxGroup<String>(
            disabled: true,
            options: const ['a'],
            labelOf: _upLabel,
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, null);
    });

    testWidgets('option disabled prevents toggle', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          AntCheckboxGroup<String>(
            options: const ['a', 'b'],
            labelOf: _upLabel,
            disabledOf: (value) => value == 'a',
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, null);
    });

    testWidgets('vertical direction renders column', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntCheckboxGroup<String>(
            direction: AntCheckboxGroupDirection.vertical,
            options: ['a', 'b'],
            labelOf: _upLabel,
          ),
        ),
      );
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('children mode toggles via group', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          AntCheckboxGroup<String>(
            onChange: (v) => changed = v,
            children: const [
              AntCheckbox(value: 'a', child: Text('A')),
              AntCheckbox(value: 'b', child: Text('B')),
            ],
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, ['a']);
      expect(find.byIcon(AntIcons.checkOutlined), findsOneWidget);
    });

    testWidgets('children mode group disabled prevents toggle', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(
        _wrap(
          AntCheckboxGroup<String>(
            disabled: true,
            onChange: (v) => changed = v,
            children: const [
              AntCheckbox(value: 'a', child: Text('A')),
            ],
          ),
        ),
      );
      await tester.tap(find.text('A'));
      await tester.pump();
      expect(changed, null);
    });
    testWidgets('自定义模型：labelOf/disabledOf 驱动渲染与选择', (tester) async {
      List<_Role>? changed;
      await tester.pumpWidget(
        _wrap(
          AntCheckboxGroup<_Role>(
            options: _roles,
            labelOf: (role) => role.name,
            disabledOf: (role) => role.disabled,
            onChange: (roles) => changed = roles,
          ),
        ),
      );
      expect(find.text('管理员'), findsOneWidget);
      expect(find.text('访客'), findsOneWidget);

      await tester.tap(find.text('编辑'));
      await tester.pump();
      expect(changed, isNull);

      await tester.tap(find.text('管理员'));
      await tester.pump();
      await tester.tap(find.text('访客'));
      await tester.pump();
      expect(changed!.map((role) => role.id).toList(), ['admin', 'viewer']);
    });

    testWidgets('自定义模型：itemBuilder 整项自定义渲染', (tester) async {
      List<_Role>? changed;
      await tester.pumpWidget(
        _wrap(
          AntCheckboxGroup<_Role>(
            options: _roles,
            itemBuilder: (context, role, index) => Chip(label: Text(role.name)),
            onChange: (roles) => changed = roles,
          ),
        ),
      );
      expect(find.text('访客'), findsOneWidget);
      await tester.tap(find.text('访客'));
      await tester.pump();
      expect(changed!.single.id, 'viewer');
    });
  });
}
