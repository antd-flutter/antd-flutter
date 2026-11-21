import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// 自定义模型：导航视图（文本 / 图标 / 禁用均由模型自身描述）。
class _ViewMode {
  const _ViewMode(this.id, this.label, this.icon, {this.disabled = false});

  final String id;
  final String label;
  final IconData icon;
  final bool disabled;
}

const _viewModes = [
  _ViewMode('list', '列表', AntIcons.unorderedListOutlined),
  _ViewMode('map', '地图', AntIcons.globalOutlined),
  _ViewMode('setting', '设置', AntIcons.settingOutlined, disabled: true),
];

/// 自定义模型：列表密度。
enum _Density { compact, standard, loose }

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
      padding: EdgeInsets.all(theme.s(16)),
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
          SizedBox(height: theme.s(16)),
          _Section(
            title: '受控模式',
            theme: theme,
            child: AntSegmented(
              options: const ['周一', '周三', '周五'],
              value: _controlledValue,
              onChange: (v) => setState(() => _controlledValue = v),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: 'Block 占满整行',
            theme: theme,
            // block 模式随父容器宽度自适应，卡片不限宽以便演示窗口拉伸。
            fullWidth: true,
            child: AntSegmented(
              options: const ['列表', '看板', '日历'],
              block: true,
              onChange: (v) => _showMsg(context, '视图：$v'),
            ),
          ),
          SizedBox(height: theme.s(16)),
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
                SizedBox(height: theme.s(8)),
                AntSegmented(
                  options: const ['小', '中', '大'],
                  size: AntSegmentedSize.middle,
                  onChange: (v) => _showMsg(context, 'middle：$v'),
                ),
                SizedBox(height: theme.s(8)),
                AntSegmented(
                  options: const ['小', '中', '大'],
                  size: AntSegmentedSize.large,
                  onChange: (v) => _showMsg(context, 'large：$v'),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
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
                SizedBox(height: theme.s(8)),
                AntSegmented(
                  options: const ['可用', '禁用项'],
                  disabledOf: (v) => v == '禁用项',
                  onChange: (v) => _showMsg(context, '选中：$v'),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '带图标',
            theme: theme,
            child: AntSegmented<_ViewMode>(
              options: _viewModes,
              labelOf: (mode) => mode.label,
              iconBuilder: (context, mode) => AntdIcon(mode.icon),
              onChange: (mode) => _showMsg(context, '选中：${mode.label}'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '自定义 Item（icon-only / itemBuilder）',
            theme: theme,
            child: AntSegmented<_ViewMode>(
              options: _viewModes,
              // 空字符串 label → 只渲染图标
              labelOf: (mode) => '',
              iconBuilder: (context, mode) => AntdIcon(mode.icon),
              onChange: (mode) => _showMsg(context, '选中：${mode.id}'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '自定义模型',
            theme: theme,
            child: AntSegmented<_Density>(
              options: _Density.values,
              labelOf: (density) => switch (density) {
                _Density.compact => '紧凑',
                _Density.standard => '标准',
                _Density.loose => '宽松',
              },
              defaultValue: _Density.standard,
              onChange: (density) => _showMsg(context, '密度：${density.name}'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '垂直排列',
            theme: theme,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 默认 hug 内容宽度（自适应最宽项），不强制撑满父容器
                AntSegmented(
                  options: const ['列表', '看板', '日历'],
                  direction: AntSegmentedDirection.vertical,
                  onChange: (v) => _showMsg(context, '方向：$v'),
                ),
                SizedBox(width: theme.s(24)),
                // icon-only：无宽度约束，同样 hug 内容
                AntSegmented<_ViewMode>(
                  options: _viewModes.take(2).toList(),
                  labelOf: (mode) => '',
                  iconBuilder: (context, mode) => AntdIcon(mode.icon),
                  direction: AntSegmentedDirection.vertical,
                  onChange: (mode) => _showMsg(context, 'icon-only：${mode.id}'),
                ),
                SizedBox(width: theme.s(24)),
                // 外部 SizedBox 可自行设置宽度（有界约束生效，不足处省略号）
                SizedBox(
                  width: theme.s(160),
                  child: AntSegmented(
                    options: const ['日', '周', '月', '年'],
                    direction: AntSegmentedDirection.vertical,
                    block: true,
                    onChange: (v) => _showMsg(context, 'block：$v'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
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
                      _demoShape = v == '胶囊'
                          ? AntSegmentedShape.round
                          : AntSegmentedShape.rounded;
                    });
                    _showMsg(context, '形状：$v');
                  },
                ),
                SizedBox(height: theme.s(8)),
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.theme,
    required this.child,
    this.fullWidth = false,
  });

  final String title;
  final AntThemeData theme;
  final Widget child;

  /// 是否不限宽（block 等自适应组件的演示需要跟随窗口宽度伸缩）。
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // 桌面宽窗口下限宽卡片，避免 demo 区块被拉得过宽影响观感；
      // fullWidth 的卡片不限宽，保证 block 组件宽度自适应可验证。
      constraints: fullWidth ? null : BoxConstraints(maxWidth: theme.s(560)),
      padding: EdgeInsets.all(theme.s(16)),
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
              fontSize: theme.s(16),
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          SizedBox(height: theme.s(12)),
          child,
        ],
      ),
    );
  }
}
