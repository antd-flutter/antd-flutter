import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class VirtualInputPage extends StatelessWidget {
  const VirtualInputPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.s(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Section(
            title: '基础用法',
            child: AntVirtualInput(
              placeholder: '请输入金额',
              onChange: (v) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('当前值: $v')));
              },
            ),
          ),
          SizedBox(height: theme.s(12)),
          _Section(
            title: '可清空',
            child: const AntVirtualInput(
              placeholder: '请输入',
              clearable: true,
              defaultValue: '100',
            ),
          ),
          SizedBox(height: theme.s(12)),
          _Section(
            title: '带确认键',
            child: AntVirtualInput(
              placeholder: '请输入密码',
              confirmText: '确定',
              onEnterPress: (v) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('确认: $v')));
              },
            ),
          ),
          SizedBox(height: theme.s(12)),
          _Section(
            title: '自定义按键',
            child: const AntVirtualInput(
              placeholder: '请输入金额（支持小数）',
              customKey: '.',
              confirmText: '确定',
            ),
          ),
          SizedBox(height: theme.s(12)),
          _Section(
            title: '禁用',
            child: const AntVirtualInput(
              placeholder: '禁用状态',
              disabled: true,
              defaultValue: '123',
            ),
          ),
          SizedBox(height: theme.s(12)),
          _Section(
            title: '自动聚焦',
            child: const AntVirtualInput(
              placeholder: '自动展开键盘',
              autoFocus: true,
            ),
          ),
          SizedBox(height: theme.s(12)),
          _Section(title: '受控模式', child: _ControlledDemo()),
        ],
      ),
    );
  }
}

class _ControlledDemo extends StatefulWidget {
  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  String _value = '88';

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntVirtualInput(
          value: _value,
          placeholder: '受控输入',
          clearable: true,
          onChange: (v) => setState(() => _value = v),
        ),
        SizedBox(height: theme.s(8)),
        Text(
          '当前值: $_value',
          style: TextStyle(
            fontSize: theme.s(14),
            color: AntTheme.of(context).colorTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Container(
      padding: EdgeInsets.all(theme.s(16)),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: theme.colorSplit, width: theme.s(1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: theme.s(15),
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
