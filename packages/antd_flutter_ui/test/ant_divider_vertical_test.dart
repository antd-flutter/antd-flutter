/// 回归测试：垂直分割线在 Row 松约束下曾有高度 0 不可见，
/// 现默认高度 0.9em（对齐 antd web）。
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('垂直分割线在 Row 内有可见高度（回归：0.9em 默认高度）', (tester) async {
    await tester.pumpWidget(
      AntTheme(
          data: AntThemeData.light(),
          child: const MaterialApp(
            home: Scaffold(
              body: Row(
                children: [
                  Text('文本一'),
                  AntDivider(type: AntDividerType.vertical),
                  Text('链接一'),
                ],
              ),
            ),
          ),
        ),
    );
    await tester.pumpAndSettle();

    final size = tester.getSize(find.byType(AntDivider));
    expect(size.height, greaterThan(0));
  });
}
