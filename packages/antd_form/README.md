# antd_form

Ant Design (antd-mobile) Form 表单的 Flutter 实现 — AntForm（表单容器）、AntFormItem（字段校验与标签）、AntFormFieldRule（required / pattern / 长度 / 数值范围 / 自定义 validator）与 AntFormController（编程式读写值、校验、提交、重置），API 对齐 antd-mobile。

> 当前为预览版本。

> R33 判定：表单类组件为常规布局组件，非滚动场景，不需要 sliver 支持。

> 归属边界（读码评估）：AutoComplete / Mentions 为独立输入联想组件，Form 源码未引用它们（ant_form.dart 仅依赖 antd_theme / material_ui / 自身 types），留在 `antd_flutter_ui`（data_entry/auto_complete、data_entry/mentions）不迁；Form 与 Input 系组件（AntInput / AntCheckbox / AntSwitch / AntStepper）的联动发生在业务层（builder 组合），本包经 ui barrel 引用。

## 安装

```yaml
dependencies:
  antd_form: ^0.1.0-beta.1
```

## 用法

```dart
import 'package:antd_form/antd_form.dart';
import 'package:antd_flutter_ui/antd_flutter_ui.dart';

AntForm(
  onFinish: (values) => print(values),
  onFinishFailed: (errors) => print(errors),
  child: Column(children: [
    // ── 基础校验 ────────────────────────────────────────
    AntFormItem<String>(
      name: 'username',
      label: '用户名',
      required: true,
      rules: [
        const AntFormFieldRule.required(message: '请输入用户名'),
        const AntFormFieldRule(minLength: 3, maxLength: 12),
      ],
      builder: (field) => AntInput(
        value: field.value ?? '',
        onChange: field.didChange,
      ),
    ),
    // ── 自定义校验器 ────────────────────────────────────
    AntFormFieldRule(
      validator: (value) =>
          (value as String).startsWith('AF') ? null : '邀请码需以 AF 开头',
    ),
  ]),
)

// ── 受控：AntFormController 编程式操作 ──────────────────
final controller = AntFormController();
controller.setValue('username', 'antd', validate: true);
final ok = await controller.validate();
controller.reset();
```

完整演示见 `example/`（基础校验 / 受控 / 自定义校验器 / 动态增减表单项 / Form 与 Input 系联动，R35.4 断点适配 + 暗色切换）。

## 迁移说明（P08 批次 2）

- 从 `antd_flutter_ui`（data_entry/form）迁出，`///` 文档注释完整随迁，源码零修改（仅 import 调整）。
- 主包 `antd_flutter_plus` 经 re-export 保持符号兼容。
- 依赖方向：antd_form → antd_flutter_ui → antd_theme/tokens/color/icons，不依赖其他独立组件包。

## License

MIT
