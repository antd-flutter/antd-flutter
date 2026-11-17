/// example 首页渲染冒烟测试
library;

import 'package:antd_flutter_example/pages/home_page.dart';
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomePage 渲染冒烟测试', (WidgetTester tester) async {
    // 直接改物理尺寸强制宽屏（1024 逻辑宽 × dpr 3）
    tester.view.devicePixelRatio = 3.0;
    tester.view.physicalSize = const Size(1024, 800) * 3.0;
    addTearDown(() {
      tester.view.devicePixelRatio = 3.0;
      tester.view.physicalSize = const Size(1024, 800) * 3.0;
    });
    await tester.pumpWidget(AntScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => const MaterialApp(home: HomePage()),
    ));
    await tester.pumpAndSettle();

    // 总览页 Hero 标题在宽/窄两种布局下都渲染
    expect(
      find.text('Ant Design v6 设计规范的 Flutter 组件库'),
      findsOneWidget,
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
