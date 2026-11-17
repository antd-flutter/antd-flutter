# P07. AntScreenUtilInit 桌面端最大宽度上限与等比放大

- 状态：`[x]`
- 目标：桌面端适配以最大屏幕宽度为基准——窗口宽度超过上限后，允许用户配置开启**等比放大**（超宽部分按比例放大 `.w/.sp/.r`），默认不开启保持现状（恒为 1 不放大）
- 前置依赖：无（与 P05 同属 antd_theme 包，建议同一任务分支 `task/antd-theme-enhance`）

## 现状逻辑（ant_screen_util.dart）
- 窗口逻辑宽度 >= `desktopBreakpoint`（默认 768）→ designSize = 窗口实际尺寸，缩放因子恒为 1，组件不缩放
- 问题：超宽屏（如 4K 横屏、超宽显示器）时布局元素偏小，没有放大选项

## 设计
- 新增参数：
  - `double? maxWidth`：桌面基准宽度上限（逻辑像素）。窗口宽度 ≤ maxWidth 时行为不变（因子 1）；超过 maxWidth 时 designSize 固定为 maxWidth（或 maxWidth × 高度比例），使缩放因子 = 窗口宽度 / maxWidth > 1，整体等比放大
  - `bool allowScaleUp = false`：是否允许超宽等比放大；默认 false 保持现行为（因子恒 1）
  - 可选 `double maxScaleFactor`：放大倍率上限保护（如 1.5），超过后不再放大，防止极端窗口下元素过大
- 组合语义：
  - `allowScaleUp: false`（默认）：现状，永不放大
  - `allowScaleUp: true, maxWidth: 1920`：窗口 2400 时因子 = 2400/1920 = 1.25，全 UI 等比放大
- 放大生效时同步给 `AntResponsive`/布局信息（若 P05 已落地）暴露 `scaleFactor` 字段，方便用户感知

## 步骤
1. `AntScreenUtilInit` 增加 `maxWidth`/`allowScaleUp`/`maxScaleFactor` 参数与 `_effectiveDesignSize` 计算改造
2. 文档注释更新（含缩放规范与示例）
3. 单元测试：因子计算（<=768、768~maxWidth、>maxWidth 开/关放大、超 maxScaleFactor 封顶）
4. example 演示：桌面窗口拉宽验证放大效果与配置开关
5. `flutter analyze` + `flutter test`

## 验收标准
- [ ] 默认行为与现状完全一致（不放大）
- [ ] `allowScaleUp: true` 后超宽等比放大生效，倍率可封顶
- [ ] 测试通过
