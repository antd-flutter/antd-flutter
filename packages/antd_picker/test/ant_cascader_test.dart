/// AntCascader widget tests
///
/// 全部用例都使用自定义模型 [_Region]，通过 keyOf / childrenOf /
/// disabledOf / labelBuilder 驱动，不构造旧的 AntCascaderOption。
library;

import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_picker/antd_picker.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// 用户自定义模型：地区
class _Region {
  const _Region(
    this.code,
    this.name, [
    this.children = const [],
    this.disabled = false,
  ]);

  final String code;
  final String name;
  final List<_Region> children;
  final bool disabled;

  @override
  String toString() => name;
}

const _xh = _Region('xh', '西湖');
const _yh = _Region('yh', '余杭');
const _hz = _Region('hz', '杭州', [_xh, _yh]);
const _jd = _Region('jd', '江东');
const _nb = _Region('nb', '宁波', [_jd]);
const _zj = _Region('zj', '浙江', [_hz, _nb]);
const _xl = _Region('xl', '玄武');
const _nj = _Region('nj', '南京', [_xl]);
const _js = _Region('js', '江苏', [_nj]);
const _regions = <_Region>[_zj, _js];

const _usable = _Region('a', '可用', [_Region('a1', '子项A1')]);
const _banned = _Region('b', '禁用', [_Region('b1', '子项B1')], true);

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    );

AntCascader<_Region> _cascader({
  List<_Region> dataSource = _regions,
  List<Object>? value,
  List<Object>? defaultValue,
  ValueChanged<List<_Region>>? onChange,
  AntCascaderLabelBuilder<_Region>? labelBuilder,
  String? placeholder,
  bool disabled = false,
  bool allowClear = false,
  bool changeOnSelect = false,
  AntCascaderSize size = AntCascaderSize.middle,
}) {
  return AntCascader<_Region>(
    dataSource: dataSource,
    keyOf: (region) => region.code,
    childrenOf: (region) => region.children,
    disabledOf: (region) => region.disabled,
    labelBuilder: labelBuilder,
    value: value,
    defaultValue: defaultValue,
    onChange: onChange,
    placeholder: placeholder,
    disabled: disabled,
    allowClear: allowClear,
    changeOnSelect: changeOnSelect,
    size: size,
  );
}

void main() {
  group('AntCascader', () {
    testWidgets('renders placeholder when no value', (tester) async {
      await tester.pumpWidget(
        _wrap(_cascader(dataSource: const [], placeholder: '请选择')),
      );
      expect(find.text('请选择'), findsOneWidget);
    });

    testWidgets('displays default value path', (tester) async {
      await tester.pumpWidget(
        _wrap(_cascader(defaultValue: const ['zj', 'hz', 'xh'])),
      );
      expect(find.text('浙江 / 杭州 / 西湖'), findsOneWidget);
    });

    testWidgets('displays controlled value path', (tester) async {
      await tester.pumpWidget(
        _wrap(_cascader(value: const ['js', 'nj', 'xl'])),
      );
      expect(find.text('江苏 / 南京 / 玄武'), findsOneWidget);
    });

    testWidgets('accepts model instances in value', (tester) async {
      await tester.pumpWidget(
        _wrap(_cascader(defaultValue: const [_zj, _hz, _xh])),
      );
      expect(find.text('浙江 / 杭州 / 西湖'), findsOneWidget);
    });

    testWidgets('opens panel on tap and shows first column', (tester) async {
      await tester.pumpWidget(_wrap(_cascader()));
      await tester.tap(find.byType(AntCascader<_Region>));
      await tester.pumpAndSettle();
      expect(find.text('浙江'), findsWidgets);
      expect(find.text('江苏'), findsWidgets);
    });

    testWidgets('expands second column when clicking parent option',
        (tester) async {
      await tester.pumpWidget(_wrap(_cascader()));
      await tester.tap(find.byType(AntCascader<_Region>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('浙江').first);
      await tester.pumpAndSettle();
      expect(find.text('杭州'), findsWidgets);
      expect(find.text('宁波'), findsWidgets);
    });

    testWidgets('expands third column and confirms leaf selection',
        (tester) async {
      var selectedPath = <_Region>[];
      await tester.pumpWidget(
        _wrap(_cascader(onChange: (path) => selectedPath = path)),
      );
      await tester.tap(find.byType(AntCascader<_Region>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('浙江').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('杭州').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('西湖'));
      await tester.pumpAndSettle();
      expect(
        selectedPath.map((region) => region.code).toList(),
        ['zj', 'hz', 'xh'],
      );
      expect(selectedPath.last.name, '西湖');
      expect(find.text('浙江 / 杭州 / 西湖'), findsOneWidget);
    });

    testWidgets('non-leaf click does not trigger onChange by default',
        (tester) async {
      var callCount = 0;
      await tester.pumpWidget(
        _wrap(_cascader(onChange: (_) => callCount++)),
      );
      await tester.tap(find.byType(AntCascader<_Region>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('浙江').first);
      await tester.pumpAndSettle();
      expect(callCount, 0);
    });

    testWidgets('changeOnSelect triggers onChange for non-leaf',
        (tester) async {
      var selectedPath = <_Region>[];
      await tester.pumpWidget(
        _wrap(
          _cascader(
            changeOnSelect: true,
            onChange: (path) => selectedPath = path,
          ),
        ),
      );
      await tester.tap(find.byType(AntCascader<_Region>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('浙江').first);
      await tester.pumpAndSettle();
      expect(selectedPath.map((region) => region.code).toList(), ['zj']);
      expect(selectedPath.single.name, '浙江');
      // 面板保持打开，子列展开
      expect(find.text('杭州'), findsWidgets);
    });

    testWidgets('disabled option cannot be selected', (tester) async {
      var selectedPath = <_Region>[];
      await tester.pumpWidget(
        _wrap(
          _cascader(
            dataSource: const [_usable, _banned],
            onChange: (path) => selectedPath = path,
          ),
        ),
      );
      await tester.tap(find.byType(AntCascader<_Region>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('禁用'));
      await tester.pumpAndSettle();
      expect(selectedPath, isEmpty);
      expect(find.text('子项B1'), findsNothing);
    });

    testWidgets('disabled cascader does not open', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _cascader(dataSource: const [], disabled: true, placeholder: '禁用'),
        ),
      );
      await tester.tap(find.byType(AntCascader<_Region>));
      await tester.pumpAndSettle();
      expect(find.text('浙江'), findsNothing);
    });

    testWidgets('allowClear shows clear icon and clears value', (tester) async {
      var selectedPath = <_Region>[_zj, _hz, _xh];
      await tester.pumpWidget(
        _wrap(
          _cascader(
            defaultValue: const ['zj', 'hz', 'xh'],
            allowClear: true,
            onChange: (path) => selectedPath = path,
          ),
        ),
      );
      expect(find.text('浙江 / 杭州 / 西湖'), findsOneWidget);
      await tester.tap(find.byIcon(AntIcons.closeCircleFilled));
      await tester.pumpAndSettle();
      expect(selectedPath, isEmpty);
    });

    testWidgets('closes panel when tapping outside', (tester) async {
      await tester.pumpWidget(_wrap(_cascader()));
      await tester.tap(find.byType(AntCascader<_Region>));
      await tester.pumpAndSettle();
      expect(find.text('浙江'), findsWidgets);
      await tester.tapAt(const Offset(300, 500));
      await tester.pumpAndSettle();
      expect(find.text('浙江'), findsNothing);
    });

    testWidgets('controlled value updates display', (tester) async {
      late StateSetter setStateOuter;
      List<_Region>? value;
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState) {
              setStateOuter = setState;
              return _cascader(value: value, placeholder: '请选择');
            },
          ),
        ),
      );
      expect(find.text('请选择'), findsOneWidget);
      setStateOuter(() => value = const [_zj, _nb, _jd]);
      await tester.pumpAndSettle();
      expect(find.text('浙江 / 宁波 / 江东'), findsOneWidget);
    });

    testWidgets('switching column selection resets deeper columns',
        (tester) async {
      await tester.pumpWidget(_wrap(_cascader()));
      await tester.tap(find.byType(AntCascader<_Region>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('浙江').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('杭州').last);
      await tester.pumpAndSettle();
      expect(find.text('西湖'), findsOneWidget);
      await tester.tap(find.text('江苏').first);
      await tester.pumpAndSettle();
      expect(find.text('南京'), findsWidgets);
      expect(find.text('西湖'), findsNothing);
    });

    testWidgets('large size renders with larger height', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _cascader(
            dataSource: const [],
            size: AntCascaderSize.large,
            placeholder: '大',
          ),
        ),
      );
      final box = tester.getSize(find.byType(AntCascader<_Region>));
      expect(box.height, greaterThan(35));
    });

    testWidgets('small size renders with smaller height', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _cascader(
            dataSource: const [],
            size: AntCascaderSize.small,
            placeholder: '小',
          ),
        ),
      );
      final box = tester.getSize(find.byType(AntCascader<_Region>));
      expect(box.height, lessThan(30));
    });

    testWidgets('labelBuilder renders custom model widget', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _cascader(
            defaultValue: const [_zj],
            labelBuilder: (context, region) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.place),
                Text('地区:${region.name}'),
              ],
            ),
          ),
        ),
      );
      expect(find.text('地区:浙江'), findsOneWidget);
      await tester.tap(find.byType(AntCascader<_Region>));
      await tester.pumpAndSettle();
      expect(find.text('地区:江苏'), findsWidgets);
    });

    testWidgets('非叶子节点展开不回填触发框（antd 语义，非 changeOnSelect）', (tester) async {
      await tester.pumpWidget(_wrap(_cascader(placeholder: '请选择')));
      await tester.tap(find.byType(AntCascader<_Region>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('浙江').first);
      await tester.pumpAndSettle();
      expect(find.text('杭州'), findsWidgets);
      expect(find.text('浙江 / 杭州'), findsNothing);
      expect(find.text('请选择'), findsOneWidget);
    });

    testWidgets('changeOnSelect 非叶子节点回填触发框', (tester) async {
      await tester.pumpWidget(
        _wrap(_cascader(changeOnSelect: true, placeholder: '请选择')),
      );
      await tester.tap(find.byType(AntCascader<_Region>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('浙江').first);
      await tester.pumpAndSettle();
      expect(find.text('浙江'), findsWidgets);
    });
  });
}
