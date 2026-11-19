import 'package:antd_form_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('antd_form example 启动冒烟', (tester) async {
    await tester.pumpWidget(const AntdFormGalleryApp());
    expect(find.text('Form 表单'), findsOneWidget);
  });
}
