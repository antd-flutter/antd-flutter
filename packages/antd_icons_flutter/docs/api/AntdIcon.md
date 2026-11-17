<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntdIcon

> 种类：类

```dart
class AntdIcon
```

Ant Design 统一图标组件。

同时支持 TTF 字体图标（Outlined/Filled）和 SVG 双色图标（TwoTone），
通过 `icon` 参数类型自动分发：

- `IconData` → TTF 字体渲染（`AntIcons` 常量）
- `String` → SVG 资产渲染（`AntIconsTwotone` 常量）

使用场景：
- 与 antd 设计规范保持视觉一致的 Flutter 应用；
- 用线框 / 实心 / 双色三形态表达选中、强调等状态差异；
- 迁移自 antd React 项目，沿用既有图标命名。

注意：
- `color` 只影响 TTF 图标，`twoToneColor` 只影响 TwoTone 图标，
  传错模式不会生效也不会报错；
- TwoTone 首次渲染需异步读取 SVG 资产，避免在 `build` 中同步依赖其
  像素结果（替换结果已按「路径 + 主色 + 次色」缓存）；
- 功能性图标务必传 `semanticLabel`，纯装饰图标可省略；
- TTF 模式同步无首帧延迟、适合高频单色小图标；TwoTone 适合需要
  双色视觉层次的品牌化、强调性场景。

```dart
// TTF 字体图标（Outlined / Filled）
AntdIcon(AntIcons.checkOutlined)
AntdIcon(AntIcons.searchOutlined, size: 24, color: Colors.blue)

// TwoTone 双色图标（默认 #333 + #E6E6E6，无需额外参数）
AntdIcon(AntIconsTwotone.checkCircleTwoTone)

// TwoTone 自定义主色（次色自动生成）
AntdIcon(AntIconsTwotone.heartTwoTone, twoToneColor: Colors.red)
```

## 构造函数

### `AntdIcon(this.icon, {super.key, this.size, this.color, this.twoToneColor, this.semanticLabel})`

创建 AntdIcon。

`icon` 接受 `IconData`（TTF 字体模式）或 `String`（TwoTone SVG 资产路径）。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `icon` | `Object` | 可选 | 接受 `IconData`（TTF 字体模式）或 `String`（TwoTone SVG 资产路径）。 |
| `size` | `double?` | 可选 | — |
| `color` | `Color?` | 可选 | — |
| `twoToneColor` | `Color?` | 可选 | — |
| `semanticLabel` | `String?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `color` | `Color?` | 图标颜色，仅 TTF 字体模式生效 |
| `icon` | `Object` | 图标定义，决定渲染模式 |
| `semanticLabel` | `String?` | 语义标签（无障碍），供屏幕阅读器朗读 |
| `size` | `double?` | 图标尺寸（逻辑像素），默认值因模式而异 |
| `twoToneColor` | `Color?` | TwoTone 主色（仅 TwoTone SVG 模式生效） |
| `_colorizedCache` | `Map<String, String>` | TwoTone SVG 色彩化缓存：path@primary@secondary → SVG 字符串 |
| `_packageName` | `String` | 包名（用于包内资产定位） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_loadAndColorize` | `Future<String>` | 加载 SVG 资产并替换双色（带缓存） |
| `build` | `Widget` | — |
| `_applyTwoToneColors` | `String` | 替换 SVG 中的双色标记 |
| `_channel8` | `int` | Color 0.0–1.0 通道值 → 0–255 整数 |
| `_generateSecondaryColor` | `Color` | 由主色生成次色（向白色方向大幅提亮） |
| `_lightenChannel` | `int` | — |
| `_toHexString` | `String` | Color → #RRGGBB 小写十六进制字符串 |

