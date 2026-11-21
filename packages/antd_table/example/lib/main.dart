/// antd_table example — Table 表格演示画廊。
///
/// - 主题经 antd_theme（P03 桥接）注入：`AntThemeData.light/dark().toThemeData()`
/// - R35.4 多平台适配：AntResponsiveInit + AntLayoutData 断点布局
///   （desktop 宽屏双栏 Wrap / phone 窄屏单栏 Column），窗口缩放无溢出
/// - 暗色切换：AppBar 按钮联动 AntTheme + themeMode
/// - 覆盖全部高级用法：基础表格、排序、筛选、固定列、固定表头、
///   行选择、合并单元格、展开行、树形数据、分页、汇总行、分组表头
library;

import 'package:antd_table/antd_table.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

void main() {
  runApp(const AntdTableGalleryApp());
}

/// 演示卡片：标题 + 内容。
typedef _DemoCard = (String, Widget);

/// antd 表格画廊根组件。
class AntdTableGalleryApp extends StatefulWidget {
  const AntdTableGalleryApp({super.key});

  @override
  State<AntdTableGalleryApp> createState() => _AntdTableGalleryAppState();
}

class _AntdTableGalleryAppState extends State<AntdTableGalleryApp> {
  bool _isDark = false;

  static const List<String> _sectionTitles = [
    '基础表格',
    '排序',
    '筛选',
    '固定列',
    '固定表头',
    '行选择',
    '合并单元格',
    '展开行',
    '树形数据',
    '分页',
    '汇总行',
    '分组表头',
  ];

  @override
  Widget build(BuildContext context) {
    // 结构对齐 antd_tree / antd_picker example：AntTheme 包裹 MaterialApp，
    // theme + darkTheme + themeMode 三件套联动，Scaffold 背景跟随 colorBgLayout。
    return AntTheme(
      data: _isDark ? AntThemeData.dark() : AntThemeData.light(),
      child: AntScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => AntResponsiveInit(
          builder: (context, layout, _) => MaterialApp(
            title: 'AntdTable Demo',
            debugShowCheckedModeBanner: false,
            themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
            theme: AntThemeData.light().toThemeData(),
            darkTheme: AntThemeData.dark().toThemeData(),
            home: DefaultTabController(
              length: _sectionTitles.length,
              child: Scaffold(
                backgroundColor: AntTheme.of(context).colorBgLayout,
                appBar: AppBar(
                  title: const Text('Table 表格'),
                  actions: [
                    IconButton(
                      onPressed: () => setState(() => _isDark = !_isDark),
                      icon: Icon(_isDark ? AntIcons.sunOutlined : AntIcons.moonOutlined),
                    ),
                  ],
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: [
                      for (final t in _sectionTitles) Tab(text: t),
                    ],
                  ),
                ),
                // R35.4：desktop 宽屏双栏、phone 窄屏单栏，缩放窗口不溢出。
                body: TabBarView(
                  children: [
                    for (final t in _sectionTitles)
                      _SectionPage(title: t),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 分区页：标题 + 演示卡片（断点自适应布局）。
class _SectionPage extends StatelessWidget {
  const _SectionPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final cards = _cardsFor(title);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        // R35.4：断点自适应 —— lg 及以上宽屏双栏 Wrap，窄屏单栏 Column。
        child: Builder(
          builder: (context) {
            final breakpoint = AntResponsive.breakpointOf(context);
            final isWide = breakpoint == AntBreakpoint.lg ||
                breakpoint == AntBreakpoint.xl ||
                breakpoint == AntBreakpoint.xxl ||
                breakpoint == AntBreakpoint.xxxl;
            if (isWide) {
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (final (t, w) in cards)
                    SizedBox(
                      width: 480,
                      child: _Card(title: t, child: w),
                    ),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (t, w) in cards)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _Card(title: t, child: w),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<_DemoCard> _cardsFor(String title) {
    switch (title) {
      case '基础表格':
        return [('基础用法', const _BasicTable())];
      case '排序':
        return [('单列排序', const _SortTable())];
      case '筛选':
        return [('本地筛选', const _FilterTable())];
      case '固定列':
        return [('固定列（横向滚动）', const _FixedColumnTable())];
      case '固定表头':
        return [('固定表头（纵向滚动）', const _FixedHeaderTable())];
      case '行选择':
        return [('行选择（含禁用行）', const _SelectionTable())];
      case '合并单元格':
        return [('rowSpan / colSpan', const _MergeTable())];
      case '展开行':
        return [('expandedRowRender', const _ExpandTable())];
      case '树形数据':
        return [('树形展示', const _TreeTable())];
      case '分页':
        return [('本地分页', const _PaginationTable())];
      case '汇总行':
        return [('summary 汇总', const _SummaryTable())];
      case '分组表头':
        return [('多级表头', const _GroupHeaderTable())];
      default:
        return [];
    }
  }
}

/// 演示卡片容器。
class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AntTheme.of(context).colorBgContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          child,
        ],
      ),
    );
  }
}

// ---------------- 测试数据 ----------------

List<Map<String, dynamic>> _people({int count = 5}) => [
      for (var i = 1; i <= count; i++)
        {
          'key': 'p$i',
          'name': '用户$i',
          'age': 20 + i * 3,
          'address': '杭州市西湖区文一路 $i 号',
          'tags': ['开发', '测试'][i % 2],
        },
    ];

// ---------------- 演示组件 ----------------

/// 基础表格。
class _BasicTable extends StatelessWidget {
  const _BasicTable();

  @override
  Widget build(BuildContext context) {
    return AntTable(
      columns: const [
        AntTableColumn(title: '姓名', dataIndex: 'name'),
        AntTableColumn(title: '年龄', dataIndex: 'age'),
        AntTableColumn(title: '地址', dataIndex: 'address'),
      ],
      dataSource: _people(),
    );
  }
}

/// 单列排序。
class _SortTable extends StatelessWidget {
  const _SortTable();

  @override
  Widget build(BuildContext context) {
    return AntTable(
      columns: [
        const AntTableColumn(title: '姓名', dataIndex: 'name'),
        AntTableColumn(
          title: '年龄',
          dataIndex: 'age',
          sorter: (a, b) => (a['age'] as int).compareTo(b['age'] as int),
        ),
        const AntTableColumn(title: '地址', dataIndex: 'address'),
      ],
      dataSource: _people(),
    );
  }
}

/// 本地筛选。
class _FilterTable extends StatelessWidget {
  const _FilterTable();

  @override
  Widget build(BuildContext context) {
    return AntTable(
      columns: [
        const AntTableColumn(title: '姓名', dataIndex: 'name'),
        const AntTableColumn(title: '年龄', dataIndex: 'age'),
        AntTableColumn(
          title: '标签',
          dataIndex: 'tags',
          filters: const [
            AntTableFilterItem(text: '开发', value: '开发'),
            AntTableFilterItem(text: '测试', value: '测试'),
          ],
          onFilter: (value, record) => record['tags'] == value,
        ),
      ],
      dataSource: _people(),
    );
  }
}

/// 固定列（横向滚动）。
class _FixedColumnTable extends StatelessWidget {
  const _FixedColumnTable();

  @override
  Widget build(BuildContext context) {
    return AntTable(
      scrollX: 900,
      columns: [
        const AntTableColumn(
          title: '姓名',
          dataIndex: 'name',
          width: 120,
          fixed: AntTableFixed.left,
        ),
        for (var i = 1; i <= 6; i++)
          AntTableColumn(title: '指标$i', dataIndex: 'm$i', width: 120),
        const AntTableColumn(
          title: '地址',
          dataIndex: 'address',
          width: 200,
          fixed: AntTableFixed.right,
        ),
      ],
      dataSource: [
        for (final p in _people(count: 5))
          {
            ...p,
            for (var i = 1; i <= 6; i++) 'm$i': '数据 $i',
          },
      ],
    );
  }
}

/// 固定表头（纵向滚动）。
class _FixedHeaderTable extends StatelessWidget {
  const _FixedHeaderTable();

  @override
  Widget build(BuildContext context) {
    return AntTable(
      scrollY: 240,
      columns: const [
        AntTableColumn(title: '姓名', dataIndex: 'name'),
        AntTableColumn(title: '年龄', dataIndex: 'age'),
        AntTableColumn(title: '地址', dataIndex: 'address'),
      ],
      dataSource: _people(count: 30),
    );
  }
}

/// 行选择（含禁用行）。
class _SelectionTable extends StatefulWidget {
  const _SelectionTable();

  @override
  State<_SelectionTable> createState() => _SelectionTableState();
}

class _SelectionTableState extends State<_SelectionTable> {
  List<Object> _selected = const ['p1'];

  @override
  Widget build(BuildContext context) {
    return AntTable(
      columns: const [
        AntTableColumn(title: '姓名', dataIndex: 'name'),
        AntTableColumn(title: '年龄', dataIndex: 'age'),
      ],
      dataSource: _people(),
      rowSelection: AntTableRowSelection(
        selectedRowKeys: _selected,
        onChange: (keys) => setState(() => _selected = keys),
        getCheckboxProps: (record) =>
            AntTableRowCheckboxProps(disabled: record['key'] == 'p3'),
      ),
    );
  }
}

/// 合并单元格（rowSpan / colSpan，经 column.onCell 配置）。
class _MergeTable extends StatelessWidget {
  const _MergeTable();

  @override
  Widget build(BuildContext context) {
    AntTableCellSpan? nameCell(Map<String, dynamic> r, int i) {
      if (i == 0) return const AntTableCellSpan(rowSpan: 2);
      if (i == 1) return const AntTableCellSpan(rowSpan: 0);
      return null;
    }

    AntTableCellSpan? addressCell(Map<String, dynamic> r, int i) {
      if (i == 2) return const AntTableCellSpan(colSpan: 2);
      if (i == 3) return const AntTableCellSpan(colSpan: 0);
      return null;
    }

    return AntTable(
      bordered: true,
      columns: [
        AntTableColumn(title: '姓名', dataIndex: 'name', onCell: nameCell),
        const AntTableColumn(title: '年龄', dataIndex: 'age'),
        AntTableColumn(title: '地址', dataIndex: 'address', onCell: addressCell),
        AntTableColumn(title: '电话', dataIndex: 'phone', onCell: addressCell),
      ],
      dataSource: const [
        {'key': '1', 'name': '张三', 'age': 32, 'address': '西湖区 1 号', 'phone': '0571-10001'},
        {'key': '2', 'name': '张三', 'age': 32, 'address': '西湖区 1 号', 'phone': '0571-10002'},
        {'key': '3', 'name': '李四', 'age': 28, 'address': '', 'phone': '0571-10003'},
      ],
    );
  }
}

/// expandedRowRender 展开行。
class _ExpandTable extends StatelessWidget {
  const _ExpandTable();

  @override
  Widget build(BuildContext context) {
    return AntTable(
      columns: const [
        AntTableColumn(title: '姓名', dataIndex: 'name'),
        AntTableColumn(title: '年龄', dataIndex: 'age'),
      ],
      dataSource: _people(),
      expandRowByClick: true,
      expandedRowRender: (record, index) => Padding(
        padding: const EdgeInsets.all(8),
        child: Text('详情：${record['name']} — ${record['address']}'),
      ),
    );
  }
}

/// 树形数据展示。
class _TreeTable extends StatelessWidget {
  const _TreeTable();

  @override
  Widget build(BuildContext context) {
    return AntTable(
      defaultExpandAllRows: true,
      columns: const [
        AntTableColumn(title: '姓名', dataIndex: 'name'),
        AntTableColumn(title: '年龄', dataIndex: 'age'),
      ],
      dataSource: [
        {
          'key': '1',
          'name': '张三',
          'age': 32,
          'children': [
            {'key': '1-1', 'name': '小张', 'age': 8},
          ],
        },
        {
          'key': '2',
          'name': '李四',
          'age': 28,
          'children': [
            {'key': '2-1', 'name': '小李', 'age': 6},
            {'key': '2-2', 'name': '小黎', 'age': 3},
          ],
        },
      ],
    );
  }
}

/// 本地分页。
class _PaginationTable extends StatelessWidget {
  const _PaginationTable();

  @override
  Widget build(BuildContext context) {
    return AntTable(
      pagination: true,
      pageSize: 5,
      columns: const [
        AntTableColumn(title: '姓名', dataIndex: 'name'),
        AntTableColumn(title: '年龄', dataIndex: 'age'),
      ],
      dataSource: _people(count: 23),
    );
  }
}

/// summary 汇总行。
class _SummaryTable extends StatelessWidget {
  const _SummaryTable();

  @override
  Widget build(BuildContext context) {
    return AntTable(
      bordered: true,
      summary: (data) => [
        AntTableSummaryCell(
          columnIndex: 0,
          colSpan: 2,
          child: const Text('总计', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        AntTableSummaryCell(
          columnIndex: 2,
          child: Text(
            '${data.fold<int>(0, (sum, r) => sum + r['age'] as int)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
      columns: const [
        AntTableColumn(title: '姓名', dataIndex: 'name'),
        AntTableColumn(title: '年龄', dataIndex: 'age'),
        AntTableColumn(title: '分数', dataIndex: 'score'),
      ],
      dataSource: const [
        {'key': '1', 'name': '张三', 'age': 32, 'score': 90},
        {'key': '2', 'name': '李四', 'age': 28, 'score': 85},
        {'key': '3', 'name': '王五', 'age': 26, 'score': 78},
      ],
    );
  }
}

/// 多级分组表头。
class _GroupHeaderTable extends StatelessWidget {
  const _GroupHeaderTable();

  @override
  Widget build(BuildContext context) {
    return AntTable(
      bordered: true,
      columns: const [
        AntTableColumn(title: '姓名', dataIndex: 'name'),
        AntTableColumn(
          title: '基本信息',
          children: [
            AntTableColumn(title: '年龄', dataIndex: 'age'),
            AntTableColumn(title: '地址', dataIndex: 'address'),
          ],
        ),
        AntTableColumn(title: '标签', dataIndex: 'tags'),
      ],
      dataSource: _people(),
    );
  }
}
