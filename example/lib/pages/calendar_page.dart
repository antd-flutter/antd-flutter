import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// AntCalendar 组件演示页。
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.s(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '卡片模式（默认）',
            theme: theme,
            child: AntCalendar(defaultValue: DateTime.now()),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '全屏模式',
            theme: theme,
            child: AntCalendar(defaultValue: DateTime.now(), fullscreen: true),
          ),
          SizedBox(height: theme.s(16)),
          const _ControllerSection(),
          SizedBox(height: theme.s(16)),
          const _ControlledSection(),
          SizedBox(height: theme.s(16)),
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
                SizedBox(width: theme.s(12)),
                Expanded(
                  child: AntCalendar(
                    defaultValue: DateTime.now(),
                    weekStartsOn: AntCalendarWeekStartsOn.sunday,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
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
          SizedBox(height: theme.s(16)),
          _Section(
            title: '禁用过去的日期',
            theme: theme,
            child: AntCalendar(
              defaultValue: DateTime.now(),
              disabledDate: (date) => date.isBefore(
                DateTime.now().subtract(const Duration(days: 1)),
              ),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '自定义单元格',
            theme: theme,
            child: AntCalendar(
              defaultValue: DateTime.now(),
              dateCell:
                  (
                    date, {
                    required isCurrentMonth,
                    required isToday,
                    required isSelected,
                  }) {
                    if (!isCurrentMonth) return null;
                    // 每月 15 日展示自定义徽标内容。
                    if (date.day == 15) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${date.day}'),
                          Container(
                            width: theme.s(6),
                            height: theme.s(6),
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
/// 程序化月份导航演示：AntCalendarController（R35.2 Controller 优先）。
class _ControllerSection extends StatefulWidget {
  const _ControllerSection();

  @override
  State<_ControllerSection> createState() => _ControllerSectionState();
}

class _ControllerSectionState extends State<_ControllerSection> {
  final AntCalendarController _controller = AntCalendarController();

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return _Section(
      title: '程序化翻页（Controller）',
      theme: theme,
      child: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: _controller.previousMonth,
                child: const Text('上一月'),
              ),
              SizedBox(width: theme.s(12)),
              ElevatedButton(
                onPressed: _controller.nextMonth,
                child: const Text('下一月'),
              ),
              SizedBox(width: theme.s(12)),
              ElevatedButton(
                onPressed: () => _controller.goToYearMonth(2027, 1),
                child: const Text('跳转 2027-01'),
              ),
            ],
          ),
          SizedBox(height: theme.s(12)),
          AntCalendar(controller: _controller, defaultValue: DateTime.now()),
        ],
      ),
    );
  }
}

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
            '受控选择',
            style: TextStyle(
              fontSize: theme.s(16),
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          SizedBox(height: theme.s(8)),
          Text(
            '当前选中：${_value.year}-${_value.month.toString().padLeft(2, '0')}-${_value.day.toString().padLeft(2, '0')}',
            style: TextStyle(fontSize: theme.s(14), color: theme.colorPrimary),
          ),
          SizedBox(height: theme.s(12)),
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
