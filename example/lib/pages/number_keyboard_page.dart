import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class NumberKeyboardPage extends StatelessWidget {
  const NumberKeyboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.s(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Section(title: '基础用法', child: _BasicDemo()),
          SizedBox(height: theme.s(12)),
          const _Section(title: '带确认键', child: _ConfirmDemo()),
          SizedBox(height: theme.s(12)),
          const _Section(title: '带自定义键', child: _CustomKeyDemo()),
          SizedBox(height: theme.s(12)),
          const _Section(title: '乱序键盘', child: _RandomDemo()),
          SizedBox(height: theme.s(12)),
          const _Section(title: '限制长度', child: _MaxLengthDemo()),
          SizedBox(height: theme.s(12)),
          const _Section(title: '带标题', child: _TitleDemo()),
          SizedBox(height: theme.s(12)),
          const _Section(title: '受控模式', child: _ControlledDemo()),
        ],
      ),
    );
  }
}

class _BasicDemo extends StatefulWidget {
  const _BasicDemo();

  @override
  State<_BasicDemo> createState() => _BasicDemoState();
}

class _BasicDemoState extends State<_BasicDemo> {
  String _value = '';

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: t.s(8)),
          child: Text(
            '当前值: ${_value.isEmpty ? '无' : _value}',
            style: TextStyle(
              fontSize: t.fontSizeSM,
              color: t.colorTextSecondary,
            ),
          ),
        ),
        AntNumberKeyboard(onChange: (v) => setState(() => _value = v)),
      ],
    );
  }
}

class _ConfirmDemo extends StatefulWidget {
  const _ConfirmDemo();

  @override
  State<_ConfirmDemo> createState() => _ConfirmDemoState();
}

class _ConfirmDemoState extends State<_ConfirmDemo> {
  String _value = '';
  String _confirmed = '';

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: t.s(8)),
          child: Text(
            '当前值: ${_value.isEmpty ? '无' : _value} / 已确认: ${_confirmed.isEmpty ? '无' : _confirmed}',
            style: TextStyle(
              fontSize: t.fontSizeSM,
              color: t.colorTextSecondary,
            ),
          ),
        ),
        AntNumberKeyboard(
          confirmText: '确定',
          onChange: (v) => setState(() => _value = v),
          onConfirm: () {
            setState(() => _confirmed = _value);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('确认: $_value'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CustomKeyDemo extends StatefulWidget {
  const _CustomKeyDemo();

  @override
  State<_CustomKeyDemo> createState() => _CustomKeyDemoState();
}

class _CustomKeyDemoState extends State<_CustomKeyDemo> {
  String _value = '';

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: t.s(8)),
          child: Text(
            '当前值: ${_value.isEmpty ? '无' : _value}',
            style: TextStyle(
              fontSize: t.fontSizeSM,
              color: t.colorTextSecondary,
            ),
          ),
        ),
        AntNumberKeyboard(
          customKey: '.',
          onChange: (v) => setState(() => _value = v),
        ),
      ],
    );
  }
}

class _RandomDemo extends StatelessWidget {
  const _RandomDemo();

  @override
  Widget build(BuildContext context) {
    return const AntNumberKeyboard(randomOrder: true);
  }
}

class _MaxLengthDemo extends StatefulWidget {
  const _MaxLengthDemo();

  @override
  State<_MaxLengthDemo> createState() => _MaxLengthDemoState();
}

class _MaxLengthDemoState extends State<_MaxLengthDemo> {
  String _value = '';

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: t.s(8)),
          child: Text(
            '当前值: ${_value.isEmpty ? '无' : _value}（最多4位）',
            style: TextStyle(
              fontSize: t.fontSizeSM,
              color: t.colorTextSecondary,
            ),
          ),
        ),
        AntNumberKeyboard(
          maxLength: 4,
          onChange: (v) => setState(() => _value = v),
        ),
      ],
    );
  }
}

class _TitleDemo extends StatelessWidget {
  const _TitleDemo();

  @override
  Widget build(BuildContext context) {
    return const AntNumberKeyboard(title: '安全键盘');
  }
}

class _ControlledDemo extends StatefulWidget {
  const _ControlledDemo();

  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  String _value = '123';

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: t.s(8)),
          child: Row(
            children: [
              Text(
                '当前值: $_value',
                style: TextStyle(
                  fontSize: t.fontSizeSM,
                  color: t.colorTextSecondary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _value = ''),
                child: Text(
                  '清空',
                  style: TextStyle(
                    fontSize: t.fontSizeSM,
                    color: t.colorPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        AntNumberKeyboard(
          value: _value,
          onChange: (v) => setState(() => _value = v),
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
    final t = AntTheme.of(context);
    return Container(
      padding: EdgeInsets.all(t.s(12)),
      decoration: BoxDecoration(
        color: t.colorBgContainer,
        borderRadius: BorderRadius.circular(t.borderRadiusLG),
        border: Border.all(color: t.colorSplit, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: t.s(8)),
            child: Text(
              title,
              style: TextStyle(
                fontSize: t.fontSizeSM,
                fontWeight: FontWeight.w500,
                color: t.colorTextSecondary,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
