/// AntCalendarController — AntCalendar 的程序化月份导航控制
/// （R35.2 Controller 优先）
///
/// 日历的「翻页/跳转」属于程序化触发动作语义（切换/跳转），按 R35
/// 暴露 Controller 类供外部调用，不依赖 GlobalKey 或外部 state 直改。
/// attach/detach 由组件内部在生命周期中调用（使用方无需手动调用）。
///
/// ```dart
/// final controller = AntCalendarController();
/// AntCalendar(controller: controller, ...);
/// controller.nextMonth();               // 下一月
/// controller.goToYearMonth(2026, 1);    // 跳转年月
/// ```
library;

/// 月份导航目标接口：由 AntCalendar 内部 State 实现，Controller 调用。
abstract class AntCalendarMonthNavigator {
  /// 按 delta 个月导航（负数向前）。
  void navigateMonths(int delta);

  /// 跳转到指定年月（month 取 1~12）。
  void navigateToYearMonth(int year, int month);

  /// 回到今天（antd-mobile jumpToToday 对齐）。
  void navigateToToday() {}
}

/// [AntCalendar] 的控制器：程序化翻页与年月跳转。
class AntCalendarController {
  AntCalendarMonthNavigator? _navigator;

  /// 是否已挂载到组件（组件 initState 时 attach，dispose 时 detach）。
  bool get isAttached => _navigator != null;

  /// 组件挂载时由内部调用（对应 ScrollPosition.attach 惯例）。
  void attach(AntCalendarMonthNavigator navigator) {
    _navigator = navigator;
  }

  /// 组件销毁/换绑时由内部调用。
  void detach(AntCalendarMonthNavigator navigator) {
    if (identical(_navigator, navigator)) _navigator = null;
  }

  AntCalendarMonthNavigator get _requireNavigator {
    final navigator = _navigator;
    if (navigator == null) {
      throw StateError(
        'AntCalendarController 未挂载到 AntCalendar（isAttached=false），'
        '请确认 controller 已传入 AntCalendar(controller: ...)。',
      );
    }
    return navigator;
  }

  /// 上一月。
  void previousMonth() => _requireNavigator.navigateMonths(-1);

  /// 下一月。
  void nextMonth() => _requireNavigator.navigateMonths(1);

  /// 跳转到指定年月（month 取 1~12；week/twoWeeks 格式下同样定位到该月）。
  void goToYearMonth(int year, int month) =>
      _requireNavigator.navigateToYearMonth(year, month);

  /// 回到今天（antd-mobile CalendarRef.jumpToToday 对齐）：
  /// 面板切回当前月并聚焦今天。
  void jumpToToday() => _requireNavigator.navigateToToday();
}
