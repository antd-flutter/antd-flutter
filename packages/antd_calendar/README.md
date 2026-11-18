# antd_calendar

Ant Design v6 日历组件族的 Flutter 实现 — 包含月视图日历（AntCalendar，双端形态自适应 + 格式切换/范围与多选/事件点标记/年月快速跳转）与移动端日历选择器（AntCalendarPicker），API 对齐 antd React Calendar 与 antd-mobile CalendarPicker。

> 当前为预览版本。

## 安装

```yaml
dependencies:
  antd_calendar: ^0.1.0-beta.1
```

## 组件

- **AntCalendar** — 月视图日历面板（桌面 fullscreen 大格子 / 移动 card 紧凑面板，经 AntResponsive 自适应，可手动指定）
- **AntCalendarPicker** — 移动端日历选择器（内嵌视图 AntCalendarPickerView + 底部弹窗，单选/范围选择）

> AntPickerView（通用滚轮选择视图）已沉淀于 [antd_flutter_ui](../antd_flutter_ui) 基础库，经本包 barrel 保持符号兼容。

## 用法

```dart
import 'package:antd_calendar/antd_calendar.dart';

// ── 基础月视图 ────────────────────────────────────────────
AntCalendar(
  defaultValue: DateTime(2024, 6, 1),
  onSelect: (date) => print(date),
);

// ── 桌面/移动双端形态（auto 经 AntResponsive 自适应） ───────
AntCalendar(layout: AntCalendarLayout.auto);     // desktop/web→fullscreen，phone→card
AntCalendar(layout: AntCalendarLayout.fullscreen); // 强制桌面形态（大格子 + dateCell 插槽）
AntCalendar(layout: AntCalendarLayout.card);       // 强制移动形态（滑动手势翻月）

// ── 格式切换（月 / 两周 / 周，table_calendar 对齐） ─────────
AntCalendar(
  showFormatSwitcher: true, // 切换按钮可隐藏（默认 false）
  onFormatChanged: (f) => print(f), // AntCalendarFormat.month/twoWeeks/week
);

// ── 范围选择 ──────────────────────────────────────────────
AntCalendar(
  selectionMode: AntCalendarSelectionMode.range,
  onRangeSelected: (start, end) => print('$start ~ $end'),
);

// ── 多选 ──────────────────────────────────────────────────
AntCalendar(
  multiSelect: true,
  onSelectMulti: (days) => print(days),
);

// ── 事件点标记（table_calendar eventLoader 对齐） ───────────
AntCalendar(
  eventLoader: (day) => events.where((e) => isSameDay(e, day)).toList(),
);

// ── 头部年月快速跳转（antd v6 行为，点击年月弹滚轮面板） ─────
AntCalendar(enableYearMonthDropdown: true); // 默认开启

// ── 国际化（内建 15 语言预设 + 自定义覆盖） ──────────────────
AntCalendar(locale: AntCalendarLocale.en);
AntCalendar(locale: AntCalendarLocale.fromLanguageCode('ja'));
// 或全局注入：
AntCalendarLocaleProvider(
  locale: AntCalendarLocale.zhTw,
  child: AntCalendar(),
);

// ── 移动端日历选择器（底部弹窗） ────────────────────────────
AntCalendarPicker(
  selectionMode: AntCalendarSelectionMode.range,
  onConfirm: (dates) => print(dates),
  child: Text('选择日期'),
);

// ── 内嵌日历视图（支持左右滑动手势翻月） ────────────────────
AntCalendarPickerView(
  selectionMode: AntCalendarSelectionMode.single,
  onChange: (dates) => print(dates),
);

// ── 通用滚轮选择视图（沉淀于 antd_flutter_ui） ──────────────
AntPickerView(
  columns: [
    [AntPickerColumnItem(label: '周一', value: 'mon')],
  ],
  onChange: (vals) => print(vals),
);
```

## 向后兼容

主包 `antd_flutter_plus` 经 re-export 保持既有用法不变：

```dart
import 'package:antd_flutter_plus/antd_flutter_plus.dart';

AntCalendar(value: ..., onSelect: ...); // 既有 value/defaultValue/onSelect/
                                        // weekStartsOn/disabledDate/dateCell/
                                        // fullscreen 等参数全部保持
```

## 说明

- 格式切换 / 范围多选 / 事件点等增强能力参考 [table_calendar](https://pub.dev/packages/table_calendar) 3.3.0 的 API 设计（Apache-2.0，仅 API 设计研究参考，未复用其源码）；桌面形态参考 antd v6 Calendar，移动形态参考 antd-mobile CalendarPicker。
- 日历网格计算引擎与通用滚轮视图沉淀于 antd_flutter_ui（`src/engines/calendar_grid_engine.dart`、`src/display/picker_view/`）。
- 依赖方向：antd_calendar → antd_flutter_ui → antd_theme/tokens/color，独立包之间无互相依赖。

## 文档与演示

- [API 文档总览](docs/api-index.md)
- 在线演示：<https://antd-flutter.github.io/antd-flutter/calendar_picker/>

## License

MIT License，详见仓库根 [LICENSE](../../LICENSE)。
