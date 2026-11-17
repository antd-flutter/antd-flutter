# P08-audit 依赖审计与拆分清单

- 状态：`[ ]`
- 分支：`task/p08-split`；上游文档：[P08-组件库拆分基础库与独立组件.md](P08-组件库拆分基础库与独立组件.md)
- 产出方式：脚本真实扫描（脚本见 `.temp/p08audit/`：`scan.sh` / `audit.py` / `gen_doc.py`，原始数据 `audit.json` / `scan_result.txt`），禁止凭印象编造
- **组件总数：106 个组件目录**（任务文档口径 111，实际扫描 `lib/src/components/*/*` 为 106 个；差异原因：部分目录为族内合并实现，如 `cascader` 含 Cascader+CascaderView、`number_keyboard` 族另有独立目录；本清单以扫描到的 106 为准，逐个落位）
- 扫描时间基线：分支 `task/p08-split` 当前 HEAD

## 0. 扫描口径说明
- 组件 = `lib/src/components/<分类>/<组件目录>/`；跨组件依赖 = 该目录 dart 文件 import 的**其他组件目录**的源码（import 自身目录内文件不计）
- 三方依赖 = 非 `dart:`、非 `flutter`、非 `antd_flutter_plus` 的 package import；其中 `antd_theme`/`antd_color`/`antd_icons_flutter`/`antd_tokens` 为**已独立基础包**（按目标结构属允许的底层依赖），`material_ui` 为内部实现依赖库，真正需要隔离的「重三方」为 `qr_flutter` / `cached_network_image` / `cupertino_ui`

## A. 依赖审计矩阵

### A1. 汇总统计（脚本统计值）
- 组件总数：106
- 跨组件依赖：**10 条边，8 个消费方组件，7 个被依赖组件**（依赖边明细见 A2）
- 全组件共通依赖：`material_ui` 106/106、`antd_theme` 102/106（其余经间接引用），属基础层公共依赖，随 antd_flutter_ui 底层统一承接
- 真正的三方依赖分布：
  - `qr_flutter` × 1：data_display/qr_code
  - `cached_network_image` × 2：data_display/image、data_display/image_viewer
  - `cupertino_ui` × 1：data_entry/picker（滚轮样式参考）
  - `antd_icons_flutter` × 5：general/float_button、general/notice_bar、general/typography、layout/layout、layout/splitter
  - `antd_color` × 1：general/button

### A2. 跨组件依赖边（全量，共 10 条）

| 消费方组件 | 被依赖组件 | 说明 |
|---|---|---|
| data_display/list | data_display/empty | List 空态插槽复用 Empty |
| data_display/tour | general/button | Tour 引导按钮复用 Button |
| data_entry/passcode_input | data_entry/number_keyboard | 格子输入复用虚拟键盘引擎 |
| data_entry/transfer | data_entry/checkbox | 穿梭框复用 Checkbox |
| data_entry/virtual_input | data_entry/number_keyboard | 虚拟输入复用虚拟键盘引擎 |
| feedback/modal | general/button | Modal 操作按钮复用 Button |
| feedback/popconfirm | general/button | Popconfirm 按钮复用 Button |
| misc/app | feedback/message | App 全局挂载 message |
| misc/app | feedback/modal | App 全局挂载 modal |
| misc/app | feedback/notification | App 全局挂载 notification |

> **关键结论**：包内耦合极低（仅 10 条边），且全部指向 Button / Empty / Checkbox / NumberKeyboard / Message-Modal-Notification 等基础库组件或族内组件——按目标结构拆分后，**独立包之间零互相依赖可自然达成**（族内依赖随族整体搬迁）

### A3. 逐组件审计矩阵（106 行，按分类排序）

列说明：**行数/文件数**为该目录 dart 文件真实统计；**包内依赖**为跨组件 import；**三方**为非官方 package import；**命中**为准入标准条数（1-5，详见 B 节打分）

| 组件 | 现目录 | 行数/文件 | 包内依赖 | 三方依赖 | 命中 |
|---|---|---|---|---|---|
| avatar | data_display/avatar | 324/2 | — | — | 1 |
| badge | data_display/badge | 217/2 | — | — | 0 |
| calendar | data_display/calendar | 385/2 | — | — | 2 |
| card | data_display/card | 303/2 | — | — | 1 |
| carousel | data_display/carousel | 496/2 | — | — | 2 |
| collapse | data_display/collapse | 328/2 | — | — | 1 |
| descriptions | data_display/descriptions | 425/2 | — | — | 1 |
| ellipsis | data_display/ellipsis | 219/2 | — | — | 1 |
| empty | data_display/empty | 181/2 | — | — | 0 |
| floating_bubble | data_display/floating_bubble | 303/2 | — | — | 3 |
| floating_panel | data_display/floating_panel | 233/2 | — | — | 2 |
| footer | data_display/footer | 75/2 | — | — | 0 |
| image | data_display/image | 525/2 | — | cached_network_image | 2 |
| image_viewer | data_display/image_viewer | 404/2 | — | cached_network_image | 4 |
| infinite_scroll | data_display/infinite_scroll | 320/2 | — | — | 1 |
| list | data_display/list | 393/2 | empty | — | 2 |
| page_indicator | data_display/page_indicator | 168/2 | — | — | 0 |
| popover | data_display/popover | 705/2 | — | — | 1 |
| qr_code | data_display/qr_code | 244/2 | — | qr_flutter | 3 |
| segmented | data_display/segmented | 443/2 | — | — | 1 |
| statistic | data_display/statistic | 321/2 | — | — | 1 |
| table | data_display/table | 1135/2 | — | — | 4 |
| tag | data_display/tag | 200/2 | — | — | 0 |
| timeline | data_display/timeline | 430/2 | — | — | 1 |
| tooltip | data_display/tooltip | 681/2 | — | — | 1 |
| tour | data_display/tour | 811/2 | button | — | 4 |
| tree | data_display/tree | 522/2 | — | — | 3 |
| auto_complete | data_entry/auto_complete | 440/2 | — | — | 1 |
| calendar_picker | data_entry/calendar_picker | 679/2 | — | — | 3 |
| cascader | data_entry/cascader | 948/3 | — | — | 3 |
| check_list | data_entry/check_list | 256/2 | — | — | 0 |
| checkbox | data_entry/checkbox | 455/2 | — | — | 1 |
| color_picker | data_entry/color_picker | 932/2 | — | — | 2 |
| date_picker | data_entry/date_picker | 521/2 | — | — | 3 |
| form | data_entry/form | 779/2 | — | — | 3 |
| image_uploader | data_entry/image_uploader | 366/2 | — | — | 2 |
| input | data_entry/input | 1055/2 | — | — | 1 |
| input_number | data_entry/input_number | 450/2 | — | — | 1 |
| mentions | data_entry/mentions | 525/2 | — | — | 1 |
| number_keyboard | data_entry/number_keyboard | 321/2 | — | — | 3 |
| passcode_input | data_entry/passcode_input | 249/2 | number_keyboard | — | 1 |
| picker | data_entry/picker | 531/3 | — | cupertino_ui | 3 |
| radio | data_entry/radio | 609/2 | — | — | 1 |
| rate | data_entry/rate | 237/2 | — | — | 0 |
| search_bar | data_entry/search_bar | 327/2 | — | — | 1 |
| select | data_entry/select | 707/2 | — | — | 2 |
| selector | data_entry/selector | 293/2 | — | — | 0 |
| slider | data_entry/slider | 354/2 | — | — | 1 |
| stepper | data_entry/stepper | 342/2 | — | — | 1 |
| switch | data_entry/switch | 209/2 | — | — | 0 |
| time_picker | data_entry/time_picker | 534/2 | — | — | 3 |
| transfer | data_entry/transfer | 757/2 | checkbox | — | 2 |
| tree_select | data_entry/tree_select | 625/2 | — | — | 3 |
| upload | data_entry/upload | 694/2 | — | — | 2 |
| virtual_input | data_entry/virtual_input | 242/2 | number_keyboard | — | 1 |
| action_sheet | feedback/action_sheet | 402/2 | — | — | 1 |
| alert | feedback/alert | 290/2 | — | — | 0 |
| dialog | feedback/dialog | 629/2 | — | — | 1 |
| drawer | feedback/drawer | 403/2 | — | — | 1 |
| error_block | feedback/error_block | 344/2 | — | — | 1 |
| loading | feedback/loading | 187/2 | — | — | 0 |
| mask | feedback/mask | 160/2 | — | — | 0 |
| message | feedback/message | 378/2 | — | — | 1 |
| modal | feedback/modal | 534/2 | button | — | 1 |
| notification | feedback/notification | 499/2 | — | — | 1 |
| popconfirm | feedback/popconfirm | 645/2 | button | — | 1 |
| popup | feedback/popup | 460/2 | — | — | 1 |
| progress | feedback/progress | 329/2 | — | — | 1 |
| pull_to_refresh | feedback/pull_to_refresh | 366/2 | — | — | 3 |
| result | feedback/result | 224/2 | — | — | 0 |
| result_page | feedback/result_page | 222/2 | — | — | 0 |
| skeleton | feedback/skeleton | 307/2 | — | — | 1 |
| spin | feedback/spin | 208/2 | — | — | 0 |
| swipe_action | feedback/swipe_action | 303/2 | — | — | 3 |
| toast | feedback/toast | 372/2 | — | — | 1 |
| watermark | feedback/watermark | 288/2 | — | — | 0 |
| button | general/button | 1239/6 | — | antd_color | 1 |
| float_button | general/float_button | 700/2 | — | antd_icons_flutter | 1 |
| notice_bar | general/notice_bar | 608/2 | — | antd_icons_flutter | 1 |
| typography | general/typography | 934/2 | — | antd_icons_flutter | 1 |
| auto_center | layout/auto_center | 53/1 | — | — | 0 |
| divider | layout/divider | 437/2 | — | — | 1 |
| flex | layout/flex | 268/2 | — | — | 0 |
| grid | layout/grid | 283/2 | — | — | 0 |
| layout | layout/layout | 403/2 | — | antd_icons_flutter | 1 |
| masonry | layout/masonry | 240/2 | — | — | 3 |
| safe_area | layout/safe_area | 111/2 | — | — | 0 |
| space | layout/space | 296/2 | — | — | 0 |
| splitter | layout/splitter | 699/2 | — | antd_icons_flutter | 3 |
| affix | misc/affix | 181/2 | — | — | 0 |
| app | misc/app | 353/2 | message, modal, notification | — | 1 |
| border_beam | misc/border_beam | 243/2 | — | — | 0 |
| config_provider | misc/config_provider | 188/2 | — | — | 0 |
| anchor | navigation/anchor | 358/2 | — | — | 1 |
| breadcrumb | navigation/breadcrumb | 164/2 | — | — | 0 |
| capsule_tabs | navigation/capsule_tabs | 207/2 | — | — | 0 |
| dropdown | navigation/dropdown | 456/2 | — | — | 1 |
| index_bar | navigation/index_bar | 294/2 | — | — | 0 |
| jumbo_tabs | navigation/jumbo_tabs | 233/2 | — | — | 0 |
| menu | navigation/menu | 546/2 | — | — | 1 |
| nav_bar | navigation/nav_bar | 127/1 | — | — | 0 |
| pagination | navigation/pagination | 460/2 | — | — | 1 |
| side_bar | navigation/side_bar | 249/2 | — | — | 0 |
| steps | navigation/steps | 431/2 | — | — | 1 |
| tab_bar | navigation/tab_bar | 273/2 | — | — | 0 |
| tabs | navigation/tabs | 650/2 | — | — | 1 |

## B. 拆分清单（最终去向表）

准入标准（与上游文档一致）：①功能复杂度 ②依赖隔离度 ③独立使用场景 ④独立演进需求 ⑤体积影响；**独立包硬性至少命中 3 条**

### B1. antd_flutter_ui（基础组件库）

| 组件 | 现目录 | 去向分组 | 命中 | 理由 |
|---|---|---|---|---|
**基础层**

| button | general/button | 基础层 | 1 | ①功能复杂度(代码量1239行,显著高于均值) |
| typography | general/typography | 基础层 | 1 | ①功能复杂度(代码量934行,显著高于均值) |
| auto_center | layout/auto_center | 基础层 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| divider | layout/divider | 基础层 | 1 | ①功能复杂度(代码量437行,偏高) |
| flex | layout/flex | 基础层 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| grid | layout/grid | 基础层 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| layout | layout/layout | 基础层 | 1 | ①功能复杂度(代码量403行,偏高) |
| safe_area | layout/safe_area | 基础层 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| space | layout/space | 基础层 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| affix | misc/affix | 基础层 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |

**通用展示**

| avatar | data_display/avatar | 通用展示 | 1 | ①功能复杂度(代码量324行,偏高) |
| badge | data_display/badge | 通用展示 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| card | data_display/card | 通用展示 | 1 | ①功能复杂度(代码量303行,偏高) |
| carousel | data_display/carousel | 通用展示 | 2 | ①功能复杂度(代码量496行,偏高)；③独立使用场景(存在大量单组件接入场景) |
| collapse | data_display/collapse | 通用展示 | 1 | ①功能复杂度(代码量328行,偏高) |
| descriptions | data_display/descriptions | 通用展示 | 1 | ①功能复杂度(代码量425行,偏高) |
| ellipsis | data_display/ellipsis | 通用展示 | 1 | ③独立使用场景(存在大量单组件接入场景) |
| empty | data_display/empty | 通用展示 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| footer | data_display/footer | 通用展示 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| image | data_display/image | 通用展示 | 2 | ①功能复杂度(代码量525行,显著高于均值)；②依赖隔离(自带三方: cached_network_image) |
| infinite_scroll | data_display/infinite_scroll | 通用展示 | 1 | ①功能复杂度(代码量320行,偏高) |
| list | data_display/list | 通用展示 | 2 | ①功能复杂度(代码量393行,偏高)；③独立使用场景(存在大量单组件接入场景) |
| page_indicator | data_display/page_indicator | 通用展示 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| popover | data_display/popover | 通用展示 | 1 | ①功能复杂度(代码量705行,显著高于均值) |
| segmented | data_display/segmented | 通用展示 | 1 | ①功能复杂度(代码量443行,偏高) |
| statistic | data_display/statistic | 通用展示 | 1 | ①功能复杂度(代码量321行,偏高) |
| tag | data_display/tag | 通用展示 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| timeline | data_display/timeline | 通用展示 | 1 | ①功能复杂度(代码量430行,偏高) |
| tooltip | data_display/tooltip | 通用展示 | 1 | ①功能复杂度(代码量681行,显著高于均值) |
| watermark | feedback/watermark | 通用展示 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| float_button | general/float_button | 通用展示 | 1 | ①功能复杂度(代码量700行,显著高于均值) |
| notice_bar | general/notice_bar | 通用展示 | 1 | ①功能复杂度(代码量608行,显著高于均值) |
| border_beam | misc/border_beam | 通用展示 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| anchor | navigation/anchor | 通用展示 | 1 | ①功能复杂度(代码量358行,偏高) |
| breadcrumb | navigation/breadcrumb | 通用展示 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| capsule_tabs | navigation/capsule_tabs | 通用展示 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| dropdown | navigation/dropdown | 通用展示 | 1 | ①功能复杂度(代码量456行,偏高) |
| index_bar | navigation/index_bar | 通用展示 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| jumbo_tabs | navigation/jumbo_tabs | 通用展示 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| menu | navigation/menu | 通用展示 | 1 | ①功能复杂度(代码量546行,显著高于均值) |
| nav_bar | navigation/nav_bar | 通用展示 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| pagination | navigation/pagination | 通用展示 | 1 | ①功能复杂度(代码量460行,偏高) |
| side_bar | navigation/side_bar | 通用展示 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| steps | navigation/steps | 通用展示 | 1 | ①功能复杂度(代码量431行,偏高) |
| tab_bar | navigation/tab_bar | 通用展示 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| tabs | navigation/tabs | 通用展示 | 1 | ①功能复杂度(代码量650行,显著高于均值) |

**通用录入**

| auto_complete | data_entry/auto_complete | 通用录入 | 1 | ①功能复杂度(代码量440行,偏高) |
| check_list | data_entry/check_list | 通用录入 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| checkbox | data_entry/checkbox | 通用录入 | 1 | ①功能复杂度(代码量455行,偏高) |
| color_picker | data_entry/color_picker | 通用录入 | 2 | ①功能复杂度(代码量932行,显著高于均值)；③独立使用场景(存在大量单组件接入场景) |
| input | data_entry/input | 通用录入 | 1 | ①功能复杂度(代码量1055行,显著高于均值) |
| input_number | data_entry/input_number | 通用录入 | 1 | ①功能复杂度(代码量450行,偏高) |
| mentions | data_entry/mentions | 通用录入 | 1 | ①功能复杂度(代码量525行,显著高于均值) |
| radio | data_entry/radio | 通用录入 | 1 | ①功能复杂度(代码量609行,显著高于均值) |
| rate | data_entry/rate | 通用录入 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| search_bar | data_entry/search_bar | 通用录入 | 1 | ①功能复杂度(代码量327行,偏高) |
| select | data_entry/select | 通用录入 | 2 | ①功能复杂度(代码量707行,显著高于均值)；③独立使用场景(存在大量单组件接入场景) |
| selector | data_entry/selector | 通用录入 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| slider | data_entry/slider | 通用录入 | 1 | ①功能复杂度(代码量354行,偏高) |
| stepper | data_entry/stepper | 通用录入 | 1 | ①功能复杂度(代码量342行,偏高) |
| switch | data_entry/switch | 通用录入 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| transfer | data_entry/transfer | 通用录入 | 2 | ①功能复杂度(代码量757行,显著高于均值)；③独立使用场景(存在大量单组件接入场景) |

**通用反馈**

| action_sheet | feedback/action_sheet | 通用反馈 | 1 | ①功能复杂度(代码量402行,偏高) |
| alert | feedback/alert | 通用反馈 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| dialog | feedback/dialog | 通用反馈 | 1 | ①功能复杂度(代码量629行,显著高于均值) |
| drawer | feedback/drawer | 通用反馈 | 1 | ①功能复杂度(代码量403行,偏高) |
| error_block | feedback/error_block | 通用反馈 | 1 | ①功能复杂度(代码量344行,偏高) |
| loading | feedback/loading | 通用反馈 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| mask | feedback/mask | 通用反馈 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| message | feedback/message | 通用反馈 | 1 | ①功能复杂度(代码量378行,偏高) |
| modal | feedback/modal | 通用反馈 | 1 | ①功能复杂度(代码量534行,显著高于均值) |
| notification | feedback/notification | 通用反馈 | 1 | ①功能复杂度(代码量499行,偏高) |
| popconfirm | feedback/popconfirm | 通用反馈 | 1 | ①功能复杂度(代码量645行,显著高于均值) |
| popup | feedback/popup | 通用反馈 | 1 | ①功能复杂度(代码量460行,偏高) |
| progress | feedback/progress | 通用反馈 | 1 | ①功能复杂度(代码量329行,偏高) |
| result | feedback/result | 通用反馈 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| result_page | feedback/result_page | 通用反馈 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| skeleton | feedback/skeleton | 通用反馈 | 1 | ①功能复杂度(代码量307行,偏高) |
| spin | feedback/spin | 通用反馈 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |
| toast | feedback/toast | 通用反馈 | 1 | ①功能复杂度(代码量372行,偏高) |

**全局**

| app | misc/app | 全局 | 1 | ①功能复杂度(代码量353行,偏高) |
| config_provider | misc/config_provider | 全局 | 0 | 简单展示/布局组件，或被广泛依赖的基础能力——命中「不拆标准」，留基础库 |

### B2. 独立包（15 个）

| 独立包 | 组件 | 现目录 | 行数/文件 | 包内依赖 | 三方 | 命中 | 理由 |
|---|---|---|---|---|---|---|---|
| antd_picker | calendar_picker | data_entry/calendar_picker | 679/2 | — | — | 3 | 滚轮选择引擎族（CalendarPicker，引擎上移后不依赖其他独立包） |
| antd_picker | cascader | data_entry/cascader | 948/3 | — | — | 3 | Cascader/CascaderView，滚轮引擎+级联列模型 |
| antd_picker | date_picker | data_entry/date_picker | 521/2 | — | — | 3 | 滚轮选择引擎族（日期列生成） |
| antd_picker | picker | data_entry/picker | 531/3 | — | cupertino_ui | 3 | 共享滚轮选择引擎族核心 |
| antd_picker | time_picker | data_entry/time_picker | 534/2 | — | — | 3 | 滚轮选择引擎族（时间列生成） |
| antd_calendar | calendar | data_display/calendar | 385/2 | — | — | 2 | 月视图引擎，与滚轮引擎无关 |
| antd_table | table | data_display/table | 1135/2 | — | — | 4 | 虚拟滚动/排序/筛选/固定列表格引擎，单包独享 |
| antd_tree | tree | data_display/tree | 522/2 | — | — | 3 | 树数据引擎 |
| antd_tree | tree_select | data_entry/tree_select | 625/2 | — | — | 3 | 树引擎弹层形态 |
| antd_form | form | data_entry/form | 779/2 | — | — | 3 | 表单状态/校验引擎 |
| antd_upload | image_uploader | data_entry/image_uploader | 366/2 | — | — | 2 | 共享文件/网络依赖体系 |
| antd_upload | upload | data_entry/upload | 694/2 | — | — | 2 | 文件选择+上传队列引擎 |
| antd_qrcode | qr_code | data_display/qr_code | 244/2 | — | qr_flutter | 3 | 自带 qr_flutter 三方依赖，独立理由典型 |
| antd_pull_to_refresh | pull_to_refresh | feedback/pull_to_refresh | 366/2 | — | — | 3 | 下拉刷新手势状态机+自定义头部 |
| antd_swipe_action | swipe_action | feedback/swipe_action | 303/2 | — | — | 3 | 滑动操作手势引擎 |
| antd_floating | floating_bubble | data_display/floating_bubble | 303/2 | — | — | 3 | 共享拖拽悬浮/锚点吸附引擎 |
| antd_floating | floating_panel | data_display/floating_panel | 233/2 | — | — | 2 | 共享拖拽悬浮/锚点吸附引擎 |
| antd_image_viewer | image_viewer | data_display/image_viewer | 404/2 | — | cached_network_image | 4 | 全屏缩放查看引擎（InteractiveViewer+Overlay+手势） |
| antd_tour | tour | data_display/tour | 811/2 | button | — | 4 | 挖孔遮罩+分步引导引擎 |
| antd_splitter | splitter | layout/splitter | 699/2 | — | antd_icons_flutter | 3 | 拖拽分割面板引擎 |
| antd_masonry | masonry | layout/masonry | 240/2 | — | — | 3 | 瀑布流分配算法引擎 |
| antd_number_keyboard | number_keyboard | data_entry/number_keyboard | 321/2 | — | — | 3 | 虚拟键盘引擎核心 |
| antd_number_keyboard | passcode_input | data_entry/passcode_input | 249/2 | number_keyboard | — | 1 | 格子输入模型，依赖 number_keyboard |
| antd_number_keyboard | virtual_input | data_entry/virtual_input | 242/2 | number_keyboard | — | 1 | 格子输入模型，依赖 number_keyboard |

### B3. 争议组件（✅ 用户已裁决，2026-11-17）

| 组件 | 裁决 | 去向包 |
|---|---|---|
| Carousel | 独立 | `antd_carousel` |
| Masonry | 独立 | `antd_masonry` |
| Ellipsis | 留基础库 | `antd_flutter_ui`（通用展示） |
| ColorPicker | 独立 | `antd_color_picker` |
| Select / Transfer | 独立 | `antd_select` / `antd_transfer` |

> 独立包依赖 ui 内公共组件（Button/Empty/Checkbox 等），符合「独立包 → ui」依赖方向约定。原争议理由表见 git 历史（8df57dc）。

## C. 双端兼容决策表

判定依据（源码基线，本地 `.temp/ant-design`（antd v6）与 `.temp/ant-design-mobile`（antd-mobile v5）真实目录对照）：
- 仅桌面端存在（antd v6 有、antd-mobile v5 无）：38 个上游组件
- 仅移动端存在（antd-mobile v5 有、antd v6 无）：49 个上游组件
- 双端都存在：32 个上游组件
- 决策规则：双端都存在且形态一致 → **单实现+响应式自适应**（AntResponsive 切换形态）；双端形态差异过大（交互范式不同）→ **双实现**；仅单端存在 → **单端实现**（以存在的端源码为准）

| 组件 | 现目录 | 决策 | 源码依据 |
|---|---|---|---|
| avatar | data_display/avatar | 单实现+响应式 | 双端都存在（`components/avatar` 与 `src/components/avatar`），形态基本一致，单实现+响应式 |
| badge | data_display/badge | 单实现+响应式 | 双端都存在（`components/badge` 与 `src/components/badge`），形态基本一致，单实现+响应式 |
| calendar | data_display/calendar | 双实现 | 双端交互形态差异大（桌面下拉/复杂操作 vs 移动滚轮/简化），无法仅靠断点自适应；上游 antd v6 与 antd-mobile v5 均有对应组件且实现为两套源码 |
| card | data_display/card | 单实现+响应式 | 双端都存在（`components/card` 与 `src/components/card`），形态基本一致，单实现+响应式 |
| carousel | data_display/carousel | 单端（桌面） | 上游仅 antd v6 存在（`components/carousel`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| collapse | data_display/collapse | 单实现+响应式 | 双端都存在（`components/collapse` 与 `src/components/collapse`），形态基本一致，单实现+响应式 |
| descriptions | data_display/descriptions | 单端（桌面） | 上游仅 antd v6 存在（`components/descriptions`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| ellipsis | data_display/ellipsis | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/ellipsis`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| empty | data_display/empty | 单实现+响应式 | 双端都存在（`components/empty` 与 `src/components/empty`），形态基本一致，单实现+响应式 |
| floating_bubble | data_display/floating_bubble | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/floating_bubble`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| floating_panel | data_display/floating_panel | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/floating_panel`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| footer | data_display/footer | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/footer`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| image | data_display/image | 单实现+响应式 | 双端都存在（`components/image` 与 `src/components/image`），形态基本一致，单实现+响应式 |
| image_viewer | data_display/image_viewer | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/image_viewer`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| infinite_scroll | data_display/infinite_scroll | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/infinite_scroll`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| list | data_display/list | 单实现+响应式 | 双端都存在且偏移动形态（`src/components/list` 为主基线），单实现+AntResponsive 断点自适应 |
| page_indicator | data_display/page_indicator | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/page_indicator`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| popover | data_display/popover | 单实现+响应式 | 双端都存在（`components/popover` 与 `src/components/popover`），形态基本一致，单实现+响应式 |
| qr_code | data_display/qr_code | 单端（桌面） | 上游仅 antd v6 存在（`components/qr_code`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| segmented | data_display/segmented | 单实现+响应式 | 双端都存在（`components/segmented` 与 `src/components/segmented`），形态基本一致，单实现+响应式 |
| statistic | data_display/statistic | 单端（桌面） | 上游仅 antd v6 存在（`components/statistic`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| table | data_display/table | 双实现 | 双端交互形态差异大（桌面下拉/复杂操作 vs 移动滚轮/简化），无法仅靠断点自适应；上游 antd v6 与 antd-mobile v5 均有对应组件且实现为两套源码 |
| tag | data_display/tag | 单实现+响应式 | 双端都存在（`components/tag` 与 `src/components/tag`），形态基本一致，单实现+响应式 |
| timeline | data_display/timeline | 单端（桌面） | 上游仅 antd v6 存在（`components/timeline`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| tooltip | data_display/tooltip | 单端（桌面） | 上游仅 antd v6 存在（`components/tooltip`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| tour | data_display/tour | 单端（桌面） | 上游仅 antd v6 存在（`components/tour`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| tree | data_display/tree | 单端（桌面） | 上游仅 antd v6 存在（`components/tree`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| auto_complete | data_entry/auto_complete | 单端（桌面） | 上游仅 antd v6 存在（`components/auto_complete`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| calendar_picker | data_entry/calendar_picker | 双实现 | 双端交互形态差异大（桌面下拉/复杂操作 vs 移动滚轮/简化），无法仅靠断点自适应；上游 antd v6 与 antd-mobile v5 均有对应组件且实现为两套源码 |
| cascader | data_entry/cascader | 双实现 | 双端交互形态差异大（桌面下拉/复杂操作 vs 移动滚轮/简化），无法仅靠断点自适应；上游 antd v6 与 antd-mobile v5 均有对应组件且实现为两套源码 |
| check_list | data_entry/check_list | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/check_list`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| checkbox | data_entry/checkbox | 单实现+响应式 | 双端都存在（`components/checkbox` 与 `src/components/checkbox`），形态基本一致，单实现+响应式 |
| color_picker | data_entry/color_picker | 双实现 | 双端交互形态差异大（桌面下拉/复杂操作 vs 移动滚轮/简化），无法仅靠断点自适应；上游 antd v6 与 antd-mobile v5 均有对应组件且实现为两套源码 |
| date_picker | data_entry/date_picker | 双实现 | 双端交互形态差异大（桌面下拉/复杂操作 vs 移动滚轮/简化），无法仅靠断点自适应；上游 antd v6 与 antd-mobile v5 均有对应组件且实现为两套源码 |
| form | data_entry/form | 双实现 | 双端交互形态差异大（桌面下拉/复杂操作 vs 移动滚轮/简化），无法仅靠断点自适应；上游 antd v6 与 antd-mobile v5 均有对应组件且实现为两套源码 |
| image_uploader | data_entry/image_uploader | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/image_uploader`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| input | data_entry/input | 单实现+响应式 | 双端都存在（`components/input` 与 `src/components/input`），形态基本一致，单实现+响应式 |
| input_number | data_entry/input_number | 单端（桌面） | 上游仅 antd v6 存在（`components/input_number`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| mentions | data_entry/mentions | 单端（桌面） | 上游仅 antd v6 存在（`components/mentions`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| number_keyboard | data_entry/number_keyboard | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/number_keyboard`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| passcode_input | data_entry/passcode_input | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/passcode_input`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| picker | data_entry/picker | 双实现 | 双端交互形态差异大（桌面下拉/复杂操作 vs 移动滚轮/简化），无法仅靠断点自适应；上游 antd v6 与 antd-mobile v5 均有对应组件且实现为两套源码 |
| radio | data_entry/radio | 单实现+响应式 | 双端都存在（`components/radio` 与 `src/components/radio`），形态基本一致，单实现+响应式 |
| rate | data_entry/rate | 单实现+响应式 | 双端都存在（`components/rate` 与 `src/components/rate`），形态基本一致，单实现+响应式 |
| search_bar | data_entry/search_bar | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/search_bar`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| select | data_entry/select | 双实现 | 双端交互形态差异大（桌面下拉/复杂操作 vs 移动滚轮/简化），无法仅靠断点自适应；上游 antd v6 与 antd-mobile v5 均有对应组件且实现为两套源码 |
| selector | data_entry/selector | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/selector`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| slider | data_entry/slider | 单实现+响应式 | 双端都存在（`components/slider` 与 `src/components/slider`），形态基本一致，单实现+响应式 |
| stepper | data_entry/stepper | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/stepper`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| switch | data_entry/switch | 单实现+响应式 | 双端都存在（`components/switch` 与 `src/components/switch`），形态基本一致，单实现+响应式 |
| time_picker | data_entry/time_picker | 双实现 | 双端交互形态差异大（桌面下拉/复杂操作 vs 移动滚轮/简化），无法仅靠断点自适应；上游 antd v6 与 antd-mobile v5 均有对应组件且实现为两套源码 |
| transfer | data_entry/transfer | 双实现 | 双端交互形态差异大（桌面下拉/复杂操作 vs 移动滚轮/简化），无法仅靠断点自适应；上游 antd v6 与 antd-mobile v5 均有对应组件且实现为两套源码 |
| tree_select | data_entry/tree_select | 双实现 | 双端交互形态差异大（桌面下拉/复杂操作 vs 移动滚轮/简化），无法仅靠断点自适应；上游 antd v6 与 antd-mobile v5 均有对应组件且实现为两套源码 |
| upload | data_entry/upload | 单实现+响应式 | 双端都存在（`components/upload` 与 `src/components/upload`），形态基本一致，单实现+响应式 |
| virtual_input | data_entry/virtual_input | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/virtual_input`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| action_sheet | feedback/action_sheet | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/action_sheet`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| alert | feedback/alert | 单端（桌面） | 上游仅 antd v6 存在（`components/alert`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| dialog | feedback/dialog | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/dialog`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| drawer | feedback/drawer | 单端（桌面） | 上游仅 antd v6 存在（`components/drawer`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| error_block | feedback/error_block | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/error_block`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| loading | feedback/loading | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/loading`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| mask | feedback/mask | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/mask`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| message | feedback/message | 单端（桌面） | 上游仅 antd v6 存在（`components/message`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| modal | feedback/modal | 单实现+响应式 | 双端都存在（`components/modal` 与 `src/components/modal`），形态基本一致，单实现+响应式 |
| notification | feedback/notification | 单端（桌面） | 上游仅 antd v6 存在（`components/notification`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| popconfirm | feedback/popconfirm | 单端（桌面） | 上游仅 antd v6 存在（`components/popconfirm`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| popup | feedback/popup | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/popup`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| progress | feedback/progress | 单端（桌面） | 上游仅 antd v6 存在（`components/progress`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| pull_to_refresh | feedback/pull_to_refresh | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/pull_to_refresh`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| result | feedback/result | 单实现+响应式 | 双端都存在（`components/result` 与 `src/components/result`），形态基本一致，单实现+响应式 |
| result_page | feedback/result_page | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/result_page`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| skeleton | feedback/skeleton | 单实现+响应式 | 双端都存在（`components/skeleton` 与 `src/components/skeleton`），形态基本一致，单实现+响应式 |
| spin | feedback/spin | 单端（桌面） | 上游仅 antd v6 存在（`components/spin`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| swipe_action | feedback/swipe_action | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/swipe_action`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| toast | feedback/toast | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/toast`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| watermark | feedback/watermark | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/water-mark`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| button | general/button | 单实现+响应式 | 双端都存在（`components/button` 与 `src/components/button`），形态基本一致，单实现+响应式 |
| float_button | general/float_button | 单端（桌面） | 上游仅 antd v6 存在（`components/float_button`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| notice_bar | general/notice_bar | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/notice_bar`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| typography | general/typography | 单实现+响应式 | 双端都存在（`components/typography` 与 `src/components/typography`），形态基本一致，单实现+响应式 |
| auto_center | layout/auto_center | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/auto_center`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| divider | layout/divider | 单实现+响应式 | 双端都存在（`components/divider` 与 `src/components/divider`），形态基本一致，单实现+响应式 |
| flex | layout/flex | 单端（桌面） | 上游仅 antd v6 存在（`components/flex`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| grid | layout/grid | 单实现+响应式 | 双端都存在（`components/grid` 与 `src/components/grid`），形态基本一致，单实现+响应式 |
| layout | layout/layout | 单端（桌面） | 上游仅 antd v6 存在（`components/layout`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| masonry | layout/masonry | 单端（桌面） | 上游仅 antd v6 存在（`components/masonry`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| safe_area | layout/safe_area | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/safe_area`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| space | layout/space | 单实现+响应式 | 双端都存在（`components/space` 与 `src/components/space`），形态基本一致，单实现+响应式 |
| splitter | layout/splitter | 单端（桌面） | 上游仅 antd v6 存在（`components/splitter`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| affix | misc/affix | 单端（桌面） | 上游仅 antd v6 存在（`components/affix`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| app | misc/app | 单端（桌面） | 上游仅 antd v6 存在（`components/app`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| border_beam | misc/border_beam | 单端（桌面） | 上游仅 antd v6 存在（`components/border_beam`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| config_provider | misc/config_provider | 单实现+响应式 | 双端都存在（`components/config-provider` 与 `src/components/config-provider`），形态基本一致，单实现+响应式 |
| anchor | navigation/anchor | 单端（桌面） | 上游仅 antd v6 存在（`components/anchor`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| breadcrumb | navigation/breadcrumb | 单端（桌面） | 上游仅 antd v6 存在（`components/breadcrumb`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| capsule_tabs | navigation/capsule_tabs | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/capsule_tabs`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| dropdown | navigation/dropdown | 双实现 | 双端都存在但交互范式差异大（见上游两套源码目录），优先双实现共享样式公共层 |
| index_bar | navigation/index_bar | 单实现+响应式 | 双端都存在且偏移动形态（`src/components/index-bar` 为主基线），单实现+AntResponsive 断点自适应 |
| jumbo_tabs | navigation/jumbo_tabs | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/jumbo_tabs`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| menu | navigation/menu | 单端（桌面） | 上游仅 antd v6 存在（`components/menu`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| nav_bar | navigation/nav_bar | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/nav_bar`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| pagination | navigation/pagination | 单端（桌面） | 上游仅 antd v6 存在（`components/pagination`），antd-mobile v5 无对应物，按 antd v6 单实现 |
| side_bar | navigation/side_bar | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/side_bar`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| steps | navigation/steps | 单实现+响应式 | 双端都存在（`components/steps` 与 `src/components/steps`），形态基本一致，单实现+响应式 |
| tab_bar | navigation/tab_bar | 单端（移动） | 上游仅 antd-mobile v5 存在（`src/components/tab_bar`），antd v6 无对应物，按 antd-mobile v5 单实现 |
| tabs | navigation/tabs | 单实现+响应式 | 双端都存在（`components/tabs` 与 `src/components/tabs`），形态基本一致，单实现+响应式 |

## D. 拓扑序执行清单

### D1. 包级拓扑序（基础优先、无相互引用先行）

依据 A2 节依赖边推导：所有独立包只依赖 `antd_flutter_ui` + 已独立基础包（tokens/color/theme/icons），**独立包之间零互相依赖**，故包级顺序主要受「ui 内基础组件须先就位」约束：

| 序 | 目标 | 前置条件 | 说明 |
|---|---|---|---|
| 0 | tokens/color/theme/icons | — | 已独立，无需动作 |
| 1 | antd_flutter_ui 基础层（button/typography/divider/flex/space/grid/layout/safe_area/auto_center/affix） | 0 | Button 被 tour/modal/popconfirm 依赖，必须最先就位；**共享引擎同批上移 `src/engines/`（滚轮选择引擎+列数据模型、虚拟键盘/格子输入模型）** |
| 2 | antd_flutter_ui 全局（config_provider/app + AntResponsive） | 1 | app 依赖 message/modal/notification，随 ui 反馈组一并迁移；AntResponsive 先行支撑后续响应式 |
| 3 | antd_flutter_ui 通用展示/通用录入/通用反馈（其余 60 组件） | 1,2 | 含 empty（list 依赖）、checkbox（transfer 依赖）、message/modal/notification（app 依赖）、image（image_viewer 依赖）|
| 4 | antd_qrcode | 1 | 无包内依赖、无被依赖，三方自含（qr_flutter），完全独立最先拆 |
| 5 | antd_pull_to_refresh / antd_swipe_action / antd_calendar / antd_splitter / antd_masonry | 1 | 均无包内依赖、无被依赖，引擎自足 |
| 6 | antd_number_keyboard | 1 | 键盘引擎已上移 ui；包内先移 number_keyboard，再 passcode_input、virtual_input（二者依赖前者） |
| 7 | antd_image_viewer | 3 | 依赖 ui 的 image（cached_network_image 共用）；其 cached_network_image 三方随包声明 |
| 8 | antd_tour | 1 | 依赖 ui 的 button（序 1 已就位） |
| 9 | antd_floating | 1 | floating_panel/floating_bubble 共享拖拽引擎，族内一并迁移 |
| 10 | antd_tree / antd_form / antd_upload | 1 | tree_select 与 tree 同包族内迁移；form/transfer 解耦（transfer 留 ui） |
| 11 | antd_picker | 3,1 | 滚轮引擎已上移 ui，Picker 族（picker/date_picker/time_picker/calendar_picker/cascader）族内迁移后不依赖任何独立包；picker 原引用 cupertino_ui 三方随包声明 |

### D2. 逐组件迁移粒度（用户要求：一个组件一个组件移植）

- **执行粒度 = 单组件**：每个组件独立完成「迁移代码+测试+example → alias + `.antd` 扩展 → 主包 re-export → 逐组件验收（上游文档「执行规则」）」后才进入下一组件
- 包内迁移顺序：**无包内依赖的组件先移**，被族内依赖的引擎组件最先；各族顺序：
  - antd_picker：picker → date_picker → time_picker → calendar_picker → cascader（首者为共享引擎/无依赖者）
  - antd_number_keyboard：number_keyboard → passcode_input → virtual_input（首者为共享引擎/无依赖者）
  - antd_floating：floating_bubble → floating_panel（首者为共享引擎/无依赖者）
  - antd_tree：tree → tree_select（首者为共享引擎/无依赖者）
  - antd_upload：upload → image_uploader（首者为共享引擎/无依赖者）
  - antd_flutter_ui：基础层 → 全局 → 通用展示（empty 先于 list）→ 通用录入（checkbox 先于 transfer 消费需求）→ 通用反馈（message/modal/notification 先于 app 挂载完成）

### D3. 主包删除 + re-export 兼容机制（写进清单，逐组件执行）

每迁移完**一个组件**：
1. 从 `antd_flutter_plus` 的 `lib/src/components/...` **删除该组件源码目录**（代码本体已搬至新包）
2. 主包保留 re-export：`export 'package:<新包>/<组件>.dart'`（经伞包聚合文件），对外 `import 'package:antd_flutter_plus/antd_flutter_plus.dart'` 用法不变，`AntXxx` 符号不变
3. 依赖反转：主包 `pubspec.yaml` 增加对新包的依赖（独立包只依赖 ui/theme/tokens/color/icons，永不依赖主包）
4. 验证：`flutter analyze` + 该组件测试自新包运行 + example 引用不变；随后按上游文档「执行规则」做逐组件用户验收

### D4. 共享引擎上移 ui 的时机

| 引擎 | 消费包 | 归属 | 上移时机 |
|---|---|---|---|
| 滚轮选择引擎 + 列数据模型 | antd_picker（全族） | ui `src/engines/` | 步骤 3 建 ui 时同批落位（D1 序 1）|
| 虚拟键盘/格子输入模型 | antd_number_keyboard 族 | ui `src/engines/` | 同上 |
| 表格/树/瀑布流/挖孔遮罩/拖拽分割/缩放预览/下拉刷新/滑动操作/拖拽吸附引擎 | 各自单包 | 留独立包内 | 随各包迁移落地，不上移 |

## E. gen-docs 时机（用户指定）

> **文档生成：P08 全部移植完成后统一执行**。逐组件迁移阶段只保证 `///` 文档注释随代码搬家完整、不欠账；`gen-docs`（dart doc + 人工文档页静态站整合）在全部 106 组件迁移完成、伞包 re-export 全部就位后一次性运行，避免中途包边界变动导致文档反复重生成。

## 附：脚本与数据

- `.temp/p08audit/scan.sh`：bash 初扫（import 粗分类）
- `.temp/p08audit/audit.py`：Python 精扫（自引用过滤/相对路径解析/行数统计），输出 `audit.json`
- `.temp/p08audit/gen_doc.py`：本文档生成器（去向映射/准入打分/双端决策均在脚本内，数据全部来自 audit.json 与上游源码目录真实 ls）
- 上游基线：`.temp/ant-design`（antd v6，`components/` 目录）、`.temp/ant-design-mobile`（antd-mobile v5，`src/components/` 目录）
