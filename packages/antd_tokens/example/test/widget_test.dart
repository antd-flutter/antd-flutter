// antd_tokens 示例应用冒烟测试。

import 'package:antd_tokens_example/main.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AntdTokensExampleApp 可正常构建渲染', (tester) async {
    await tester.pumpWidget(const AntdTokensExampleApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
