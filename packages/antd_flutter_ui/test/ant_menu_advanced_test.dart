import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

Widget _wrap(Widget child, {AntThemeData? data}) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: data ?? AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    ),
  );
}

class _MenuData {
  const _MenuData({
    required this.key,
    this.label,
    this.icon,
    this.extra,
    this.children = const [],
    this.dashed = false,
    this.type = AntMenuItemType.item,
  });

  final String key;
  final String? label;
  final Widget? icon;
  final Widget? extra;
  final List<_MenuData> children;
  final bool dashed;
  final AntMenuItemType type;
}

Widget _menu({
  Key? key,
  List<_MenuData> items = const [],
  AntMenuMode mode = AntMenuMode.inline,
  AntMenuTheme theme = AntMenuTheme.light,
  List<Object>? selectedKeys,
  List<Object> defaultSelectedKeys = const [],
  List<Object>? openKeys,
  List<Object> defaultOpenKeys = const [],
  ValueChanged<String>? onClick,
  ValueChanged<_MenuData>? onItemClick,
  ValueChanged<_MenuData>? onSelect,
  ValueChanged<_MenuData>? onDeselect,
  ValueChanged<List<Object>>? onSelectedKeysChange,
  ValueChanged<List<Object>>? onOpenChange,
  bool selectable = true,
  bool multiple = false,
  AntMenuTrigger triggerSubMenuAction = AntMenuTrigger.hover,
  Duration subMenuOpenDelay = const Duration(milliseconds: 100),
  Duration subMenuCloseDelay = const Duration(milliseconds: 100),
  bool inlineCollapsed = false,
  double inlineIndent = 24,
  Widget? expandIcon,
  Widget? overflowedIndicator,
  bool disabled = false,
  bool tooltip = true,
}) {
  return AntMenu<_MenuData>(
    key: key,
    items: items,
    keyOf: (item) => item.key,
    childrenOf: (item) => item.children,
    labelBuilder: (context, item, index) => Text(item.label ?? ''),
    iconBuilder: (context, item) => item.icon,
    extraBuilder: (context, item) => item.extra,
    typeOf: (item) => item.type,
    dashedOf: (item) => item.dashed,
    collapsedLabelOf: (item) => item.label,
    mode: mode,
    theme: theme,
    selectedKeys: selectedKeys,
    defaultSelectedKeys: defaultSelectedKeys,
    openKeys: openKeys,
    defaultOpenKeys: defaultOpenKeys,
    onClick: onClick == null ? null : (item) => onClick(item.key),
    onItemClick: onItemClick,
    onSelect: onSelect,
    onDeselect: onDeselect,
    onSelectedKeysChange: onSelectedKeysChange,
    onOpenChange: onOpenChange,
    selectable: selectable,
    multiple: multiple,
    triggerSubMenuAction: triggerSubMenuAction,
    subMenuOpenDelay: subMenuOpenDelay,
    subMenuCloseDelay: subMenuCloseDelay,
    inlineCollapsed: inlineCollapsed,
    inlineIndent: inlineIndent,
    expandIcon: expandIcon,
    overflowedIndicator: overflowedIndicator,
    disabled: disabled,
    tooltip: tooltip,
  );
}

void main() {
  group('AntMenu — 选中语义', () {
    testWidgets('multiple 模式下再次点击取消选中并触发 onDeselect', (tester) async {
      final selected = <String>[];
      final deselected = <String>[];
      await tester.pumpWidget(
        _wrap(
          _menu(
            multiple: true,
            onSelect: (item) => selected.add(item.key),
            onDeselect: (item) => deselected.add(item.key),
            items: const [
              _MenuData(key: '1', label: '一'),
              _MenuData(key: '2', label: '二'),
            ],
          ),
        ),
      );

      await tester.tap(find.text('一'));
      await tester.tap(find.text('二'));
      await tester.pumpAndSettle();
      expect(selected, ['1', '2']);
      expect(deselected, isEmpty);

      await tester.tap(find.text('一'));
      await tester.pumpAndSettle();
      expect(deselected, ['1']);
    });

    testWidgets('单选模式重复点击已选中项仍触发 onSelect', (tester) async {
      final selected = <String>[];
      final deselected = <String>[];
      await tester.pumpWidget(
        _wrap(
          _menu(
            defaultSelectedKeys: const ['1'],
            onSelect: (item) => selected.add(item.key),
            onDeselect: (item) => deselected.add(item.key),
            items: const [_MenuData(key: '1', label: '一')],
          ),
        ),
      );

      await tester.tap(find.text('一'));
      await tester.pumpAndSettle();

      expect(selected, ['1']);
      expect(deselected, isEmpty);
    });

    testWidgets('selectable 为 false 时不写入选中，但仍触发点击回调', (tester) async {
      String? clicked;
      final keys = <List<Object>>[];
      await tester.pumpWidget(
        _wrap(
          _menu(
            selectable: false,
            onSelectedKeysChange: keys.add,
            onItemClick: (item) => clicked = item.key,
            items: const [_MenuData(key: '1', label: '一')],
          ),
        ),
      );

      await tester.tap(find.text('一'));
      await tester.pumpAndSettle();

      expect(clicked, '1');
      expect(keys, isEmpty);
    });
  });

  group('AntMenu — 垂直模式弹层', () {
    testWidgets('垂直模式子菜单使用浮层，选中后关闭', (tester) async {
      final keys = <List<Object>>[];
      await tester.pumpWidget(
        _wrap(
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 200,
              child: _menu(
                mode: AntMenuMode.vertical,
                // ignore: prefer_const_constructors
                onSelectedKeysChange: keys.add,
                items: const [
                  _MenuData(
                    key: 'sub',
                    label: '更多',
                    children: [_MenuData(key: 'child', label: '子项')],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('子项'), findsNothing);

      await tester.tap(find.text('更多'));
      await tester.pumpAndSettle();
      expect(find.text('子项'), findsOneWidget);

      await tester.tap(find.text('子项'));
      await tester.pumpAndSettle();
      expect(keys.last, ['child']);
      expect(find.text('子项'), findsNothing);
    });

    testWidgets('点击菜单外部关闭浮层', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 200,
              child: _menu(
                mode: AntMenuMode.vertical,
                items: [
                  const _MenuData(
                    key: 'sub',
                    label: '更多',
                    children: [_MenuData(key: 'child', label: '子项')],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('更多'));
      await tester.pumpAndSettle();
      expect(find.text('子项'), findsOneWidget);

      await tester.tapAt(const Offset(600, 300));
      await tester.pumpAndSettle();
      expect(find.text('子项'), findsNothing);
    });
  });

  group('AntMenu — 缩进与折叠', () {
    testWidgets('inline 根级缩进为 inlineIndent，子级为两倍', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _menu(
            defaultOpenKeys: ['sub'],
            items: [
              const _MenuData(
                key: 'sub',
                label: '父级',
                children: [_MenuData(key: 'child', label: '子级')],
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      EdgeInsets paddingOf(String text) {
        final container = tester.widget<Container>(
          find
              .ancestor(of: find.text(text), matching: find.byType(Container))
              .first,
        );
        return container.padding! as EdgeInsets;
      }

      expect(paddingOf('父级').left, 24);
      expect(paddingOf('父级').right, 34);
      expect(paddingOf('子级').left, 48);
    });

    testWidgets('折叠态无 icon 的项显示首字母', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _menu(
            inlineCollapsed: true,
            items: [const _MenuData(key: '1', label: '首字母项')],
          ),
        ),
      );

      expect(find.text('首'), findsOneWidget);
      expect(find.text('首字母项'), findsNothing);
    });

    testWidgets('折叠态根容器宽度为 80', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _menu(
            inlineCollapsed: true,
            items: [
              const _MenuData(
                key: '1',
                label: '一',
                icon: Icon(AntIcons.homeOutlined),
              ),
            ],
          ),
        ),
      );

      final roots = tester.widgetList<Container>(find.byType(Container));
      expect(
        roots.any((c) => c.constraints?.maxWidth == 80),
        isTrue,
      );
    });
  });

  group('AntMenu — 键盘与主题', () {
    testWidgets('方向键移动高亮，Enter 选中', (tester) async {
      final keys = <List<Object>>[];
      await tester.pumpWidget(
        _wrap(
          _menu(
            onSelectedKeysChange: keys.add,
            items: const [
              _MenuData(key: '1', label: '一'),
              _MenuData(key: '2', label: '二'),
            ],
          ),
        ),
      );

      await tester.tap(find.text('一'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(keys.last, ['2']);
    });

    testWidgets('暗色主题选中项使用主色实底', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _menu(
            theme: AntMenuTheme.dark,
            defaultSelectedKeys: ['1'],
            items: [const _MenuData(key: '1', label: '一')],
          ),
          data: AntThemeData.dark(),
        ),
      );
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find
            .ancestor(of: find.text('一'), matching: find.byType(Container))
            .first,
      );
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.color, AntThemeData.dark().colorPrimary);
    });
  });

  group('AntMenu — 数据形态', () {
    testWidgets('divider 支持 dashed 虚线', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _menu(
            items: [
              const _MenuData(key: '1', label: '一'),
              const _MenuData(
                key: 'd',
                type: AntMenuItemType.divider,
                dashed: true,
              ),
              const _MenuData(key: '2', label: '二'),
            ],
          ),
        ),
      );

      final dashed = find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint &&
            widget.painter.runtimeType.toString().contains('Dashed'),
      );
      expect(dashed, findsOneWidget);
    });

    testWidgets('分组标题不可点击，组内项仍可选中', (tester) async {
      final keys = <List<Object>>[];
      await tester.pumpWidget(
        _wrap(
          _menu(
            onSelectedKeysChange: keys.add,
            items: [
              const _MenuData(
                key: 'group',
                type: AntMenuItemType.group,
                label: '分组',
                children: [_MenuData(key: 'g1', label: '组内项')],
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('分组'));
      await tester.pumpAndSettle();
      expect(keys, isEmpty);

      await tester.tap(find.text('组内项'));
      await tester.pumpAndSettle();
      expect(keys.last, ['g1']);
    });

    testWidgets('extra 渲染在行尾', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _menu(
            items: [
              const _MenuData(key: '1', label: '一', extra: Text('3')),
            ],
          ),
        ),
      );

      expect(find.text('一'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });
  });
}
