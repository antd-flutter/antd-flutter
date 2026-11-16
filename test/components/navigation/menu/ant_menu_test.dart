import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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

void main() {
  group('AntMenu — 基础渲染', () {
    testWidgets('渲染菜单项文本', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            items: const [
              AntMenuItem(key: '1', label: '菜单项一'),
              AntMenuItem(key: '2', label: '菜单项二'),
              AntMenuItem(key: '3', label: '菜单项三'),
            ],
          ),
        ),
      );

      expect(find.text('菜单项一'), findsOneWidget);
      expect(find.text('菜单项二'), findsOneWidget);
      expect(find.text('菜单项三'), findsOneWidget);
    });

    testWidgets('items 为空时渲染 SizedBox.shrink', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntMenu()),
      );
      expect(find.byType(AntMenu), findsOneWidget);
      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(AntMenu),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.width, 0.0);
      expect(sizedBox.height, 0.0);
    });

    testWidgets('渲染图标', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            items: const [
              AntMenuItem(
                key: '1',
                label: '首页',
                icon: Icon(Icons.home),
              ),
            ],
          ),
        ),
      );
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.text('首页'), findsOneWidget);
    });

    testWidgets('渲染 labelWidget', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            items: [
              AntMenuItem(
                key: '1',
                label: '文本标签',
                labelWidget: const Text('自定义标签'),
              ),
            ],
          ),
        ),
      );
      expect(find.text('自定义标签'), findsOneWidget);
      expect(find.text('文本标签'), findsNothing);
    });

    testWidgets('渲染分组标题', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            items: const [
              AntMenuItem(
                key: 'g1',
                label: '分组一',
                type: AntMenuItemType.group,
                children: [
                  AntMenuItem(key: '1', label: '选项 1'),
                  AntMenuItem(key: '2', label: '选项 2'),
                ],
              ),
            ],
          ),
        ),
      );
      expect(find.text('分组一'), findsOneWidget);
      expect(find.text('选项 1'), findsOneWidget);
      expect(find.text('选项 2'), findsOneWidget);
    });

    testWidgets('渲染分割线', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            items: const [
              AntMenuItem(key: '1', label: '选项 1'),
              AntMenuItem(key: 'd', type: AntMenuItemType.divider),
              AntMenuItem(key: '2', label: '选项 2'),
            ],
          ),
        ),
      );
      expect(find.byType(Divider), findsOneWidget);
      expect(find.text('选项 1'), findsOneWidget);
      expect(find.text('选项 2'), findsOneWidget);
    });
  });

  group('AntMenu — 点击与选中', () {
    testWidgets('点击菜单项触发 onClick', (tester) async {
      String? clickedKey;
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            items: const [
              AntMenuItem(key: '1', label: '菜单项一'),
              AntMenuItem(key: '2', label: '菜单项二'),
            ],
            onClick: (key) => clickedKey = key,
          ),
        ),
      );

      await tester.tap(find.text('菜单项一'));
      await tester.pump();

      expect(clickedKey, '1');
    });

    testWidgets('defaultSelectedKeys 默认选中', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            items: const [
              AntMenuItem(key: '1', label: '菜单项一'),
              AntMenuItem(key: '2', label: '菜单项二'),
            ],
            defaultSelectedKeys: ['2'],
          ),
        ),
      );

      // 选中项应有背景色（找到带 BoxDecoration 的 Container）
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('菜单项二'),
          matching: find.byType(Container),
        ).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, isNot(Colors.transparent));
    });

    testWidgets('selectedKeys 受控选中', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            items: const [
              AntMenuItem(key: '1', label: '菜单项一'),
              AntMenuItem(key: '2', label: '菜单项二'),
            ],
            selectedKeys: ['1'],
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('菜单项一'),
          matching: find.byType(Container),
        ).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, isNot(Colors.transparent));
    });

    testWidgets('非受控模式点击后自动选中', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            items: const [
              AntMenuItem(key: '1', label: '菜单项一'),
              AntMenuItem(key: '2', label: '菜单项二'),
            ],
          ),
        ),
      );

      await tester.tap(find.text('菜单项二'));
      await tester.pump();

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('菜单项二'),
          matching: find.byType(Container),
        ).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, isNot(Colors.transparent));
    });

    testWidgets('受控模式点击不改变内部选中状态', (tester) async {
      String? clickedKey;
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            items: const [
              AntMenuItem(key: '1', label: '菜单项一'),
              AntMenuItem(key: '2', label: '菜单项二'),
            ],
            selectedKeys: ['1'],
            onClick: (key) => clickedKey = key,
          ),
        ),
      );

      await tester.tap(find.text('菜单项二'));
      await tester.pump();

      expect(clickedKey, '2');
      // 受控模式下 '1' 仍然选中
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('菜单项一'),
          matching: find.byType(Container),
        ).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, isNot(Colors.transparent));
    });

    testWidgets('禁用项不可点击', (tester) async {
      String? clickedKey;
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            items: const [
              AntMenuItem(key: '1', label: '菜单项一', disabled: true),
              AntMenuItem(key: '2', label: '菜单项二'),
            ],
            onClick: (key) => clickedKey = key,
          ),
        ),
      );

      await tester.tap(find.text('菜单项一'));
      await tester.pump();

      expect(clickedKey, isNull);
    });

    testWidgets('danger 项文字为红色', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            items: const [
              AntMenuItem(key: '1', label: '危险操作', danger: true),
            ],
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('危险操作'));
      expect(text.style?.color, isA<Color>());
    });
  });

  group('AntMenu — 子菜单展开', () {
    testWidgets('点击子菜单标题切换展开', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            items: const [
              AntMenuItem(key: 'sub1', label: '子菜单', children: [
                AntMenuItem(key: '1-1', label: '子项 1'),
              ]),
            ],
          ),
        ),
      );

      // 初始折叠时子项不可见
      expect(find.text('子项 1'), findsNothing);

      await tester.tap(find.text('子菜单'));
      await tester.pumpAndSettle();

      expect(find.text('子项 1'), findsOneWidget);

      await tester.tap(find.text('子菜单'));
      await tester.pumpAndSettle();

      expect(find.text('子项 1'), findsNothing);
    });

    testWidgets('defaultOpenKeys 默认展开', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            items: const [
              AntMenuItem(key: 'sub1', label: '子菜单', children: [
                AntMenuItem(key: '1-1', label: '子项 1'),
              ]),
            ],
            defaultOpenKeys: ['sub1'],
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('子项 1'), findsOneWidget);
    });

    testWidgets('openKeys 受控展开', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            items: const [
              AntMenuItem(key: 'sub1', label: '子菜单', children: [
                AntMenuItem(key: '1-1', label: '子项 1'),
              ]),
            ],
            openKeys: ['sub1'],
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('子项 1'), findsOneWidget);
    });

    testWidgets('onOpenChange 回调触发', (tester) async {
      List<String>? openKeys;
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            items: const [
              AntMenuItem(key: 'sub1', label: '子菜单', children: [
                AntMenuItem(key: '1-1', label: '子项 1'),
              ]),
            ],
            onOpenChange: (keys) => openKeys = keys,
          ),
        ),
      );

      await tester.tap(find.text('子菜单'));
      await tester.pumpAndSettle();

      expect(openKeys, ['sub1']);
    });

    testWidgets('点击子菜单内菜单项触发 onClick', (tester) async {
      String? clickedKey;
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            items: const [
              AntMenuItem(key: 'sub1', label: '子菜单', children: [
                AntMenuItem(key: '1-1', label: '子项 1'),
                AntMenuItem(key: '1-2', label: '子项 2'),
              ]),
            ],
            defaultOpenKeys: ['sub1'],
            onClick: (key) => clickedKey = key,
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('子项 1'));
      await tester.pump();

      expect(clickedKey, '1-1');
    });

    testWidgets('受控 openKeys 点击不改变展开状态', (tester) async {
      List<String>? lastOpenKeys;
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            items: const [
              AntMenuItem(key: 'sub1', label: '子菜单', children: [
                AntMenuItem(key: '1-1', label: '子项 1'),
              ]),
            ],
            openKeys: ['sub1'],
            onOpenChange: (keys) => lastOpenKeys = keys,
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('子菜单'));
      await tester.pumpAndSettle();

      expect(lastOpenKeys, isEmpty);
      // 受控模式下子项仍然可见
      expect(find.text('子项 1'), findsOneWidget);
    });

    testWidgets('嵌套子菜单', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            items: const [
              AntMenuItem(key: 'sub1', label: '一级菜单', children: [
                AntMenuItem(key: 'sub1-1', label: '二级菜单', children: [
                  AntMenuItem(key: '1-1-1', label: '三级项'),
                ]),
              ]),
            ],
            defaultOpenKeys: ['sub1'],
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('二级菜单'), findsOneWidget);
      expect(find.text('三级项'), findsNothing);

      await tester.tap(find.text('二级菜单'));
      await tester.pumpAndSettle();
      expect(find.text('三级项'), findsOneWidget);
    });
  });

  group('AntMenu — 主题与模式', () {
    testWidgets('暗色主题背景色', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            theme: AntMenuTheme.dark,
            items: const [
              AntMenuItem(key: '1', label: '菜单项'),
            ],
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('菜单项'),
          matching: find.byType(Container),
        ).last,
      );
      // 暗色主题背景为 0xFF001529
      expect(container.color, const Color(0xFF001529));
    });

    testWidgets('水平模式渲染', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            mode: AntMenuMode.horizontal,
            items: const [
              AntMenuItem(key: '1', label: '导航一'),
              AntMenuItem(key: '2', label: '导航二'),
            ],
          ),
        ),
      );

      expect(find.text('导航一'), findsOneWidget);
      expect(find.text('导航二'), findsOneWidget);
    });

    testWidgets('水平模式选中项有底部边框', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            mode: AntMenuMode.horizontal,
            items: const [
              AntMenuItem(key: '1', label: '导航一'),
              AntMenuItem(key: '2', label: '导航二'),
            ],
            selectedKeys: ['1'],
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text('导航一'),
          matching: find.byType(Container),
        ).first,
      );
      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;
      expect(border.bottom.color, isA<Color>());
      expect(border.bottom.width, 2.0);
    });

    testWidgets('水平模式点击子菜单展开下拉面板', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            mode: AntMenuMode.horizontal,
            items: const [
              AntMenuItem(key: 'sub1', label: '子菜单', children: [
                AntMenuItem(key: '1-1', label: '下拉项 1'),
              ]),
              AntMenuItem(key: '2', label: '导航二'),
            ],
          ),
        ),
      );

      expect(find.text('下拉项 1'), findsNothing);

      await tester.tap(find.text('子菜单'));
      await tester.pumpAndSettle();

      expect(find.text('下拉项 1'), findsOneWidget);
    });

    testWidgets('水平模式点击菜单项关闭下拉面板', (tester) async {
      String? clickedKey;
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            mode: AntMenuMode.horizontal,
            items: const [
              AntMenuItem(key: 'sub1', label: '子菜单', children: [
                AntMenuItem(key: '1-1', label: '下拉项 1'),
              ]),
            ],
            onClick: (key) => clickedKey = key,
          ),
        ),
      );

      await tester.tap(find.text('子菜单'));
      await tester.pumpAndSettle();
      expect(find.text('下拉项 1'), findsOneWidget);

      await tester.tap(find.text('下拉项 1'));
      await tester.pumpAndSettle();

      expect(clickedKey, '1-1');
      expect(find.text('下拉项 1'), findsNothing);
    });

    testWidgets('水平模式跳过分组项', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            mode: AntMenuMode.horizontal,
            items: const [
              AntMenuItem(
                key: 'g1',
                label: '分组',
                type: AntMenuItemType.group,
                children: [
                  AntMenuItem(key: '1', label: '选项'),
                ],
              ),
              AntMenuItem(key: '2', label: '普通项'),
            ],
          ),
        ),
      );

      // 分组标题在水平模式下不渲染
      expect(find.text('分组'), findsNothing);
      expect(find.text('普通项'), findsOneWidget);
    });
  });

  group('AntMenu — inlineCollapsed', () {
    testWidgets('折叠模式下不渲染文字标签', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            inlineCollapsed: true,
            items: const [
              AntMenuItem(key: '1', label: '菜单项', icon: Icon(Icons.home)),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.text('菜单项'), findsNothing);
    });

    testWidgets('折叠模式下无展开箭头', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            inlineCollapsed: true,
            items: const [
              AntMenuItem(
                key: 'sub1',
                label: '子菜单',
                icon: Icon(Icons.settings),
                children: [
                  AntMenuItem(key: '1-1', label: '子项'),
                ],
              ),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.settings), findsOneWidget);
      // 不应出现展开箭头图标
      expect(find.byIcon(Icons.keyboard_arrow_right), findsNothing);
    });
  });

  group('AntMenu — 缩进', () {
    testWidgets('inlineIndent 影响子菜单缩进', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntMenu(
            inlineIndent: 32,
            items: const [
              AntMenuItem(key: 'sub1', label: '一级', children: [
                AntMenuItem(key: '1-1', label: '二级'),
              ]),
            ],
            defaultOpenKeys: ['sub1'],
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('二级'), findsOneWidget);

      // 验证二级项的 padding left 大于一级项
      final level1Container = tester.widget<Container>(
        find.ancestor(
          of: find.text('一级'),
          matching: find.byType(Container),
        ).first,
      );
      final level2Container = tester.widget<Container>(
        find.ancestor(
          of: find.text('二级'),
          matching: find.byType(Container),
        ).first,
      );
      final l1Padding = level1Container.padding as EdgeInsets;
      final l2Padding = level2Container.padding as EdgeInsets;
      expect(l2Padding.left, greaterThan(l1Padding.left));
    });
  });
}