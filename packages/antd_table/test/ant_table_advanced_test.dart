import 'package:antd_table/antd_table.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

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

Finder _byKeyValue(String value) => find.byWidgetPredicate(
      (widget) =>
          widget.key is ValueKey &&
          (widget.key! as ValueKey).value.toString() == value,
    );

Finder _tapKey(String value) => find.byWidgetPredicate(
      (widget) =>
          widget is GestureDetector &&
          widget.key is ValueKey &&
          (widget.key! as ValueKey).value.toString() == value,
    );

Finder _rowCheckboxes() => find.byWidgetPredicate(
      (widget) =>
          widget is GestureDetector &&
          widget.key is ValueKey &&
          (widget.key! as ValueKey).value.toString().startsWith(
                'ant_table_checkbox_row_',
              ),
    );

// ---------------- 测试数据：用户自定义模型 ----------------

class Person {
  const Person({
    required this.id,
    required this.name,
    required this.age,
    this.city = '',
    this.children = const [],
  });

  final int id;
  final String name;
  final int age;
  final String city;
  final List<Person> children;
}

List<Person> _people() => const [
      Person(id: 1, name: 'Alice', age: 30, city: '北京'),
      Person(id: 2, name: 'Bob', age: 25, city: '上海'),
      Person(id: 3, name: 'Carol', age: 35, city: '深圳'),
    ];

List<Person> _treeData() => const [
      Person(
        id: 1,
        name: '父A',
        age: 40,
        children: [
          Person(id: 11, name: '子A1', age: 20),
          Person(id: 12, name: '子A2', age: 22),
        ],
      ),
      Person(id: 2, name: '父B', age: 35),
    ];

List<AntTableColumn<Person>> _baseColumns() => [
      AntTableColumn<Person>(
        title: '姓名',
        cell: (context, person, index) => Text(person.name),
      ),
      AntTableColumn<Person>(
        title: '年龄',
        cell: (context, person, index) => Text('${person.age}'),
      ),
      AntTableColumn<Person>(
        title: '城市',
        cell: (context, person, index) => Text(person.city),
      ),
    ];

Widget _table({
  List<AntTableColumn<Person>>? columns,
  List<Person>? dataSource,
  AntTableRowKeyFn<Person>? rowKey,
  AntTableChildrenFn<Person>? childrenOf,
  double? scrollX,
  double? scrollY,
  bool pagination = false,
  int pageSize = 10,
  AntTableRowSelection<Person>? rowSelection,
  AntTableExpandedRowBuilder<Person>? expandedRowRender,
  bool defaultExpandAllRows = false,
  List<Object>? expandedRowKeys,
  AntTableExpandChangeFn? onExpandedRowsChange,
  bool expandRowByClick = false,
  AntTableSummaryFn<Person>? summary,
  AntTableSortChangeFn? onSortChange,
  AntTableFilterChangeFn? onFilterChange,
  void Function(int page, int pageSize)? onPageChange,
}) {
  return AntTable<Person>(
    columns: columns ?? _baseColumns(),
    dataSource: dataSource ?? _people(),
    rowKey: rowKey ?? (person) => person.id,
    childrenOf: childrenOf,
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

void main() {
  group('AntTable advanced', () {
    // ----------------------------------------------------------
    // 排序：受控 / 多列 / 回调
    // ----------------------------------------------------------

    testWidgets('controlled sortOrder drives row order', (tester) async {
      AntTableSortOrder? controlled = AntTableSortOrder.ascend;
      await tester.pumpWidget(
        _wrap(
          StatefulBuilder(
            builder: (context, setState) {
              return _table(
                columns: [
                  AntTableColumn<Person>(
                    title: '姓名',
                    cell: (context, person, index) => Text(person.name),
                  ),
                  AntTableColumn<Person>(
                    title: '年龄',
                    cell: (context, person, index) => Text('${person.age}'),
                    sorter: (a, b) => a.age.compareTo(b.age),
                    sortOrder: controlled,
                  ),
                ],
                onSortChange: (leafIndex, order) =>
                    setState(() => controlled = order),
              );
            },
          ),
        ),
      );

      double dyOf(String name) => tester.getTopLeft(find.text(name)).dy;

      // 受控升序：Bob(25) < Alice(30) < Carol(35)
      expect(dyOf('Bob'), lessThan(dyOf('Alice')));
      expect(dyOf('Alice'), lessThan(dyOf('Carol')));

      // 点击表头 → 受控值切换为降序
      await tester.tap(find.text('年龄'));
      await tester.pump();
      expect(controlled, AntTableSortOrder.descend);
      expect(dyOf('Carol'), lessThan(dyOf('Alice')));
    });

    testWidgets('multi-column sort chains by sortPriority', (tester) async {
      const rows = [
        Person(id: 1, name: 'r1', age: 30, city: 'A'),
        Person(id: 2, name: 'r2', age: 20, city: 'B'),
        Person(id: 3, name: 'r3', age: 25, city: 'A'),
        Person(id: 4, name: 'r4', age: 22, city: 'B'),
      ];
      await tester.pumpWidget(
        _wrap(
          _table(
            dataSource: rows,
            columns: [
              AntTableColumn<Person>(
                title: '姓名',
                cell: (context, person, index) => Text(person.name),
              ),
              AntTableColumn<Person>(
                title: '城市',
                cell: (context, person, index) => Text(person.city),
                sorter: (a, b) => a.city.compareTo(b.city),
                defaultSortOrder: AntTableSortOrder.ascend,
                sortPriority: 1,
              ),
              AntTableColumn<Person>(
                title: '年龄',
                cell: (context, person, index) => Text('${person.age}'),
                sorter: (a, b) => a.age.compareTo(b.age),
                defaultSortOrder: AntTableSortOrder.descend,
                sortPriority: 2,
              ),
            ],
          ),
        ),
      );

      // 城市升序（A,A,B,B），同城市内年龄降序 → r1,r3,r4,r2
      final order = tester
          .widgetList<Text>(find.textStartingWith('r'))
          .map((t) => t.data)
          .toList();
      expect(order, ['r1', 'r3', 'r4', 'r2']);
    });

    testWidgets('onSortChange fires with order cycle', (tester) async {
      final events = <AntTableSortOrder?>[];
      await tester.pumpWidget(
        _wrap(
          _table(
            columns: [
              AntTableColumn<Person>(
                title: '姓名',
                cell: (context, person, index) => Text(person.name),
              ),
              AntTableColumn<Person>(
                title: '年龄',
                cell: (context, person, index) => Text('${person.age}'),
                sorter: (a, b) => a.age.compareTo(b.age),
              ),
            ],
            onSortChange: (leafIndex, order) => events.add(order),
          ),
        ),
      );

      await tester.tap(find.text('年龄'));
      await tester.pump();
      await tester.tap(find.text('年龄'));
      await tester.pump();
      await tester.tap(find.text('年龄'));
      await tester.pump();

      expect(events, [
        AntTableSortOrder.ascend,
        AntTableSortOrder.descend,
        null,
      ]);
    });

    // ----------------------------------------------------------
    // 筛选：单选 / 默认值 / 受控
    // ----------------------------------------------------------

    testWidgets('filterMultiple false switches to radio single select',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 300,
            child: _table(
              columns: [
                AntTableColumn<Person>(
                  title: '姓名',
                  cell: (context, person, index) => Text(person.name),
                ),
                AntTableColumn<Person>(
                  title: '城市',
                  cell: (context, person, index) => Text(person.city),
                  filters: [
                    const AntTableFilterItem(text: '北京', value: '北京'),
                    const AntTableFilterItem(text: '上海', value: '上海'),
                  ],
                  filterMultiple: false,
                  onFilter: (value, record) => record.city == value,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(AntIcons.filterOutlined));
      await tester.pump();
      await tester.tap(_tapKey('ant_table_filter_option_北京'));
      await tester.pump();
      // 单选：再选上海会替换北京
      await tester.tap(_tapKey('ant_table_filter_option_上海'));
      await tester.pump();
      await tester.tap(_tapKey('ant_table_filter_confirm'));
      await tester.pump();

      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('Alice'), findsNothing);
      expect(find.text('Carol'), findsNothing);
    });

    testWidgets('defaultFilteredValue filters on first build', (tester) async {
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 300,
            child: _table(
              columns: [
                AntTableColumn<Person>(
                  title: '姓名',
                  cell: (context, person, index) => Text(person.name),
                ),
                AntTableColumn<Person>(
                  title: '城市',
                  cell: (context, person, index) => Text(person.city),
                  filters: [
                    const AntTableFilterItem(text: '北京', value: '北京'),
                    const AntTableFilterItem(text: '上海', value: '上海'),
                  ],
                  defaultFilteredValue: const ['北京'],
                  onFilter: (value, record) => record.city == value,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsNothing);
    });

    testWidgets('controlled filteredValue + onFilterChange', (tester) async {
      var filtered = <Object>['北京'];
      final events = <List<Object>?>[];
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 300,
            child: StatefulBuilder(
              builder: (context, setState) {
                return _table(
                  columns: [
                    AntTableColumn<Person>(
                      title: '姓名',
                      cell: (context, person, index) => Text(person.name),
                    ),
                    AntTableColumn<Person>(
                      title: '城市',
                      cell: (context, person, index) => Text(person.city),
                      filters: [
                        const AntTableFilterItem(text: '北京', value: '北京'),
                        const AntTableFilterItem(text: '上海', value: '上海'),
                      ],
                      filteredValue: filtered,
                      onFilter: (value, record) => record.city == value,
                    ),
                  ],
                  onFilterChange: (leafIndex, value) {
                    events.add(value);
                    setState(() => filtered = value ?? const []);
                  },
                );
              },
            ),
          ),
        ),
      );

      // 受控初始值生效
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsNothing);

      // 重置 → 回调解出 null
      await tester.tap(find.byIcon(AntIcons.filterOutlined));
      await tester.pump();
      await tester.tap(_tapKey('ant_table_filter_reset'));
      await tester.pump();
      expect(events.last, isNull);
      expect(find.text('Bob'), findsOneWidget);
    });

    // ----------------------------------------------------------
    // 固定列 / 滚动
    // ----------------------------------------------------------

    testWidgets('fixed right column stays visible during scroll',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          SizedBox(
            width: 400,
            child: _table(
              scrollX: 400,
              columns: [
                AntTableColumn<Person>(
                  title: '姓名',
                  width: 120,
                  cell: (context, person, index) => Text(person.name),
                ),
                AntTableColumn<Person>(
                  title: '年龄',
                  width: 120,
                  cell: (context, person, index) => Text('${person.age}'),
                ),
                AntTableColumn<Person>(
                  title: '城市',
                  width: 120,
                  fixed: AntTableFixed.right,
                  cell: (context, person, index) => Text(person.city),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('城市'), findsOneWidget);
      expect(find.text('年龄'), findsOneWidget);
      expect(find.text('北京'), findsOneWidget);

      // 横向滚动后右侧固定列仍然渲染
      await tester.drag(find.text('年龄').first, const Offset(-200, 0));
      await tester.pump();
      expect(find.text('城市'), findsOneWidget);
      expect(find.text('北京'), findsOneWidget);
    });

    testWidgets('scrollY keeps header outside scrollable body', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            scrollY: 200,
            dataSource: List.generate(
              30,
              (i) => Person(id: i, name: '用户$i', age: 20 + i),
            ),
          ),
        ),
      );

      expect(find.byType(Scrollable), findsWidgets);
      expect(find.text('姓名'), findsOneWidget);
      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pump();
      // 表头不随表体滚动
      expect(find.text('姓名'), findsOneWidget);
      expect(find.text('年龄'), findsOneWidget);
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
            rowSelection: AntTableRowSelection<Person>(
              onChange: changes.add,
            ),
          ),
        ),
      );

      expect(_rowCheckboxes(), findsNWidgets(3));

      await tester.tap(_tapKey('ant_table_checkbox_header'));
      await tester.pump();
      expect(changes.last.toSet(), {1, 2, 3});

      await tester.tap(_tapKey('ant_table_checkbox_header'));
      await tester.pump();
      expect(changes.last, isEmpty);
    });

    testWidgets('getCheckboxProps disabled row excluded from select all',
        (tester) async {
      final changes = <List<Object>>[];
      await tester.pumpWidget(
        _wrap(
          _table(
            rowSelection: AntTableRowSelection<Person>(
              onChange: changes.add,
              getCheckboxProps: (record) =>
                  AntTableRowCheckboxProps(disabled: record.id == 2),
            ),
          ),
        ),
      );

      await tester.tap(_tapKey('ant_table_checkbox_header'));
      await tester.pump();
      expect(changes.last.toSet(), {1, 3});
    });

    testWidgets('tree rows selection cascades to children', (tester) async {
      final changes = <List<Object>>[];
      await tester.pumpWidget(
        _wrap(
          _table(
            dataSource: _treeData(),
            childrenOf: (person) => person.children,
            rowSelection: AntTableRowSelection<Person>(
              onChange: changes.add,
            ),
          ),
        ),
      );

      await tester.tap(_tapKey('ant_table_checkbox_row_1'));
      await tester.pump();
      expect(changes.last.toSet(), containsAll({1, 11, 12}));
    });

    testWidgets('custom selections menu receives selectable keys',
        (tester) async {
      var received = <Object>{};
      await tester.pumpWidget(
        _wrap(
          _table(
            rowSelection: AntTableRowSelection<Person>(
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

      await tester.tap(find.byIcon(AntIcons.caretDownOutlined));
      await tester.pump();
      await tester.tap(find.text('全选'));
      await tester.pump();
      expect(received, {1, 2, 3});
    });

    // ----------------------------------------------------------
    // 单元格合并
    // ----------------------------------------------------------

    testWidgets('rowSpan merges cells vertically', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            columns: [
              AntTableColumn<Person>(
                title: '姓名',
                cell: (context, person, index) => Text(person.name),
                onCell: (record, rowIndex) {
                  if (record.id == 1) return const AntTableCellSpan(rowSpan: 2);
                  if (record.id == 2) return const AntTableCellSpan(rowSpan: 0);
                  return null;
                },
              ),
              AntTableColumn<Person>(
                title: '年龄',
                cell: (context, person, index) => Text('${person.age}'),
              ),
            ],
          ),
        ),
      );

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsNothing); // 被合并隐藏
      expect(find.text('Carol'), findsOneWidget);
    });

    testWidgets('colSpan merges cells horizontally', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            columns: [
              AntTableColumn<Person>(
                title: '姓名',
                cell: (context, person, index) => Text(person.name),
                onCell: (record, rowIndex) =>
                    record.id == 1 ? const AntTableCellSpan(colSpan: 2) : null,
              ),
              AntTableColumn<Person>(
                title: '年龄',
                cell: (context, person, index) => Text('${person.age}'),
              ),
            ],
          ),
        ),
      );

      expect(_byKeyValue('ant_table_row_1'), findsOneWidget);
      expect(find.text('25'), findsOneWidget);
      expect(find.text('35'), findsOneWidget);
    });

    // ----------------------------------------------------------
    // 展开
    // ----------------------------------------------------------

    testWidgets('expandedRowRender shows content after icon tap',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            expandedRowRender: (context, record, index) =>
                Text('详情-${record.name}'),
          ),
        ),
      );

      expect(find.text('详情-Alice'), findsNothing);
      await tester.tap(_tapKey('ant_table_expand_1_false'));
      await tester.pump();
      expect(find.text('详情-Alice'), findsOneWidget);
      expect(find.text('详情-Bob'), findsNothing);
    });

    testWidgets('expandRowByClick toggles without icon tap', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            expandRowByClick: true,
            expandedRowRender: (context, record, index) =>
                Text('详情-${record.name}'),
          ),
        ),
      );

      await tester.tap(find.text('Bob'));
      await tester.pump();
      expect(find.text('详情-Bob'), findsOneWidget);
      await tester.tap(find.text('Bob'));
      await tester.pump();
      expect(find.text('详情-Bob'), findsNothing);
    });

    testWidgets('tree children hidden until expand', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            dataSource: _treeData(),
            childrenOf: (person) => person.children,
          ),
        ),
      );

      expect(find.text('子A1'), findsNothing);
      await tester.tap(_tapKey('ant_table_expand_1_false'));
      await tester.pump();
      expect(find.text('子A1'), findsOneWidget);
      expect(find.text('子A2'), findsOneWidget);
    });

    testWidgets('defaultExpandAllRows shows all children', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            dataSource: _treeData(),
            childrenOf: (person) => person.children,
            defaultExpandAllRows: true,
          ),
        ),
      );
      expect(find.text('子A1'), findsOneWidget);
      expect(find.text('子A2'), findsOneWidget);
    });

    // ----------------------------------------------------------
    // 分页
    // ----------------------------------------------------------

    testWidgets('onPageChange fires and page switch swaps rows',
        (tester) async {
      final pages = <int>[];
      await tester.pumpWidget(
        _wrap(
          _table(
            pagination: true,
            pageSize: 10,
            dataSource: List.generate(
              15,
              (i) => Person(id: i, name: '用户${i + 1}', age: 20 + i),
            ),
            onPageChange: (page, pageSize) => pages.add(page),
          ),
        ),
      );

      expect(find.text('用户10'), findsOneWidget);
      expect(find.text('用户11'), findsNothing);

      await tester.tap(_byKeyValue('ant_table_page_2'));
      await tester.pump();
      expect(pages, [2]);
      expect(find.text('用户11'), findsOneWidget);
      expect(find.text('用户1'), findsNothing);
    });

    // ----------------------------------------------------------
    // 汇总
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
                  '年龄 ${data.fold<int>(0, (sum, person) => sum + person.age)}',
                ),
              ),
            ],
          ),
        ),
      );

      expect(_byKeyValue('ant_table_summary'), findsOneWidget);
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
    // 分组表头
    // ----------------------------------------------------------

    testWidgets('column children renders multi-level header', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            columns: [
              AntTableColumn<Person>(
                title: '姓名',
                cell: (context, person, index) => Text(person.name),
              ),
              AntTableColumn<Person>(
                title: '详细信息',
                children: [
                  AntTableColumn<Person>(
                    title: '年龄',
                    cell: (context, person, index) => Text('${person.age}'),
                  ),
                  AntTableColumn<Person>(
                    title: '城市',
                    cell: (context, person, index) => Text(person.city),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      expect(find.text('详细信息'), findsOneWidget);
      expect(find.text('年龄'), findsOneWidget);
      expect(find.text('城市'), findsOneWidget);
      expect(find.text('北京'), findsOneWidget);
    });

    testWidgets('sorter inside column group still sorts', (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            columns: [
              AntTableColumn<Person>(
                title: '姓名',
                cell: (context, person, index) => Text(person.name),
              ),
              AntTableColumn<Person>(
                title: '详细信息',
                children: [
                  AntTableColumn<Person>(
                    title: '年龄',
                    cell: (context, person, index) => Text('${person.age}'),
                    sorter: (a, b) => a.age.compareTo(b.age),
                  ),
                  AntTableColumn<Person>(
                    title: '城市',
                    cell: (context, person, index) => Text(person.city),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('年龄'));
      await tester.pump();

      final texts = tester
          .widgetList<Text>(find.byType(Text))
          .map((t) => t.data)
          .where((data) => data == '25' || data == '30' || data == '35')
          .toList();
      expect(texts, ['25', '30', '35']);
    });

    testWidgets('selection column keeps header and body checkboxes aligned',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntTable<Person>(
            columns: _baseColumns(),
            dataSource: _people(),
            rowKey: (person) => person.id,
            rowSelection: AntTableRowSelection<Person>(
              selections: [
                AntTableRowSelectionItem(text: '全选', onSelect: (_) {}),
              ],
            ),
          ),
        ),
      );

      final headerCell = tester.getRect(_byKeyValue('ant_table_th_selection'));
      final headerBox = tester.getRect(_tapKey('ant_table_checkbox_header'));
      final rowBox = tester.getRect(_byKeyValue('ant_table_row_1'));
      final rowCheckbox = tester.getRect(_tapKey('ant_table_checkbox_row_1'));

      expect(headerBox.center.dx, closeTo(headerCell.center.dx, 0.5));
      expect(headerBox.center.dx, closeTo(rowCheckbox.center.dx, 0.5));
      expect(rowCheckbox.center.dy, closeTo(rowBox.center.dy, 1.0));
    });

    testWidgets('header title aligns with body cell start padding',
        (tester) async {
      await tester.pumpWidget(_wrap(_table()));
      final headerName = tester.getTopLeft(find.text('姓名'));
      final bodyName = tester.getTopLeft(find.text('Alice'));
      expect((bodyName.dx - headerName.dx).abs(), lessThan(2));

      final headerAge = tester.getTopLeft(find.text('年龄'));
      final bodyAge = tester.getTopLeft(find.text('30'));
      expect((bodyAge.dx - headerAge.dx).abs(), lessThan(2));
    });

    testWidgets('group header title centers over its child columns',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            columns: [
              AntTableColumn<Person>(
                title: '姓名',
                cell: (context, person, index) => Text(person.name),
              ),
              AntTableColumn<Person>(
                title: '基本信息',
                children: [
                  AntTableColumn<Person>(
                    title: '年龄',
                    cell: (context, person, index) => Text('${person.age}'),
                  ),
                  AntTableColumn<Person>(
                    title: '城市',
                    cell: (context, person, index) => Text(person.city),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

      final groupCenter = tester.getCenter(find.text('基本信息')).dx;
      final first = tester.getRect(_byKeyValue('ant_table_th_1'));
      final second = tester.getRect(_byKeyValue('ant_table_th_2'));
      expect(groupCenter, closeTo((first.left + second.right) / 2, 2));
    });

    // ----------------------------------------------------------
    // 用户自定义模型专项（children + 排序）
    // ----------------------------------------------------------

    testWidgets('custom model with children supports tree + per-level sort',
        (tester) async {
      final data = _treeData();
      await tester.pumpWidget(
        _wrap(
          _table(
            dataSource: data,
            childrenOf: (person) => person.children,
            columns: [
              AntTableColumn<Person>(
                title: '姓名',
                cell: (context, person, index) => Text(person.name),
              ),
              AntTableColumn<Person>(
                title: '年龄',
                cell: (context, person, index) => Text('${person.age}'),
                sorter: (a, b) => b.age.compareTo(a.age), // 年龄降序
                defaultSortOrder: AntTableSortOrder.ascend,
              ),
            ],
          ),
        ),
      );

      // 展开父A：排序在每一层递归生效（子A2 22 > 子A1 20）
      await tester.tap(_tapKey('ant_table_expand_1_false'));
      await tester.pump();
      expect(find.text('子A2'), findsOneWidget);
      expect(find.text('子A1'), findsOneWidget);
      final childA2 = tester.getTopLeft(find.text('子A2')).dy;
      final childA1 = tester.getTopLeft(find.text('子A1')).dy;
      expect(childA2, lessThan(childA1));

      // 排序/展开不会改写用户模型
      expect(data.first.children.length, 2);
      expect(data.first.children.first.name, '子A1');
    });

    testWidgets('custom model sorter orders rows by model field',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          _table(
            columns: [
              AntTableColumn<Person>(
                title: '姓名',
                cell: (context, person, index) => Text(person.name),
              ),
              AntTableColumn<Person>(
                title: '年龄',
                cell: (context, person, index) => Text('${person.age}'),
                sorter: (a, b) => a.age.compareTo(b.age),
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('年龄'));
      await tester.pump();
      final asc = tester
          .widgetList<Text>(find.byType(Text))
          .map((t) => t.data)
          .where((d) => d == '25' || d == '30' || d == '35')
          .toList();
      expect(asc, ['25', '30', '35']);

      await tester.tap(find.text('年龄'));
      await tester.pump();
      final desc = tester
          .widgetList<Text>(find.byType(Text))
          .map((t) => t.data)
          .where((d) => d == '25' || d == '30' || d == '35')
          .toList();
      expect(desc, ['35', '30', '25']);
    });
  });
}

extension _FindTextStartingWith on CommonFinders {
  Finder textStartingWith(String prefix) => find.byWidgetPredicate(
        (widget) =>
            widget is Text && (widget.data?.startsWith(prefix) ?? false),
      );
}
