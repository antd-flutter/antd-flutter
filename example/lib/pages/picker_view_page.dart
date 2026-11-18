import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

const _fruits = <AntPickerColumnItem>[
  AntPickerColumnItem(label: '苹果', value: 'apple'),
  AntPickerColumnItem(label: '香蕉', value: 'banana'),
  AntPickerColumnItem(label: '橙子', value: 'orange'),
  AntPickerColumnItem(label: '葡萄', value: 'grape'),
];

const _drinks = <AntPickerColumnItem>[
  AntPickerColumnItem(label: '茶', value: 'tea'),
  AntPickerColumnItem(label: '咖啡', value: 'coffee'),
  AntPickerColumnItem(label: '果汁', value: 'juice'),
];

/// PickerViewPage — AntPickerView 内嵌滚轮选择器演示页。
class PickerViewPage extends StatefulWidget {
  const PickerViewPage({super.key});

  @override
  State<PickerViewPage> createState() => _PickerViewPageState();
}

class _PickerViewPageState extends State<PickerViewPage> {
  List<AntPickerValue> _value = const ['banana', 'tea'];

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础多列选择',
            child: AntPickerView(
              columns: const [_fruits, _drinks],
              onChange: (vals) => debugPrint('onChange: $vals'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '受控 value（onChange 同步外部状态）',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AntPickerView(
                  columns: const [_fruits, _drinks],
                  value: _value,
                  onChange: (vals) => setState(() => _value = vals),
                ),
                SizedBox(height: 8.h),
                Text(
                  '当前选择：${_value.join(' / ')}',
                  style: TextStyle(fontSize: 14.sp, color: t.colorPrimary),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '禁用交互（IgnorePointer 包裹）',
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.6,
                child: AntPickerView(
                  columns: const [_fruits],
                  defaultValue: const ['orange'],
                  onChange: (vals) => debugPrint('不应触发: $vals'),
                ),
              ),
            ),
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
        border: Border.all(color: t.colorSplit),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: t.colorText,
            ),
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}
