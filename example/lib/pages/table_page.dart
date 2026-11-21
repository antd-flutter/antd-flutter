import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// AntTable 演示页
///
/// 数据源直接使用业务模型 [_Person]（不要求先转 Map）：
/// 列通过 `cell` 构建单元格、`sorter`/`onFilter` 直接比较模型字段。
class TablePage extends StatelessWidget {
  const TablePage({super.key});

  // ---------------- 模拟数据 ----------------

  static const _cities = ['北京', '上海', '深圳', '杭州'];

  static List<_Person> _mockData(int count) {
    return List.generate(count, (i) {
      return _Person(
        id: i + 1,
        name: '用户 ${i + 1}',
        age: 18 + (i * 7) % 40,
        city: _cities[i % _cities.length],
        status: i % 3 == 0 ? '已启用' : (i % 3 == 1 ? '停用' : '待审核'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- 基础用法 ----------------
          _Section(
            title: '基础用法（直接使用业务模型 _Person）',
            theme: theme,
            child: AntTable<_Person>(
              columns: const [
                AntTableColumn(
                  title: '姓名',
                  cell: _nameCell,
                ),
                AntTableColumn(title: '年龄', cell: _ageCell),
                AntTableColumn(title: '城市', cell: _cityCell),
              ],
              dataSource: _mockData(5),
            ),
          ),
          SizedBox(height: 16.w),

          // ---------------- 排序 ----------------
          _Section(
            title: '排序（点击表头：升序 → 降序 → 取消）',
            theme: theme,
            child: AntTable<_Person>(
              columns: [
                const AntTableColumn(title: '姓名', cell: _nameCell),
                AntTableColumn(
                  title: '年龄',
                  cell: _ageCell,
                  sorter: (a, b) => a.age.compareTo(b.age),
                ),
                AntTableColumn(
                  title: '城市',
                  cell: _cityCell,
                  sorter: (a, b) => a.city.compareTo(b.city),
                ),
              ],
              dataSource: _mockData(8),
            ),
          ),
          SizedBox(height: 16.w),

          // ---------------- 筛选 ----------------
          _Section(
            title: '筛选（表头筛选图标，多选 + 确定 / 重置）',
            theme: theme,
            child: AntTable<_Person>(
              columns: [
                const AntTableColumn(title: '姓名', cell: _nameCell),
                AntTableColumn(
                  title: '城市',
                  cell: _cityCell,
                  filters: const [
                    AntTableFilterItem(text: '北京', value: '北京'),
                    AntTableFilterItem(text: '上海', value: '上海'),
                    AntTableFilterItem(text: '深圳', value: '深圳'),
                    AntTableFilterItem(text: '杭州', value: '杭州'),
                  ],
                  onFilter: (value, record) => record.city == value,
                ),
                AntTableColumn(
                  title: '年龄',
                  cell: _ageCell,
                  filters: const [
                    AntTableFilterItem(text: '青年(<30)', value: 24),
                    AntTableFilterItem(text: '中年(38)', value: 38),
                  ],
                  onFilter: (value, record) => record.age == value,
                ),
              ],
              dataSource: _mockData(10),
            ),
          ),
          SizedBox(height: 16.w),

          // ---------------- 固定列 ----------------
          _Section(
            title: '固定列（横向滚动吸边 + 阴影分隔）',
            theme: theme,
            child: AntTable<_Person>(
              scrollX: 900,
              columns: [
                const AntTableColumn(
                  title: '姓名',
                  width: 120,
                  fixed: AntTableFixed.left,
                  cell: _nameCell,
                ),
                const AntTableColumn(
                  title: '年龄',
                  width: 150,
                  cell: _ageCell,
                ),
                const AntTableColumn(
                  title: '城市',
                  width: 150,
                  cell: _cityCell,
                ),
                const AntTableColumn(
                  title: '状态',
                  width: 150,
                  cell: _statusCell,
                ),
                AntTableColumn(
                  title: '备注',
                  width: 180,
                  cell: (_, record, _) => Text('${record.name} 的备注信息'),
                ),
                AntTableColumn(
                  title: '操作',
                  width: 120,
                  fixed: AntTableFixed.right,
                  cell: (_, record, _) => Text('编辑 #${record.id}'),
                ),
              ],
              dataSource: _mockData(6),
            ),
          ),
          SizedBox(height: 16.w),

          // ---------------- 虚拟滚动 ----------------
          _Section(
            title: '滚动 + 虚拟滚动（100 行，scrollY 懒加载）',
            theme: theme,
            child: AntTable<_Person>(
              scrollY: 320,
              columns: const [
                AntTableColumn(title: '姓名', cell: _nameCell),
                AntTableColumn(title: '年龄', cell: _ageCell),
                AntTableColumn(title: '城市', cell: _cityCell),
                AntTableColumn(title: '状态', cell: _statusCell),
              ],
              dataSource: _mockData(100),
            ),
          ),
          SizedBox(height: 16.w),

          // ---------------- 分页 ----------------
          _Section(
            title: '分页（pageSize = 5）',
            theme: theme,
            child: AntTable<_Person>(
              pagination: true,
              pageSize: 5,
              columns: const [
                AntTableColumn(title: '姓名', cell: _nameCell),
                AntTableColumn(title: '年龄', cell: _ageCell),
                AntTableColumn(title: '城市', cell: _cityCell),
              ],
              dataSource: _mockData(18),
            ),
          ),
          SizedBox(height: 16.w),

          // ---------------- 尺寸与边框 ----------------
          _Section(
            title: '尺寸（large / middle / small）与边框',
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AntTable<_Person>(
                  size: AntTableSize.large,
                  columns: _sizeColumns(),
                  dataSource: _mockData(3),
                ),
                SizedBox(height: 12.w),
                AntTable<_Person>(
                  size: AntTableSize.middle,
                  columns: _sizeColumns(),
                  dataSource: _mockData(3),
                ),
                SizedBox(height: 12.w),
                AntTable<_Person>(
                  size: AntTableSize.small,
                  bordered: true,
                  columns: _sizeColumns(),
                  dataSource: _mockData(3),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),

          // ---------------- 加载与空数据 ----------------
          _Section(
            title: '加载与空数据',
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AntTable<_Person>(
                  loading: true,
                  columns: _sizeColumns(),
                  dataSource: _mockData(3),
                ),
                SizedBox(height: 12.w),
                AntTable<_Person>(columns: _sizeColumns(), dataSource: const []),
              ],
            ),
          ),
          SizedBox(height: 16.w),

          // ---------------- 行选择 ----------------
          _Section(
            title: '行选择（全选 / 半选 / 禁用行 / 自定义选择项）',
            theme: theme,
            child: AntTable<_Person>(
              columns: _sizeColumns(),
              dataSource: _mockData(5),
              rowKey: (record) => record.id,
              rowSelection: AntTableRowSelection<_Person>(
                onChange: (keys) {},
                getCheckboxProps: (record) =>
                    AntTableRowCheckboxProps(disabled: record.id == 3),
                selections: [
                  AntTableRowSelectionItem(text: '全选', onSelect: (keys) {}),
                  AntTableRowSelectionItem(text: '清空', onSelect: (_) {}),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.w),

          // ---------------- 树形数据 ----------------
          _Section(
            title: '树形数据（childrenOf 展开 + 与行选择联动）',
            theme: theme,
            child: AntTable<_Person>(
              columns: _sizeColumns(),
              dataSource: _treeData(),
              rowKey: (record) => record.id,
              childrenOf: (record) => record.children,
              defaultExpandAllRows: false,
              rowSelection: const AntTableRowSelection<_Person>(),
            ),
          ),
          SizedBox(height: 16.w),

          // ---------------- 合并单元格 ----------------
          _Section(
            title: '合并单元格（onCell rowSpan / colSpan）',
            theme: theme,
            child: AntTable<_Person>(
              bordered: true,
              columns: [
                AntTableColumn(
                  title: '城市',
                  cell: _cityCell,
                  onCell: (record, _) => record.id == 1
                      ? const AntTableCellSpan(rowSpan: 3)
                      : const AntTableCellSpan(rowSpan: 0),
                ),
                const AntTableColumn(title: '姓名', cell: _nameCell),
                const AntTableColumn(title: '年龄', cell: _ageCell),
              ],
              dataSource: _mockData(3),
            ),
          ),
          SizedBox(height: 16.w),

          // ---------------- 展开行 ----------------
          _Section(
            title: '展开行（expandedRowRender，点击行展开）',
            theme: theme,
            child: AntTable<_Person>(
              columns: _sizeColumns(),
              dataSource: _mockData(4),
              rowKey: (record) => record.id,
              expandRowByClick: true,
              expandedRowRender: (_, record, _) => Text(
                '详情：${record.name}，城市 ${record.city}，状态 ${record.status}',
              ),
            ),
          ),
          SizedBox(height: 16.w),

          // ---------------- 汇总行 ----------------
          _Section(
            title: '汇总行（summary：人数合计 + 年龄均值）',
            theme: theme,
            child: AntTable<_Person>(
              columns: _sizeColumns(),
              dataSource: _mockData(5),
              summary: (data) => [
                AntTableSummaryCell(
                  columnIndex: 0,
                  child: Text('总计 ${data.length} 人'),
                ),
                AntTableSummaryCell(
                  columnIndex: 1,
                  child: Text(
                    '平均 ${data.isEmpty ? 0 : data.fold<int>(0, (s, r) => s + r.age) ~/ data.length} 岁',
                  ),
                ),
                const AntTableSummaryCell(columnIndex: 2, child: Text('—')),
              ],
            ),
          ),
          SizedBox(height: 16.w),

          // ---------------- 表头分组 ----------------
          _Section(
            title: '表头分组（多级表头，分组内叶子列支持排序）',
            theme: theme,
            child: AntTable<_Person>(
              columns: [
                const AntTableColumn(title: '姓名', cell: _nameCell),
                AntTableColumn(
                  title: '基本信息',
                  children: [
                    AntTableColumn(
                      title: '年龄',
                      cell: _ageCell,
                      sorter: (a, b) => a.age.compareTo(b.age),
                    ),
                    const AntTableColumn(title: '城市', cell: _cityCell),
                  ],
                ),
                AntTableColumn(
                  title: '其他',
                  children: [
                    const AntTableColumn(title: '状态', cell: _statusCell),
                    const AntTableColumn(
                      title: 'ID',
                      cell: _idCell,
                      fixed: AntTableFixed.right,
                    ),
                  ],
                ),
              ],
              dataSource: _mockData(4),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _nameCell(BuildContext context, _Person record, int index) =>
      Text(record.name);

  static Widget _ageCell(BuildContext context, _Person record, int index) =>
      Text('${record.age}');

  static Widget _cityCell(BuildContext context, _Person record, int index) =>
      Text(record.city);

  static Widget _statusCell(BuildContext context, _Person record, int index) =>
      Text(record.status);

  static Widget _idCell(BuildContext context, _Person record, int index) =>
      Text('${record.id}');

  static List<AntTableColumn<_Person>> _sizeColumns() => const [
    AntTableColumn(title: '姓名', cell: _nameCell),
    AntTableColumn(title: '年龄', cell: _ageCell),
    AntTableColumn(title: '城市', cell: _cityCell),
  ];

  static List<_Person> _treeData() => const [
    _Person(
      id: 1,
      name: '华东区',
      age: 40,
      city: '上海',
      status: '已启用',
      children: [
        _Person(id: 11, name: '用户 11', age: 21, city: '上海', status: '已启用'),
        _Person(id: 12, name: '用户 12', age: 22, city: '杭州', status: '待审核'),
      ],
    ),
    _Person(id: 2, name: '华北区', age: 35, city: '北京', status: '停用'),
  ];
}

/// 业务模型示例：组件不要求用户转 Map，列直接读取模型字段。
class _Person {
  const _Person({
    required this.id,
    required this.name,
    required this.age,
    required this.city,
    required this.status,
    this.children = const [],
  });

  final int id;
  final String name;
  final int age;
  final String city;
  final String status;
  final List<_Person> children;
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.theme,
    required this.child,
  });

  final String title;
  final AntThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: theme.colorSplit),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          SizedBox(height: 12.w),
          child,
        ],
      ),
    );
  }
}
