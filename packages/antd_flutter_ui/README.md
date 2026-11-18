# antd_flutter_ui

Ant Design v6 Flutter 基础组件库 — 承载基础层/通用展示/通用录入/通用反馈/全局组件，以及被多个独立组件包消费的共享引擎（滚轮选择引擎、虚拟键盘/格子输入模型）。

> 当前为预览版本。全量接入经伞包 `antd_flutter_plus`（re-export 本包全部组件），也可直接依赖本包按需使用。

## 安装

```yaml
dependencies:
  antd_flutter_ui: ^0.1.0-beta.1
```

## 用法

```dart
import 'package:antd_flutter_ui/antd_flutter_ui.dart';

// ── 基础组件示例：按钮 ───────────────────────────────────
AntButton(
  type: AntButtonType.normal,   // normal / primary / dashed / text / link
  size: AntButtonSize.middle,   // small / middle / large
  danger: false,
  loading: false,
  disabled: false,
  onTap: () {},
  child: const Text('按钮'),
);

// ── 共享引擎示例：滚轮选择列（WheelPickerColumn） ─────────
WheelPickerColumn(
  column: const [
    AntPickerColumnItem(label: '早', value: 'am'),
    AntPickerColumnItem(label: '中', value: 'noon'),
    AntPickerColumnItem(label: '晚', value: 'pm'),
  ],
  controller: FixedExtentScrollController(initialItem: 0),
  itemHeight: 40,
  fontSize: 16,
  colorText: Colors.black,
  onSelected: (index) {},
);
```

依赖方向：独立组件包 → 本包 → antd_theme / antd_tokens / antd_color / antd_icons_flutter。

## License

MIT License，详见仓库根 [LICENSE](../../LICENSE)。
