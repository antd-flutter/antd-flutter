import 'package:antd_refresh_example/main.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('all gallery sections render without layout overflow', (
    tester,
  ) async {
    final exceptions = <String>[];
    await tester.runAsync(() async {});
    await tester.pumpWidget(const AntdRefreshGalleryApp());
    await tester.pumpAndSettle();
    // 依次点侧栏每个分区。
    final tiles = find.byType(ListTile);
    final count = tiles.evaluate().length;
    for (var i = 0; i < count; i++) {
      await tester.tap(tiles.at(i));
      await tester.pumpAndSettle();
      final ex = tester.takeException();
      if (ex != null) exceptions.add('section $i: $ex');
    }
    expect(exceptions, isEmpty, reason: exceptions.join('\n'));
  });
}
