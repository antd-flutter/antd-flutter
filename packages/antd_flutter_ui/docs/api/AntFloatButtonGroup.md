<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntFloatButtonGroup

> 种类：类

```dart
class AntFloatButtonGroup
```

Ant Design 浮动按钮组。

触发按钮在组的一端，点击/悬停展开子按钮列表。
- `trigger`：click（点击展开/收起）/ hover（悬停展开）
- `placement`：子按钮列表相对触发按钮的方位
- `shape`：circle（独立圆形按钮 + 间距）/ square（连体方形 + 分隔线）

## 构造函数

### `AntFloatButtonGroup({super.key, this.trigger = AntFloatButtonGroupTrigger.click, this.open, this.onOpenChange, this.placement = AntFloatButtonGroupPlacement.top, this.shape = AntFloatButtonShape.circle, this.closeIcon, this.children = const []})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `trigger` | `AntFloatButtonGroupTrigger` | = AntFloatButtonGroupTrigger.click | — |
| `open` | `bool?` | 可选 | — |
| `onOpenChange` | `ValueChanged<bool>?` | 可选 | — |
| `placement` | `AntFloatButtonGroupPlacement` | = AntFloatButtonGroupPlacement.top | — |
| `shape` | `AntFloatButtonShape` | = AntFloatButtonShape.circle | — |
| `closeIcon` | `Widget?` | 可选 | — |
| `children` | `List<Widget>` | = const [] | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `children` | `List<Widget>` | 子按钮列表 |
| `closeIcon` | `Widget?` | 展开时触发按钮显示的关闭图标 |
| `onOpenChange` | `ValueChanged<bool>?` | 展开状态变化回调 |
| `open` | `bool?` | 受控展开状态（为 null 时内部自管理） |
| `placement` | `AntFloatButtonGroupPlacement` | 子按钮列表弹出方位 |
| `shape` | `AntFloatButtonShape` | 组形状 |
| `trigger` | `AntFloatButtonGroupTrigger` | 展开触发方式 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntFloatButtonGroup>` | — |

