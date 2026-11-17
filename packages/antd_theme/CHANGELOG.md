# 更新日志

## 1.0.0

首个正式版（stable）。API 与 0.1.0-beta.1 相比**无破坏性变更**。

- **AntThemeData** — antd v6 三层令牌（Seed → Map → Alias）完整主题数据：`light()` / `dark()` / `fromSeed()` 工厂，颜色 / 字体 / 圆角 / 尺寸 / 控件高度 / 动效 / 阴影 / 屏幕断点全量便捷访问器
- **AntTheme / AntThemeBuilder** — `InheritedWidget` 主题注入，自动将 antd 主题转换为 Flutter `ThemeData`（原生 Material 控件呈现 antd 风格）
- **AntBreakpoint / AntBreakpoints** — antd 响应式断点（xs ~ xxxl），`fromWidth` / `of` / `isUp` / `isDown` / `isBetween`
- **AntResponsive（新增）** — 响应式布局信息通知（`AntResponsiveInit` 包裹）：断点 / 设备类型 / 方向 / 折叠屏 / 平台 / 缩放因子，基于 `InheritedModel<AntLayoutAspect>` 的细粒度 aspect 订阅（`breakpointOf` / `deviceTypeOf` / `foldStateOf` / `platformOf` / `widthOf` / `scaleFactorOf`），并提供 `AntResponsiveScope.layoutListenableOf` 非 Widget 订阅入口；值不变不通知
- **AntPlatform（下沉）** — 平台检测工具类自主工程下沉至本包（isOhos / isDesktop / supportsHover / useTouchRipple 等），API 向后兼容
- **AntMaterialBridge（新增）** — `AntMaterialTheme.toThemeData()` 主题桥接：AntThemeData → Flutter `ColorScheme` / `TextTheme` / 组件主题完整映射，每个映射注明 antd 规范出处
- **AntScreenUtilInit 桌面等比放大（新增）** — 桌面超宽屏（4K / 带鱼屏）等比放大支持：`allowScaleUp` / `maxWidth` / `maxScaleFactor` 参数，缩放因子经 `scaleFactorListenable` 全局暴露并上报 `AntResponsive`
- 测试：64 个测试用例全量通过
