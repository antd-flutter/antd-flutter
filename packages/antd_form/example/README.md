# antd_form example

antd_form 表单（AntForm / AntFormItem / AntFormFieldRule / AntFormController）全平台演示画廊。

## 覆盖形态

- **基础校验**：required / pattern / 长度 / 数值范围规则，onFinish / onFinishFailed 提交流
- **受控操作**：AntFormController 编程式 setValue 注入、validate 校验、reset 重置、getValues / getErrors 实时展示
- **自定义校验器**：AntFormFieldRule.validator 自定义校验逻辑
- **动态表单项**：动态增减表单项（成员 1-5 人）
- **Form 与 Input 系联动**：AntInput / AntCheckbox / AntSwitch / AntStepper 经 builder 绑定表单字段

## 运行

```bash
cd packages/antd_form/example
fvm flutter pub get
fvm flutter run -d macos   # 或 -d chrome / android / ios / linux / windows
```

## R35.4 多平台 UI 适配

- `AntResponsiveInit` + `AntLayoutData` 断点布局：desktop 宽屏（≥768 或 lg/xl/xxl）Wrap 双栏卡片、phone 窄屏单列
- AppBar 暗色切换按钮：AntTheme + themeMode 三件套联动
- 布局使用 `Wrap` / 单列 `Column` + 固定内边距，窗口缩放无溢出
