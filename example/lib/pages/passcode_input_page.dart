import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class PasscodeInputPage extends StatelessWidget {
  const PasscodeInputPage({super.key});

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
            child: AntPasscodeInput(
              onFill: (v) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('输入完成: $v')));
              },
            ),
          ),
          SizedBox(height: theme.s(12)),
          _Section(title: '明文展示', child: AntPasscodeInput(plain: true)),
          SizedBox(height: theme.s(12)),
          _Section(title: '格子分离', child: AntPasscodeInput(separated: true)),
          SizedBox(height: theme.s(12)),
          _Section(
            title: '4 位验证码',
            child: AntPasscodeInput(
              length: 4,
              plain: true,
              onFill: (v) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('验证码: $v')));
              },
            ),
          ),
          SizedBox(height: theme.s(12)),
          _Section(
            title: '错误状态',
            child: AntPasscodeInput(
              error: true,
              defaultValue: '123',
              plain: true,
            ),
          ),
          SizedBox(height: theme.s(12)),
          _Section(title: '自动聚焦', child: AntPasscodeInput(autofocus: true)),
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
  String _value = '12';

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntPasscodeInput(
          value: _value,
          plain: true,
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
