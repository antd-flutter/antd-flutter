import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class SelectorPage extends StatelessWidget {
  const SelectorPage({super.key});

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            child: AntSelector<String>(
              options: const [
                AntSelectorOption(value: 'a', label: Text('苹果')),
                AntSelectorOption(value: 'b', label: Text('香蕉')),
                AntSelectorOption(value: 'c', label: Text('橙子')),
              ],
              onChange: (v) => _showSnackbar(context, '选中: $v'),
            ),
          ),
          SizedBox(height: 12.h),
          _Section(
            title: '多选',
            child: AntSelector<String>(
              multiple: true,
              defaultValue: ['b'],
              options: const [
                AntSelectorOption(value: 'a', label: Text('足球')),
                AntSelectorOption(value: 'b', label: Text('篮球')),
                AntSelectorOption(value: 'c', label: Text('游泳')),
                AntSelectorOption(value: 'd', label: Text('跑步')),
              ],
              onChange: (v) => _showSnackbar(context, '选中: $v'),
            ),
          ),
          SizedBox(height: 12.h),
          _Section(
            title: '带描述',
            child: AntSelector<String>(
              options: const [
                AntSelectorOption(
                  value: 'a',
                  label: Text('上午场'),
                  description: Text('09:00 - 12:00'),
                ),
                AntSelectorOption(
                  value: 'b',
                  label: Text('下午场'),
                  description: Text('14:00 - 17:00'),
                ),
                AntSelectorOption(
                  value: 'c',
                  label: Text('晚间场'),
                  description: Text('19:00 - 22:00'),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          _Section(
            title: '两列布局',
            child: AntSelector<String>(
              columns: 2,
              options: const [
                AntSelectorOption(value: 'a', label: Text('选项一')),
                AntSelectorOption(value: 'b', label: Text('选项二')),
                AntSelectorOption(value: 'c', label: Text('选项三')),
              ],
              onChange: (v) => _showSnackbar(context, '选中: $v'),
            ),
          ),
          SizedBox(height: 12.h),
          _Section(
            title: '三列布局',
            child: AntSelector<String>(
              columns: 3,
              defaultValue: ['b'],
              options: const [
                AntSelectorOption(value: 'a', label: Text('小')),
                AntSelectorOption(value: 'b', label: Text('中')),
                AntSelectorOption(value: 'c', label: Text('大')),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          _Section(
            title: '禁用',
            child: AntSelector<String>(
              options: const [
                AntSelectorOption(value: 'a', label: Text('可用')),
                AntSelectorOption(value: 'b', label: Text('禁用'), disabled: true),
                AntSelectorOption(value: 'c', label: Text('可用')),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          const _ControlledDemo(),
        ],
      ),
    );
  }
}

class _ControlledDemo extends StatefulWidget {
  const _ControlledDemo();

  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  List<String> _value = ['a'];

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return _Section(
      title: '受控模式',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              '当前值: $_value',
              style: TextStyle(
                fontSize: t.fontSizeSM,
                color: t.colorTextSecondary,
              ),
            ),
          ),
          AntSelector<String>(
            value: _value,
            multiple: true,
            options: const [
              AntSelectorOption(value: 'a', label: Text('选项一')),
              AntSelectorOption(value: 'b', label: Text('选项二')),
              AntSelectorOption(value: 'c', label: Text('选项三')),
            ],
            onChange: (v) => setState(() => _value = v),
          ),
        ],
      ),
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
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: t.colorBgContainer,
        borderRadius: BorderRadius.circular(t.borderRadiusLG),
        border: Border.all(color: t.colorSplit, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
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