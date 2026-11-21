import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class CalendarPickerPage extends StatelessWidget {
  const CalendarPickerPage({super.key});

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

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
            child: AntCalendarPickerView(
              defaultValue: [DateTime(2024, 6, 15)],
              onChange: (dates) {
                if (dates.isNotEmpty) {
                  _showSnackbar(
                    context,
                    '选中: ${dates.first.year}-${dates.first.month}-${dates.first.day}',
                  );
                }
              },
            ),
          ),
          SizedBox(height: theme.s(12)),
          _Section(
            title: '范围选择',
            child: AntCalendarPickerView(
              selectionMode: AntCalendarSelectionMode.range,
              onChange: (dates) {
                if (dates.length == 2) {
                  _showSnackbar(
                    context,
                    '范围: ${dates.first.month}/${dates.first.day} - ${dates.last.month}/${dates.last.day}',
                  );
                }
              },
            ),
          ),
          SizedBox(height: theme.s(12)),
          _Section(
            title: '周一起始',
            child: AntCalendarPickerView(
              weekStartsOn: AntCalendarWeekStartsOn.monday,
              defaultValue: [DateTime(2024, 6, 15)],
            ),
          ),
          SizedBox(height: theme.s(12)),
          _Section(
            title: '限定范围',
            child: AntCalendarPickerView(
              min: DateTime(2024, 6, 10),
              max: DateTime(2024, 6, 25),
            ),
          ),
          SizedBox(height: theme.s(12)),
          _Section(
            title: '禁用清除',
            child: AntCalendarPickerView(
              defaultValue: [DateTime(2024, 6, 15)],
              allowClear: false,
            ),
          ),
          SizedBox(height: theme.s(12)),
          const _PopupDemo(),
          SizedBox(height: theme.s(12)),
          const _RangePopupDemo(),
          SizedBox(height: theme.s(12)),
          const _ControlledDemo(),
        ],
      ),
    );
  }
}

class _PopupDemo extends StatefulWidget {
  const _PopupDemo();

  @override
  State<_PopupDemo> createState() => _PopupDemoState();
}

class _PopupDemoState extends State<_PopupDemo> {
  String _selected = '未选择';

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return _Section(
      title: '弹窗选择',
      child: AntCalendarPicker(
        title: '选择日期',
        min: DateTime(2024, 1, 1),
        max: DateTime(2024, 12, 31),
        onConfirm: (dates) {
          setState(() {
            if (dates.isNotEmpty) {
              _selected =
                  '${dates.first.year}-${dates.first.month}-${dates.first.day}';
            } else {
              _selected = '未选择';
            }
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: t.s(12), vertical: t.s(8)),
          decoration: BoxDecoration(
            border: Border.all(color: t.colorBorder),
            borderRadius: BorderRadius.circular(t.borderRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                AntIcons.calendarOutlined,
                size: t.s(16),
                color: t.colorTextSecondary,
              ),
              SizedBox(width: t.s(8)),
              Text(
                _selected,
                style: TextStyle(fontSize: t.fontSize, color: t.colorText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RangePopupDemo extends StatefulWidget {
  const _RangePopupDemo();

  @override
  State<_RangePopupDemo> createState() => _RangePopupDemoState();
}

class _RangePopupDemoState extends State<_RangePopupDemo> {
  String _selected = '未选择';

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return _Section(
      title: '弹窗范围选择',
      child: AntCalendarPicker(
        title: '选择范围',
        selectionMode: AntCalendarSelectionMode.range,
        min: DateTime(2024, 1, 1),
        max: DateTime(2024, 12, 31),
        onConfirm: (dates) {
          setState(() {
            if (dates.length == 2) {
              _selected =
                  '${dates.first.month}/${dates.first.day} - ${dates.last.month}/${dates.last.day}';
            } else {
              _selected = '未选择';
            }
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: t.s(12), vertical: t.s(8)),
          decoration: BoxDecoration(
            border: Border.all(color: t.colorBorder),
            borderRadius: BorderRadius.circular(t.borderRadius),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                AntIcons.calendarOutlined,
                size: t.s(16),
                color: t.colorTextSecondary,
              ),
              SizedBox(width: t.s(8)),
              Text(
                _selected,
                style: TextStyle(fontSize: t.fontSize, color: t.colorText),
              ),
            ],
          ),
        ),
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
  List<DateTime> _value = [DateTime(2024, 6, 15)];

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return _Section(
      title: '受控模式',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: t.s(8)),
            child: Text(
              _value.isNotEmpty
                  ? '当前值: ${_value.first.year}-${_value.first.month}-${_value.first.day}'
                  : '当前值: 无',
              style: TextStyle(
                fontSize: t.fontSizeSM,
                color: t.colorTextSecondary,
              ),
            ),
          ),
          AntCalendarPickerView(
            value: _value,
            onChange: (dates) {
              setState(() {
                _value = dates;
              });
            },
          ),
          SizedBox(height: t.s(8)),
          AntButton(
            size: AntButtonSize.small,
            onTap: () {
              setState(() {
                _value = [];
              });
            },
            child: const Text('清除选择'),
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
