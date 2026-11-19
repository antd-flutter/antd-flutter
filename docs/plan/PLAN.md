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
  - 排查/改造组件清单：AntPullToRefresh（现 GlobalKey State.callRefresh → AntRefreshController 类 R35.2 化）、AntInfiniteScroll、AntCalendar/AntCalendarPicker（受控 visible/value）、AntSegmented（受控 value）、AntTooltip/AntPopover/AntPopconfirm/AntDropdown（p15-ctrl 四弹层 Controller 改造已覆盖）、AntFloatingPanel/AntFloatingBubble、AntDropdown 等——逐个对照 Flutter Controller 惯例修正
- R35.2 **Controller 优先，减少 key/state 引用（用户指定）**：受控模式的操作入口优先使用 **Controller 类**（如 AntTooltipController.show()/hide()），减少 GlobalKey 与外部 state 引用（除非必要）；已实现组件统一排查改造一轮（Tooltip/Popover/Popconfirm/Dropdown 受控模式首批）
- R35.3 **独立包 example 运行验证（用户指定）**：每个独立包 example 创建后，必须执行一次 `flutter run -d macos` 真机验证（正常启动、页面渲染、交互无报错），验证通过后退出自身启动的进程再收尾；「不要 flutter run」纪律针对的是用户正在跑的会话，独立包 example 的启动验证不受此限（跑完即退，不占用户会话）
- R35.4 **独立包 example 多平台 UI 适配（用户指定）**：独立包 example 不只是创建目录——demo UI 必须做多平台适配（AntResponsive 断点：desktop 宽屏布局 / phone 窄屏布局自适应、暗色切换、窗口缩放无溢出），验证覆盖 macOS + 移动端形态
- R37 **全局热键系统（用户指定，底层基础设施）**：热键系统是**底层能力**——**任何控件都应该可以挂接热键**，让用户可以基于热键操作控件。落地形态：
  - ui 层提供通用热键基础设施：`AntHotkeys` 包裹 widget / `HotkeyRegistry` 注册中心（KeyboardEvent 监听 + 热键绑定 → 触发控件动作/回调），开发者可对**任意控件**绑定任意快捷键组合
  - 组件内建默认绑定示例：弹层类 Esc 关闭（Tooltip/Popover/Popconfirm/Dropdown/Dialog/Drawer/Modal/Toast/Message/Notification/ActionSheet/TreeSelect/Cascader/CalendarPicker 等，关闭操作最常见优先）
  - 其余控件按语义提供可选热键入口；桌面端优先

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
  - AntNumberKeyboard 虚拟键盘 → flutter_onscreen_keyboard（布局/按键行为/长按连续删除参考，用户指定）
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

## 六、剩余队列（批次制——用户指示：ui 归属基础组件先行迁移，独立包拆分靠后）

> **组件去向规则（严格遵守）**：最终归属 ui 的组件先迁入 ui；最终去向为独立包的组件不经过 ui 中转，轮到时直接从主包拆独立包。**批次 0（ui 基础组件迁移）全部完成并验收后，才开始批次 1 起的独立包拆分。**

> **验收流程调整（用户指定）**：子任务完成后**不再逐批等待用户验收**，lead 按队列自动继续推进；**所有验收集中放在发布 1.0.0 前**统一进行（验收状态表照常维护 ⏱ 标记，批次 0 的「验收后才开始」语义调整为「迁移完成后」）
> **Calendar 全量功能完善（用户指定，提前执行）**：桌面端对齐 antd v6 Calendar 全量功能 + 移动端对齐 antd-mobile Calendar 全量功能——**功能完整实现**，样式不强制完全遵循 antd 对应样式（按我们的 token 体系呈现）；提前至批次 0 收尾后立即执行

### 批次 0：plus 剩余基础组件迁入 ui（用户指示先行，约 55+ 组件，8 小批串行）
> 主包 lib/src/components/ 尚有 feedback 17 / data_entry 24 / data_display 6 / navigation 12 / misc+general 5 未迁，全部 ui 归属。每小批：git mv → barrel/re-export → 三件套（nav ⏱ + demo 接线）→ analyze/test/build 全绿再下一批：
> - 0-1 反馈非弹层族：alert / error_block / loading / mask / progress / result / result_page / skeleton / spin
> - 0-2 反馈弹层族：dialog / drawer / modal / popup / action_sheet / toast / message / notification（弹层接 popup_engine 基座）
> - 0-3 录入简单族：checkbox / radio / rate / slider / switch / stepper / input / input_number / search_bar / check_list / selector / number_keyboard / passcode_input / virtual_input / image_uploader
> - 0-4 select-like 族：select / color_picker / auto_complete / mentions（统一接 popup_engine 底座——已立项估算项在此落地）
> - 0-5 数据展示残余：collapse / descriptions / list / timeline
> - 0-6 导航族：tabs / capsule_tabs / tab_bar / steps / jumbo_tabs / side_bar / menu / nav_bar / pagination / anchor / breadcrumb / index_bar（含 AntTabs/AntSteps 无界高度 bug 修复）
> - 0-7 misc/general：affix / app / config_provider / border_beam / float_button
> - 0-8 压轴：form / transfer / table（复杂表单与表格引擎）

### 批次 1：antd_picker 独立包 ✅ 已完成
### 批次 2 前插（用户指定，优先级最高）：antd_keyboard 独立包
键盘族功能增强后功能强大（通用 AntKeyboard 引擎 + 全布局吸收 + 桌面形态），**单独成包**：packages/antd_keyboard/——从 ui 迁出（通用键盘引擎 + AntNumberKeyboard/PasscodeInput/VirtualInput 三组件；引擎随包走不入 ui engines），标准五件套（example R35.4 多平台适配 + R32.2 AntdKeyboard + CI + re-export 链调整 + R33 判定 + R35.3 macos 验证）。**批次 0-3 迁移任务（a23）完成后立即执行（同文件域串行）**，其后才继续批次 2 其余项。

### 批次 2：独立包直接从主包拆分（逐个串行）
1. **antd_tree** ✅（Tree/TreeSelect）
2. **antd_carousel** ✅
3. **antd_masonry** ✅（含 AntSliverMasonry sliver 变体 R33）
4. **antd_floating** 🔧 进行中
5. **antd_form**（表单相关独立包评估——0-8 已将 form/transfer 迁 ui，此处从 ui 拆出）
5b. **antd_transfer**（用户指定追加：从 ui 拆出，标准五件套 + R32.2 AntdTransfer）
6. **antd_table**（压轴，从 ui 拆出；pluto_grid 参考）

### 批次 3：收尾
0. **组件自举替换（用户指定，验收前必做）**：排查所有组件内部使用的非 antd 组件（Material/Cupertino 原生 widget，如内部按钮用了 Material ElevatedButton/IconButton、开关用了 Material Switch 等），**存在对应 antd 实现的一律替换为 antd 组件**（自举），行为保持不变；无对应 antd 实现的保留原生并登记清单
1. **R37 全局热键系统**：全部迁移完成后统一落地（弹层类 Esc 关闭优先，ui 层统一基础设施）
2. select-like 族统一 popup_engine 底座收尾核查（TreeSelect ✅ 已接；Cascader/AutoComplete/ColorPicker/Mentions 核查）
2. Calendar 完善（⏱：双 UI 一致性打磨）
3. 全量回归 + 伞包 antd_flutter_plus README（全量伞包/单组件包两种接入方式）
3b. **全部 example 身份脚本终跑 + 全量 gen-docs 重新生成（用户指定）**：所有 example（含根 example/伞包）统一跑 setup_example_identity.sh（icon/BundleID com.antd.<x>/显示名/壳名）+ scripts/gen_docs.sh 全量重跑（API 文档与代码同步终态）——发布前终态固化

### 批次 4：发布 1.0.0
CHANGELOG 正式化/去 beta/tag/发布（pub.dev 授权停下交用户）


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
