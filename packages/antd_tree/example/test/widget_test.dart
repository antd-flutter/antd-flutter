import 'package:antd_tree_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('画廊根组件可构建并渲染分区 Tab', (tester) async {
    await tester.pumpWidget(const AntdTreeGalleryApp());
    await tester.pumpAndSettle();
    expect(find.text('Tree 树形控件族'), findsOneWidget);
    expect(find.text('基础树'), findsOneWidget);
  });
}
