import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:antd_tree/antd_tree.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// 用户自定义模型：组件不要求实现任何接口。
class _City {
  const _City(
    this.id,
    this.name, {
    this.children = const <_City>[],
    this.disabled = false,
  });

  final int id;
  final String name;
  final List<_City> children;
  final bool disabled;
}

const _cities = <_City>[
  _City(
    1,
    '浙江',
    children: [
      _City(
        2,
        '杭州',
        children: [_City(3, '西湖'), _City(4, '临安')],
      ),
      _City(5, '宁波'),
    ],
  ),
  _City(
    6,
    '江苏',
    children: [_City(7, '南京'), _City(8, '苏州')],
  ),
  _City(9, '广东'),
];

Widget _wrap(Widget child, {bool dark = false}) => AntScreenUtilInit(
      builder: (context, _) => MaterialApp(
        home: Scaffold(
          body: AntTheme(
            data: dark ? AntThemeData.dark() : AntThemeData.light(),
            child: Material(child: Center(child: child)),
          ),
        ),
      ),
    );

Future<void> _pumpSelect(
  WidgetTester tester, {
  List<_City> dataSource = _cities,
  Object? value,
  Object? defaultValue,
  ValueChanged<Object?>? onChange,
  bool multiple = false,
  bool disabled = false,
  bool allowClear = false,
  bool treeDefaultExpandAll = false,
  AntTreeSelectSize size = AntTreeSelectSize.middle,
  String? placeholder,
  double? width,
  double? height,
  double? dropdownHeight,
  bool dark = false,
  Widget Function(BuildContext context, _City city)? titleBuilder,
}) async {
  await tester.pumpWidget(
    _wrap(
      AntTreeSelect<_City>(
        dataSource: dataSource,
        keyOf: (city) => city.id,
        labelOf: (city) => city.name,
        titleBuilder: titleBuilder ?? (context, city) => Text(city.name),
        childrenOf: (city) => city.children,
        disabledOf: (city) => city.disabled,
        value: value,
        defaultValue: defaultValue,
        onChange: onChange,
        multiple: multiple,
        disabled: disabled,
        allowClear: allowClear,
        treeDefaultExpandAll: treeDefaultExpandAll,
        size: size,
        placeholder: placeholder,
        width: width,
        height: height,
        dropdownHeight: dropdownHeight,
      ),
      dark: dark,
    ),
  );
  await tester.pumpAndSettle();
}

Finder _panel() => find.byKey(const Key('ant_tree_select_panel'));

Finder _panelText(String text) =>
    find.descendant(of: _panel(), matching: find.text(text));

Finder _panelRow(String title) =>
    find.ancestor(of: _panelText(title), matching: find.byType(Row)).first;

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.byType(AntTreeSelect<_City>));
  await tester.pumpAndSettle();
}

Future<void> _expand(WidgetTester tester, String title) async {
  await tester.tap(
    find.descendant(
      of: _panelRow(title),
      matching: find.byIcon(AntIcons.rightOutlined),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _selectNode(WidgetTester tester, String title) async {
  await tester.tap(_panelText(title));
  await tester.pumpAndSettle();
}

void main() {
  group('AntTreeSelect', () {
    testWidgets('renders placeholder when empty', (tester) async {
      await _pumpSelect(tester, placeholder: '请选择');
      expect(find.text('请选择'), findsOneWidget);
    });

    testWidgets('shows default single value label', (tester) async {
      await _pumpSelect(tester, defaultValue: 7);
      expect(find.text('南京'), findsOneWidget);
    });

    testWidgets('shows controlled value label', (tester) async {
      await _pumpSelect(tester, value: 8);
      expect(find.text('苏州'), findsOneWidget);
    });

    testWidgets('opens dropdown and lists top-level nodes', (tester) async {
      await _pumpSelect(tester);
      await _open(tester);
      expect(_panel(), findsOneWidget);
      expect(_panelText('浙江'), findsOneWidget);
      expect(_panelText('江苏'), findsOneWidget);
      expect(_panelText('广东'), findsOneWidget);
      expect(_panelText('杭州'), findsNothing);
    });

    testWidgets('children stay hidden until expanded', (tester) async {
      await _pumpSelect(tester);
      await _open(tester);
      await _expand(tester, '浙江');
      expect(_panelText('杭州'), findsOneWidget);
      expect(_panelText('宁波'), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: _panelRow('浙江'),
          matching: find.byIcon(AntIcons.downOutlined),
        ),
      );
      await tester.pumpAndSettle();
      expect(_panelText('杭州'), findsNothing);
    });

    testWidgets('treeDefaultExpandAll expands all parents', (tester) async {
      await _pumpSelect(tester, treeDefaultExpandAll: true);
      await _open(tester);
      expect(_panelText('杭州'), findsOneWidget);
      expect(_panelText('宁波'), findsOneWidget);
      expect(_panelText('南京'), findsOneWidget);
    });

    testWidgets('selecting a node emits its key and closes panel',
        (tester) async {
      Object? changed;
      await _pumpSelect(
        tester,
        treeDefaultExpandAll: true,
        onChange: (v) => changed = v,
      );
      await _open(tester);
      await _selectNode(tester, '南京');
      expect(changed, 7);
      expect(_panel(), findsNothing);
      expect(find.text('南京'), findsOneWidget);
    });

    testWidgets('disabled node cannot be selected', (tester) async {
      final data = <_City>[
        const _City(1, '浙江'),
        const _City(9, '广东', disabled: true),
      ];
      Object? changed;
      await _pumpSelect(tester, dataSource: data, onChange: (v) => changed = v);
      await _open(tester);
      await _selectNode(tester, '广东');
      expect(changed, isNull);
      expect(_panel(), findsOneWidget);
    });

    testWidgets('whole trigger disabled does not open', (tester) async {
      await _pumpSelect(tester, disabled: true);
      await _open(tester);
      expect(_panel(), findsNothing);
    });

    testWidgets('multiple toggles keys and keeps panel open', (tester) async {
      final changes = <Object?>[];
      await _pumpSelect(
        tester,
        multiple: true,
        treeDefaultExpandAll: true,
        onChange: changes.add,
      );
      await _open(tester);
      await _selectNode(tester, '南京');
      expect(changes.last, <Object>[7]);
      expect(_panel(), findsOneWidget);
      await _selectNode(tester, '苏州');
      expect(changes.last, <Object>[7, 8]);
      await _selectNode(tester, '南京');
      expect(changes.last, <Object>[8]);
    });

    testWidgets('multiple joins selected labels in trigger', (tester) async {
      await _pumpSelect(tester, multiple: true, defaultValue: <Object>[7, 8]);
      expect(find.text('南京、苏州'), findsOneWidget);
    });

    testWidgets('allowClear clears single value', (tester) async {
      Object? changed = 7;
      await _pumpSelect(
        tester,
        defaultValue: 7,
        allowClear: true,
        onChange: (v) => changed = v,
      );
      await tester.tap(find.byIcon(AntIcons.closeCircleFilled));
      await tester.pumpAndSettle();
      expect(changed, isNull);
      expect(find.text('南京'), findsNothing);
    });

    testWidgets('allowClear clears multiple values', (tester) async {
      Object? changed;
      await _pumpSelect(
        tester,
        multiple: true,
        defaultValue: <Object>[7, 8],
        allowClear: true,
        onChange: (v) => changed = v,
      );
      await tester.tap(find.byIcon(AntIcons.closeCircleFilled));
      await tester.pumpAndSettle();
      expect(changed, <Object>[]);
    });

    testWidgets('tapping outside closes panel', (tester) async {
      await _pumpSelect(tester);
      await _open(tester);
      expect(_panel(), findsOneWidget);
      await tester.tapAt(const Offset(8, 8));
      await tester.pumpAndSettle();
      expect(_panel(), findsNothing);
    });

    testWidgets('controlled value update refreshes trigger', (tester) async {
      await _pumpSelect(tester, value: 7);
      expect(find.text('南京'), findsOneWidget);
      await _pumpSelect(tester, value: 8);
      expect(find.text('苏州'), findsOneWidget);
    });

    testWidgets('size and custom dimensions are applied', (tester) async {
      await _pumpSelect(
        tester,
        size: AntTreeSelectSize.small,
        height: 44,
        width: 180,
      );
      final trigger = find
          .descendant(
            of: find.byType(AntTreeSelect<_City>),
            matching: find.byType(Container),
          )
          .first;
      final expectedHeight = 44 * ScreenUtil().scaleHeight;
      expect(tester.getSize(trigger), Size(180, expectedHeight));
    });

    testWidgets('dropdownHeight limits panel height', (tester) async {
      await _pumpSelect(tester, dropdownHeight: 120);
      await _open(tester);
      final panel = tester.widget<Container>(_panel());
      expect(
        panel.constraints?.maxHeight,
        120 * ScreenUtil().scaleHeight,
      );
    });

    testWidgets('自定义模型：keyOf + labelOf 驱动触发器与 onChange', (tester) async {
      var changes = <Object?>[];
      await _pumpSelect(
        tester,
        treeDefaultExpandAll: true,
        onChange: changes.add,
      );
      await _open(tester);
      await _selectNode(tester, '西湖');
      expect(changes, <Object>[3]);
      expect(find.text('西湖'), findsOneWidget);
    });

    testWidgets('自定义模型：childrenOf + disabledOf 驱动展开与禁用', (tester) async {
      final data = <_City>[
        const _City(
          1,
          '浙江',
          children: [_City(2, '杭州'), _City(3, '宁波', disabled: true)],
        ),
        const _City(9, '广东'),
      ];
      Object? changed;
      await _pumpSelect(
        tester,
        dataSource: data,
        treeDefaultExpandAll: true,
        onChange: (v) => changed = v,
      );
      await _open(tester);
      expect(_panelText('杭州'), findsOneWidget);
      await _selectNode(tester, '宁波');
      expect(changed, isNull);
      await _selectNode(tester, '杭州');
      expect(changed, 2);
    });

    testWidgets('custom titleBuilder renders row content', (tester) async {
      await _pumpSelect(
        tester,
        titleBuilder: (context, city) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(AntIcons.environmentOutlined, size: 12),
            Text(city.name),
          ],
        ),
      );
      await _open(tester);
      expect(
        find.descendant(
          of: _panel(),
          matching: find.byIcon(AntIcons.environmentOutlined),
        ),
        findsNWidgets(3),
      );
    });
  });
}
