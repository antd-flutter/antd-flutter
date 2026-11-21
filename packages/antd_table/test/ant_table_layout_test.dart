import 'package:antd_table/antd_table.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

class _Row {
  const _Row(this.id, this.name, this.age, this.city);
  final int id;
  final String name;
  final int age;
  final String city;
}

const _rows = [
  _Row(1, '张三', 30, '北京'),
  _Row(2, '李四', 25, '上海'),
  _Row(3, '王五', 35, '深圳'),
];

Widget _wrap(Widget child, {double width = 800}) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Center(
            child: SizedBox(width: width, child: SingleChildScrollView(child: child)),
          ),
        ),
      ),
    );

void main() {
  testWidgets('mixed fixed/flex columns align between header and body',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        AntTable<_Row>(
          columns: [
            AntTableColumn<_Row>(
              title: '姓名',
              width: 120,
              cell: (c, r, i) => Text(r.name),
            ),
            AntTableColumn<_Row>(
              title: '年龄',
              cell: (c, r, i) => Text('${r.age}'),
            ),
            AntTableColumn<_Row>(
              title: '城市',
              width: 160,
              cell: (c, r, i) => Text(r.city),
            ),
          ],
          dataSource: _rows,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final headerAge = tester.getTopLeft(find.text('年龄'));
    final bodyAge = tester.getTopLeft(find.text('30'));
    final headerCity = tester.getTopLeft(find.text('城市'));
    final bodyCity = tester.getTopLeft(find.text('北京'));
    expect(bodyAge.dx, closeTo(headerAge.dx, 0.5));
    expect(bodyCity.dx, closeTo(headerCity.dx, 0.5));
  });

  testWidgets('grouped header centers title over its leaf columns',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        AntTable<_Row>(
          columns: [
            AntTableColumn<_Row>(
              title: '姓名',
              cell: (c, r, i) => Text(r.name),
            ),
            AntTableColumn<_Row>(
              title: '基本信息',
              children: [
                AntTableColumn<_Row>(
                  title: '年龄',
                  cell: (c, r, i) => Text('${r.age}'),
                ),
                AntTableColumn<_Row>(
                  title: '城市',
                  cell: (c, r, i) => Text(r.city),
                ),
              ],
            ),
          ],
          dataSource: _rows,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final groupRect = tester.getRect(find.text('基本信息'));
    final leafAge = tester.getRect(
      find.byKey(const ValueKey('ant_table_th_1')),
    );
    final leafCity = tester.getRect(
      find.byKey(const ValueKey('ant_table_th_2')),
    );
    expect(
      groupRect.center.dx,
      closeTo((leafAge.left + leafCity.right) / 2, 2),
    );
    // 分组内叶子列表头与表体同列。
    expect(
      tester.getTopLeft(find.text('30')).dx,
      closeTo(tester.getTopLeft(find.text('年龄')).dx, 0.5),
    );
  });

  testWidgets('rowSpan renders one merged cell spanning rows', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AntTable<_Row>(
          bordered: true,
          columns: [
            AntTableColumn<_Row>(
              title: '城市',
              cell: (c, r, i) => Text(r.city),
              onCell: (r, i) => r.id == 1
                  ? const AntTableCellSpan(rowSpan: 3)
                  : const AntTableCellSpan(rowSpan: 0),
            ),
            AntTableColumn<_Row>(
              title: '姓名',
              cell: (c, r, i) => Text(r.name),
            ),
            AntTableColumn<_Row>(
              title: '年龄',
              cell: (c, r, i) => Text('${r.age}'),
            ),
          ],
          dataSource: _rows,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 合并只渲染一次内容，且高度覆盖三行。
    expect(find.text('北京'), findsOneWidget);
    final merged = tester.getRect(find.text('北京'));
    final firstRow = tester.getRect(find.text('张三'));
    final lastRow = tester.getRect(find.text('王五'));
    expect(merged.top, lessThan(firstRow.top + 1));
    expect(lastRow.bottom - firstRow.top, greaterThan(60));
    // 其余列的起始位置在各行一致（占位宽度不塌陷）。
    expect(
      tester.getTopLeft(find.text('李四')).dx,
      closeTo(tester.getTopLeft(find.text('张三')).dx, 0.5),
    );
  });

  testWidgets('mouse drag scrolls horizontally', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AntTable<_Row>(
          scrollX: 900,
          columns: [
            AntTableColumn<_Row>(
              title: '姓名',
              width: 120,
              fixed: AntTableFixed.left,
              cell: (c, r, i) => Text(r.name),
            ),
            AntTableColumn<_Row>(
              title: '年龄',
              width: 150,
              cell: (c, r, i) => Text('${r.age}'),
            ),
            AntTableColumn<_Row>(
              title: '城市',
              width: 300,
              cell: (c, r, i) => Text(r.city),
            ),
            AntTableColumn<_Row>(
              title: '备注',
              width: 300,
              cell: (c, r, i) => Text('备注 ${r.id}'),
            ),
          ],
          dataSource: _rows,
        ),
        width: 360,
      ),
    );
    await tester.pumpAndSettle();

    final scrollables = find.byWidgetPredicate(
      (w) => w is Scrollable && w.axisDirection == AxisDirection.right,
    );
    final horizontal = tester.state<ScrollableState>(scrollables.first);
    final before = horizontal.position.pixels;

    await tester.drag(
      find.text('30'),
      const Offset(-120, 0),
      kind: PointerDeviceKind.mouse,
    );
    await tester.pumpAndSettle();

    final after = horizontal.position.pixels;
    expect(after, greaterThan(before + 10));
  });
}
