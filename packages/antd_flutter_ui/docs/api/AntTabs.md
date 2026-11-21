<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTabs

> 种类：类

```dart
class AntTabs
```

选项卡 — 对内容进行分区切换的导航组件。

对齐 antd React Tabs 组件，支持线条/卡片/可编辑卡片三种类型、
四个方向位置、三种尺寸、居中、动画与增删回调。

```dart
AntTabs(
  items: [
    AntTabsItem(key: '1', label: 'Tab 1', child: Text('Content 1')),
    AntTabsItem(key: '2', label: 'Tab 2', child: Text('Content 2')),
  ],
)
```

## 构造函数

### `AntTabs({super.key, this.activeKey, this.defaultActiveKey, this.items = const [], this.type = AntTabsType.line, this.size = AntTabsSize.normal, this.tabPosition = AntTabPosition.top, this.centered = false, this.animated = true, this.tabBarGutter, this.addIcon, this.onChange, this.onEdit})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `activeKey` | `String?` | 可选 | — |
| `defaultActiveKey` | `String?` | 可选 | — |
| `items` | `List<AntTabsItem>` | = const [] | — |
| `type` | `AntTabsType` | = AntTabsType.line | — |
| `size` | `AntTabsSize` | = AntTabsSize.normal | — |
| `tabPosition` | `AntTabPosition` | = AntTabPosition.top | — |
| `centered` | `bool` | = false | — |
| `animated` | `bool` | = true | — |
| `tabBarGutter` | `double?` | 可选 | — |
| `addIcon` | `Widget?` | 可选 | — |
| `onChange` | `ValueChanged<String>?` | 可选 | — |
| `onEdit` | `void Function(String key, AntTabsEditAction action)?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `activeKey` | `String?` | 受控当前激活 key |
| `addIcon` | `Widget?` | 自定义新增按钮图标（editableCard） |
| `animated` | `bool` | 切换动画 |
| `centered` | `bool` | 标签居中 |
| `defaultActiveKey` | `String?` | 非受控默认激活 key |
| `items` | `List<AntTabsItem>` | 选项卡项列表 |
| `onChange` | `ValueChanged<String>?` | 切换回调 |
| `onEdit` | `void Function(String key, AntTabsEditAction action)?` | 新增/删除回调（editableCard） |
| `size` | `AntTabsSize` | 尺寸 |
| `tabBarGutter` | `double?` | 标签间隙 |
| `tabPosition` | `AntTabPosition` | 选项卡位置 |
| `type` | `AntTabsType` | 选项卡类型 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntTabs>` | — |

