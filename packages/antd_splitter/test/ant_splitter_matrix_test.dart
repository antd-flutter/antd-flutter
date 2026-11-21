/// AntSplitter 折叠按钮定位组合核对表：
/// 2/3/4 面板 × 水平/垂直 × 拖拽后 × 折叠后，按钮组中心必须精确等于分割条中心。
library;

import 'package:antd_splitter/antd_splitter.dart';
import 'package:antd_theme/antd_theme.dart';
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: AntTheme(
        data: AntThemeData.light(),
        child: Material(child: child),
      ),
    ),
  );
}

void _assertCentered(
  WidgetTester tester,
  bool isHorizontal, {
  bool allowClamped = false,
}) {
  var draggerIndex = 0;
  while (
      tester.any(find.byKey(ValueKey('ant_splitter_dragger_$draggerIndex')))) {
    final draggerCenter = tester
        .getCenter(find.byKey(ValueKey('ant_splitter_dragger_$draggerIndex')));
    final centers = <Offset>[];
    for (final panel in [draggerIndex, draggerIndex + 1]) {
      final key = ValueKey('ant_splitter_collapse_${draggerIndex}_$panel');
      if (tester.any(find.byKey(key))) {
        centers.add(tester.getCenter(find.byKey(key)));
      }
    }
    if (centers.isNotEmpty) {
      final groupCenter = isHorizontal
          ? Offset(
              centers.map((c) => c.dx).reduce((a, b) => a + b) / centers.length,
              centers.first.dy,
            )
          : Offset(
              centers.first.dx,
              centers.map((c) => c.dy).reduce((a, b) => a + b) / centers.length,
            );
      final delta = (groupCenter - draggerCenter).distance;
      // 分割线贴边时按钮钳制在容器内，允许偏移 ≤ 半个命中框（44/2）
      expect(
        delta,
        allowClamped ? lessThanOrEqualTo(22) : lessThan(0.5),
        reason: 'dragger $draggerIndex buttons not centered: '
            '$groupCenter vs $draggerCenter',
      );
    }
    draggerIndex++;
  }
}

List<double> _panelSizes(WidgetTester tester, bool isHorizontal) {
  final sizes = <double>[];
  var i = 0;
  while (tester.any(find.byKey(ValueKey('ant_splitter_panel_$i')))) {
    final size = tester.getSize(find.byKey(ValueKey('ant_splitter_panel_$i')));
    sizes.add(isHorizontal ? size.width : size.height);
    i++;
  }
  return sizes;
}

void main() {
  for (final panelCount in [2, 3, 4]) {
    for (final isHorizontal in [true, false]) {
      final layout = isHorizontal ? 'horizontal' : 'vertical';
      testWidgets('$layout $panelCount 面板 — 初始位置', (tester) async {
        await tester.pumpWidget(
          _wrap(
            SizedBox(
              width: isHorizontal ? double.infinity : 200,
              height: isHorizontal ? 200 : double.infinity,
              child: AntSplitter(
                layout: isHorizontal
                    ? AntSplitterLayout.horizontal
                    : AntSplitterLayout.vertical,
                children: [
                  for (var i = 0; i < panelCount; i++)
                    AntSplitterPanel(
                      collapsible: true,
                      child: Text('P$i'),
                    ),
                ],
              ),
            ),
          ),
        );
        _assertCentered(tester, isHorizontal);
      });

      testWidgets('$layout $panelCount 面板 — 拖拽后位置', (tester) async {
        await tester.pumpWidget(
          _wrap(
            SizedBox(
              width: isHorizontal ? double.infinity : 200,
              height: isHorizontal ? 200 : double.infinity,
              child: AntSplitter(
                layout: isHorizontal
                    ? AntSplitterLayout.horizontal
                    : AntSplitterLayout.vertical,
                children: [
                  for (var i = 0; i < panelCount; i++)
                    AntSplitterPanel(
                      collapsible: true,
                      child: Text('P$i'),
                    ),
                ],
              ),
            ),
          ),
        );
        await tester.drag(
          find.byKey(const ValueKey('ant_splitter_dragger_0')),
          isHorizontal ? const Offset(40, 0) : const Offset(0, 40),
        );
        await tester.pumpAndSettle();
        _assertCentered(tester, isHorizontal);
      });

      testWidgets('$layout $panelCount 面板 — 折叠后位置', (tester) async {
        await tester.pumpWidget(
          _wrap(
            SizedBox(
              width: isHorizontal ? double.infinity : 200,
              height: isHorizontal ? 200 : double.infinity,
              child: AntSplitter(
                layout: isHorizontal
                    ? AntSplitterLayout.horizontal
                    : AntSplitterLayout.vertical,
                children: [
                  for (var i = 0; i < panelCount; i++)
                    AntSplitterPanel(
                      collapsible: true,
                      child: Text('P$i'),
                    ),
                ],
              ),
            ),
          ),
        );
        await tester
            .tap(find.byKey(const ValueKey('ant_splitter_collapse_0_0')));
        await tester.pumpAndSettle();
        expect(_panelSizes(tester, isHorizontal)[0], closeTo(0, 1));
        _assertCentered(tester, isHorizontal, allowClamped: true);
      });
    }
  }
}
