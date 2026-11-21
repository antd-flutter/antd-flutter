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

List<Map<String, dynamic>> _treeData() => [
      {
        'id': 1,
        'name': '父A',
        'age': 40,
        'children': [
          {'id': 11, 'name': '子A1', 'age': 20},
          {'id': 12, 'name': '子A2', 'age': 22},
        ],
      },
      {'id': 2, 'name': '父B', 'age': 35},
    ];

Widget _table({
  List<AntTableColumn>? columns,
  List<Map<String, dynamic>>? dataSource,
  AntTableRowKeyFn? rowKey,
  double? scrollX,
  double? scrollY,
  bool pagination = false,
  int pageSize = 10,
  AntTableRowSelection? rowSelection,
  Widget? Function(Map<String, dynamic>, int)? expandedRowRender,
  bool defaultExpandAllRows = false,
  List<Object>? expandedRowKeys,
  AntTableExpandChangeFn? onExpandedRowsChange,
  bool expandRowByClick = false,
  AntTableSummaryFn? summary,
  AntTableSortChangeFn? onSortChange,
  AntTableFilterChangeFn? onFilterChange,
  void Function(int, int)? onPageChange,
}) {
  return AntTable(
    columns: columns ?? _baseColumns(),
    dataSource: dataSource ?? _people(),
    rowKey: rowKey,
    scrollX: scrollX,
    scrollY: scrollY,
    pagination: pagination,
    pageSize: pageSize,
    rowSelection: rowSelection,
    expandedRowRender: expandedRowRender,
    defaultExpandAllRows: defaultExpandAllRows,
    expandedRowKeys: expandedRowKeys,
    onExpandedRowsChange: onExpandedRowsChange,
    expandRowByClick: expandRowByClick,
    summary: summary,
    onSortChange: onSortChange,
    onFilterChange: onFilterChange,
    onPageChange: onPageChange,
  );
}

List<AntTableColumn> _baseColumns() => [
      const AntTableColumn(title: '姓名', dataIndex: 'name'),
      const AntTableColumn(title: '年龄', dataIndex: 'age'),
    ];

void main() {
  group('AntTable 高级用法', () {
    // ----------------------------------------------------------
    // 排序：受控 / 多列 / 回调
    // ----------------------------------------------------------

    testWidgets('controlled sortOrder drives row order', (tester) async {
      AntTableSortOrder? controlled;
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState) => _table(
              columns: [
                const AntTableColumn(title: '姓名', dataIndex: 'name'),
                AntTableColumn(
                  title: '年龄',
                  dataIndex: 'age',
                  sorter: (a, b) =>
                      (a['age'] as int).compareTo(b['age'] as int),
                  sortOrder: controlled,
                ),
              ],
              onSortChange: (i, order) => setState(() => controlled = order),
            ),
          ),
        ),
      );
      expect(find.text('Alice'), findsOneWidget);

      // 点击表头触发回调（受控，不发内部 setState 排序）
      await tester.tap(find.text('年龄'));
      await tester.pumpAndSettle();
      expect(controlled, AntTableSortOrder.ascend);
    });

    testWidgets('multi-column sort chains by sortPriority', (tester) async {
      // dept 为主排序（priority 1），age 次排序（priority 2）
      final rows = [
        {'id': 1, 'dept': 'A', 'age': 30, 'name': 'r1'},
        {'id': 2, 'dept': 'B', 'age': 20, 'name': 'r2'},
        {'id': 3, 'dept': 'A', 'age': 25, 'name': 'r3'},
        {'id': 4, 'dept': 'B', 'age': 22, 'name': 'r4'},
      ];
      await tester.pumpWidget(
        _wrap(
          _table(
            columns: [
              const AntTableColumn(title: '姓名', dataIndex: 'name'),
              AntTableColumn(
                title: '部门',
                dataIndex: 'dept',
                sortPriority: 1,
                defaultSortOrder: AntTableSortOrder.ascend,
                sorter: (a, b) =>
                    (a['dept'] as String).compareTo(b['dept'] as String),
              ),
              AntTableColumn(
                title: '年龄',
                dataIndex: 'age',
                sortPriority: 2,
                defaultSortOrder: AntTableSortOrder.descend,
                sorter: (a, b) => (a['age'] as int).compareTo(b['age'] as int),
              ),
            ],
            dataSource: rows,
          ),
        ),
      );
      await tester.pumpAndSettle();
      // dept 升序，同部门内 age 降序
      final order = tester
          .widgetList(find.textStartingWith('r'))
          .map((w) => (w as Text).data)
          .toList();
      expect(order, ['r1', 'r3', 'r4', 'r2']);
    });

    testWidgets('onSortChange fires with order cycle', (tester) async {
      final events = <AntTableSortOrder?>[];
      await tester.pumpWidget(
        _wrap(
          _table(
            columns: [
              const AntTableColumn(title: '姓名', dataIndex: 'name'),
              AntTableColumn(
                title: '年龄',
                dataIndex: 'age',
                sorter: (a, b) => (a['age'] as int).compareTo(b['age'] as int),
              ),
            ],
            onSortChange: (_, order) => events.add(order),
          ),
        ),
      );
      await tester.tap(find.text('年龄'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('年龄'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('年龄'));
      await tester.pumpAndSettle();
      expect(events, [
        AntTableSortOrder.ascend,
        AntTableSortOrder.descend,
        null,
      ]);
    });

    // ----------------------------------------------------------
    // 筛选：单选 / 初始值 / 受控 / 回调
    // ----------------------------------------------------------

    testWidgets('filterMultiple false switches to radio single select',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            columns: [
              const AntTableColumn(title: '姓名', dataIndex: 'name'),
              AntTableColumn(
                title: '城市',
                dataIndex: 'city',
                filterMultiple: false,
                filters: const [
                  AntTableFilterItem(text: '北京', value: '北京'),
                  AntTableFilterItem(text: '上海', value: '上海'),
                ],
                onFilter: (v, r) => v == r['city'],
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.byIcon(AntIcons.filterOutlined));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const ValueKey('ant_table_filter_option_北京')));
      await tester.pumpAndSettle();
      await tester
          .tap(find.byKey(const ValueKey('ant_table_filter_option_上海')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('ant_table_filter_confirm')));
      await tester.pumpAndSettle();

      // 单选：只有最后一次选择的上海生效
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Alice'), findsNothing);
      expect(find.text('Carol'), findsNothing);
    });

    testWidgets('defaultFilteredValue filters on first build', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            columns: [
              const AntTableColumn(title: '姓名', dataIndex: 'name'),
              AntTableColumn(
                title: '城市',
                dataIndex: 'city',
                defaultFilteredValue: const ['北京'],
                filters: const [
                  AntTableFilterItem(text: '北京', value: '北京'),
                  AntTableFilterItem(text: '上海', value: '上海'),
                ],
                onFilter: (v, r) => v == r['city'],
              ),
            ],
          ),
        ),
      );
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsNothing);
    });

    testWidgets('controlled filteredValue + onFilterChange', (tester) async {
      final events = <List<Object?>?>[];
      AntTableColumn columnOf(List<Object>? filtered) => AntTableColumn(
            title: '城市',
            dataIndex: 'city',
            filteredValue: filtered,
            filters: const [
              AntTableFilterItem(text: '北京', value: '北京'),
              AntTableFilterItem(text: '上海', value: '上海'),
            ],
            onFilter: (v, r) => v == r['city'],
          );
      List<Object>? controlled = const ['北京'];
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState) => _table(
              columns: [
                const AntTableColumn(title: '姓名', dataIndex: 'name'),
                columnOf(controlled),
              ],
              onFilterChange: (_, v) {
                events.add(v);
                setState(() => controlled = v);
              },
            ),
          ),
        ),
      );
      expect(find.text('Bob'), findsNothing);

      await tester.tap(find.byIcon(AntIcons.filterOutlined));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('ant_table_filter_reset')));
      await tester.pumpAndSettle();
      expect(events.last, isNull);
      expect(find.text('Bob'), findsOneWidget);
    });

    // ----------------------------------------------------------
    // 固定列 / 固定表头
    // ----------------------------------------------------------

    testWidgets('fixed right column stays visible during scroll',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            columns: [
              const AntTableColumn(title: '姓名', dataIndex: 'name', width: 120),
              const AntTableColumn(title: '年龄', dataIndex: 'age', width: 120),
              const AntTableColumn(
                title: '城市',
                dataIndex: 'city',
                width: 120,
                fixed: AntTableFixed.right,
              ),
            ],
            scrollX: 400,
          ),
        ),
      );
      // 固定列表头在滚动区外仍可见
      expect(find.text('城市'), findsOneWidget);
      // 中间列在滚动区内
      expect(find.text('年龄'), findsOneWidget);
    });

    testWidgets('scrollY keeps header outside the scrollable body',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            dataSource: List.generate(
              30,
              (i) => {
                'id': i,
                'name': '用户$i',
                'age': 20 + i,
              },
            ),
            scrollY: 200,
          ),
        ),
      );
      final scrollable = find
          .descendant(
            of: find.byType(AntTable),
            matching: find.byType(Scrollable),
          )
          .evaluate()
          .length;
      expect(scrollable, greaterThanOrEqualTo(1));
      // 表头固定渲染一次
      expect(find.text('姓名'), findsOneWidget);
    });

    // ----------------------------------------------------------
    // 行选择
    // ----------------------------------------------------------

    testWidgets('header select all toggles every row + onChange',
        (tester) async {
      final changes = <List<Object>>[];
      await tester.pumpWidget(
        _wrap(
          _table(
            rowSelection: AntTableRowSelection(
              onChange: changes.add,
            ),
          ),
        ),
      );
      // 初始行复选框数量正确
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is GestureDetector &&
              (w.key?.toString() ?? '').contains('ant_table_checkbox_row_'),
        ),
        findsNWidgets(3),
      );
      await tester
          .tap(find.byKey(const ValueKey('ant_table_checkbox_header')).last);
      await tester.pumpAndSettle();
      expect(changes.last.toSet(), {1, 2, 3});
      await tester
          .tap(find.byKey(const ValueKey('ant_table_checkbox_header')).last);
      await tester.pumpAndSettle();
      expect(changes.last, isEmpty);
    });

    testWidgets('getCheckboxProps disabled row excluded from select all',
        (tester) async {
      final changes = <List<Object>>[];
      await tester.pumpWidget(
        _wrap(
          _table(
            rowSelection: AntTableRowSelection(
              onChange: changes.add,
              getCheckboxProps: (record) =>
                  AntTableRowCheckboxProps(disabled: record['id'] == 2),
            ),
          ),
        ),
      );
      await tester
          .tap(find.byKey(const ValueKey('ant_table_checkbox_header')).last);
      await tester.pumpAndSettle();
      expect(changes.last.toSet(), {1, 3});
    });

    testWidgets('tree rows selection cascades to children', (tester) async {
      final changes = <List<Object>>[];
      await tester.pumpWidget(
        _wrap(
          _table(
            dataSource: _treeData(),
            rowSelection: AntTableRowSelection(onChange: changes.add),
          ),
        ),
      );
      // 选中父A → 子 A1/A2 全选
      await tester
          .tap(find.byKey(const ValueKey('ant_table_checkbox_row_1')).last);
      await tester.pumpAndSettle();
      expect(changes.last.toSet().containsAll({1, 11, 12}), isTrue);
    });

    testWidgets('custom selections menu receives selectable keys',
        (tester) async {
      Set<Object>? received;
      await tester.pumpWidget(
        _wrap(
          _table(
            rowSelection: AntTableRowSelection(
              selections: [
                AntTableRowSelectionItem(
                  text: '全选',
                  onSelect: (keys) => received = keys,
                ),
              ],
            ),
          ),
        ),
      );
      // 表头下拉箭头
      await tester.tap(find.byIcon(AntIcons.caretDownOutlined));
      await tester.pumpAndSettle();
      await tester.tap(find.text('全选'));
      await tester.pumpAndSettle();
      expect(received?.toSet(), {1, 2, 3});
    });

    // ----------------------------------------------------------
    // 合并单元格
    // ----------------------------------------------------------

    testWidgets('rowSpan merges cells vertically', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            columns: [
              AntTableColumn(
                title: '姓名',
                dataIndex: 'name',
                onCell: (record, _) => record['id'] == 1
                    ? const AntTableCellSpan(rowSpan: 2)
                    : (record['id'] == 2
                        ? const AntTableCellSpan(rowSpan: 0)
                        : null),
              ),
              const AntTableColumn(title: '年龄', dataIndex: 'age'),
            ],
          ),
        ),
      );
      // Alice 渲染一次，Bob 被 rowSpan 覆盖不渲染
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsNothing);
      expect(find.text('Carol'), findsOneWidget);
    });

    testWidgets('colSpan merges cells horizontally', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            columns: [
              AntTableColumn(
                title: '姓名',
                dataIndex: 'name',
                onCell: (record, _) => record['id'] == 1
                    ? const AntTableCellSpan(colSpan: 2)
                    : null,
              ),
              const AntTableColumn(title: '年龄', dataIndex: 'age'),
            ],
          ),
        ),
      );
      // Alice 行的姓名格跨两列，年龄格被合并不渲染
      expect(find.text('Alice'), findsOneWidget);
      final aliceRow = find.ancestor(
        of: find.text('Alice'),
        matching: find.byKey(const ValueKey<Object?>('ant_table_row_1')),
      );
      expect(aliceRow, findsOneWidget);
      // Bob / Carol 行正常渲染年龄
      expect(find.text('25'), findsOneWidget);
      expect(find.text('35'), findsOneWidget);
    });

    // ----------------------------------------------------------
    // 展开行
    // ----------------------------------------------------------

    testWidgets('expandedRowRender shows content after icon tap',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            expandedRowRender: (record, index) => Text('详情-${record['name']}'),
          ),
        ),
      );
      expect(find.text('详情-Alice'), findsNothing);
      await tester.tap(find.byKey(const ValueKey('ant_table_expand_1_false')));
      await tester.pumpAndSettle();
      expect(find.text('详情-Alice'), findsOneWidget);
      expect(find.text('详情-Bob'), findsNothing);
    });

    testWidgets('expandRowByClick toggles without icon tap', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            expandRowByClick: true,
            expandedRowRender: (record, index) => Text('详情-${record['name']}'),
          ),
        ),
      );
      await tester.tap(find.text('Bob'));
      await tester.pumpAndSettle();
      expect(find.text('详情-Bob'), findsOneWidget);
      await tester.tap(find.text('Bob'));
      await tester.pumpAndSettle();
      expect(find.text('详情-Bob'), findsNothing);
    });

    // ----------------------------------------------------------
    // 树形数据
    // ----------------------------------------------------------

    testWidgets('tree children hidden until expand', (tester) async {
      await tester.pumpWidget(_wrap(_table(dataSource: _treeData())));
      expect(find.text('子A1'), findsNothing);
      await tester.tap(find.byKey(const ValueKey('ant_table_expand_1_false')));
      await tester.pumpAndSettle();
      expect(find.text('子A1'), findsOneWidget);
      expect(find.text('子A2'), findsOneWidget);
    });

    testWidgets('defaultExpandAllRows shows all children', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            dataSource: _treeData(),
            defaultExpandAllRows: true,
          ),
        ),
      );
      expect(find.text('子A1'), findsOneWidget);
      expect(find.text('子A2'), findsOneWidget);
    });

    // ----------------------------------------------------------
    // 分页集成
    // ----------------------------------------------------------

    testWidgets('onPageChange fires and page switch swaps rows',
        (tester) async {
      final pages = <int>[];
      await tester.pumpWidget(
        _wrap(
          _table(
            dataSource: List.generate(
              15,
              (i) => {
                'id': i + 1,
                'name': '用户${i + 1}',
                'age': 20 + i,
              },
            ),
            pagination: true,
            pageSize: 10,
            onPageChange: (page, size) => pages.add(page),
          ),
        ),
      );
      expect(find.text('用户10'), findsOneWidget);
      expect(find.text('用户11'), findsNothing);

      await tester.tap(find.byKey(const ValueKey('ant_table_page_2')));
      await tester.pumpAndSettle();
      expect(pages, [2]);
      expect(find.text('用户11'), findsOneWidget);
      expect(find.text('用户1'), findsNothing);
    });

    // ----------------------------------------------------------
    // 汇总行
    // ----------------------------------------------------------

    testWidgets('summary renders footer with aggregated values',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            summary: (data) => [
              AntTableSummaryCell(
                columnIndex: 0,
                child: Text('总计 ${data.length} 人'),
              ),
              AntTableSummaryCell(
                columnIndex: 1,
                child: Text(
                  '年龄 ${data.fold<int>(0, (s, r) => s + r['age'] as int)}',
                ),
              ),
            ],
          ),
        ),
      );
      expect(find.byKey(const ValueKey('ant_table_summary')), findsOneWidget);
      expect(find.text('总计 3 人'), findsOneWidget);
      expect(find.text('年龄 90'), findsOneWidget);
    });

    testWidgets('summary cell colSpan merges columns', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            summary: (data) => const [
              AntTableSummaryCell(
                columnIndex: 0,
                colSpan: 2,
                child: Text('合并汇总'),
              ),
            ],
          ),
        ),
      );
      expect(find.text('合并汇总'), findsOneWidget);
    });

    // ----------------------------------------------------------
    // 表头分组（多级表头）
    // ----------------------------------------------------------

    testWidgets('column children renders multi-level header', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            columns: [
              const AntTableColumn(title: '姓名', dataIndex: 'name'),
              const AntTableColumn(
                title: '详细信息',
                children: [
                  AntTableColumn(title: '年龄', dataIndex: 'age'),
                  AntTableColumn(title: '城市', dataIndex: 'city'),
                ],
              ),
            ],
          ),
        ),
      );
      expect(find.text('详细信息'), findsOneWidget);
      expect(find.text('年龄'), findsOneWidget);
      expect(find.text('城市'), findsOneWidget);
      // 叶子列数据正常渲染
      expect(find.text('北京'), findsOneWidget);
    });

    testWidgets('sorter inside column group still sorts', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            columns: [
              AntTableColumn(
                title: '详细信息',
                children: [
                  AntTableColumn(
                    title: '年龄',
                    dataIndex: 'age',
                    sorter: (a, b) =>
                        (a['age'] as int).compareTo(b['age'] as int),
                  ),
                  const AntTableColumn(title: '城市', dataIndex: 'city'),
                ],
              ),
            ],
          ),
        ),
      );
      await tester.tap(find.text('年龄'));
      await tester.pumpAndSettle();
      final ages = tester
          .widgetList(
            find.byWidgetPredicate(
              (w) => w is Text && int.tryParse(w.data ?? '') != null,
            ),
          )
          .map((w) => (w as Text).data)
          .toList();
      expect(ages, ['25', '30', '35']);
    });

    testWidgets('selection column keeps header and body checkboxes aligned',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntTable(
            columns: const [
              AntTableColumn(title: '姓名', dataIndex: 'name'),
              AntTableColumn(title: '年龄', dataIndex: 'age'),
            ],
            dataSource: _people(),
            rowSelection: AntTableRowSelection(
              selections: [
                AntTableRowSelectionItem(text: '全选', onSelect: (_) {}),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final headerCell = tester.getRect(
        find.byKey(const ValueKey('ant_table_th_selection')),
      );
      final headerBox = tester.getRect(
        find.byKey(const ValueKey('ant_table_checkbox_header')).first,
      );
      final row = tester.getRect(
        find.byKey(const ValueKey<Object?>('ant_table_row_1')),
      );
      final rowBox = tester.getRect(
        find.byKey(const ValueKey('ant_table_checkbox_row_1')).first,
      );

      // 有下拉箭头时复选框仍水平居中，且与表体行复选框同列
      expect(headerBox.center.dx, closeTo(headerCell.center.dx, 0.5));
      expect(headerBox.center.dx, closeTo(rowBox.center.dx, 0.5));
      // 表头与表体复选框都垂直居中
      expect(headerBox.center.dy, closeTo(headerCell.center.dy, 0.5));
      expect(rowBox.center.dy, closeTo(row.center.dy, 1.0));
    });

    testWidgets('header title aligns with body cell start padding',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntTable(
            columns: [
              const AntTableColumn(title: '姓名', dataIndex: 'name'),
              AntTableColumn(
                title: '年龄',
                dataIndex: 'age',
                sorter: (a, b) => (a['age'] as int).compareTo(b['age'] as int),
              ),
            ],
            dataSource: _people(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 表头标题与表体首个单元格文本都从列左内边距开始
      final headerTitle = tester.getRect(find.text('姓名'));
      final bodyText = tester.getRect(find.text('Alice'));
      expect(headerTitle.left, closeTo(bodyText.left, 0.5));

      // 带排序箭头的表头标题同样左对齐
      final sortedTitle = tester.getRect(find.text('年龄'));
      final ageText = tester.getRect(find.text('30'));
      expect(sortedTitle.left, closeTo(ageText.left, 0.5));
    });

    testWidgets('group header title centers over its child columns',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntTable(
            columns: [
              const AntTableColumn(title: '姓名', dataIndex: 'name'),
              const AntTableColumn(
                title: '基本信息',
                children: [
                  AntTableColumn(title: '年龄', dataIndex: 'age'),
                  AntTableColumn(title: '城市', dataIndex: 'city'),
                ],
              ),
            ],
            dataSource: _people(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final groupTitle = tester.getRect(find.text('基本信息'));
      final ageCell =
          tester.getRect(find.byKey(const ValueKey('ant_table_th_1')));
      final cityCell =
          tester.getRect(find.byKey(const ValueKey('ant_table_th_2')));
      final spanCenter = (ageCell.left + cityCell.right) / 2;
      expect(groupTitle.center.dx, closeTo(spanCenter, 1.0));
    });
  });
}

extension _FindTextStartingWith on CommonFinders {
  Finder textStartingWith(String prefix) => find.byWidgetPredicate(
        (w) => w is Text && (w.data?.startsWith(prefix) ?? false),
      );
}
