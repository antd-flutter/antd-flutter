// antd_qrcode example 组件画廊烟囱测试。
import 'package:antd_qrcode/antd_qrcode.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:antd_qrcode_example/main.dart';

void main() {
  testWidgets('画廊启动并展示基础二维码分区', (WidgetTester tester) async {
    await tester.pumpWidget(const AntdQrcodeGalleryApp());
    await tester.pumpAndSettle();

    // 侧栏与内容标题各出现一次
    expect(find.text('基础用法'), findsNWidgets(2));
    // 基础分区渲染出一个 AntQRCode 实例
    expect(find.byType(AntQRCode), findsOneWidget);
  });
}
