# antd_calendar - Flutter 日历与日期选择器

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_calendar/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_calendar/README_CN.md)

## 定位与设计

`antd_calendar` 提供 Ant Design 风格的月/年面板，由三个协作部件组成：`AntCalendar` 用于内联或全屏展示，`AntCalendarPicker` 用于以触发控件为锚点的底部弹层选择器，`AntCalendarController` 用于从外部驱动翻页。`platform` 一个开关即可选择桌面渲染器（年/月下拉、周序号、月年模式切换）或移动端渲染器（大触控格、范围选择），同一份声明可适配两种形态。

设计原则：

- **一套状态模型，两套渲染器。** 选中、翻页边界与禁用日期只声明一次，渲染器只改变呈现。
- **选择状态显式。** `value` 使日历受控，`defaultValue` 提供非受控初始值，`onSelect` / `onChange` / `onRangeChange` 汇报变更。
- **单元格内容可组合。** `cellRender` 装饰默认单元格，`fullCellRender` 完全接管；返回 `null` 时回退内置渲染。
- **文案注入而非硬编码。** `AntCalendarLocaleProvider` 提供星期标签、月份模板与按钮文案；内置 15 种语言预设，也可逐字段覆盖。

## 安装

要求 Dart `>=3.0.0`、Flutter `>=3.10.0`。

```yaml
dependencies:
  antd_calendar: ^1.0.0
```

用 `AntTheme` 包裹子树；日期格、面板头部与弹层外观均来自设计 token：

```dart
AntTheme(
  data: AntThemeData.light(),
  child: MaterialApp(home: YourPage()),
)
```

## 快速开始

```dart
import 'package:antd_calendar/antd_calendar.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(
      AntTheme(
        data: AntThemeData.light(),
        child: const MaterialApp(home: CalendarPage()),
      ),
    );

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selected = DateTime(2025, 3, 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: AntCalendar(
        value: _selected,
        weekStartsOn: AntCalendarWeekStartsOn.monday,
        fullscreen: true,
        onSelect: (date) => setState(() => _selected = date),
      ),
    );
  }
}
```

页面展示占满宽度的月面板，选中日期高亮。`fullscreen: true` 强制使用大日历形态；省略则使用紧凑卡片形态。

## API

[API 参考](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_calendar/docs/api-index.md)

### 1. 禁用日期与自定义日期内容

```dart
AntCalendar(
  value: _selected,
  onSelect: (date) => setState(() => _selected = date),
  disabledDate: (date) => date.weekday == DateTime.saturday || date.weekday == DateTime.sunday,
  validRange: AntCalendarValidRange(DateTime(2025, 1, 1), DateTime(2025, 12, 31)),
  cellRender: (date, info) {
    if (date.day != 1) return null;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
      ),
    );
  },
)
```

`disabledDate` 按天禁用交互，`validRange` 同时把面板翻页裁剪在年内。`cellRender` 返回 `null` 时保留默认单元格，因此这里只给每月 1 号加标记。

### 2. 移动端渲染器的范围选择

```dart
AntCalendar(
  platform: AntCalendarPlatform.mobile,
  selectionMode: AntCalendarSelectionMode.range,
  defaultRangeValue: [DateTime(2025, 3, 3), DateTime(2025, 3, 9)],
  weekStartsOn: AntCalendarWeekStartsOn.monday,
  onRangeChange: (range) => debugPrint('range=$range'),
)
```

移动端渲染器把起始、结束与中间日期绘成一条连续色带。`rangeValue` / `onRangeChange` 仅在 range 模式可用，范围选择由移动端渲染器支持。

### 3. 挂在输入控件上的底部弹层选择器

```dart
class PickDateField extends StatefulWidget {
  const PickDateField({super.key});

  @override
  State<PickDateField> createState() => _PickDateFieldState();
}

class _PickDateFieldState extends State<PickDateField> {
  List<DateTime> _dates = <DateTime>[];

  @override
  Widget build(BuildContext context) {
    return AntCalendarPicker(
      title: 'Deadline',
      defaultValue: _dates,
      weekStartsOn: AntCalendarWeekStartsOn.monday,
      onConfirm: (dates) => setState(() => _dates = dates),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: const BoxDecoration(
          border: Border.fromBorderSide(BorderSide(color: Colors.grey)),
        ),
        child: Text(
          _dates.isEmpty ? 'Select a date' : _dates.first.toString(),
        ),
      ),
    );
  }
}
```

点击 `child` 打开模态底部弹层；确认通过 `onConfirm` 回报所选列表，`onChange` 在面板内每次选择时触发。`onCancel`、`onClose`、`onMaskClick` 用于区分不同关闭路径。

用 `AntCalendarLocaleProvider(locale: AntCalendarLocale.en, child: ...)` 包裹子树即可切换星期与按钮文案，无需改动单个组件。

## 演示

- 在线演示：https://flutter-open.github.io/antd-flutter/calendar/
- 发现问题或有疑问？[提交 Issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## 项目结构

```text
packages/antd_calendar/
├── lib/
│   ├── antd_calendar.dart                  # barrel 导出
│   └── src/
│       ├── calendar/
│       │   ├── ant_calendar.dart           # 对外日历组件
│       │   ├── ant_calendar_controller.dart# 月份/页面导航
│       │   ├── ant_calendar_types.dart     # 模式、布局与回调
│       │   ├── calendar_core/              # 状态、国际化与公共计算
│       │   ├── desktop/                    # 桌面渲染器
│       │   └── mobile/                     # 移动端渲染器
│       └── calendar_picker/
│           └── ant_calendar_picker.dart    # 底部弹层选择器
├── example/lib/main.dart                   # 可运行示例
├── docs/api-index.md                       # 生成的 API 索引
└── README.md
```

## License

MIT，详见仓库 [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE)。

## ☕ 请我喝咖啡

如果这个项目帮到了你，欢迎请我喝杯咖啡，感谢你的支持！

| 支付宝 | 微信 |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="支付宝收款码" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="微信收款码" /> |
