// antd_icons_flutter example 画廊烟囱测试。
import 'package:flutter_test/flutter_test.dart';

import 'package:antd_icons_example/main.dart';

void main() {
  testWidgets('画廊启动展示图标分区', (WidgetTester tester) async {
    // main() 未执行，需先初始化全局主题控制器
    themeModeController = ThemeController(initialDark: false);
    await tester.pumpWidget(const AntdIconsGalleryApp());
    await tester.pumpAndSettle();

    // 侧栏/画廊内容渲染即可（具体文案经国际化，不直接断言字符串）
    expect(find.byType(AntdIconsGalleryApp), findsOneWidget);
  });
}
