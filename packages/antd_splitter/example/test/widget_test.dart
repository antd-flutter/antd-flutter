// antd_splitter example 组件画廊烟囱测试。
import 'package:antd_splitter/antd_splitter.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:antd_splitter_example/main.dart';

void main() {
  testWidgets('画廊渲染烟囱测试', (tester) async {
    await tester.pumpWidget(const AntdSplitterGalleryApp());
    await tester.pump();

    // 基础分区渲染出 AntSplitter 实例
    expect(find.byType(AntSplitter), findsWidgets);
    expect(find.text('基本用法'), findsOneWidget);
  });
}
