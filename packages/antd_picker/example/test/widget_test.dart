import 'package:antd_picker_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('画廊根组件可构建并渲染分区 Tab', (tester) async {
    await tester.pumpWidget(const AntdPickerGalleryApp());
    await tester.pumpAndSettle();
    expect(find.text('Picker 选择器族'), findsOneWidget);
    expect(find.text('Picker 滚轮选择'), findsOneWidget);
  });
}
