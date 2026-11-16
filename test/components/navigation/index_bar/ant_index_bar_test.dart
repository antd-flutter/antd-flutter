import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => AntScreenUtilInit(
      builder: (context, _) => MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 400,
            child: AntTheme(
              data: AntThemeData.light(),
              child: Material(child: child),
            ),
          ),
        ),
      ),
    );

void main() {
  group('AntIndexBar — 渲染', () {
    testWidgets('渲染索引字母', (tester) async {
      await tester.pumpWidget(_wrap(const AntIndexBar(
        items: [
          AntIndexBarItem(key: 'A'),
          AntIndexBarItem(key: 'B'),
          AntIndexBarItem(key: 'C'),
        ],
      )));

      // 每个字母同时出现在索引条和分组标题 → 2 处
      expect(find.text('A'), findsNWidgets(2));
      expect(find.text('B'), findsNWidgets(2));
      expect(find.text('C'), findsNWidgets(2));
    });

    testWidgets('渲染分组标题', (tester) async {
      await tester.pumpWidget(_wrap(const AntIndexBar(
        items: [
          AntIndexBarItem(key: 'A', title: 'A 组'),
          AntIndexBarItem(key: 'B', title: 'B 组'),
        ],
      )));

      // 分组标题
      expect(find.text('A 组'), findsOneWidget);
      expect(find.text('B 组'), findsOneWidget);
    });

    testWidgets('渲染分组内容', (tester) async {
      await tester.pumpWidget(_wrap(const AntIndexBar(
        items: [
          AntIndexBarItem(key: 'A', child: Text('阿强')),
          AntIndexBarItem(key: 'B', child: Text('Bob')),
        ],
      )));

      expect(find.text('阿强'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
    });

    testWidgets('无 title 时用 key 作为分组标题', (tester) async {
      await tester.pumpWidget(_wrap(const AntIndexBar(
        items: [
          AntIndexBarItem(key: 'A'),
        ],
      )));

      // key 'A' 同时出现在索引条和分组标题 → 2 处
      expect(find.text('A'), findsNWidgets(2));
    });
  });

  group('AntIndexBar — 交互', () {
    testWidgets('点击索引触发 onChange', (tester) async {
      String? changed;
      await tester.pumpWidget(_wrap(AntIndexBar(
        items: const [
          AntIndexBarItem(key: 'A'),
          AntIndexBarItem(key: 'B'),
        ],
        onChange: (key) => changed = key,
      )));

      // 点击索引条中的 B（.last：索引条在右侧）
      await tester.tap(find.text('B').last);
      await tester.pump();

      expect(changed, 'B');
    });

    testWidgets('选中后显示中央气泡', (tester) async {
      await tester.pumpWidget(_wrap(const AntIndexBar(
        items: [
          AntIndexBarItem(key: 'A'),
          AntIndexBarItem(key: 'B'),
        ],
      )));

      await tester.tap(find.text('B').last);
      await tester.pump();

      // 气泡显示 → 'B' 出现 3 处（索引条 + 分组标题 + 气泡）
      expect(find.text('B'), findsNWidgets(3));
    });

    testWidgets('气泡 800ms 后自动隐藏', (tester) async {
      await tester.pumpWidget(_wrap(const AntIndexBar(
        items: [
          AntIndexBarItem(key: 'A'),
          AntIndexBarItem(key: 'B'),
        ],
      )));

      await tester.tap(find.text('B').last);
      await tester.pump();

      // 气泡显示中
      expect(find.text('B'), findsNWidgets(3));

      // 等待 800ms
      await tester.pump(const Duration(milliseconds: 900));

      // 气泡隐藏 → 'B' 回到 2 处
      expect(find.text('B'), findsNWidgets(2));
    });

    testWidgets('垂直拖动切换索引', (tester) async {
      String? changed;
      await tester.pumpWidget(_wrap(AntIndexBar(
        items: const [
          AntIndexBarItem(key: 'A'),
          AntIndexBarItem(key: 'B'),
          AntIndexBarItem(key: 'C'),
        ],
        onChange: (key) => changed = key,
      )));

      // 从索引条的 A（.last：分组标题在前，索引条在后）开始向下拖动
      final offsetA = tester.getCenter(find.text('A').last);
      final gesture = await tester.startGesture(offsetA);
      // 微移触发 drag start
      await gesture.moveTo(Offset(offsetA.dx, offsetA.dy + 20));
      await tester.pump();

      // 拖到索引条的 C 位置
      final offsetC = tester.getCenter(find.text('C').last);
      await gesture.moveTo(offsetC);
      await tester.pump();
      expect(changed, 'C');

      await gesture.up();
      await tester.pump();
    });
  });
}