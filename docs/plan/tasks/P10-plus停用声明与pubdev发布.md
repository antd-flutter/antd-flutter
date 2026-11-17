# P10. antd_flutter_plus 停用声明 + pub.dev 发布（beta 版本）

- 状态：`[ ]`
- 目标：`antd_flutter_plus` README 添加「不要使用」声明（组件库拆分在即，此伞包将重构，暂不建议接入）；以 `1.0.0-beta.xxx` 版本规则发布到 pub.dev
- 前置依赖：无（提前执行——「不要使用」提醒最关键，优先让 pub.dev 上的声明生效）

## 版本号规则（总规则 R6）
- 预发布统一 `1.0.0-beta.xxx`，每次预发布序号 +1（当前 pubspec 版本对齐后确定起始序号）
- beta 后缀消失（`1.0.0`）= 正式发布，不设其他中间形态

## 步骤
1. README 重写为纯声明页：移除所有组件表格与展示内容，只保留「不要使用/即将重构拆分」声明——拆分背景（基础库 `antd_flutter_ui` + 独立组件包）、未来接入方式（全量伞包 / 单组件包）、License 与仓库链接；现有组件文档内容整体移除（组件文档未来由各独立包的 README 承载）
2. 各子包（antd_color/tokens/theme/icons 等）README 检查，保留 beta 警告横幅并统一措辞
3. 校对根包与子包 `pubspec.yaml`：version 统一 `1.0.0-beta.x` 形态；`flutter pub publish --dry-run` 预检（拿不到本地验证环境则依赖 CI）
4. 发布到 pub.dev：`flutter pub publish`（需要 pub.dev 账号凭据；若凭据缺失或命令交互无法完成，报告并交由用户手动执行）
5. 发布确认：pub.dev 页面可见 beta 版本，README 仅显示重构声明

## 验收标准
- [ ] antd_flutter_plus README 只含重构声明（无任何组件表格/展示内容）
- [ ] pub.dev 发布成功，版本为 1.0.0-beta.x
- [ ] 版本规则 R6 已执行（beta.xxx 递增，正式发布即去掉后缀）

## 备注
- pub.dev 发布需要用户账号授权（浏览器 OAuth 或 credentials.json），代理无法代登录时必须停下交回用户
- 声明措辞正式（公开仓库），不出现内部计划细节
