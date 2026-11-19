<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntFloatButtonBackTop

> 种类：类

```dart
class AntFloatButtonBackTop
```

Ant Design 回到顶部按钮。

监听滚动位置，超过 `visibilityHeight` 时显示；
点击后平滑滚动回顶部。

## 构造函数

### `AntFloatButtonBackTop({super.key, this.visibilityHeight = 400, this.duration = const Duration(milliseconds: 450), this.onClick, this.icon, this.type = AntFloatButtonType.normal, this.shape = AntFloatButtonShape.circle, this.badge, this.tooltip, this.scrollController})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `visibilityHeight` | `double` | = 400 | — |
| `duration` | `Duration` | = const Duration(milliseconds: 450) | — |
| `onClick` | `VoidCallback?` | 可选 | — |
| `icon` | `Widget?` | 可选 | — |
| `type` | `AntFloatButtonType` | = AntFloatButtonType.normal | — |
| `shape` | `AntFloatButtonShape` | = AntFloatButtonShape.circle | — |
| `badge` | `AntFloatButtonBadge?` | 可选 | — |
| `tooltip` | `String?` | 可选 | — |
| `scrollController` | `ScrollController?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `badge` | `AntFloatButtonBadge?` | 角标配置 |
| `duration` | `Duration` | 回顶滚动动画时长 |
| `icon` | `Widget?` | 自定义图标（默认 verticalAlignTopOutlined） |
| `onClick` | `VoidCallback?` | 点击回调（回顶动画之后触发） |
| `scrollController` | `ScrollController?` | 滚动控制器（为 null 时从 PrimaryScrollController 解析） |
| `shape` | `AntFloatButtonShape` | 按钮形状 |
| `tooltip` | `String?` | 提示文字 |
| `type` | `AntFloatButtonType` | 按钮类型 |
| `visibilityHeight` | `double` | 滚动超过此偏移量时显示按钮 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntFloatButtonBackTop>` | — |

