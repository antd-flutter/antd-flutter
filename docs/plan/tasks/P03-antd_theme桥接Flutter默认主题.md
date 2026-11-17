# P03. antd_theme 优化：桥接 Flutter 默认主题

- 状态：`[ ]`
- 目标：将 `AntThemeData` 转换为 Flutter 默认的亮/暗两套 `ThemeData`（antd token 值 → Material 主题对应项），使原生 Material/Cupertino 控件「变相」遵循 antd 主题；并提供类似 Flutter `Theme` 的外包裹用法，内部可就近读取主题
- 前置依赖：无

## 现状盘点
- `packages/antd_theme/lib/src/ant_theme.dart`：`AntTheme` 已是 InheritedWidget，已有 `AntTheme.of(context)` 就近读取
- `packages/antd_theme/lib/src/ant_theme_data.dart`：`AntThemeData` 已存在
- `packages/antd_tokens/`：seed/color/shadow token 已有，是映射数据来源

## 步骤
1. 设计映射表：antd token → `ThemeData` 字段（colorScheme：primary=antd 主色、error=错误色、surface/background 等；textTheme：antd 字体 token → TextTheme；组件级：button/card/input 等 ComponentThemes 对应 antd 组件规范）
2. 实现 `AntThemeData.toThemeData({Brightness brightness})`（或 `AntMaterialTheme` 转换器），输出亮/暗两套 ThemeData
3. 实现桥接 Widget：`AntTheme` 包裹时自动注入 `Theme`（等价 Flutter `Theme` 的外侧包一层、内部就近生效），支持 `AntTheme(builder: (ctx, theme) ...)` 用法不变，且 `Theme.of(ctx)` 在其后代中取到 antd 派生主题
4. 暗色模式：基于 antd dark token 生成 dark ThemeData，`AntThemeData` 增加/确认 dark 配置入口
5. example 演示页：新增「Material 控件兼容」示例页（按钮/输入框/卡片在 AntTheme 下原生控件直接呈现 antd 风格，亮暗切换）
6. 单元测试：映射关键断言（主色/surface/文字样式）、亮暗两套生成、`Theme.of` 就近读取
7. `flutter analyze` + `flutter test` 通过

## 验收标准
- [ ] `AntThemeData` 可生成亮/暗两套 Flutter `ThemeData`
- [ ] AntTheme 包裹下，原生 Material 控件自动继承 antd 配色与字体
- [ ] `Theme.of(context)` / `AntTheme.of(context)` 均可就近读取
- [ ] example 含兼容演示页，测试通过

## 备注
- 映射表是核心资产，建议独立文件（如 `ant_material_bridge.dart`）并加注释说明每个映射的 antd 规范出处
- 注意与 `flutter-best-practices`/`flutter-theme` 约定一致；不改动现有组件库渲染逻辑，桥接只影响 Material 默认控件
