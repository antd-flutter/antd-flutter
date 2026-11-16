import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class SegmentedPage extends StatefulWidget {
  const SegmentedPage({super.key});

  @override
  State<SegmentedPage> createState() => _SegmentedPageState();
}

class _SegmentedPageState extends State<SegmentedPage> {
  String _controlledValue = '周';
  AntSegmentedShape _demoShape = AntSegmentedShape.rounded;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            theme: theme,
            child: AntSegmented(
              options: const ['日', '周', '月', '年'],
              onChange: (v) => _showMsg(context, '选中：$v'),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '受控模式',
            theme: theme,
            child: AntSegmented(
              options: const ['周一', '周三', '周五'],
              value: _controlledValue,
              onChange: (v) => setState(() => _controlledValue = v),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: 'Block 占满整行',
            theme: theme,
            child: AntSegmented(
              options: const ['列表', '看板', '日历'],
              block: true,
              onChange: (v) => _showMsg(context, '视图：$v'),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '三种大小',
            theme: theme,
            child: Column(
              children: [
                AntSegmented(
                  options: const ['小', '中', '大'],
                  size: AntSegmentedSize.small,
                  onChange: (v) => _showMsg(context, 'small：$v'),
                ),
                SizedBox(height: 8.w),
                AntSegmented(
                  options: const ['小', '中', '大'],
                  size: AntSegmentedSize.middle,
                  onChange: (v) => _showMsg(context, 'middle：$v'),
                ),
                SizedBox(height: 8.w),
                AntSegmented(
                  options: const ['小', '中', '大'],
                  size: AntSegmentedSize.large,
                  onChange: (v) => _showMsg(context, 'large：$v'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '禁用',
            theme: theme,
            child: Column(
              children: [
                const AntSegmented(
                  options: ['开启', '关闭'],
                  disabled: true,
                  defaultValue: '开启',
                ),
                SizedBox(height: 8.w),
                AntSegmented(
                  options: const [
                    AntSegmentedItem(label: '可用'),
                    AntSegmentedItem(label: '禁用项', disabled: true),
                  ],
                  onChange: (v) => _showMsg(context, '选中：$v'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '带图标',
            theme: theme,
            child: AntSegmented(
              options: const [
                AntSegmentedItem(label: '列表', icon: Icon(Icons.list)),
                AntSegmentedItem(label: '地图', icon: Icon(Icons.map)),
                AntSegmentedItem(label: '设置', icon: Icon(Icons.settings)),
              ],
              onChange: (v) => _showMsg(context, '选中：$v'),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义 Item（icon-only / 混合）',
            theme: theme,
            child: AntSegmented(
              options: [
                const AntSegmentedItem(value: 'list', icon: Icon(Icons.list)),
                const AntSegmentedItem(value: 'grid', icon: Icon(Icons.grid_view)),
                '文字项',
              ],
              onChange: (v) => _showMsg(context, '选中：$v'),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '胶囊形状',
            theme: theme,
            child: Column(
              children: [
                AntSegmented(
                  options: const ['圆角', '胶囊'],
                  shape: _demoShape,
                  onChange: (v) {
                    setState(() {
                      _demoShape =
                          v == '胶囊' ? AntSegmentedShape.round : AntSegmentedShape.rounded;
                    });
                    _showMsg(context, '形状：$v');
                  },
                ),
                SizedBox(height: 8.w),
                AntSegmented(
                  options: const ['Kilometer', 'Monthly', 'Yearly'],
                  block: true,
                  shape: _demoShape,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMsg(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
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
