# P09. 伞包 example 重构：响应式布局 + device_preview

- 状态：`[x]`
- 目标：重构 `antd_flutter_plus`（伞包）的 example demo 为响应式布局，接入 device_preview 设备模拟；移动端不使用 device_preview，其余端（desktop/web）使用且**不区分 debug/release**；支持折叠屏预览
- 前置依赖：P08（伞包与拆分定案后重构才有意义，建议排在 P08 之后；响应式部分依赖 P05 AntResponsive）

## device_preview 调研结论（2026-11-17 实测更新）
- **3.0.0 已发布但当前不可用** ✅❌ — 绑定层新架构（folds/hinges 折叠模拟 ✔、
  `DevicePreview.enable(enabled: true)` 全模式开启 ✔），但其
  `PreviewPlatformDispatcher` 未实现 Flutter 3.50 新增的
  `PlatformDispatcher.resetInternalState`，在本工程 Flutter 3.50.0 下
  **无法编译**（flutter test / build web 均失败）；上游 master
  （aloisdeniel/flutter_device_preview，截至 2026-11-17 最新 commit
  2026-08-25 Release 3.0.0）尚无适配修复
- **退回 1.3.1**（按任务约定）：三行包装接入（`DevicePreview` widget +
  `locale/appBuilder` 透传），`enabled: true` 不区分 debug/release；
  1.x 不支持 folds/hinges 折叠模拟，折叠屏形态验证改经 AntResponsive
  半折模拟尺寸（681×841）的布局断言覆盖
- 待上游适配 Flutter 3.50 后可升级回 3.0（wrapper 已保留 bootstrap/wrap
  API 形态，升级只改中间件层）

## 步骤
1. 响应式布局改造：example 布局改用 AntResponsive 断点/设备类型驱动（宽屏 Header/侧栏、窄屏 NavBar/底部导航），复用根 example 已有亮暗切换与自举组件
2. device_preview 接入（经中间件隔离，规则 R16）：
   - 封装 wrapper（如 `AntDevicePreview`），业务代码不直接触碰 device_preview API
   - 平台判断：仅 desktop/web 端启用（`AntPlatform.isDesktop || kIsWeb`），**移动端不启用**
   - 全模式启用：`enable(enabled: true)`，不区分 debug/release
   - 预置设备清单包含折叠屏设备（验证 folds/hinges 模拟）+ 手机 + 平板 + 桌面窗口
3. demo 页适配：所有组件 demo 页在 device_preview 模拟尺寸下无溢出/布局异常（重点验证折叠屏半折形态的布局连续性）
4. 测试：响应式布局断言（宽/窄/折叠三态）+ wrapper 单测
5. `flutter analyze` + `flutter test` + `flutter build web` 验证

## 验收标准
- [ ] example 响应式布局生效（宽窄屏形态切换）
- [ ] desktop/web 端 device_preview 全模式可用，含折叠屏模拟
- [ ] 移动端不受 device_preview 影响
- [ ] 全部 demo 页在模拟尺寸下无布局异常
- [ ] 测试与构建通过

## 备注
- device_preview 3.0 UI 在 DevTools 中（无应用内工具栏），如需应用内切换面板需经 controller 自建——先不加，保持简单
- 执行记录（2026-11-17）：3.0 不可编译 → 实际接入 1.3.1（见调研结论）；
  demo 页修复 tabs_page（AntTabs 无界高度）/steps_page（AntSteps 垂直
  无界高度）加有界 SizedBox 约束；组件库（material_ui 包 AntTabs/AntSteps
  内部 Expanded 对无界上下文不友好）问题记录不修包
