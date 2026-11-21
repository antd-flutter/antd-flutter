# antd_picker

Ant Design (antd-mobile) 弹层选择器族的 Flutter 实现 — Picker（滚轮选择器，单列/多列联动）、DatePicker（日期选择器）、TimePicker（时间选择器）、Cascader（级联选择）与 CascaderView（内嵌级联视图），API 对齐 antd-mobile。

> 当前为预览版本。

> R33 判定：弹层选择器类组件（Picker 族经 Popup 弹层选择，CascaderView 为内嵌面板），均非滚动场景，不需要 sliver 支持。

> 归属边界：AntPickerView（通用滚轮视图）留在 `antd_flutter_ui`（display/picker_view），本包经 ui barrel 引用。

## 安装

```yaml
dependencies:
  antd_picker: ^0.1.0-beta.1
```

## 用法

```dart
import 'package:antd_picker/antd_picker.dart';

// ── Picker 单列选择 ─────────────────────────────────────
final value = await AntPicker.pick(
  context,
  columns: [
    ['周一', '周二', '周三', '周四', '周五'],
  ],
  onConfirm: (values) {},
);

// ── 多列联动 ────────────────────────────────────────────
AntPicker(
  columns: _linkedColumns(selected),
  value: _value,
  onChange: (values) => setState(() => _value = values),
)

// ── DatePicker 年月日 ───────────────────────────────────
AntDatePicker(
  value: _date,
  min: DateTime(2020),
  max: DateTime(2030),
  precision: AntDatePickerPrecision.day,
  onConfirm: (date) => setState(() => _date = date),
)

// ── TimePicker 时分秒 ───────────────────────────────────
AntTimePicker(
  value: _time,
  precision: AntTimePickerPrecision.second,
  onConfirm: (time) => setState(() => _time = time),
)

// ── Cascader 级联选择（弹层） ────────────────────────────
AntCascader(
  options: _options,
  value: _cascaderValue,
  onConfirm: (value) => setState(() => _cascaderValue = value),
)

// ── CascaderView 内嵌（不弹层） ──────────────────────────
AntCascaderView(
  options: _options,
  value: _cascaderValue,
  onChange: (value) => setState(() => _cascaderValue = value),
)
```

## 组件清单

| 组件 | 说明 | 对齐 API |
| --- | --- | --- |
| `AntPicker` | 滚轮选择器（单列/多列联动、受控） | antd-mobile `Picker` |
| `AntDatePicker` | 日期选择器（年/月/日精度） | antd-mobile `DatePicker` |
| `AntTimePicker` | 时间选择器（时/分/秒精度） | antd-mobile `DatePicker`（precision time） |
| `AntCascader` | 级联选择器（弹层） | antd-mobile `Cascader` |
| `AntCascaderView` | 内嵌级联视图 | antd-mobile `CascaderView` |

## 依赖方向

`antd_picker → antd_flutter_ui`（滚轮引擎 + AntPickerView）`→ antd_theme`；不依赖其他独立组件包。主包 `antd_flutter_plus` 经 re-export 保持对外兼容。

完整 demo 见 [example](example/)（全平台，含 R35.4 多平台响应式适配与暗色切换）。
