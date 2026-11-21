/// AntNavBar widget 测试
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
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

void main() {
  group('AntNavBar — 渲染', () {
    testWidgets('渲染标题', (tester) async {
      await tester.pumpWidget(_wrap(const AntNavBar(child: Text('标题'))));
      expect(find.text('标题'), findsOneWidget);
    });

    testWidgets('默认显示返回箭头', (tester) async {
      await tester.pumpWidget(_wrap(const AntNavBar(child: Text('标题'))));
      expect(find.byIcon(AntIcons.leftOutlined), findsOneWidget);
    });

    testWidgets('back=false 不显示返回箭头', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNavBar(back: false, child: Text('标题'))),
      );
      expect(find.byIcon(AntIcons.leftOutlined), findsNothing);
    });

    testWidgets('自定义返回箭头', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntNavBar(
            backArrow: Icon(AntIcons.closeOutlined),
            child: Text('标题'),
          ),
        ),
      );
      expect(find.byIcon(AntIcons.closeOutlined), findsOneWidget);
      expect(find.byIcon(AntIcons.leftOutlined), findsNothing);
    });

    testWidgets('右侧内容渲染', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntNavBar(
            right: Text('编辑'),
            child: Text('标题'),
          ),
        ),
      );
      expect(find.text('编辑'), findsOneWidget);
    });

    testWidgets('左侧附加内容渲染', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntNavBar(
            left: Text('附加'),
            child: Text('标题'),
          ),
        ),
      );
      expect(find.text('附加'), findsOneWidget);
    });

    testWidgets('默认底部边框存在', (tester) async {
      await tester.pumpWidget(_wrap(const AntNavBar(child: Text('标题'))));
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AntNavBar),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });

    testWidgets('border=false 无底边框', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntNavBar(border: false, child: Text('标题'))),
      );
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AntNavBar),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border, isNull);
    });
  });

  group('AntNavBar — 交互', () {
    testWidgets('点击返回触发 onBack', (tester) async {
      var backCount = 0;
      await tester.pumpWidget(
        _wrap(
          AntNavBar(
            child: const Text('标题'),
            onBack: () => backCount++,
          ),
        ),
      );
      await tester.tap(find.byIcon(AntIcons.leftOutlined));
      expect(backCount, 1);
    });

    testWidgets('无 onBack 时不崩溃', (tester) async {
      await tester.pumpWidget(_wrap(const AntNavBar(child: Text('标题'))));
      await tester.tap(find.byIcon(AntIcons.leftOutlined));
      expect(find.text('标题'), findsOneWidget);
    });
  });

  group('AntNavBar — 布局', () {
    testWidgets('标题居中显示', (tester) async {
      await tester.pumpWidget(_wrap(const AntNavBar(child: Text('标题'))));
      // 标题应位于导航栏水平中心附近
      final titleRect = tester.getCenter(find.text('标题'));
      final barRect = tester.getTopLeft(find.byType(AntNavBar));
      final barSize = tester.getSize(find.byType(AntNavBar));
      // 允许 1 像素误差（左右 Expanded 等分，标题精确居中）
      expect((titleRect.dx - (barRect.dx + barSize.width / 2)).abs(),
          lessThan(1.0),);
    });

    testWidgets('右侧内容靠右', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntNavBar(
            right: Text('编辑'),
            child: Text('标题'),
          ),
        ),
      );
      final rightRect = tester.getTopRight(find.text('编辑'));
      final barRect = tester.getTopRight(find.byType(AntNavBar));
      // 右侧内容应靠近导航栏右边缘（含 padding）
      expect(barRect.dx - rightRect.dx, lessThan(20.0));
    });
  });
}