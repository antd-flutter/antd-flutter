/// AntAutoCenter Widget 测试
library;

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
  group('AntAutoCenter — 基础渲染', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntAutoCenter(child: Text('centered'))),
      );
      expect(find.text('centered'), findsOneWidget);
    });

    testWidgets('null child renders Center', (tester) async {
      await tester.pumpWidget(_wrap(const AntAutoCenter()));
      expect(find.byType(AntAutoCenter), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AntAutoCenter),
          matching: find.byType(Center),
        ),
        findsOneWidget,
      );
    });

    testWidgets('default expanded=false uses Center without Expanded',
        (tester) async {
      await tester.pumpWidget(
        _wrap(const AntAutoCenter(child: Text('centered'))),
      );
      expect(
        find.descendant(
          of: find.byType(AntAutoCenter),
          matching: find.byType(Center),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(AntAutoCenter),
          matching: find.byType(Expanded),
        ),
        findsNothing,
      );
    });

    testWidgets('expanded=true wraps Center with Expanded', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Column(
            children: [
              SizedBox(height: 100),
              AntAutoCenter(expanded: true, child: Text('centered')),
            ],
          ),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(AntAutoCenter),
          matching: find.byType(Expanded),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(AntAutoCenter),
          matching: find.byType(Center),
        ),
        findsOneWidget,
      );
    });
  });

  group('AntAutoCenter — 布局行为', () {
    testWidgets('expanded=true fills remaining space in Column',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Column(
            children: [
              SizedBox(height: 200),
              AntAutoCenter(expanded: true, child: Text('centered')),
            ],
          ),
        ),
      );

      // 测试面高度 600，SizedBox 占 200，AntAutoCenter 应占 400
      final autoCenterRect = tester.getRect(find.byType(AntAutoCenter));
      expect(autoCenterRect.height, 400);
      expect(autoCenterRect.top, 200);
    });

    testWidgets('expanded=false does not expand in Column', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Column(
            children: [
              SizedBox(height: 200),
              AntAutoCenter(child: SizedBox(height: 50)),
            ],
          ),
        ),
      );

      // expanded=false 时 AntAutoCenter 不占满剩余空间，仅包裹 child
      final autoCenterRect = tester.getRect(find.byType(AntAutoCenter));
      expect(autoCenterRect.height, 50);
    });

    testWidgets('content is centered within available space', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Column(
            children: [
              AntAutoCenter(expanded: true, child: SizedBox(height: 40)),
            ],
          ),
        ),
      );

      // 测试面高度 600，AntAutoCenter 占满，child 40 居中 → top = (600 - 40) / 2 = 280
      final innerRect = tester.getRect(
        find.descendant(
          of: find.byType(AntAutoCenter),
          matching: find.byType(SizedBox),
        ),
      );
      expect(innerRect.top, 280);
    });
  });
}