# 执行计划（内部，不对外公开）

> 约定：
> - 子任务文件放在 `docs/plan/tasks/`，完成后**删除对应文件并移除下方引用**
> - 全部完成后，执行最后一个任务：发布 1.0.0 版本，然后本计划目录整体删除
> - 状态标记：`[ ]` 未开始 / `[~]` 进行中 / `[!]` 受阻

## 总任务

- [ ] 发布 1.0.0 版本
  - 前置：以下所有子任务全部完成并删除
  - 步骤：更新 CHANGELOG（仅正式内容）/ 版本号 → 构建验证 → 打 tag → 发布

## 通用规则（后续任务创建时遵循）

### 分支规则
- R1 同一任务组的多个子任务共用**一个任务分支**，避免任务分支过多；分支名按任务组命名（如 `task/p01-p02-dual-remote-gitcode`、`task/p03-theme-bridge`），新任务若属于已有任务组则复用该分支
- R2 任务分支从 `master` 拉出，完成后本地验证通过（R18）即合并回 `master` 并删除任务分支；**不等待 CI**，CI 失败事后修复
- R3 临时/实验分支不推送远程；任务分支推送时遵循双地址推送规则（P01 完成后）

### CHANGELOG 规则
- R4 CHANGELOG 中**不放入 beta 更新内容**；已有的 beta 条目全部删除
- R5 仅在**正式发布**时才向 CHANGELOG 添加内容；beta 期间的变更记录保留在任务文档（`docs/plan/tasks/`）中，不进 CHANGELOG

### 版本规则
- R6 版本号规则：预发布阶段统一为 **`1.0.0-beta.xxx`**（每次预发布 beta 序号 +1，如 1.0.0-beta.1 → 1.0.0-beta.2）；**beta 后缀消失（即 `1.0.0`）的那一刻就是正式发布**，不设其他中间版本形态

### 质量规则
- R7 每个任务完成前：`flutter analyze` 零问题 + 相关 `flutter test` 全量通过
- R8 新增功能必须附带单元测试/Widget 测试
- R9 遵循最小改动原则，不做扩散性变更

### 任务文档规则
- R10 每个子任务一个文件，命名 `P<n>-<标题>.md`，含：目标 / 前置依赖 / 步骤 / 验收标准
- R11 任务完成后：更新 CHANGELOG 的动作留给正式发布时统一执行，任务内只记录变更点

### 组件库设计规则
- R12 平台判断必须有统一入口且下沉到 antd_theme 包（现状 `AntPlatform` 在主工程，需迁移并保持 API 向后兼容）；**严禁使用 `Platform.isOhos`**（Flutter SDK 无此属性）
- R13 布局/主题等全局状态变化必须走**局部刷新**通知（InheritedWidget 依赖 / ValueNotifier 订阅），禁止让用户整页 setState；通知前做值相等去重，值不变不通知
- R14 所有 example 页面按「正式形态」要求打磨：国际化（至少中英文）+ 明暗模式切换 + 支持嵌入模式（URL 参数关闭宿主 UI、可传主题参数）
- R15 example 内可用组件尽量自举替换为 antd-flutter 组件（对齐根 example 自举约定）
- R16 三方 SDK/平台 API 必须经中间层隔离（如 `AntOhosChannel` 抽象接口），业务代码不直接触碰 SDK 语义

### Dart 文件拆分规则
- R25 组件 dart 文件必须**细粒度拆分**，便于 skill/工具按文件读取与检索：一个组件目录内按职责分层放置——`config/`（组件配置类，如 ButtonConfig）、`enum/`（枚举与形态定义，如 button_type/text_button 等各占一个文件）、组件主体（ant_button.dart）、回调/数据类型必要时单独 types 文件；**禁止把配置/枚举/组件主体堆在一个文件里**
- R26 每个组件目录通过一个统一的 `index.dart`（或同名聚合文件）对外 export 全部公开文件，消费方与 barrel 只引 index.dart；新增/移动文件必须同步维护 index.dart

### 文档规则
- R20 **文档单轨脚本生成（2026-11-17 用户指示，替代原双轨方案）**：所有文档由 gen-docs 命令从源码 `///` 注释自动生成（API 签名/参数表/文档全文），**不设人工文档**；人工只维护代码内的 `///` 注释（Effective Dart 规范），文档更新=改注释+跑命令
- R21 静态页面产出：人工文档 + dart doc 整合为静态页面，供用户网页查看；预留与站点发布（P02）及未来官网整合
- R22 文档随代码走：生成产物放各包 `docs/`（gitignore 与否由生成物稳定性决定，api-index.md 纳入版本控制）；改组件 API = 改 /// 注释 + 跑 gen-docs，一次提交完成
- R29 **编码基类沉淀**
- R30 **实现前先查轮子（用户指定）**：实现某功能前，先到 pub.dev 搜索是否已有成熟包实现（读其文档/源码/示例），优先「下载源码研究 → 按需改造吸收进自己代码」，避免从零重造；引入三方依赖需评估维护活跃度与依赖面（R16 中间件隔离仍适用）；改造吸收（拷源码改写）优于直接依赖（减少依赖树），版权/License 合规（MIT/Apache 可，需在文件头注明来源）
- R30.1 **已确认的轮子参考清单（用户与 lead 调研，实现对应组件时必须先研究该轮子源码再改造吸收）**：
- R30.2 **迁移时直接改造吸收，一步到位（用户指定）**：凡清单中的组件，迁移子任务必须**在迁移的同时完成轮子改造吸收**（源码研究 → 吸收进迁移后的实现），**禁止先纯搬家再二次改造**——省去两遍工序；迁移子任务的验收标准即包含轮子能力落地
- R30.3 **有轮子时优先完全仿造（用户指定，antd_refresh 模式）**：存在合适轮子时，优先**完全仿造轮子实现**（完整移植复刻其代码，仅修改类名/前缀避免冲突）——因为轮子经过大量用户验证，比自研或部分吸收更可靠；验证仿造实现可运行后，**再基于它实现 antd 方向的封装控件**（antd 样式/API/能力增强）。范例：antd_refresh = 完全复刻 easy_refresh + 其上封装 AntPullToRefresh/AntInfiniteScroll。「部分改造吸收」仅在轮子不适合完全移植（如引擎与我们的架构深度耦合）时作为次选（R30 原路线）
  - AntTable 表格 → pluto_grid / syncfusion_flutter_datagrid（虚拟滚动/排序/固定列/列宽拖拽）
  - AntImageViewer → photo_view（缩放手势标准实现）
  - AntCarousel（antd_carousel 独立包）→ carousel_slider（页面变换/视差）
  - AntMasonry（antd_masonry 独立包）→ flutter_staggered_grid_view（瀑布流算法 + SliverMasonryGrid sliver 支持，R33 联动）
  - AntInfiniteScroll → infinite_scroll_pagination（分页状态管理）
  - AntTour → tutorial_coach_mark（挖孔遮罩+引导流程）
  - AntCalendar（antd_calendar 独立包）→ table_calendar（格式切换/range/事件，已确认吸收）
  - AntPullToRefresh → pull_to_refresh_flutter3（桌面滚轮支持，改造进行中）
  - AntSwipeAction → flutter_swipe_action_cell（改造排队）
  - 弹层底座（Tooltip/Popover/Popconfirm/Dropdown）→ popover（已吸收为 P15）
  - Picker 族滚轮引擎 → 系统 CupertinoPicker 继承评估（R31 第一优先级）
- R31 **样式实现优先级（用户指定，迁移/新代码直接执行）**：① 能继承 Flutter 系统组件的优先继承系统实现（适配层形态，如 AntSafeArea extends SafeArea / AntSliverAppBar extends SliverAppBar）；② 系统组件无法满足的，优先去 pub.dev 查找**高星级**开源轮子研究其实现方式后改造吸收（按 R30）；③ 都不适用才自研自绘。三档优先级在组件迁移与新组件开发时**直接执行**，无需逐次确认
- R32 **独立组件包自建 example 满足发布条件（用户指定，全平台）**：每个独立组件包必须有**自己的 example 工程（全平台：iOS/Android/macOS/Windows/Linux/Web 目录齐全 + CI 矩阵覆盖）**，独立运行 + 发布到站点子路径（学习 antd_icons_flutter 的 example/gallery 模式），并完善自身 demo 至发布标准（组件全部关键形态展示、README、双轨文档）；本机验证 macOS + iOS 模拟器 + Web；**antd_icons_flutter 的 example 也按此标准补齐全平台**
- R33 **组件 sliver 家族支持判定（用户指定，lead 判断落地）**：滚动集合类组件必须提供 sliver 家族支持（sliver 变体组件或 sliver 兼容），供 CustomScrollView 使用——判定标准：① 组件本质是「滚动内容集合」（如瀑布流/栅格/列表）→ **必须**；② overlay 弹层类/固定布局类/包裹类（Watermark/SafeArea/Carousel/Table/Tour 等）→ **不需要**。落地形态：独立包内提供 sliver 变体（如 `AntSliverMasonry`）或经 ui/src/adapt/ 适配层（`extends SliverXxx` 模式）；迁移与新组件开发时按此判定执行
- R34 **独立组件包文案国际化（用户指定）**：所有涉及文案的组件（默认文案/占位/按钮/提示等），独立组件包内**自行实现国际化**（组件内建 locale 机制或文案配置入口），**默认中文**——不依赖主包/宿主 App 的国际化体系；有英文需求的组件提供 en 支持（arb 或文案映射表），跟随系统或宿主语言
- R28 **文档命令化生成（单轨落地）**：gen-docs 命令承担全部文档产出；既有的人工 md（antd_color/antd_tokens/antd_icons_flutter 的 color/palette/parse/seed-token 等）属于历史遗留，由 P14 迁移为生成产物后删除
- R23 **禁用 golden（图像快照）测试**（用户确认：token/积分成本高，跨平台字体渲染易 flaky）：组件默认参数值用普通单测断言；视觉效果由用户在 example 页人工抽查验收
- R24 **import 统一用 `package:material_ui/material_ui.dart` 替代 `flutter/material.dart`**（官方迁移方向，防止 material.dart 遗弃问题；cupertino 同理用 cupertino_ui）；所有子包/主包/example/测试文件一律遵守，新代码禁止出现 `flutter/material.dart` import

### 任务执行规则
- R17 任务修改按**子任务模式**执行：一次执行**一个完整子任务**（该任务文件的全部步骤连续做完），**中途不询问**；全部子任务完成后整体验证
- R18 验证策略（2026-11-17 更新，用户确认：**本地环境已可用，恢复本地验证**）：子任务完成 → 本地 `flutter analyze` 零问题 + 相关 `flutter test` 全量通过（R7）→ 提交推送；**推送后不等 CI**，直接继续下一子任务；CI 仅作事后验证，失败时由主窗口整理修复任务优先处理；提交信息仅描述修改内容本身，不带任务编号/步骤
- R19 子任务完成并提交后：勾掉 PLAN.md 索引 → **删除任务文件并移除索引行**（按计划约定）
- R27 **子任务代理化执行**：所有子任务一律派发子代理执行，不占用主任务窗口交互；**同一时间只允许一个子任务在跑**，完成后才下发下一个；主窗口收到新任务时若上一子任务仍在进行，将新任务整理成任务文件加入计划**排队等待**，不并行派发

## 子任务索引

- [ ] [P15-统一弹层底座](tasks/P15-统一弹层底座.md)（排队：P08 迁移任务之后）
- [ ] [P08-组件库拆分基础库与独立组件](tasks/P08-组件库拆分基础库与独立组件.md)（**挂起：计划已细化待评审，用户明确说「执行」才开工；合并执行项：AntTabs/AntSteps 无界高度 Expanded 问题修复（P09 记录）**）

## 执行顺序（用户已确认）
P05 → P11 → P07 → P02 → P06 → P09 → P14 → P08（**与原 P11 一键 antd 化扩展合并执行**：重构时同步实现 `.antd` 扩展 + Flutter 别名层；涉及 pub.dev 账号授权时会停下交回用户；P08 仍需用户明确下令才开工）；逐个派发子代理执行，同一时间只跑一个子任务（避免 git 提交冲突），每个完成后汇报；**完成的条目直接从本行删除，不保留/不移动位置**

## 待明确问题
- P05/P06：device_preview 折叠屏支持已查证（P09 文件内）；暂无其他待明确项
- **遗留问题登记**（用户确认重构前即存在，非迁移引入，待 demo 适配批次统一处理）：example demo 页间距观感异常（macOS 桌面端桌面模式缩放因子=1，demo 页混用 const EdgeInsets 与 .w 两种间距来源导致密度不一致）

## 变更记录
| 日期 | 变更 |
|---|---|
| 2026-11-18 | 独立包拆分标准流程补充：example 创建完善（R32 全平台）+ CI 静态部署集成（deploy.yml/build_site.sh 已通用化，随包追加）
| 2026-11-17 | P08 争议组件裁决：Carousel/Masonry/ColorPicker/Select/Transfer 独立成包，Ellipsis 留 ui
| 2026-11-17 | 双远程由 GitCode 改为 Gitee；随后 **Gitee Pages 无法开通，整体回退为 GitHub 单远程**（移除 .workflow/publish 脚本/双推技能，P02 站点方案回归 GitHub Pages）
| 2026-11-17 | 文档规则改单轨脚本生成（R20/R22/R28 重写），人工文档废除；P14 排队（全量文档生成能力）
| 2026-11-17 | R22 强化（API 变更同提交更新文档）+ 新增 R28（文档命令化生成）；新增 P12（gen-docs 命令，排队）
| 2026-11-17 | 新增 R25/R26（dart 细粒度拆分+index 统一导出）；新增 P11（packages 现有包拆分，antd_flutter_plus 重构归 P08） |
| 2026-11-17 | 建立计划骨架 |
| 2026-11-17 | 新增 P01/P02（双地址+GitCode CI）、P03（主题桥接） |
| 2026-11-17 | 增加通用规则（分支/CHANGELOG/版本/质量/任务文档），新增 P04 清理 CHANGELOG |
