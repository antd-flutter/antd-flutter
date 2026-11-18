<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntAvatarGroup

> 种类：类

```dart
class AntAvatarGroup
```

头像组 — 多个头像堆叠展示，支持最大数量限制。

对齐 antd React Avatar.Group 组件。

## 构造函数

### `AntAvatarGroup({super.key, required this.children, this.maxCount, this.size, this.presetSize, this.maxStyle, this.spacing = -8})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `children` | `List<AntAvatar>` | 可选 | — |
| `maxCount` | `int?` | 可选 | — |
| `size` | `double?` | 可选 | — |
| `presetSize` | `AntAvatarSize?` | 可选 | — |
| `maxStyle` | `TextStyle?` | 可选 | — |
| `spacing` | `double` | = -8 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `children` | `List<AntAvatar>` | 头像列表 |
| `maxCount` | `int?` | 最大显示数量，超出部分显示 +N |
| `maxStyle` | `TextStyle?` | +N 提示的自定义样式 |
| `presetSize` | `AntAvatarSize?` | 预设尺寸（应用到所有子头像） |
| `size` | `double?` | 自定义像素尺寸（应用到所有子头像） |
| `spacing` | `double` | 头像间距，负值产生堆叠效果 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

