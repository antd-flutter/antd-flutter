/// AntCalendar / AntCalendarPicker — Ant Design v6 日历组件族独立包
///
/// 从主包 antd_flutter_plus 拆分的独立组件包：
/// - [AntCalendar] — 月视图日历（双端形态自适应 + 格式切换/range/多选/事件点/年月跳转）
/// - [AntCalendarPicker] — 移动端日历选择器（内嵌视图 + 底部弹窗）
///
/// 日历网格引擎与通用滚轮视图（AntPickerView）沉淀于 antd_flutter_ui 基础库，
/// 经本 barrel 保持对外符号兼容（主包与既有用户代码 import 路径不变）。
///
/// 依赖方向约定：antd_calendar → antd_flutter_ui → antd_theme/tokens/color，
/// 独立包之间禁止互相依赖。主包 antd_flutter_plus 经 re-export 保持对外兼容。
library;

export 'package:antd_flutter_ui/src/display/picker_view/ant_picker_view.dart';
export 'src/calendar/ant_calendar.dart';
export 'src/calendar/ant_calendar_types.dart';
export 'src/calendar_picker/ant_calendar_picker.dart';
