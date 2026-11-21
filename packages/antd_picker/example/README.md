# antd_picker example

antd_picker 弹层选择器族（Picker / DatePicker / TimePicker / Cascader / CascaderView）全平台演示画廊。

## 覆盖形态

- **Picker 滚轮选择**：单列选择、多列选择（列间独立滚动）
- **DatePicker**：年月日日期选择、允许清除
- **TimePicker**：时分秒选择、小时步进
- **Cascader**：弹层级联选择（changeOnSelect）、禁用态
- **CascaderView**：内嵌级联视图（不弹层）
- **受控操作**：AntPicker 受控 value + 重置、Cascader / DatePicker 受控 + 清空

## 运行

```bash
cd packages/antd_picker/example
fvm flutter pub get
fvm flutter run -d macos   # 或 -d chrome / android / ios / linux / windows
```

## R35.4 多平台 UI 适配

- `AntResponsiveInit` + `AntLayoutData` 断点布局：desktop 宽屏（≥768 或 lg/xl/xxl）Wrap 双栏卡片、phone 窄屏单列
- AppBar 暗色切换按钮：AntTheme + themeMode 三件套联动
- 布局使用 `Wrap` / 单列 `Column` + 固定内边距，窗口缩放无溢出
