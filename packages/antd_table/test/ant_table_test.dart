import 'package:antd_table/antd_table.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          // 外层可滚动，避免固定高度下表体溢出误报
          child: SingleChildScrollView(child: Material(child: child)),
        ),
      ),
    ),
  );
}

// ---------------- 测试数据 ----------------

List<Map<String, dynamic>> _people() => [
      {'id': 1, 'name': 'Alice', 'age': 30, 'city': '北京'},
      {'id': 2, 'name': 'Bob', 'age': 25, 'city': '上海'},
      {'id': 3, 'name': 'Carol', 'age': 35, 'city': '深圳'},
    ];

List<AntTableColumn> _baseColumns() => [
      const AntTableColumn(title: '姓名', dataIndex: 'name'),
      const AntTableColumn(title: '年龄', dataIndex: 'age'),
    ];

Widget _table({
  List<AntTableColumn>? columns,
  List<Map<String, dynamic>>? dataSource,
  AntTableRowKeyFn? rowKey,
  double? scrollX,
  double? scrollY,
  bool pagination = false,
  int pageSize = 10,
  AntTableSize size = AntTableSize.middle,
  bool bordered = false,
  bool loading = false,
  Widget? empty,
}) {
  return AntTable(
    columns: columns ?? _baseColumns(),
    dataSource: dataSource ?? _people(),
    rowKey: rowKey,
    scrollX: scrollX,
    scrollY: scrollY,
    pagination: pagination,
    pageSize: pageSize,
    size: size,
    bordered: bordered,
    loading: loading,
    empty: empty,
  );
}

void main() {
  group('AntTable', () {
    // ----------------------------------------------------------
    // 基础渲染
    // ----------------------------------------------------------

    testWidgets('renders headers and rows', (tester) async {
      await tester.pumpWidget(_wrap(_table()));
      expect(find.text('姓名'), findsOneWidget);
      expect(find.text('年龄'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Carol'), findsOneWidget);
    });

    testWidgets('render custom column builds custom widget', (tester) async {
      await tester.pumpWidget(_wrap(_table(
        columns: [
          const AntTableColumn(title: '姓名', dataIndex: 'name'),
          AntTableColumn(
            title: '操作',
            render: (value, record, index) =>
                Text('操作-${record['name'] as String}'),
          ),
        ],
      ),),);
      expect(find.text('操作-Alice'), findsOneWidget);
      expect(find.text('操作-Bob'), findsOneWidget);
    });

    testWidgets('default rowKey uses id field', (tester) async {
      await tester.pumpWidget(_wrap(_table()));
      expect(
        find.byKey(const ValueKey<Object?>('ant_table_row_1')),
        findsOneWidget,
      );
    });

    testWidgets('custom rowKey function applies', (tester) async {
      await tester.pumpWidget(_wrap(_table(
        rowKey: (record) => 'r-${record['id']}',
      ),),);
      expect(
        find.byKey(const ValueKey<Object?>('ant_table_row_r-2')),
        findsOneWidget,
      );
    });

    // ----------------------------------------------------------
    // 排序
    // ----------------------------------------------------------

    testWidgets('sort cycles ascend -> descend -> cancel', (tester) async {
      await tester.pumpWidget(_wrap(_table(columns: [
        const AntTableColumn(title: '姓名', dataIndex: 'name'),
        AntTableColumn(
          title: '年龄',
          dataIndex: 'age',
          sorter: (a, b) => (a['age'] as int).compareTo(b['age'] as int),
        ),
      ],),),);

      double dyOf(String name) =>
          tester.getTopLeft(find.text(name)).dy;

      // 初始顺序 Alice, Bob, Carol
      expect(dyOf('Alice'), lessThan(dyOf('Bob')));

      // 第一次点击 → 升序（25, 30, 35 → Bob, Alice, Carol）
      await tester.tap(find.text('年龄'));
      await tester.pump();
      expect(dyOf('Bob'), lessThan(dyOf('Alice')));
      expect(dyOf('Alice'), lessThan(dyOf('Carol')));

      // 第二次点击 → 降序（Carol, Alice, Bob）
      await tester.tap(find.text('年龄'));
      await tester.pump();
      expect(dyOf('Carol'), lessThan(dyOf('Alice')));
      expect(dyOf('Alice'), lessThan(dyOf('Bob')));

      // 第三次点击 → 取消排序（恢复原始顺序）
      await tester.tap(find.text('年龄'));
      await tester.pump();
      expect(dyOf('Alice'), lessThan(dyOf('Bob')));
    });

    testWidgets('sort icon colors active with primary color',
        (tester) async {
      await tester.pumpWidget(_wrap(_table(columns: [
        const AntTableColumn(title: '姓名', dataIndex: 'name'),
        AntTableColumn(
          title: '年龄',
          dataIndex: 'age',
          sorter: (a, b) => 0,
        ),
      ],),),);

      final theme = AntThemeData.light();
      final upIcon =
          tester.widget<Icon>(find.byIcon(AntIcons.arrowUpOutlined));
      expect(upIcon.color, theme.colorTextQuaternary);

      await tester.tap(find.text('年龄'));
      await tester.pump();
      final ascIcon =
          tester.widget<Icon>(find.byIcon(AntIcons.arrowUpOutlined));
      expect(ascIcon.color, theme.colorPrimary);
      final downIcon =
          tester.widget<Icon>(find.byIcon(AntIcons.arrowDownOutlined));
      expect(downIcon.color, theme.colorTextQuaternary);
    });

    testWidgets('column without sorter is not clickable sortable',
        (tester) async {
      await tester.pumpWidget(_wrap(_table()));
      // 基础列没有排序图标
      expect(find.byIcon(AntIcons.arrowUpOutlined), findsNothing);
      expect(find.byIcon(AntIcons.arrowDownOutlined), findsNothing);
    });

    // ----------------------------------------------------------
    // 筛选
    // ----------------------------------------------------------

    testWidgets('filter icon appears only on filter columns',
        (tester) async {
      await tester.pumpWidget(_wrap(_table(columns: [
        const AntTableColumn(title: '姓名', dataIndex: 'name'),
        AntTableColumn(
          title: '城市',
          dataIndex: 'city',
          filters: [
            const AntTableFilterItem(text: '北京', value: '北京'),
            const AntTableFilterItem(text: '上海', value: '上海'),
          ],
          onFilter: (value, record) => record['city'] == value,
        ),
      ],),),);
      expect(find.byIcon(AntIcons.filterOutlined), findsOneWidget);
    });

    testWidgets('filter selects items and filters rows', (tester) async {
      await tester.pumpWidget(_wrap(SizedBox(
        width: 300,
        child: _table(columns: [
          const AntTableColumn(title: '姓名', dataIndex: 'name'),
          AntTableColumn(
            title: '城市',
            dataIndex: 'city',
            filters: [
              const AntTableFilterItem(text: '北京', value: '北京'),
              const AntTableFilterItem(text: '上海', value: '上海'),
              const AntTableFilterItem(text: '深圳', value: '深圳'),
            ],
            onFilter: (value, record) => record['city'] == value,
          ),
        ],),
      ),),);

      // 打开筛选面板
      await tester.tap(find.byIcon(AntIcons.filterOutlined));
      await tester.pump();

      // 选择「北京」「上海」
      await tester.tap(find.text('北京').last);
      await tester.pump();
      await tester.tap(find.text('上海').last);
      await tester.pump();

      // 确定
      await tester.tap(find.text('确定'));
      await tester.pump();

      // 深圳的 Carol 被过滤掉
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Carol'), findsNothing);
    });

    testWidgets('filter reset restores rows', (tester) async {
      await tester.pumpWidget(_wrap(SizedBox(
        width: 300,
        child: _table(columns: [
          const AntTableColumn(title: '姓名', dataIndex: 'name'),
          AntTableColumn(
            title: '城市',
            dataIndex: 'city',
            filters: [
              const AntTableFilterItem(text: '北京', value: '北京'),
            ],
            onFilter: (value, record) => record['city'] == value,
          ),
        ],),
      ),),);

      await tester.tap(find.byIcon(AntIcons.filterOutlined));
      await tester.pump();
      await tester.tap(find.text('北京').last);
      await tester.pump();
      await tester.tap(find.text('确定'));
      await tester.pump();
      expect(find.text('Carol'), findsNothing);

      // 重新打开面板并重置
      await tester.tap(find.byIcon(AntIcons.filterOutlined));
      await tester.pump();
      await tester.tap(find.text('重置'));
      await tester.pump();
      expect(find.text('Carol'), findsOneWidget);
    });

    // ----------------------------------------------------------
    // 固定列
    // ----------------------------------------------------------

    testWidgets('fixed left column stays outside scroll area',
        (tester) async {
      await tester.pumpWidget(_wrap(SizedBox(
        width: 400,
        child: _table(
          scrollX: 800,
          columns: [
            const AntTableColumn(
              title: '姓名',
              dataIndex: 'name',
              width: 100,
              fixed: AntTableFixed.left,
            ),
            const AntTableColumn(title: '年龄', dataIndex: 'age', width: 200),
            const AntTableColumn(title: '城市', dataIndex: 'city', width: 200),
          ],
        ),
      ),),);

      // 固定列渲染正常
      expect(find.text('姓名'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      // 固定列阴影存在
      final gradients = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) => c.decoration is BoxDecoration &&
              (c.decoration! as BoxDecoration).gradient != null,)
          .length;
      expect(gradients, greaterThanOrEqualTo(2)); // 表头 + 行
    });

    testWidgets('fixed right column renders', (tester) async {
      await tester.pumpWidget(_wrap(SizedBox(
        width: 400,
        child: _table(
          scrollX: 800,
          columns: [
            const AntTableColumn(title: '年龄', dataIndex: 'age', width: 200),
            const AntTableColumn(
              title: '城市',
              dataIndex: 'city',
              width: 100,
              fixed: AntTableFixed.right,
            ),
          ],
        ),
      ),),);
      expect(find.text('城市'), findsOneWidget);
      expect(find.text('北京'), findsOneWidget);
    });

    testWidgets('scrollY keeps header above scrollable body',
        (tester) async {
      await tester.pumpWidget(_wrap(_table(
        scrollY: 200,
        dataSource: List.generate(
          30,
          (i) => {'id': i, 'name': 'row $i', 'age': i},
        ),
      ),),);

      // 表头在滚动区外，滚动后仍可见
      expect(find.text('姓名'), findsOneWidget);
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pump();
      expect(find.text('姓名'), findsOneWidget);
      expect(find.text('年龄'), findsOneWidget);
    });

    // ----------------------------------------------------------
    // 虚拟滚动
    // ----------------------------------------------------------

    testWidgets('virtual scroll lazy builds only visible rows',
        (tester) async {
      await tester.pumpWidget(_wrap(_table(
        scrollY: 300,
        dataSource: List.generate(
          100,
          (i) => {'id': i, 'name': 'row $i', 'age': i},
        ),
      ),),);

      // ListView.builder 懒加载：首屏只构建可见行
      expect(find.text('row 0'), findsOneWidget);
      expect(find.text('row 99'), findsNothing);

      // 滚动到底部后远端行才被构建
      await tester.drag(find.byType(ListView), const Offset(0, -40000));
      await tester.pump();
      expect(find.text('row 99'), findsOneWidget);
    });

    testWidgets('small row count with scrollY does not lazy build',
        (tester) async {
      await tester.pumpWidget(_wrap(_table(
        scrollY: 300,
        dataSource: _people(),
      ),),);
      // 3 行 < 50 行阈值，全部一次性构建
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Carol'), findsOneWidget);
    });

    // ----------------------------------------------------------
    // 分页
    // ----------------------------------------------------------

    testWidgets('pagination splits rows by pageSize', (tester) async {
      final data = List.generate(
        9,
        (i) => {'id': i, 'name': 'user $i', 'age': 100 + i},
      );
      await tester.pumpWidget(_wrap(_table(
        pagination: true,
        pageSize: 4,
        dataSource: data,
      ),),);

      // 第一页显示 user 0~3
      expect(find.text('user 0'), findsOneWidget);
      expect(find.text('user 3'), findsOneWidget);
      expect(find.text('user 4'), findsNothing);

      // 切到第二页
      await tester.tap(find.text('2'));
      await tester.pump();
      expect(find.text('user 4'), findsOneWidget);
      expect(find.text('user 7'), findsOneWidget);
      expect(find.text('user 0'), findsNothing);

      // 切到第三页
      await tester.tap(find.text('3'));
      await tester.pump();
      expect(find.text('user 8'), findsOneWidget);
    });

    testWidgets('pagination prev/next buttons work', (tester) async {
      final data = List.generate(
        8,
        (i) => {'id': i, 'name': 'user $i', 'age': 100 + i},
      );
      await tester.pumpWidget(_wrap(_table(
        pagination: true,
        pageSize: 4,
        dataSource: data,
      ),),);

      // 下一页
      await tester.tap(find.byIcon(AntIcons.rightOutlined));
      await tester.pump();
      expect(find.text('user 4'), findsOneWidget);

      // 上一页
      await tester.tap(find.byIcon(AntIcons.leftOutlined));
      await tester.pump();
      expect(find.text('user 0'), findsOneWidget);
    });

    testWidgets('no pagination by default', (tester) async {
      final data = List.generate(
        25,
        (i) => {'id': i, 'name': 'user $i', 'age': 100 + i},
      );
      await tester.pumpWidget(_wrap(_table(dataSource: data)));
      expect(find.text('user 24'), findsOneWidget);
      expect(find.text('2'), findsNothing);
    });

    // ----------------------------------------------------------
    // 边框 / 尺寸 / 加载 / 空数据
    // ----------------------------------------------------------

    testWidgets('bordered true draws outer border', (tester) async {
      await tester.pumpWidget(_wrap(_table(bordered: true)));
      // 外框 = 四边均有 border 的容器（Border.all）
      final outerBorders = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) {
        final deco = c.decoration;
        if (deco is! BoxDecoration || deco.border is! Border) return false;
        final b = deco.border! as Border;
        const solid = BorderStyle.solid;
        return b.left.style == solid &&
            b.right.style == solid &&
            b.top.style == solid &&
            b.bottom.style == solid;
      }).toList();
      expect(outerBorders, isNotEmpty);
    });

    testWidgets('bordered false has no outer border', (tester) async {
      await tester.pumpWidget(_wrap(_table(bordered: false)));
      final outerBorders = tester
          .widgetList<Container>(find.byType(Container))
          .where((c) {
        final deco = c.decoration;
        if (deco is! BoxDecoration || deco.border is! Border) return false;
        final b = deco.border! as Border;
        const solid = BorderStyle.solid;
        return b.left.style == solid &&
            b.right.style == solid &&
            b.top.style == solid &&
            b.bottom.style == solid;
      }).toList();
      expect(outerBorders, isEmpty);
    });

    testWidgets('size large uses larger cell padding than small',
        (tester) async {
      Future<double?> verticalPadding(AntTableSize size) async {
        await tester.pumpWidget(_wrap(_table(size: size)));
        final cellContainer = tester
            .widgetList<Container>(find.ancestor(
          of: find.text('Alice'),
          matching: find.byType(Container),
        ),)
            .firstWhere((c) => c.padding != null);
        return (cellContainer.padding! as EdgeInsets).vertical;
      }

      final large = await verticalPadding(AntTableSize.large);
      final middle = await verticalPadding(AntTableSize.middle);
      final small = await verticalPadding(AntTableSize.small);
      expect(large!, greaterThan(middle!));
      expect(middle, greaterThan(small!));
    });

    testWidgets('loading true shows overlay spinner', (tester) async {
      await tester.pumpWidget(_wrap(_table(loading: true)));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // 内容仍渲染在遮罩下方
      expect(find.text('Alice'), findsOneWidget);
    });

    testWidgets('loading false hides spinner', (tester) async {
      await tester.pumpWidget(_wrap(_table(loading: false)));
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('empty dataSource shows default placeholder',
        (tester) async {
      await tester.pumpWidget(_wrap(_table(dataSource: const [])));
      expect(find.text('暂无数据'), findsOneWidget);
    });

    testWidgets('custom empty widget renders', (tester) async {
      await tester.pumpWidget(_wrap(_table(
        dataSource: const [],
        empty: const Text('自定义空状态'),
      ),),);
      expect(find.text('自定义空状态'), findsOneWidget);
      expect(find.text('暂无数据'), findsNothing);
    });

    // ----------------------------------------------------------
    // ellipsis
    // ----------------------------------------------------------

    testWidgets('ellipsis true truncates long cell text', (tester) async {
      const longText =
          '这是一段非常非常非常非常非常非常非常非常长的文本内容用于测试省略号';
      await tester.pumpWidget(_wrap(SizedBox(
        width: 200,
        child: _table(columns: [
          const AntTableColumn(
            title: '描述',
            dataIndex: 'desc',
            width: 100,
            ellipsis: true,
          ),
        ], dataSource: const [
          {'id': 1, 'desc': longText},
        ],),
      ),),);

      final cellText = tester.widget<Text>(find.text(longText));
      expect(cellText.maxLines, 1);
      expect(cellText.overflow, TextOverflow.ellipsis);
    });

    testWidgets('align center/right applies alignment', (tester) async {
      await tester.pumpWidget(_wrap(_table(columns: [
        const AntTableColumn(
          title: '年龄',
          dataIndex: 'age',
          align: AntTableAlign.center,
        ),
      ],),),);
      // 居中列的表头/单元格内容以 Alignment.center 对齐
      final aligns = tester
          .widgetList<Align>(
            find.ancestor(
              of: find.text('年龄'),
              matching: find.byType(Align),
            ),
          )
          .toList();
      expect(aligns, isNotEmpty);
      expect(aligns.first.alignment, Alignment.center);
    });
  });
}
