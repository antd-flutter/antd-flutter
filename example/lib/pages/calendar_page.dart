import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// AntCalendar 组件演示页。
///
/// 按平台分段：桌面（antd v6：fullscreen / card）与移动（antd-mobile v5：
/// 单选 / 范围 / 自定义格子）。顶部可切换 `platform` 观察分派结果。
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  AntCalendarPlatform _platform = AntCalendarPlatform.auto;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final resolved = _platform == AntCalendarPlatform.auto
        ? (AntPlatform.isMobile
            ? AntCalendarPlatform.mobile
            : AntCalendarPlatform.desktop)
        : _platform;
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.s(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '平台分派',
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    for (final option in AntCalendarPlatform.values)
                      Padding(
                        padding: EdgeInsets.only(right: theme.s(8)),
                        child: AntButton(
                          type: _platform == option
                              ? AntButtonType.primary
                              : AntButtonType.normal,
                          size: AntButtonSize.small,
                          onTap: () => setState(() => _platform = option),
                          child: Text(switch (option) {
                            AntCalendarPlatform.auto => 'auto',
                            AntCalendarPlatform.desktop => 'desktop',
                            AntCalendarPlatform.mobile => 'mobile',
                          }),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: theme.s(8)),
                Text(
                  '当前解析平台：${resolved == AntCalendarPlatform.desktop ? 'desktop（antd v6）' : 'mobile（antd-mobile v5）'}',
                  style: TextStyle(
                    fontSize: theme.s(13),
                    color: theme.colorTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (resolved == AntCalendarPlatform.desktop) ...[
            SizedBox(height: theme.s(16)),
            const _DesktopFullscreenSection(),
            SizedBox(height: theme.s(16)),
            const _DesktopCardSection(),
          ] else ...[
            SizedBox(height: theme.s(16)),
            const _MobileSingleSection(),
            SizedBox(height: theme.s(16)),
            const _MobileRangeSection(),
            SizedBox(height: theme.s(16)),
            const _MobileCustomCellSection(),
          ],
          SizedBox(height: theme.s(16)),
          const _ControllerSection(),
          SizedBox(height: theme.s(16)),
          const _ControlledSection(),
        ],
      ),
    );
  }
}

/// 桌面 · fullscreen 全屏面板（antd v6 默认形态）：周序号 + 选中来源。
class _DesktopFullscreenSection extends StatefulWidget {
  const _DesktopFullscreenSection();

  @override
  State<_DesktopFullscreenSection> createState() =>
      _DesktopFullscreenSectionState();
}

class _DesktopFullscreenSectionState extends State<_DesktopFullscreenSection> {
  String _lastSource = '未选择';

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return _Section(
      title: '桌面 · 全屏面板（showWeek + onSelectWithInfo）',
      theme: theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '最近一次选中来源：$_lastSource',
            style: TextStyle(fontSize: theme.s(13), color: theme.colorPrimary),
          ),
          SizedBox(height: theme.s(8)),
          AntCalendar(
            platform: AntCalendarPlatform.desktop,
            fullscreen: true,
            showWeek: true,
            defaultValue: DateTime.now(),
            onSelectWithInfo: (date, info) {
              setState(() => _lastSource = info.source.name);
            },
          ),
        ],
      ),
    );
  }
}

/// 桌面 · card 迷你面板（fullscreen: false）。
class _DesktopCardSection extends StatelessWidget {
  const _DesktopCardSection();

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return _Section(
      title: '桌面 · 卡片面板（fullscreen: false）',
      theme: theme,
      child: AntCalendar(
        platform: AntCalendarPlatform.desktop,
        fullscreen: false,
        defaultValue: DateTime.now(),
        onSelectWithInfo: (date, info) {},
      ),
    );
  }
}

/// 移动 · 单选：allowClear 默认 true，renderLabel 展示价格。
class _MobileSingleSection extends StatelessWidget {
  const _MobileSingleSection();

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return _Section(
      title: '移动 · 单选（allowClear + renderLabel）',
      theme: theme,
      child: AntCalendar(
        platform: AntCalendarPlatform.mobile,
        selectionMode: AntCalendarSelectionMode.single,
        defaultValue: DateTime.now(),
        renderLabel: (date) {
          if (date.day % 5 != 0) return null;
          return Text(
            '¥${date.day * 10}',
            style: TextStyle(fontSize: theme.s(10), color: theme.colorError),
          );
        },
      ),
    );
  }
}

/// 移动 · 范围选择（onRangeChange，两次点击）。
class _MobileRangeSection extends StatefulWidget {
  const _MobileRangeSection();

  @override
  State<_MobileRangeSection> createState() => _MobileRangeSectionState();
}

class _MobileRangeSectionState extends State<_MobileRangeSection> {
  List<DateTime>? _range;

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return _Section(
      title: '移动 · 范围选择（selectionMode: range）',
      theme: theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _range == null
                ? '未选择'
                : '${_fmt(_range!.first)} ~ ${_fmt(_range!.last)}',
            style: TextStyle(fontSize: theme.s(13), color: theme.colorPrimary),
          ),
          SizedBox(height: theme.s(8)),
          AntCalendar(
            platform: AntCalendarPlatform.mobile,
            selectionMode: AntCalendarSelectionMode.range,
            rangeValue: _range,
            defaultValue: DateTime.now(),
            onRangeChange: (value) => setState(() => _range = value),
          ),
        ],
      ),
    );
  }
}

/// 移动 · 自定义格子：renderDate + mobileCellRender 包裹。
class _MobileCustomCellSection extends StatelessWidget {
  const _MobileCustomCellSection();

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return _Section(
      title: '移动 · 自定义格子（renderDate + mobileCellRender）',
      theme: theme,
      child: AntCalendar(
        platform: AntCalendarPlatform.mobile,
        selectionMode: AntCalendarSelectionMode.single,
        defaultValue: DateTime.now(),
        renderDate: (date) {
          if (date.day == 15) {
            return Text(
              '15',
              style: TextStyle(
                fontSize: theme.s(19),
                color: theme.colorSuccess,
                fontWeight: FontWeight.w600,
              ),
            );
          }
          return null;
        },
        mobileCellRender: (oriNode, {required date}) {
          if (date.weekday == DateTime.monday) {
            return DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorSplit),
                borderRadius: BorderRadius.circular(theme.s(4)),
              ),
              child: oriNode,
            );
          }
          return oriNode;
        },
      ),
    );
  }
}

/// 程序化月份导航演示：AntCalendarController。
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
              AntButton(
                size: AntButtonSize.small,
                onTap: _controller.previousMonth,
                child: const Text('上一月'),
              ),
              SizedBox(width: theme.s(12)),
              AntButton(
                size: AntButtonSize.small,
                onTap: _controller.nextMonth,
                child: const Text('下一月'),
              ),
              SizedBox(width: theme.s(12)),
              AntButton(
                size: AntButtonSize.small,
                onTap: () => _controller.goToYearMonth(2027, 1),
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
    return _Section(
      title: '受控选择（onSelect）',
      theme: theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '当前选中：${_value.year}-${_value.month.toString().padLeft(2, '0')}-${_value.day.toString().padLeft(2, '0')}',
            style: TextStyle(fontSize: theme.s(13), color: theme.colorPrimary),
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
