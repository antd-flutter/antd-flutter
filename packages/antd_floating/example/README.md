# antd_floating_example

Ant Design Floating 浮动组件演示画廊（antd_floating 独立包 example）。

## 覆盖形态

- **FloatingPanel**：把手拖拽 + 松手动画吸附最近锚点；`AntFloatingPanelController` 程序化展开/收起/重置/指定锚点；边缘锚点三档形态；`onHeightChange` 高度比例回调
- **FloatingBubble**：拖拽（x/y/both 轴向）+ 边界约束；`AntFloatingBubbleController` 边缘磁吸/移动/重置/显示隐藏；点击回调；menu 菜单展开
- **气泡多实例**：主色/金色/仅 Y 轴三个独立实例互不影响

## 运行

```bash
flutter pub get
flutter run -d macos   # R35.3 真机验证拖拽/吸附交互
flutter build web      # CI 站点构建（base-href /floating/）
```

## 规范

- R35.4：`AntResponsiveInit` 断点布局（宽屏 Wrap / 窄屏 Column），窗口缩放无溢出；暗色切换经 AppBar 按钮联动 `AntTheme` + `themeMode`
- R32.2：应用图标/名称经 `bash scripts/setup_example_identity.sh --pkg antd_floating --example packages/antd_floating/example --name AntdFloating` 统一
