/// example 首页渲染冒烟测试
library;

import 'package:antd_flutter_example/main.dart';
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'dart:ui' show Size;
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomePage 渲染冒烟测试', (WidgetTester tester) async {
    // 宽屏 1024 逻辑宽（HomePage 布局依赖 AntResponsive，需经
    // AntdFlutterExampleApp 完整根组件链泵入）
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1024, 800);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const AntdFlutterExampleApp());
    await tester.pumpAndSettle();

    // 总览页 Hero 标题在宽/窄两种布局下都渲染
    expect(
      find.text('Ant Design v6 设计规范的 Flutter 组件库'),
      findsOneWidget,
    );
    // 宽屏形态：常驻侧栏渲染
    expect(find.byType(AntLayoutHeader), findsOneWidget);
  });
}
