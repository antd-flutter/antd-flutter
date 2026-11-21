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
AntTabs<User>(
  items: users,
  keyOf: (user) => user.id,
  labelBuilder: (context, user, index) => Text(user.name),
  childBuilder: (context, user, index) => Text(user.email),
)
```

## 构造函数

### `AntTabs({super.key, this.activeKey, this.defaultActiveKey, this.items = const [], this.keyOf, this.labelBuilder, this.childBuilder, this.iconBuilder, this.disabledOf, this.closableOf, this.type = AntTabsType.line, this.size = AntTabsSize.normal, this.tabPosition = AntTabPosition.top, this.centered = false, this.animated = true, this.tabBarGutter, this.addIcon, this.onChange, this.onEdit})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `activeKey` | `Object?` | 可选 | — |
| `defaultActiveKey` | `Object?` | 可选 | — |
| `items` | `List<T>` | = const [] | — |
| `keyOf` | `Object Function(T item)?` | 可选 | — |
| `labelBuilder` | `AntTabsLabelBuilder<T>?` | 可选 | — |
| `childBuilder` | `AntTabsChildBuilder<T>?` | 可选 | — |
| `iconBuilder` | `AntTabsIconBuilder<T>?` | 可选 | — |
| `disabledOf` | `bool Function(T item)?` | 可选 | — |
| `closableOf` | `bool? Function(T item)?` | 可选 | — |
| `type` | `AntTabsType` | = AntTabsType.line | — |
| `size` | `AntTabsSize` | = AntTabsSize.normal | — |
| `tabPosition` | `AntTabPosition` | = AntTabPosition.top | — |
| `centered` | `bool` | = false | — |
| `animated` | `bool` | = true | — |
| `tabBarGutter` | `double?` | 可选 | — |
| `addIcon` | `Widget?` | 可选 | — |
| `onChange` | `ValueChanged<T>?` | 可选 | — |
| `onEdit` | `void Function(T? item, AntTabsEditAction action)?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `activeKey` | `Object?` | 受控当前激活 key |
| `addIcon` | `Widget?` | 自定义新增按钮图标（editableCard） |
| `animated` | `bool` | 切换动画 |
| `centered` | `bool` | 标签居中 |
| `childBuilder` | `AntTabsChildBuilder<T>?` | 内容构建器 |
| `closableOf` | `bool? Function(T item)?` | 是否可关闭某项 |
| `defaultActiveKey` | `Object?` | 非受控默认激活 key |
| `disabledOf` | `bool Function(T item)?` | 是否禁用某项 |
| `iconBuilder` | `AntTabsIconBuilder<T>?` | 图标构建器 |
| `items` | `List<T>` | 选项卡项列表 |
| `keyOf` | `Object Function(T item)?` | 提取唯一标识，默认使用下标 |
| `labelBuilder` | `AntTabsLabelBuilder<T>?` | 标题构建器 |
| `onChange` | `ValueChanged<T>?` | 切换回调 |
| `onEdit` | `void Function(T? item, AntTabsEditAction action)?` | 新增/删除回调（editableCard） |
| `size` | `AntTabsSize` | 尺寸 |
| `tabBarGutter` | `double?` | 标签间隙 |
| `tabPosition` | `AntTabPosition` | 选项卡位置 |
| `type` | `AntTabsType` | 选项卡类型 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntTabs<T>>` | — |

