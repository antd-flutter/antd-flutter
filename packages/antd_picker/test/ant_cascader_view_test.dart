/// AntCascaderView widget tests
///
/// 全部用例都使用自定义模型 [_Area]，通过 keyOf / childrenOf /
/// disabledOf / labelBuilder 驱动。
library;

import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_picker/antd_picker.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// 用户自定义模型：地区
class _Area {
  const _Area(
    this.code,
    this.name, [
    this.children = const [],
    this.disabled = false,
  ]);

  final String code;
  final String name;
  final List<_Area> children;
  final bool disabled;

  @override
  String toString() => name;
}

const _xh = _Area('xh', '西湖区');
const _yh = _Area('yh', '余杭区');
const _hz = _Area('hz', '杭州', [_xh, _yh]);
const _nb = _Area('nb', '宁波');
const _zj = _Area('zj', '浙江', [_hz, _nb]);
const _nj = _Area('nj', '南京');
const _sz = _Area('sz', '苏州');
const _js = _Area('js', '江苏', [_nj, _sz]);
const _areas = <_Area>[_zj, _js];

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    );

AntCascaderView<_Area> _view({
  List<_Area> dataSource = _areas,
  List<Object>? value,
  List<Object> defaultValue = const [],
  AntCascaderViewOnChange<_Area>? onChange,
  ValueChanged<int>? onTabsChange,
  Widget? activeIcon,
  double? height,
  String placeholder = '请选择',
  AntCascaderLabelBuilder<_Area>? labelBuilder,
}) {
  return AntCascaderView<_Area>(
    dataSource: dataSource,
    keyOf: (area) => area.code,
    childrenOf: (area) => area.children,
    disabledOf: (area) => area.disabled,
    labelBuilder: labelBuilder,
    value: value,
    defaultValue: defaultValue,
    onChange: onChange,
    onTabsChange: onTabsChange,
    activeIcon: activeIcon,
    height: height,
    placeholder: placeholder,
  );
}

void main() {
  group('AntCascaderView — rendering', () {
    testWidgets('renders first level options', (tester) async {
      await tester.pumpWidget(_wrap(_view()));
      expect(find.text('浙江'), findsOneWidget);
      expect(find.text('江苏'), findsOneWidget);
    });

    testWidgets('shows placeholder for unselected level', (tester) async {
      await tester.pumpWidget(
        _wrap(_view(placeholder: '请选择地区')),
      );
      expect(find.text('请选择地区'), findsOneWidget);
    });

    testWidgets('renders only first level initially', (tester) async {
      await tester.pumpWidget(_wrap(_view()));
      expect(find.text('杭州'), findsNothing);
      expect(find.text('南京'), findsNothing);
    });

    testWidgets('labelBuilder renders custom model widget', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _view(
            labelBuilder: (context, area) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.place),
                Text('地区:${area.name}'),
              ],
            ),
          ),
        ),
      );
      expect(find.text('地区:浙江'), findsOneWidget);
      expect(find.text('地区:江苏'), findsOneWidget);
      expect(find.byIcon(Icons.place), findsNWidgets(2));
    });
  });

  group('AntCascaderView — selection', () {
    testWidgets('selecting first level shows children', (tester) async {
      await tester.pumpWidget(_wrap(_view()));
      await tester.tap(find.text('浙江'));
      await tester.pumpAndSettle();

      expect(find.text('杭州'), findsOneWidget);
      expect(find.text('宁波'), findsOneWidget);
      // Tab title shows selected label (content shows next level)
      expect(find.text('浙江'), findsOneWidget);
    });

    testWidgets('selecting leaf fires onChange with full path', (tester) async {
      List<_Area>? changedValue;
      List<_Area?>? changedItems;
      await tester.pumpWidget(
        _wrap(
          _view(
            onChange: (value, items) {
              changedValue = value;
              changedItems = items;
            },
          ),
        ),
      );

      await tester.tap(find.text('浙江'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('杭州'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('西湖区'));
      await tester.pumpAndSettle();

      expect(
        changedValue!.map((area) => area.code).toList(),
        ['zj', 'hz', 'xh'],
      );
      expect(changedValue!.last.name, '西湖区');
      expect(changedItems?.length, 3);
      expect(changedItems?[0]?.name, '浙江');
      expect(changedItems?[1]?.name, '杭州');
      expect(changedItems?[2]?.name, '西湖区');
    });

    testWidgets('selecting leaf does not add extra level', (tester) async {
      await tester.pumpWidget(_wrap(_view()));
      await tester.tap(find.text('浙江'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('宁波'));
      await tester.pumpAndSettle();

      // 宁波 is leaf — only 2 tabs (浙江 / 宁波)
      expect(find.text('请选择'), findsNothing);
    });

    testWidgets('re-selecting a different first level resets path',
        (tester) async {
      await tester.pumpWidget(_wrap(_view()));
      await tester.tap(find.text('浙江'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('杭州'));
      await tester.pumpAndSettle();

      // Go back to first tab
      await tester.tap(find.text('浙江').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('江苏'));
      await tester.pumpAndSettle();

      // Should show 江苏's children, not 浙江's
      expect(find.text('南京'), findsOneWidget);
      expect(find.text('杭州'), findsNothing);
    });
  });

  group('AntCascaderView — controlled / defaultValue', () {
    testWidgets('defaultValue pre-selects path', (tester) async {
      await tester.pumpWidget(
        _wrap(_view(defaultValue: const ['zj', 'hz'])),
      );
      await tester.pumpAndSettle();

      // Should be at the third level (西湖区/余杭区)
      expect(find.text('西湖区'), findsOneWidget);
      expect(find.text('余杭区'), findsOneWidget);
    });

    testWidgets('controlled value updates display', (tester) async {
      final key = GlobalKey<_ControlledCascaderViewState>();
      await tester.pumpWidget(
        _wrap(_ControlledCascaderView(key: key)),
      );
      await tester.pumpAndSettle();

      // Initially no selection
      expect(find.text('南京'), findsNothing);

      key.currentState!.setValue(const [_js, _nj]);
      await tester.pumpAndSettle();

      // After controlled update, should show 江苏's children level
      // and 南京 selected
      expect(find.text('苏州'), findsOneWidget);
    });

    testWidgets('controlled value onChange fires', (tester) async {
      List<_Area>? changed;
      await tester.pumpWidget(
        _wrap(
          _view(
            value: const ['zj'],
            onChange: (value, _) => changed = value,
          ),
        ),
      );

      await tester.tap(find.text('杭州'));
      await tester.pumpAndSettle();

      expect(changed!.map((area) => area.code).toList(), ['zj', 'hz']);
    });
  });

  group('AntCascaderView — tabs', () {
    testWidgets('onTabsChange fires when switching tab', (tester) async {
      int? tabIndex;
      await tester.pumpWidget(
        _wrap(_view(onTabsChange: (index) => tabIndex = index)),
      );

      await tester.tap(find.text('浙江'));
      await tester.pumpAndSettle();
      // Selecting 浙江 auto-advances to tab 1
      expect(tabIndex, 1);

      // Go back to tab 0
      await tester.tap(find.text('浙江').first);
      await tester.pumpAndSettle();
      expect(tabIndex, 0);
    });

    testWidgets('tab bar shows selected labels', (tester) async {
      await tester.pumpWidget(_wrap(_view()));
      await tester.tap(find.text('浙江'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('杭州'));
      await tester.pumpAndSettle();

      // Tab 0 title = 浙江, Tab 1 title = 杭州, Tab 2 title = placeholder
      expect(find.text('浙江'), findsOneWidget);
      expect(find.text('杭州'), findsOneWidget);
      expect(find.text('请选择'), findsOneWidget);
    });
  });

  group('AntCascaderView — disabled / custom', () {
    testWidgets('disabled option cannot be selected', (tester) async {
      const disabledAreas = <_Area>[
        _Area('a', '可用'),
        _Area('b', '禁用', [], true),
      ];
      List<_Area>? changed;
      await tester.pumpWidget(
        _wrap(
          _view(
            dataSource: disabledAreas,
            onChange: (value, _) => changed = value,
          ),
        ),
      );

      await tester.tap(find.text('禁用'));
      await tester.pumpAndSettle();

      expect(changed, isNull);
    });

    testWidgets('custom activeIcon shows when selected', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _view(activeIcon: const Icon(AntIcons.starFilled)),
        ),
      );

      await tester.tap(find.text('浙江'));
      await tester.pumpAndSettle();
      // Switch back to tab 0 to see the selected item's icon
      await tester.tap(find.text('浙江'));
      await tester.pumpAndSettle();

      expect(find.byIcon(AntIcons.starFilled), findsOneWidget);
      expect(find.byIcon(AntIcons.checkOutlined), findsNothing);
    });

    testWidgets('default check icon shows when selected', (tester) async {
      await tester.pumpWidget(_wrap(_view()));
      await tester.tap(find.text('浙江'));
      await tester.pumpAndSettle();
      // Switch back to tab 0 to see the selected item's icon
      await tester.tap(find.text('浙江'));
      await tester.pumpAndSettle();

      expect(find.byIcon(AntIcons.checkOutlined), findsOneWidget);
    });

    testWidgets('custom height applies to content area', (tester) async {
      await tester.pumpWidget(_wrap(_view(height: 200)));

      final sizedBox = tester.widget<SizedBox>(
        find
            .ancestor(
              of: find.text('浙江'),
              matching: find.byType(SizedBox),
            )
            .last,
      );
      expect(sizedBox.height, 200);
    });
  });
}

/// Helper widget for controlled value testing
class _ControlledCascaderView extends StatefulWidget {
  const _ControlledCascaderView({super.key});

  @override
  State<_ControlledCascaderView> createState() =>
      _ControlledCascaderViewState();
}

class _ControlledCascaderViewState extends State<_ControlledCascaderView> {
  List<_Area>? _value;

  void setValue(List<_Area> value) {
    setState(() => _value = value);
  }

  @override
  Widget build(BuildContext context) {
    return _view(value: _value);
  }
}
