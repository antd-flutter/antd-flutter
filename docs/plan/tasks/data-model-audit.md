# 数据传参模式审计（P08 · 2026-11-21）

目标：让使用者能用**自己的数据模型**驱动组件，而不是先把数据转成本库的 `Ant*Item/Option`（或 Table 的 `Map`）。

## 现状分类

### A. 已是「泛型数据源 + 渲染回调」（无需改造）
| 组件 | 数据参数 | 自定义手段 |
| --- | --- | --- |
| AntList | `dataSource: List<T>` | `renderItem(T item) => Widget` |
| AntForm | `builder` | 整体自定义渲染 |
| AntTable | `dataSource: List<Map<String,dynamic>>` | `rowKey`、`AntTableColumn.render(record,index)`、`expandedRowRender` — 但行数据被限定为 Map |
| AntBreadcrumb | `items: List<AntBreadcrumbItem>` | item 带 icon / builder |

### B. 必须构造本库 Item，但 Item 内有 Widget 槽（可用，啰嗦）
| 组件 | 数据参数 | 现有槽位 |
| --- | --- | --- |
| AntTabs / JumboTabs / CapsuleTabs / TabBar | `items: List<AntXxxItem>` | `labelWidget`、`child`、`icon` |
| AntMenu | `items: List<AntMenuItem>` | `labelWidget`、`icon`、`extra`、`title` |
| AntDescriptions | `items: List<AntDescriptionsItem>` | `child`（值区域） |
| AntCollapse | `items: List<AntCollapsePanel>` | `child`（面板内容） |
| AntIndexBar | `items: List<AntIndexBarItem>` | `child`（分组内容）、`briefWidget` |
| AntAnchor | `items: List<AntAnchorItem>` | `title`（String）+ 嵌套 |
| AntTimeline | `items: List<AntTimelineItem>` | `content`(Widget)、`dot` |
| AntTour | `steps: List<AntTourStep>` | `content`(Widget) |
| AntCard | `actions: List<AntCardAction>` | `icon`/`onTap` |
| AntSteps | `items: List<AntStepsItem>` | 仅 `icon`（标题/描述只能 String） |

### C. 封闭模型：字段固定、无 Widget 槽（必须转换数据，最影响接入）
| 组件 | 数据参数 | 缺少的能力 |
| --- | --- | --- |
| AntTable（行） | `List<Map<String,dynamic>>` + `dataIndex` | 行模型只能是 Map，排序/筛选按字段名取 |
| AntTree / AntTreeSelect | `treeData: List<AntTreeNode/AntTreeSelectOption>` | title 只能是 String、无行内自定义 widget、key 只能 String |
| AntTransfer | `dataSource: List<AntTransferItem>` | title/description 只能 String |
| AntCascader | `options: List<AntCascaderOption>` | label/value 只能 String |
| AntPicker / PickerView | `columns: List<AntPickerColumn>` | label/value 只能 String |
| AntAutoComplete / AntMentions | `options: List<AntXxxOption>` | label 只能 String |
| AntSelect | `options: List<AntSelectOption<T>>` | value 已泛型，label 只能 String（无 labelWidget） |
| AntSegmented | `items: List<AntSegmentedItem>` | 有 `icon`，label 只能 String |
| AntSelector | `options: List<AntSelectorOption<T>>` | label 已是 Widget（最好） |
| AntRadio / Checkbox / CheckList | 各自 Option 泛型 value | label 为 String/Widget 不一 |
| AntUpload / ImageUploader | `fileList: List<AntUploadFile/AntImageUploadItem>` | 文件名/预览固定 |
| AntSlider | `marks: List<AntSliderMark>` | label 只能 String |
| AntColorPicker | `presets: List<AntColorPreset>` | 仅颜色值 |

## 差距归纳

1. **三种风格并存**：List 用 `List<T> + renderItem`；Selector 用 `Widget label`；多数组件用「封闭 Item + String」。
2. **接入成本**：用户有自己的 `User`/`Order` 模型时，必须写转换函数 + 丢失类型安全（Table 尤其明显，只能转 Map）。
3. **渲染上限**：C 类无法在行内放自定义 widget（徽标、进度、多行布局），只能改库。

## 建议方案（两段式）

### 第一步：泛型数据源（类型安全，推荐在 1.0 前做，属破坏性或新增重载）
```dart
AntTable<User>(
  dataSource: users,
  rowKey: (u) => u.id,
  columns: [
    AntTableColumn<User>(title: '姓名', cell: (u, i) => Text(u.name)),
    AntTableColumn<User>(title: '状态', cell: (u, i) => AntTag(text: u.status)),
  ],
);

AntTree<Category>(
  dataSource: categories,
  keyOf: (c) => c.id,
  titleOf: (c) => c.name,
  childrenOf: (c) => c.children,
);
```
保留现有 `AntTreeNode` / `Map` 构造作为默认重载，旧代码不破坏。

### 第二步：行内渲染逃生口（非破坏）
给 C 类模型补 `Widget Function(T)?` 槽（titleBuilder/labelBuilder/valueBuilder），先解决 Tree / Transfer / Cascader / Picker / Select。

## 建议顺序（按收益/风险）
1. **Table**（行泛型 + columns 泛型）— 收益最大，改动最大（2100 行 + 53 测试）。
2. **Tree / TreeSelect**（titleBuilder + 泛型 key）。
3. **Transfer / Cascader / Picker / AutoComplete / Select**（labelBuilder）。
4. **Steps / Timeline / Menu / Tabs 家族**（已有 Widget 槽，补 label/titleBuilder 与 `data` 泛型）。
5. **Upload / ImageUploader / Slider / Segmented / Radio / Checkbox**（小项补齐）。

## 兼容策略
- 新增泛型重载 / 可选 builder，保留旧构造；
- 老 API 标 `@Deprecated('2.0 移除，请使用泛型数据源')` 只在确认后加；
- 每个组件补一条「用户自定义模型」回归测试；
- 文档/示例增加「用你自己的模型」小节。

## 决策（2026-11-21）

用户确认：**全量泛型化**，1.0 前允许破坏性变更，不必保留旧 Item 模型作为唯一入口。执行约定见 `docs/plan/tasks/data-model-generic-convention.md`。

分组执行：
1. antd_table（Table<T> 行 + 列泛型）
2. antd_tree（Tree/TreeSelect + Transfer）
3. antd_picker（Picker/Cascader）、antd_upload
4. antd_flutter_ui data_entry（Select/Radio/Checkbox/CheckList/Selector/Segmented/AutoComplete/Mentions/Slider/ColorPicker/ImageUploader）
5. antd_flutter_ui navigation + display（Tabs/JumboTabs/CapsuleTabs/TabBar/SideBar/IndexBar/Menu/Steps/Anchor/Breadcrumb/Pagination/List/Timeline/Descriptions/Collapse/Tour/Card/Splitter/SwipeAction）

已确认无需改造（天然组合式）：AntForm（children 组合 + Map 值，后续可泛型化）、AntMasonry（List<Widget>）、AntCarousel（List<Widget>）、AntFloatingBubble（action 列表，Widget 槽）、AntCalendar（cellRender 已有）。
