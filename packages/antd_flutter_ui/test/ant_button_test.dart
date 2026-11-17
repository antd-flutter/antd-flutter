/// AntButton Widget 测试（随 P08 组件迁移自主包 test/components/general/button 迁入）
library;

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_flutter_ui/src/basic/button/ant_button_variant_resolver.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    ),
  );
}

void main() {
  group('AntButton', () {
    testWidgets('渲染文字并响应点击', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(
          AntButton(
            onTap: () => taps++,
            child: const Text('按钮'),
          ),
        ),
      );

      expect(find.text('按钮'), findsOneWidget);
      await tester.tap(find.byType(AntButton));
      expect(taps, 1);
    });

    testWidgets('type=primary 映射主色主变体', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntButton(
            type: AntButtonType.primary,
            child: Text('主按钮'),
          ),
        ),
      );

      final style = resolveButtonVariant(type: AntButtonType.primary);
      expect(style.color, AntButtonColor.primary);
      expect(style.variant, AntButtonVariant.solid);
      expect(find.text('主按钮'), findsOneWidget);
    });

    testWidgets('disabled 不响应点击', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(
          AntButton(
            disabled: true,
            onTap: () => taps++,
            child: const Text('禁用'),
          ),
        ),
      );

      await tester.tap(find.byType(AntButton), warnIfMissed: false);
      expect(taps, 0);
    });
  });
}
