/// AntCascaderView widget tests
library;

import 'package:antd_picker/antd_picker.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

const _options = <AntCascaderOption>[
  AntCascaderOption(value: 'zj', label: '浙江', children: [
    AntCascaderOption(value: 'hz', label: '杭州', children: [
      AntCascaderOption(value: 'xh', label: '西湖区'),
      AntCascaderOption(value: 'yh', label: '余杭区'),
    ],),
    AntCascaderOption(value: 'nb', label: '宁波'),
  ],),
  AntCascaderOption(value: 'js', label: '江苏', children: [
    AntCascaderOption(value: 'nj', label: '南京'),
    AntCascaderOption(value: 'sz', label: '苏州'),
  ],),
];

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
  group('AntCascaderView — rendering', () {
    testWidgets('renders first level options', (tester) async {
      await tester.pumpWidget(_wrap(const AntCascaderView(options: _options)));
      expect(find.text('浙江'), findsOneWidget);
      expect(find.text('江苏'), findsOneWidget);
    });

    testWidgets('shows placeholder for unselected level', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntCascaderView(options: _options, placeholder: '请选择地区'),
      ),);
      expect(find.text('请选择地区'), findsOneWidget);
    });

    testWidgets('renders only first level initially', (tester) async {
      await tester.pumpWidget(_wrap(const AntCascaderView(options: _options)));
      expect(find.text('杭州'), findsNothing);
      expect(find.text('南京'), findsNothing);
    });
  });

  group('AntCascaderView — selection', () {
    testWidgets('selecting first level shows children', (tester) async {
      await tester.pumpWidget(_wrap(const AntCascaderView(options: _options)));
      await tester.tap(find.text('浙江'));
      await tester.pumpAndSettle();

      expect(find.text('杭州'), findsOneWidget);
      expect(find.text('宁波'), findsOneWidget);
      // Tab title shows selected label (content shows next level)
      expect(find.text('浙江'), findsOneWidget);
    });

    testWidgets('selecting leaf fires onChange with full path', (tester) async {
      List<String>? changedValue;
      List<AntCascaderOption?>? changedItems;
      await tester.pumpWidget(_wrap(AntCascaderView(
        options: _options,
        onChange: (v, items) {
          changedValue = v;
          changedItems = items;
        },
      ),),);

      await tester.tap(find.text('浙江'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('杭州'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('西湖区'));
      await tester.pumpAndSettle();

      expect(changedValue, ['zj', 'hz', 'xh']);
      expect(changedItems?.length, 3);
      expect(changedItems?[0]?.label, '浙江');
      expect(changedItems?[1]?.label, '杭州');
      expect(changedItems?[2]?.label, '西湖区');
    });

    testWidgets('selecting leaf does not add extra level', (tester) async {
      await tester.pumpWidget(_wrap(const AntCascaderView(options: _options)));
      await tester.tap(find.text('浙江'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('宁波'));
      await tester.pumpAndSettle();

      // 宁波 is leaf — only 2 tabs (浙江 / 宁波)
      expect(find.text('请选择'), findsNothing);
    });

    testWidgets('re-selecting a different first level resets path',
        (tester) async {
      await tester.pumpWidget(_wrap(const AntCascaderView(options: _options)));
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
      await tester.pumpWidget(_wrap(const AntCascaderView(
        options: _options,
        defaultValue: ['zj', 'hz'],
      ),),);
      await tester.pumpAndSettle();

      // Should be at the third level (西湖区/余杭区)
      expect(find.text('西湖区'), findsOneWidget);
      expect(find.text('余杭区'), findsOneWidget);
    });

    testWidgets('controlled value updates display', (tester) async {
      final key = GlobalKey<_AntCascaderViewTestState>();
      await tester.pumpWidget(_wrap(
        _ControlledCascaderView(key: key),
      ),);
      await tester.pumpAndSettle();

      // Initially no selection
      expect(find.text('南京'), findsNothing);

      key.currentState!.setValue(['js', 'nj']);
      await tester.pumpAndSettle();

      // After controlled update, should show 江苏's children level
      // and 南京 selected
      expect(find.text('苏州'), findsOneWidget);
    });

    testWidgets('controlled value onChange fires', (tester) async {
      List<String>? changed;
      await tester.pumpWidget(_wrap(AntCascaderView(
        options: _options,
        value: ['zj'],
        onChange: (v, _) => changed = v,
      ),),);

      await tester.tap(find.text('杭州'));
      await tester.pumpAndSettle();

      expect(changed, ['zj', 'hz']);
    });
  });

  group('AntCascaderView — tabs', () {
    testWidgets('onTabsChange fires when switching tab', (tester) async {
      int? tabIndex;
      await tester.pumpWidget(_wrap(AntCascaderView(
        options: _options,
        onTabsChange: (i) => tabIndex = i,
      ),),);

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
      await tester.pumpWidget(_wrap(const AntCascaderView(options: _options)));
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
      const disabledOptions = <AntCascaderOption>[
        AntCascaderOption(value: 'a', label: '可用'),
        AntCascaderOption(value: 'b', label: '禁用', disabled: true),
      ];
      List<String>? changed;
      await tester.pumpWidget(_wrap(AntCascaderView(
        options: disabledOptions,
        onChange: (v, _) => changed = v,
      ),),);

      await tester.tap(find.text('禁用'));
      await tester.pumpAndSettle();

      expect(changed, isNull);
    });

    testWidgets('custom activeIcon shows when selected', (tester) async {
      await tester.pumpWidget(_wrap(const AntCascaderView(
        options: _options,
        activeIcon: Icon(AntIcons.starFilled),
      ),),);

      await tester.tap(find.text('浙江'));
      await tester.pumpAndSettle();
      // Switch back to tab 0 to see the selected item's icon
      await tester.tap(find.text('浙江'));
      await tester.pumpAndSettle();

      expect(find.byIcon(AntIcons.starFilled), findsOneWidget);
      expect(find.byIcon(AntIcons.checkOutlined), findsNothing);
    });

    testWidgets('default check icon shows when selected', (tester) async {
      await tester.pumpWidget(_wrap(const AntCascaderView(options: _options)));
      await tester.tap(find.text('浙江'));
      await tester.pumpAndSettle();
      // Switch back to tab 0 to see the selected item's icon
      await tester.tap(find.text('浙江'));
      await tester.pumpAndSettle();

      expect(find.byIcon(AntIcons.checkOutlined), findsOneWidget);
    });

    testWidgets('custom height applies to content area', (tester) async {
      await tester.pumpWidget(_wrap(const AntCascaderView(
        options: _options,
        height: 200,
      ),),);

      final sizedBox = tester.widget<SizedBox>(
        find.ancestor(
          of: find.text('浙江'),
          matching: find.byType(SizedBox),
        ).last,
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
      _AntCascaderViewTestState();
}

class _AntCascaderViewTestState extends State<_ControlledCascaderView> {
  List<String>? _value;

  void setValue(List<String> v) {
    setState(() => _value = v);
  }

  @override
  Widget build(BuildContext context) {
    return AntCascaderView(
      options: _options,
      value: _value,
    );
  }
}