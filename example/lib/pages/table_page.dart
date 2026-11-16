import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

// 注：待 lib/antd_flutter_plus.dart 追加 ant_table export 后，
// 可改回统一入口 import 'package:antd_flutter_plus/antd_flutter_plus.dart';

/// AntTable 演示页
class TablePage extends StatelessWidget {
  const TablePage({super.key});

  // ---------------- 模拟数据 ----------------

  static const _cities = ['北京', '上海', '深圳', '杭州'];

  static List<Map<String, dynamic>> _mockData(int count) {
    return List.generate(count, (i) {
      return <String, dynamic>{
        'id': i + 1,
        'name': '用户 ${i + 1}',
        'age': 18 + (i * 7) % 40,
        'city': _cities[i % _cities.length],
        'status': i % 3 == 0 ? '已启用' : (i % 3 == 1 ? '停用' : '待审核'),
      };
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
            title: '基础用法',
            theme: theme,
            child: AntTable(
              columns: const [
                AntTableColumn(title: '姓名', dataIndex: 'name'),
                AntTableColumn(title: '年龄', dataIndex: 'age'),
                AntTableColumn(title: '城市', dataIndex: 'city'),
              ],
              dataSource: _mockData(5),
            ),
          ),
          SizedBox(height: 16.w),

          // ---------------- 排序 ----------------
          _Section(
            title: '排序（点击表头：升序 → 降序 → 取消）',
            theme: theme,
            child: AntTable(
              columns: [
                const AntTableColumn(title: '姓名', dataIndex: 'name'),
                AntTableColumn(
                  title: '年龄',
                  dataIndex: 'age',
                  sorter: (a, b) =>
                      (a['age'] as int).compareTo(b['age'] as int),
                ),
                AntTableColumn(
                  title: '城市',
                  dataIndex: 'city',
                  sorter: (a, b) => (a['city'] as String)
                      .compareTo(b['city'] as String),
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
            child: AntTable(
              columns: [
                const AntTableColumn(title: '姓名', dataIndex: 'name'),
                AntTableColumn(
                  title: '城市',
                  dataIndex: 'city',
                  filters: const [
                    AntTableFilterItem(text: '北京', value: '北京'),
                    AntTableFilterItem(text: '上海', value: '上海'),
                    AntTableFilterItem(text: '深圳', value: '深圳'),
                    AntTableFilterItem(text: '杭州', value: '杭州'),
                  ],
                  onFilter: (value, record) => record['city'] == value,
                ),
                AntTableColumn(
                  title: '年龄',
                  dataIndex: 'age',
                  filters: const [
                    AntTableFilterItem(text: '青年(<30)', value: 24),
                    AntTableFilterItem(text: '中年(38)', value: 38),
                  ],
                  onFilter: (value, record) => record['age'] == value,
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
            child: AntTable(
              scrollX: 900,
              columns: [
                const AntTableColumn(
                  title: '姓名',
                  dataIndex: 'name',
                  width: 120,
                  fixed: AntTableFixed.left,
                ),
                const AntTableColumn(title: '年龄', dataIndex: 'age', width: 150),
                const AntTableColumn(title: '城市', dataIndex: 'city', width: 150),
                const AntTableColumn(title: '状态', dataIndex: 'status', width: 150),
                AntTableColumn(
                  title: '备注',
                  dataIndex: 'name',
                  width: 180,
                  render: (value, record, index) =>
                      Text('$value 的备注信息'),
                ),
                AntTableColumn(
                  title: '操作',
                  dataIndex: 'id',
                  width: 120,
                  fixed: AntTableFixed.right,
                  render: (value, record, index) =>
                      Text('编辑 #${record['id']}'),
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
            child: AntTable(
              scrollY: 320,
              columns: const [
                AntTableColumn(title: '姓名', dataIndex: 'name'),
                AntTableColumn(title: '年龄', dataIndex: 'age'),
                AntTableColumn(title: '城市', dataIndex: 'city'),
                AntTableColumn(title: '状态', dataIndex: 'status'),
              ],
              dataSource: _mockData(100),
            ),
          ),
          SizedBox(height: 16.w),

          // ---------------- 分页 ----------------
          _Section(
            title: '分页（pageSize = 5）',
            theme: theme,
            child: AntTable(
              pagination: true,
              pageSize: 5,
              columns: const [
                AntTableColumn(title: '姓名', dataIndex: 'name'),
                AntTableColumn(title: '年龄', dataIndex: 'age'),
                AntTableColumn(title: '城市', dataIndex: 'city'),
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
                AntTable(
                  size: AntTableSize.large,
                  columns: _sizeColumns(),
                  dataSource: _mockData(3),
                ),
                SizedBox(height: 12.w),
                AntTable(
                  size: AntTableSize.middle,
                  columns: _sizeColumns(),
                  dataSource: _mockData(3),
                ),
                SizedBox(height: 12.w),
                AntTable(
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
                AntTable(
                  loading: true,
                  columns: _sizeColumns(),
                  dataSource: _mockData(3),
                ),
                SizedBox(height: 12.w),
                AntTable(
                  columns: _sizeColumns(),
                  dataSource: const [],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static List<AntTableColumn> _sizeColumns() => const [
        AntTableColumn(title: '姓名', dataIndex: 'name'),
        AntTableColumn(title: '年龄', dataIndex: 'age'),
        AntTableColumn(title: '城市', dataIndex: 'city'),
      ];
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.theme, required this.child});

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
