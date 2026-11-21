import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class _PanelData {
  const _PanelData({
    required this.label,
    this.child,
    this.extra,
    this.disabled = false,
  });

  final String label;
  final Widget? child;
  final Widget? extra;
  final bool disabled;
}

Widget _collapse({
  Key? key,
  List<_PanelData> items = const [],
  bool accordion = false,
  List<Object>? activeKey,
  List<Object>? defaultActiveKey,
  ValueChanged<List<Object>>? onChange,
  AntCollapseExpandIconPosition expandIconPosition =
      AntCollapseExpandIconPosition.left,
  Widget Function(BuildContext, bool)? expandIcon,
  bool bordered = true,
  AntCollapseSize size = AntCollapseSize.middle,
}) {
  return AntCollapse<_PanelData>(
    key: key,
    items: items,
    keyOf: (item) => 'panel_${items.indexOf(item)}',
    labelBuilder: (context, item, index) => Text(item.label),
    childBuilder: (context, item, index) => item.child,
    extraBuilder: (context, item, index) => item.extra,
    disabledOf: (item) => item.disabled,
    accordion: accordion,
    activeKey: activeKey,
    defaultActiveKey: defaultActiveKey,
    onChange: onChange,
    expandIconPosition: expandIconPosition,
    expandIcon: expandIcon,
    bordered: bordered,
    size: size,
  );
}

class CollapsePage extends StatelessWidget {
  const CollapsePage({super.key});

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
            child: _collapse(
              items: const [
                _PanelData(label: '面板一', child: Text('面板一的内容，点击标题展开或收起。')),
                _PanelData(label: '面板二', child: Text('面板二的内容，点击标题展开或收起。')),
                _PanelData(label: '面板三', child: Text('面板三的内容，点击标题展开或收起。')),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '手风琴',
            theme: theme,
            child: _collapse(
              accordion: true,
              items: const [
                _PanelData(label: '第一项', child: Text('同时只能展开一个面板。')),
                _PanelData(label: '第二项', child: Text('同时只能展开一个面板。')),
                _PanelData(label: '第三项', child: Text('同时只能展开一个面板。')),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(title: '受控展开', theme: theme, child: _ControlledCollapse()),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '禁用面板',
            theme: theme,
            child: _collapse(
              defaultActiveKey: const ['panel_0'],
              items: const [
                _PanelData(label: '可展开', child: Text('正常面板。')),
                _PanelData(
                  label: '禁用面板',
                  disabled: true,
                  child: Text('禁用面板的内容不可展开。'),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '无边框',
            theme: theme,
            child: _collapse(
              bordered: false,
              size: AntCollapseSize.small,
              items: const [
                _PanelData(label: '无边框一', child: Text('无边框变体。')),
                _PanelData(label: '无边框二', child: Text('无边框变体。')),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: 'extra 与自定义图标',
            theme: theme,
            child: _collapse(
              expandIconPosition: AntCollapseExpandIconPosition.right,
              items: [
                _PanelData(
                  label: '带附加内容',
                  extra: Text(
                    'OK',
                    style: TextStyle(
                      fontSize: theme.s(14),
                      color: theme.colorSuccess,
                    ),
                  ),
                  child: const Text('extra 展示在标题右侧。'),
                ),
                const _PanelData(label: '自定义图标', child: Text('自定义展开图标。')),
              ],
              expandIcon: (context, isExpanded) => Icon(
                isExpanded
                    ? AntIcons.minusCircleOutlined
                    : AntIcons.plusCircleOutlined,
                size: theme.s(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlledCollapse extends StatefulWidget {
  @override
  State<_ControlledCollapse> createState() => _ControlledCollapseState();
}

class _ControlledCollapseState extends State<_ControlledCollapse> {
  final List<String> _activeKey = const ['panel_0'];

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '当前展开：${_activeKey.isEmpty ? "无" : _activeKey.join(", ")}',
          style: TextStyle(fontSize: theme.s(13), color: theme.colorTextSecondary),
        ),
        SizedBox(height: theme.s(8)),
        _collapse(
          activeKey: _activeKey,
          onChange: (_) {},
          items: const [
            _PanelData(label: '受控面板一', child: Text('受控模式内容。')),
            _PanelData(label: '受控面板二', child: Text('受控模式内容。')),
          ],
        ),
      ],
    );
  }
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
