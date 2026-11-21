import 'package:antd_keyboard_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('画廊根组件可构建并渲染分区 Tab', (tester) async {
    await tester.pumpWidget(const AntdKeyboardGalleryApp());
    await tester.pumpAndSettle();
    expect(find.text('Keyboard 键盘族'), findsOneWidget);
    expect(find.text('AntKeyboard 引擎'), findsOneWidget);
  });
}
