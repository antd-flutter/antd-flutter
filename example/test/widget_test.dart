/// example 首页渲染冒烟测试
library;

import 'package:antd_flutter_example/pages/home_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomePage 渲染冒烟测试', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    // 侧边栏 Logo 与前两个分组标题可见
    expect(find.text('antd-flutter'), findsWidgets);
    expect(find.text('通用'), findsOneWidget);
    expect(find.text('布局'), findsOneWidget);
  });
}