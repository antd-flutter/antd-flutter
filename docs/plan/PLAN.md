# antd-flutter 执行计划（内部交接文档）

> **本文件是新会话接手的唯一入口**：先读「现状快照」与「接手指南」，再按「剩余队列」串行执行。全部规则 R1-R34 在下方，派发子任务时把「子任务强制清单」原样写入子代理提示。
>
> - 子任务文件放在 `docs/plan/tasks/`，完成后**删除对应文件并移除索引引用**
> - 全部完成后：发布 1.0.0 版本（CHANGELOG 正式化/去 beta 后缀/tag/发布），然后本计划目录整体删除
> - 状态标记：`[ ]` 未开始 / `[~]` 进行中 / `[x]` 完成（完成后删任务文件与索引）

---

## 一、现状快照（2026-11-18）

### 仓库与分支
- 仓库：github.com/antd-flutter/antd-flutter（单远程 GitHub，SSH；Gitee/GitCode 双推已取消）
- **当前分支：`task/p08-split`**（P08 进行中，未合并 master）；master 停在 P08 前状态
- Flutter：fvm 3.50.0 stable；pub.dev 凭证已缓存（曾成功发布子包）
- 进行中子代理：task-p08-calendar2（antd_calendar 独立包，见「进行中」节）

### 组件总量与进度
- 全库 106 个组件（含族内合并实现）；已迁移到独立包/ui 并**用户验收 ✅ 21 个**（详见 `docs/plan/tasks/P08-验收状态表.md`）
- 基础层 10/10 ✅、通用展示+反馈约 12 ✅、独立包：antd_qrcode ✅ / antd_pull_to_refresh ✅（已更名 antd_refresh 并入 InfiniteScroll）
- 测试基线：packages/antd_refresh 59+ / antd_flutter_ui 445+ / 根包 1700+ 全过

### 包结构现状
```
packages/
├── antd_color / antd_tokens / antd_theme / antd_icons_flutter   （已发布 1.0.0/1.0.1 stable）
├── antd_flutter_ui        （基础库，19 组件已迁入 + engines/ 滚轮/键盘引擎）
├── antd_qrcode            （独立包 ✅ 验收通过，零三方依赖——qr 引擎已吸收 src/engines/qr/）
├── antd_refresh           （独立包：AntPullToRefresh 下拉刷新 + AntInfiniteScroll 上拉加载，easy_refresh 架构自研重写）
├── antd_calendar          （🚧 task-p08-calendar2 构建中：Calendar/CalendarPicker/PickerView 三组件）
└── antd_pull_to_refresh   （已删除，被 antd_refresh 替代——若目录残留属历史，删除即可）
主包 antd_flutter_plus      ← 伞包：未迁移组件仍在 lib/src/components/，已迁移组件 re-export 独立包
```

### 关键环境事实
- material_ui 迁移已完成（R24：全库禁 flutter/material.dart import）
- iOS 模拟器无需证书；iPhone Duo 折叠模拟器 UDID `5E6064EC-2C07-4150-9DF7-941C74669629`（Xcode 26 模拟器界面在 DeviceHub.app）
- macOS example 验收窗口已固定 1728×1080（example/macos/Runner/MainFlutterWindow.swift）
- pub.dev 已发布：antd_color/antd_tokens/antd_theme 1.0.0、antd_icons_flutter 1.0.1、antd_flutter_plus 1.0.0-beta.2（伞包停用声明页 README，待拆分完成后按新结构重新发布）
- example 亮暗/命名规范脚本：scripts/setup_example_identity.sh（R32.2）
- 文档生成：scripts/gen_docs.sh（R20/R28，8 包 api-index 全绿）

---

## 二、新会话接手指南

1. 读本文件全文 + `docs/plan/tasks/P08-验收状态表.md`（逐组件验收 ✅ 跟踪）
2. `git branch --show-current` 确认分支；`git status` 检查进行中子代理是否残留未提交文件（有则按其任务文档裁决收尾）
3. 按「剩余队列」**串行**派发子代理（R27），每个子代理提示必须原样包含下方「子任务强制清单」
4. 每个子任务完成：定向 add 提交推送 → 更新验收状态表 ✅ → 用户验收 → 下一项
5. 全部完成后执行「发布 1.0.0」总任务，最后删除本计划目录

---

## 三、通用规则（R1-R34，全部有效）

### 分支与提交
- R1 同组子任务共用一个任务分支（如 task/p08-split）；R2 本地验证通过即合并 **develop** 删分支（不等 CI）；develop 在里程碑/发布时合并 master；R3 实验分支不推远程
- R17 子任务模式：一次一个完整子任务，中途不询问；R27 所有子任务派子代理执行、同一时间只跑一个、新任务排队等待

### 验证与质量
- R7 analyze 零问题 + test 全过；R8 新功能带测试；R9 最小改动
- R18 验证策略：本地 analyze/test 通过即提交推送，**推送后不等 CI**；CI 失败由主窗口整理修复任务优先处理
- R23 禁用 golden 图像快照测试（视觉由用户 example 页人工抽查）；默认参数值用普通单测断言

### 版本与 CHANGELOG
- R4/R5 CHANGELOG 只在正式发布时写正式内容（beta 记录在任务文档）
- R6 预发布统一 `1.0.0-beta.xxx` 递增；beta 后缀消失即正式发布

### 任务文档
- R10 子任务文件 `P<n>-<标题>.md`；R19 完成后删文件移索引；R11 CHANGELOG 留正式发布统一执行

### 组件库设计
- R12 平台判断统一入口在 antd_theme（AntPlatform 已下沉）；严禁 `Platform.isOhos`
- R13 全局状态变化走局部刷新通知（值相等去重）
- R14 example 正式形态：国际化中英文 + 明暗切换 + 嵌入模式（URL 参数）
- R15 example 自举替换 antd 组件；R16 三方 SDK 经中间层隔离（AntOhosChannel 模式）
- R25/R26 dart 文件细粒度拆分（config//enum/ 分层）+ index.dart 统一导出
- R29 编码基类沉淀（重复逻辑抽取基类，禁复制粘贴式实现）
- R33 sliver 家族判定：滚动集合类组件必须提供 sliver 支持（Masonry→AntSliverMasonry；Grid/List 经 adapt 层）；overlay/包裹/固定布局类不需要

### 文档
- R20/R28 文档单轨脚本生成（gen-docs 从 /// 注释生成，不设人工文档；人工只维护 /// 注释）
- R21/R22 静态页面产出、文档随代码走、改 API 同提交更新文档
- R34 独立组件包文案国际化：内建 locale 机制，默认中文，常用语言全集内置（zh/en/ja/ko/fr/de/es/ru/pt/it/ar），已有包 antd_refresh 已落地
- R35 **Flutter Controller 模式规范（用户指定）**：受控/可编程操作的组件必须遵循 Flutter 编码惯例——暴露 **Controller 类**（如 ScrollController/EasyRefreshController 模式），通过 controller 调用开启/关闭/刷新等操作，不依赖 GlobalKey hack 或内部状态直改；**性能**：局部刷新用 ListenableBuilder/ValueListenableBuilder 等（对应 R13），禁止整页 setState
- R35.1 **已实现组件统一排查改造（用户指定，一次性）**：P08 当前子任务完成后，对所有已实现组件统一排查一轮——不符合 Controller 模式/局部刷新规范的逐个修正；后续新组件开发直接按 R35 实现

### 轮子与实现优先级
- R30 实现前先查轮子（pub.dev 搜索成熟实现，源码研究改造吸收优于直接依赖；License 合规注明）
- R30.1 轮子参考清单（实现对应组件时必须先研究该轮子源码）：
  - AntTable → pluto_grid / syncfusion_flutter_datagrid
  - AntImageViewer → photo_view
  - AntCarousel（antd_carousel 独立包）→ carousel_slider
  - AntMasonry（antd_masonry 独立包）→ flutter_staggered_grid_view（含 SliverMasonryGrid，R33 联动）
  - AntInfiniteScroll → infinite_scroll_pagination（已在 antd_refresh 落地）
  - AntTour → tutorial_coach_mark
  - AntCalendar（antd_calendar 独立包）→ table_calendar（已确认吸收，task-p08-calendar2 执行中）
  - AntPullToRefresh → pull_to_refresh_flutter3（✅ 已改造完成）
  - AntSwipeAction → flutter_swipe_action_cell（✅ 已改造完成，Apache-2.0）
  - 弹层底座 → popover（P15 立项吸收）
  - Picker 族滚轮引擎 → 系统 CupertinoPicker 继承评估（R31 第一优先级）
- R30.2 迁移时直接改造吸收，一步到位（禁止先搬家再二次改造）
- R30.3 有轮子优先**完全仿造轮子实现**（完整移植复刻+类名前缀改造），验证后在其上实现 antd 封装（antd_refresh 模式）；部分吸收仅作次选
- R31 样式实现优先级：① 继承 Flutter 系统组件（适配层 extends 模式）② pub.dev 高星轮子改造吸收 ③ 自研自绘——迁移直接执行
- R32 独立包自建 example 全平台（iOS/Android/macOS/Windows/Linux/Web + CI）；R32.1 README 只写功能介绍/安装/用法/文档链接（不含部署构建）；R32.2 图标统一 SVG 生成 + 名称大驼峰不含 example；统一脚本 scripts/setup_example_identity.sh

### example 与文案
- R34 独立组件包文案国际化：内建 locale 机制默认中文，常用语言全集（zh/en/ja/ko/fr/de/es/ru/pt/it/ar）；antd_refresh 已落地，后续独立包按此实现
- R24 import 统一 `package:material_ui/material_ui.dart`（禁 flutter/material.dart；cupertino 同理 cupertino_ui）

### git 纪律（双向）
- 子任务只 add 自己的文件，严禁 `git add -A`/`git add .`；提交前 `git status --short` 逐项核对
- lead 在子代理运行期间同样只定向 add；严禁 pkill 用户的 flutter 会话

---

## 四、子任务强制清单（派发子代理时原样写入提示）

1. **example 同步三件套**：① nav_data 恢复/新增该组件 NavItem ② migration_status.dart 加入 kPendingVerify ③ demo 页渲染确认（历史教训：五次漏入口）
2. 验证范围：目标包 analyze/test + example analyze/build web；不验证根包（最终统一回归兜底）
3. 验证平台：macOS + iOS 模拟器，不用 web；双实现组件开双端
4. flutter 命令限制：禁止 flutter run；严禁 pkill 用户会话；锁冲突等待 1-2 分钟重试
5. 验收流转：验收状态表标 ✅ + kPendingVerify 移入 kMigratedVerified（两处同步）
6. R29-R33 全部适用
7. git add 纪律双向：严禁 add -A，定向 add + 逐项核对
8. R30.2 迁移即改造：R30.1 清单组件迁移时同步完成轮子改造吸收

---

## 五、进行中任务

### [~] P08-组件库拆分（task-p08-calendar2 子代理执行中）
- 分支 task/p08-split；文档：docs/plan/tasks/P08-组件库拆分基础库与独立组件.md（含完整执行规则与强制清单）
- **本子任务范围**：建包 packages/antd_calendar（Calendar/CalendarPicker/PickerView 三组件合入，用户裁决）+ 双实现（桌面 fullscreen/移动 card 经 AntResponsive）+ 增强能力全做（月/两周/周格式切换、range 范围选择、多选、事件点标记、头部年月下拉快速跳转；吸收 table_calendar 源码，Apache-2.0）+ 主包 re-export 切换 + gen-docs + example 兼容
- 完成后：验收状态表更新 → 用户验收 → 继续下方队列

### 验收状态表
docs/plan/tasks/P08-验收状态表.md（逐组件 ✅ 跟踪，用户验收后更新）

---

## 六、剩余队列（按复杂度重排：简单先行、复杂靠后——用户指定）

> 每项一个子任务串行执行（R27），迁移即改造（R30.2），按 R30.1 轮子参考；完成后更新验收状态表 + example 入口 + 标 ⏱ 待用户验收

1. **PageIndicator**（ui 迁移，最简单分页指示器）
2. **P15 弹层底座**（popover 算法吸收 → popup_engine；AntTooltip 箭头异常一并修复——用户反馈待修）
3. **弹层族迁移**：AntPopover / AntDropdown（迁 ui + 接入弹层底座；AntTooltip 已在 ui）
4. **antd_splitter**（独立包：拖拽分割引擎）
5. **antd_image_viewer**（独立包：photo_view 缩放改造；AntImage 本体已迁 ui）
6. **AntTour 迁移**（tutorial_coach_mark 挖孔引导参考）
7. **antd_upload**（独立包：文件选择/上传队列体系）
8. **Cascader/CascaderView**（级联选择逻辑，归 antd_picker 族）
9. **antd_picker**（Picker/DatePicker/TimePicker——滚轮引擎 CupertinoPicker 继承评估 R31；CalendarPicker 已归 antd_calendar）
10. **antd_tree**（Tree/TreeSelect 树引擎）
11. **antd_carousel**（独立包：carousel_slider 页面变换参考）
12. **antd_masonry**（独立包：staggered_grid_view 瀑布流 + sliver 变体 R33）
13. **antd_floating**（FloatingPanel/FloatingBubble 拖拽吸附引擎）
14. **AntInfiniteScroll 增强**（infinite_scroll_pagination 分页状态参考，已在 antd_refresh 基础上增强）
15. **antd_form**（表单状态/校验引擎）
16. **Transfer**（穿梭框复杂交互，归 antd_form 或独立评估）
17. **antd_table**（pluto_grid——最复杂组件，最后拆分）
18. **Calendar 完善**（⏱ 待验证项：双 UI 一致性 + 增强能力打磨，验收后闭环）
19. 全量回归 + 伞包 README 更新（拆分后接入方式）
20. **发布 1.0.0**（总任务：CHANGELOG 正式化/去 beta/tag/发布，pub.dev 授权停下交用户）

## 七、遗留问题登记
- example demo 页间距观感异常（macOS 桌面模式因子=1，const EdgeInsets 与 .w 混用密度不一致）——待 demo 适配批次统一处理
- AntTabs/AntSteps 无界高度 Expanded bug——已并入 P08 合并执行范围
- device_preview 3.0.0 与 Flutter 3.50 不兼容（PreviewPlatformDispatcher 未实现 resetInternalState），当前用 1.3.1，待上游适配升级

---

## 八、关键文件与脚本索引
- 验收状态表：docs/plan/tasks/P08-验收状态表.md
- P08 审计与清单：docs/plan/tasks/P08-audit-依赖审计与拆分清单.md
- P08 执行规则与强制清单：docs/plan/tasks/P08-组件库拆分基础库与独立组件.md
- P15 弹层底座：docs/plan/tasks/P15-统一弹层底座.md
- 脚本：scripts/gen_docs.sh（文档生成，--pkg 参数）、scripts/setup_example_identity.sh（example 图标/命名）、scripts/build_site.sh（站点合并）
- 轮子源码参考：.temp/easy_refresh_src/（easy_refresh 3.5.1）、.temp/ant-design/（antd v6）、.temp/ant-design-mobile/（antd-mobile v5）
- 迁移状态驱动：example/lib/data/migration_status.dart（kPendingVerify/kMigratedVerified 清单）

## 变更记录
| 日期 | 变更 |
|---|---|
| 2026-11-18 | **本文件重写为独立交接文档**：现状快照/接手指南/规则汇总（R1-R34 去重）/剩余队列/强制清单/文件索引；P08 进行中状态（calendar2）与剩余队列整理；GitCode 待办取消 |
| 2026-11-18 | 独立包拆分标准流程补充：example 创建完善（R32 全平台）+ CI 静态部署集成（deploy.yml/build_site.sh 已通用化，随包追加）
| 2026-11-17 | P08 争议组件裁决：Carousel/Masonry/ColorPicker/Select/Transfer 独立成包，Ellipsis 留 ui
| 2026-11-17 | 双远程由 GitCode 改为 Gitee；随后 **Gitee Pages 无法开通，整体回退为 GitHub 单远程**（移除 .workflow/publish 脚本/双推技能，P02 站点方案回归 GitHub Pages）
| 2026-11-17 | 文档规则改单轨脚本生成（R20/R22/R28 重写），人工文档废除；P14 排队（全量文档生成能力）
| 2026-11-17 | R22 强化（API 变更同提交更新文档）+ 新增 R28（文档命令化生成）；新增 P12（gen-docs 命令，排队）
| 2026-11-17 | 新增 R25/R26（dart 细粒度拆分+index 统一导出）；新增 P11（packages 现有包拆分，antd_flutter_plus 重构归 P08） |
| 2026-11-17 | 建立计划骨架 |
| 2026-11-17 | 新增 P01/P02（双地址+GitCode CI）、P03（主题桥接） |
| 2026-11-17 | 增加通用规则（分支/CHANGELOG/版本/质量/任务文档），新增 P04 清理 CHANGELOG |
