import 'package:antd_theme/antd_theme.dart';
import 'package:antd_tree/antd_tree.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

class _City {
  const _City(this.id, this.name, {this.children = const <_City>[]});

  final int id;
  final String name;
  final List<_City> children;
}

const _cities = <_City>[
  _City(
    1,
    '浙江',
    children: [_City(2, '杭州'), _City(3, '宁波')],
  ),
  _City(
    6,
    '江苏',
    children: [_City(7, '南京'), _City(8, '苏州')],
  ),
];

Widget _wrap(Widget child, {bool dark = false}) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: dark ? AntThemeData.dark() : AntThemeData.light(),
          child: Material(child: Center(child: child)),
        ),
      ),
    );

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  bool dark = false,
}) async {
  await tester.pumpWidget(_wrap(child, dark: dark));
  await tester.pumpAndSettle();
}

AntTreeSelect<_City> _select({
  List<_City> dataSource = _cities,
  Object? value,
  ValueChanged<Object?>? onChange,
  bool multiple = false,
  bool treeDefaultExpandAll = false,
}) {
  return AntTreeSelect<_City>(
    dataSource: dataSource,
    keyOf: (city) => city.id,
    labelOf: (city) => city.name,
    titleBuilder: (context, city) => Text(city.name),
    childrenOf: (city) => city.children,
    value: value,
    onChange: onChange,
    multiple: multiple,
    treeDefaultExpandAll: treeDefaultExpandAll,
  );
}

Finder _panel() => find.byKey(const Key('ant_tree_select_panel'));

Finder _panelText(String text) =>
    find.descendant(of: _panel(), matching: find.text(text));

void main() {
  testWidgets('updates controlled value while panel is open', (tester) async {
    await _pump(tester, _select(value: 7));
    await tester.tap(find.byType(AntTreeSelect<_City>));
    await tester.pumpAndSettle();
    expect(_panel(), findsOneWidget);

    await _pump(tester, _select(value: 8));
    expect(
      find.descendant(
        of: find.byType(AntTreeSelect<_City>),
        matching: find.text('苏州'),
      ),
      findsOneWidget,
    );
    expect(_panel(), findsOneWidget);
  });

  testWidgets('updates dataSource while panel is open', (tester) async {
    await _pump(tester, _select());
    await tester.tap(find.byType(AntTreeSelect<_City>));
    await tester.pumpAndSettle();
    expect(_panelText('浙江'), findsOneWidget);

    const next = <_City>[
      _City(10, '北京'),
      _City(11, '上海'),
    ];
    await _pump(tester, _select(dataSource: next));
    expect(_panel(), findsOneWidget);
    expect(_panelText('北京'), findsOneWidget);
    expect(_panelText('上海'), findsOneWidget);
  });

  testWidgets('recomputes expanded keys when data is replaced', (tester) async {
    await _pump(tester, _select(treeDefaultExpandAll: true));
    await tester.tap(find.byType(AntTreeSelect<_City>));
    await tester.pumpAndSettle();
    expect(_panelText('杭州'), findsOneWidget);

    const next = <_City>[
      _City(6, '江苏', children: [_City(7, '南京')]),
    ];
    await _pump(tester, _select(dataSource: next, treeDefaultExpandAll: true));
    expect(_panelText('南京'), findsOneWidget);
    expect(_panelText('杭州'), findsNothing);
  });

  testWidgets('uncontrolled multiple selection flow', (tester) async {
    final changes = <Object?>[];
    await _pump(
      tester,
      _select(
        multiple: true,
        treeDefaultExpandAll: true,
        onChange: changes.add,
      ),
    );
    await tester.tap(find.byType(AntTreeSelect<_City>));
    await tester.pumpAndSettle();
    await tester.tap(_panelText('南京'));
    await tester.pumpAndSettle();
    await tester.tap(_panelText('苏州'));
    await tester.pumpAndSettle();
    expect(changes, <Object?>[
      <Object>[7],
      <Object>[7, 8],
    ]);
  });

  testWidgets('theme switch rebuilds open panel', (tester) async {
    await _pump(tester, _select());
    await tester.tap(find.byType(AntTreeSelect<_City>));
    await tester.pumpAndSettle();
    expect(_panel(), findsOneWidget);

    await _pump(tester, _select(), dark: true);
    expect(_panel(), findsOneWidget);
    expect(_panelText('浙江'), findsOneWidget);
  });
}
