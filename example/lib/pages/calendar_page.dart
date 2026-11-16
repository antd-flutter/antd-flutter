import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// AntCalendar 组件演示页。
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '卡片模式（默认）',
            theme: theme,
            child: AntCalendar(
              defaultValue: DateTime.now(),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '全屏模式',
            theme: theme,
            child: AntCalendar(
              defaultValue: DateTime.now(),
              fullscreen: true,
            ),
          ),
          SizedBox(height: 16.w),
          const _ControlledSection(),
          SizedBox(height: 16.w),
          _Section(
            title: '周起始日',
            theme: theme,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AntCalendar(
                    defaultValue: DateTime.now(),
                    weekStartsOn: AntCalendarWeekStartsOn.monday,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AntCalendar(
                    defaultValue: DateTime.now(),
                    weekStartsOn: AntCalendarWeekStartsOn.sunday,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '禁用周末',
            theme: theme,
            child: AntCalendar(
              defaultValue: DateTime.now(),
              disabledDate: (date) =>
                  date.weekday == DateTime.saturday ||
                  date.weekday == DateTime.sunday,
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '禁用过去的日期',
            theme: theme,
            child: AntCalendar(
              defaultValue: DateTime.now(),
              disabledDate: (date) =>
                  date.isBefore(DateTime.now().subtract(const Duration(days: 1))),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义单元格',
            theme: theme,
            child: AntCalendar(
              defaultValue: DateTime.now(),
              dateCell: (date,
                  {required isCurrentMonth,
                  required isToday,
                  required isSelected}) {
                if (!isCurrentMonth) return null;
                // 每月 15 日展示自定义徽标内容。
                if (date.day == 15) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${date.day}'),
                      Container(
                        width: 6.r,
                        height: 6.r,
                        decoration: BoxDecoration(
                          color: theme.colorSuccess,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  );
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 受控选中演示。
class _ControlledSection extends StatefulWidget {
  const _ControlledSection();

  @override
  State<_ControlledSection> createState() => _ControlledSectionState();
}

class _ControlledSectionState extends State<_ControlledSection> {
  DateTime _value = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: theme.colorSplit),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '受控选择',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          SizedBox(height: 8.w),
          Text(
            '当前选中：${_value.year}-${_value.month.toString().padLeft(2, '0')}-${_value.day.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 14.sp,
              color: theme.colorPrimary,
            ),
          ),
          SizedBox(height: 12.w),
          AntCalendar(
            value: _value,
            onSelect: (date) => setState(() => _value = date),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.theme, required this.child});

  final String title;
  final AntThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
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
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          SizedBox(height: 12.w),
          child,
        ],
      ),
    );
  }
}
