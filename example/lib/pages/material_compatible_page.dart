import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

/// Material 控件兼容演示页 —
/// 展示 AntTheme 包裹下，原生 Material 控件自动呈现 antd 风格（亮暗可切换）。
class MaterialCompatiblePage extends StatefulWidget {
  const MaterialCompatiblePage({super.key});

  @override
  State<MaterialCompatiblePage> createState() => _MaterialCompatiblePageState();
}

class _MaterialCompatiblePageState extends State<MaterialCompatiblePage> {
  bool _dark = false;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '亮暗切换',
            theme: theme,
            child: Row(
              children: [
                const Text('暗色模式'),
                AntSwitch(
                  checked: _dark,
                  onChange: (v) => setState(() => _dark = v),
                ),
                SizedBox(width: 12.w),
                Text('Theme.of 主色：'
                    '${Theme.of(context).colorScheme.primary}'),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          // AntTheme 包裹即覆盖：内部原生 Material 控件直接取到 antd 派生主题
          AntTheme(
            data: _dark ? AntThemeData.dark() : AntThemeData.light(),
            child: Builder(
              builder: (context) {
                final antTheme = AntTheme.of(context);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Section(
                      title: '按钮（原生 Material）',
                      theme: antTheme,
                      child: Wrap(
                        spacing: 8.w,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('主按钮'),
                          ),
                          OutlinedButton(
                            onPressed: () {},
                            child: const Text('次按钮'),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('链接按钮'),
                          ),
                          ElevatedButton(
                            onPressed: null,
                            child: const Text('禁用'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.w),
                    _Section(
                      title: '输入框（原生 Material）',
                      theme: antTheme,
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: '请输入内容',
                          labelText: 'Label',
                        ),
                      ),
                    ),
                    SizedBox(height: 16.w),
                    _Section(
                      title: '卡片与选择控件（原生 Material）',
                      theme: antTheme,
                      child: Column(
                        children: [
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(12.w),
                              child: ListTile(
                                title: const Text('antd 风格卡片'),
                                subtitle:
                                    const Text('原生 Card / ListTile 自动继承'),
                                trailing: Switch(
                                  value: _dark,
                                  onChanged: (v) =>
                                      setState(() => _dark = v),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.w),
                          Row(
                            children: [
                              Checkbox(value: true, onChanged: (_) {}),
                              const Text('Checkbox'),
                              SizedBox(width: 16.w),
                              Radio<bool>(
                                value: true,
                                groupValue: true,
                                onChanged: (_) {},
                              ),
                              const Text('Radio'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.w),
                    _Section(
                      title: '对话框（原生 Material）',
                      theme: antTheme,
                      child: OutlinedButton(
                        onPressed: () => _showDialog(context),
                        child: const Text('打开原生 Dialog'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('提示'),
        content: const Text('这是一个原生 AlertDialog，配色来自 antd 主题桥接。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('知道了'),
          ),
        ],
      ),
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
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: theme.colorBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: theme.fontSizeLG,
              fontWeight: FontWeight.w600,
              color: theme.colorTextHeading,
            ),
          ),
          SizedBox(height: 8.w),
          child,
        ],
      ),
    );
  }
}
