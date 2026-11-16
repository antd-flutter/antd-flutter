import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

const _seasons = <AntPickerColumnItem>[
  AntPickerColumnItem(label: '春', value: 'spring'),
  AntPickerColumnItem(label: '夏', value: 'summer'),
  AntPickerColumnItem(label: '秋', value: 'autumn'),
  AntPickerColumnItem(label: '冬', value: 'winter'),
];

const _weekdays = <AntPickerColumnItem>[
  AntPickerColumnItem(label: '周一', value: 'mon'),
  AntPickerColumnItem(label: '周二', value: 'tue'),
  AntPickerColumnItem(label: '周三', value: 'wed'),
  AntPickerColumnItem(label: '周四', value: 'thu'),
  AntPickerColumnItem(label: '周五', value: 'fri'),
];

const _times = <AntPickerColumnItem>[
  AntPickerColumnItem(label: '上午', value: 'am'),
  AntPickerColumnItem(label: '下午', value: 'pm'),
  AntPickerColumnItem(label: '晚上', value: 'night'),
];

class PickerPage extends StatelessWidget {
  const PickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            child: AntPicker(
              columns: const [_seasons],
              onConfirm: (vals) => debugPrint('onConfirm: $vals'),
              onCancel: () => debugPrint('onCancel'),
              child: _trigger(t, '选择季节', '春'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '带标题',
            child: AntPicker(
              columns: const [_seasons],
              title: '请选择季节',
              onConfirm: (vals) => debugPrint('onConfirm: $vals'),
              child: _trigger(t, '选择季节', null),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '多列选择',
            child: AntPicker(
              columns: const [_weekdays, _times],
              title: '选择时间',
              onConfirm: (vals) => debugPrint('onConfirm: $vals'),
              child: _trigger(t, '选择日期时段', null),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '自定义按钮文本',
            child: AntPicker(
              columns: const [_seasons],
              confirmText: 'OK',
              cancelText: 'Close',
              onConfirm: (vals) => debugPrint('onConfirm: $vals'),
              child: _trigger(t, '选择季节', null),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '默认值',
            child: AntPicker(
              columns: const [_seasons],
              defaultValue: const ['autumn'],
              onConfirm: (vals) => debugPrint('onConfirm: $vals'),
              child: _trigger(t, '选择季节', '秋'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '受控模式',
            child: const _ControlledPicker(),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '内嵌选择器（AntPickerView）',
            child: AntPickerView(
              columns: const [_seasons],
              onChange: (vals) => debugPrint('onChange: $vals'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '内嵌多列选择器',
            child: AntPickerView(
              columns: const [_weekdays, _times],
              onChange: (vals) => debugPrint('onChange: $vals'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _trigger(AntThemeData t, String label, String? value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: t.colorFillSecondary,
        borderRadius: BorderRadius.circular(t.borderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: t.colorText),
          ),
          if (value != null)
            Text(
              value,
              style: TextStyle(fontSize: 14.sp, color: t.colorPrimary),
            )
          else
            Icon(Icons.keyboard_arrow_right, size: 18.sp, color: t.colorTextTertiary),
        ],
      ),
    );
  }
}

class _ControlledPicker extends StatefulWidget {
  const _ControlledPicker();

  @override
  State<_ControlledPicker> createState() => _ControlledPickerState();
}

class _ControlledPickerState extends State<_ControlledPicker> {
  List<AntPickerValue> _value = ['spring'];

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final label = _seasons
        .where((s) => s.value == _value.first)
        .map((s) => s.label)
        .followedBy([''])
        .first;
    return AntPicker(
      columns: const [_seasons],
      value: _value,
      onConfirm: (vals) => setState(() => _value = vals),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: t.colorFillSecondary,
          borderRadius: BorderRadius.circular(t.borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '当前选择',
              style: TextStyle(fontSize: 14.sp, color: t.colorText),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 14.sp, color: t.colorPrimary),
            ),
          ],
        ),
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