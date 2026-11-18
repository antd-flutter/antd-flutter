// 临时探针：垂直 Segmented 在不同容器宽度下的实际尺寸
import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('垂直 Segmented 宽度探针', (tester) async {
    for (final w in [400.0, 800.0]) {
      tester.view.physicalSize = Size(w, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        AntScreenUtilInit(
          builder: (_, __) => AntTheme(
            data: AntThemeData.light(),
            child: MaterialApp(
              home: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: w,
                    child: const AntSegmented(
                      direction: AntSegmentedDirection.vertical,
                      block: true,
                      value: 'a',
                      options: [
                        AntSegmentedItem(value: 'a', label: 'A'),
                        AntSegmentedItem(value: 'b', label: 'B'),
                        AntSegmentedItem(value: 'c', label: 'C'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final segSize = tester.getSize(find.byType(AntSegmented));
      debugPrint('VERTICAL container=$w → segSize=${segSize.width}x${segSize.height}');
    }
  });
}
