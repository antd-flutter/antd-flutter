<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntButton

> 种类：类

```dart
class AntButton
```

Ant Design Button 组件。

颜色矩阵、尺寸形状均从 `AntThemeData` 令牌实时解析，
与 antd v6 `button/style/variant.ts` + `token.ts` 逐值对齐。

## 构造函数

### `AntButton({super.key, this.type = AntButtonType.normal, this.color, this.variant, this.danger = false, this.ghost = false, this.shape = AntButtonShape.normal, this.size = AntButtonSize.middle, this.block = false, this.icon, this.iconPlacement = AntButtonIconPlacement.start, this.loading = false, this.disabled = false, this.onTap, this.child})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `type` | `AntButtonType` | = AntButtonType.normal | — |
| `color` | `AntButtonColor?` | 可选 | — |
| `variant` | `AntButtonVariant?` | 可选 | — |
| `danger` | `bool` | = false | — |
| `ghost` | `bool` | = false | — |
| `shape` | `AntButtonShape` | = AntButtonShape.normal | — |
| `size` | `AntButtonSize` | = AntButtonSize.middle | — |
| `block` | `bool` | = false | — |
| `icon` | `Widget?` | 可选 | — |
| `iconPlacement` | `AntButtonIconPlacement` | = AntButtonIconPlacement.start | — |
| `loading` | `bool` | = false | — |
| `disabled` | `bool` | = false | — |
| `onTap` | `VoidCallback?` | 可选 | — |
| `child` | `Widget?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `block` | `bool` | 撑满父容器宽度 |
| `child` | `Widget?` | 按钮内容（通常为文字） |
| `color` | `AntButtonColor?` | 显式颜色语义，覆盖 type 映射的默认色 |
| `danger` | `bool` | 危险按钮，强制 color = danger |
| `disabled` | `bool` | 禁用状态 |
| `ghost` | `bool` | 幽灵按钮，背景透明 |
| `icon` | `Widget?` | 图标 Widget（加载中时被旋转指示器替换） |
| `iconPlacement` | `AntButtonIconPlacement` | 图标位置（文字前/后） |
| `loading` | `bool` | 加载中状态 |
| `onTap` | `VoidCallback?` | 点击回调 |
| `shape` | `AntButtonShape` | 按钮形状 |
| `size` | `AntButtonSize` | 按钮尺寸 |
| `type` | `AntButtonType` | 按钮类型，映射到默认的 color + variant 组合 |
| `variant` | `AntButtonVariant?` | 显式变体，覆盖 type 映射的默认变体 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntButton>` | — |

