# P06. antd_icons_flutter example 优化

- 状态：`[ ]`
- 目标：把 antd_icons_flutter 的 example 打磨为正式形态：更换项目图标、国际化、明暗切换、支持独立运行与嵌入（URL 参数关闭顶部导航）、主题经 antd_theme 适配、搜索框置顶且按当前 tab 过滤
- 前置依赖：P03（主题桥接，嵌入适配引用 antd_theme 时对齐实现；可并行开发，联调依赖 P03）

## 步骤
1. **项目图标**：应用图标（web/android/ios 各端 manifest 与 web manifest icon）更换为 https://gw.alipayobjects.com/zos/rmsportal/KDpgvguMpGfqaHPjicRK.svg
   - 注意：Android/iOS 需要位图，SVG 需转多尺寸 PNG（512/192/48 等）再配置；web 可直接用 SVG
2. **工程逻辑优化（正式化）**：
   - 国际化：界面文案（搜索框占位、tab 标题等）接入 intl/arb，至少中英文
   - 明暗模式：顶栏明暗切换，经 `AntTheme` 联动全局主题（对齐根 example 的切换实现）
   - 嵌入模式：支持被另一个 app 以网页 iframe/webview 嵌入，**URL 参数**（如 `?embed=1`）隐藏顶部导航（Header/NavBar），仅渲染图标内容区
   - 主题适配：嵌入宿主的明暗/主题色可通过 URL 参数传入（如 `?theme=dark&primary=...`），经 antd_theme 应用
3. **搜索框置顶**：搜索框固定在顶部，输入关键字时**当前所在 tab** 的图标列表实时过滤（各 tab 独立更新，切换 tab 保留/恢复各自搜索状态）
4. example 内组件尽量替换为 antd-flutter 组件（对齐根 example 自举约定）
5. `flutter analyze` + `flutter test`（如有测试）+ `flutter build web` 验证

## 验收标准
- [ ] 各端应用图标更换完成
- [ ] 中英文国际化 + 明暗切换可用
- [ ] `?embed=1` 等参数可关闭顶部导航、可传主题参数
- [ ] 搜索框置顶，按 tab 独立过滤生效
- [ ] web 构建成功，发布到站点（P02 站点 icons/ 目录）后嵌入验证

## 备注
- 与 P02 联动：此 example 是静态站点的 icons 画廊（deploy.yml 已构建到 `site/icons/`），嵌入场景主要由官网/文档站引用
- SVG 转 PNG 工具链确定后再执行步骤 1 的位图部分
