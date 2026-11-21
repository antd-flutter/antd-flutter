import 'package:antd_masonry_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('example 冒烟：画廊应用可构建', (tester) async {
    await tester.pumpWidget(const AntdMasonryGalleryApp());
    await tester.pumpAndSettle();
    expect(find.text('Masonry 瀑布流'), findsOneWidget);
  });
}
