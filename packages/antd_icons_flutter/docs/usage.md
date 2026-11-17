# antd_icons_flutter 使用指南

## 简介

`antd_icons_flutter` 将 [Ant Design 官方图标](https://github.com/ant-design/ant-design-icons)（`@ant-design/icons-svg`）移植到 Flutter，共 **698 个图标**、三种风格：

| 风格 | 数量 | 渲染方式 | Dart 常量类 | 后缀 |
| --- | --- | --- | --- | --- |
| Outlined（线框） | 447 | TTF 字体 | `AntIcons` | `Outlined` |
| Filled（实心） | 251 | TTF 字体 | `AntIcons` | `Filled` |
| TwoTone（双色） | 150 | SVG 资产 + `flutter_svg` | `AntIconsTwotone` | `TwoTone` |

命名规则与 antd React 版对齐：`<CheckOutlined />` → `AntIcons.checkOutlined`，`<HeartTwoTone />` → `AntIconsTwotone.heartTwoTone`。

## 安装与引入

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  antd_icons_flutter: ^1.0.0
```

安装后引入：

```dart
import 'package:antd_icons_flutter/antd_icons_flutter.dart';
```

字体与资产均由包内声明（字体族 `AntIcons`、资产目录 `assets/twotone/`），宿主应用**无需任何额外配置**即可使用。

## 使用场景

- 需要与 antd 设计规范保持视觉一致的 Flutter 应用；
- 需要同一图标多种形态（线框/实心/双色）以表达选中、强调等状态；
- 迁移自 antd React 项目，希望沿用既有图标命名。

## 三种图标形态用法

### 方式一：统一组件 AntdIcon（推荐）

`AntdIcon` 通过 `icon` 参数类型自动分发渲染模式，三种风格使用同一套参数：

```dart
// Outlined（TTF 字体）
AntdIcon(AntIcons.checkOutlined)

// Filled（TTF 字体）
AntdIcon(AntIcons.heartFilled, size: 32, color: Colors.red)

// TwoTone（SVG 资产，默认 #333 + #E6E6E6 双色）
AntdIcon(AntIconsTwotone.checkCircleTwoTone)

// TwoTone 自定义主色（次色自动生成）
AntdIcon(AntIconsTwotone.heartTwoTone, twoToneColor: Colors.red)
```

### 方式二：TTF 图标直接使用 Flutter Icon

Outlined/Filled 常量即标准 `IconData`，可与 Material 图标混用：

```dart
Icon(AntIcons.searchOutlined, size: 24, color: Colors.blue)
```

### 方式三：TwoTone 直接使用 flutter_svg

不经过 `AntdIcon` 时，需传入 `package` 以正确定位包内资产：

```dart
SvgPicture.asset(
  AntIconsTwotone.checkCircleTwoTone,
  package: 'antd_icons_flutter',
  width: 24,
  height: 24,
)
```

### 双形态对比示例

利用 Outlined/Filled/TwoTone 表达状态差异：

```dart
Row(
  children: [
    AntdIcon(AntIcons.starOutlined, semanticLabel: '未收藏'),      // 线框：默认态
    AntdIcon(AntIcons.starFilled, color: Colors.amber, semanticLabel: '已收藏'), // 实心 + 着色：选中态
    AntdIcon(AntIconsTwotone.starTwoTone, twoToneColor: Colors.amber, semanticLabel: '半收藏'), // 双色：强调态
  ],
)
```

## 参数表

### AntdIcon

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | :---: | --- |
| `icon` | `Object`（`IconData` 或 `String`） | ✓ | 图标定义。传 `IconData`（如 `AntIcons.checkOutlined`）走 TTF 字体渲染；传 `String`（如 `AntIconsTwotone.heartTwoTone`）走 TwoTone SVG 渲染 |
| `size` | `double?` | — | 图标尺寸（逻辑像素）。未设置时继承 `IconTheme`，兜底 24.0 |
| `color` | `Color?` | — | 图标颜色，**仅 TTF 模式生效**；未设置时继承 `IconTheme`。对 TwoTone 无效 |
| `twoToneColor` | `Color?` | — | TwoTone 主色，**仅 SVG 模式生效**。替换 SVG 中的 `#333`，次色由主色自动提亮生成；未设置时使用原始双色（`#333` + `#E6E6E6`） |
| `semanticLabel` | `String?` | — | 无障碍语义标签，供屏幕阅读器朗读；`null` 时视为纯装饰图标 |

### AntIcons / AntIconsTwotone

| 成员 | 类型 | 说明 |
| --- | --- | --- |
| `AntIcons.*Outlined` | `IconData` | Outlined 线框图标常量（447 个） |
| `AntIcons.*Filled` | `IconData` | Filled 实心图标常量（251 个） |
| `AntIcons.outlinedIcons` | `List<(String, IconData)>` | Outlined 全量枚举（名称 + 图标），用于图标选择器 |
| `AntIcons.filledIcons` | `List<(String, IconData)>` | Filled 全量枚举 |
| `AntIconsTwotone.*TwoTone` | `String` | TwoTone SVG 资产路径常量（150 个） |
| `AntIconsTwotone.twotoneIcons` | `List<(String, String)>` | TwoTone 全量枚举（名称 + 路径） |

## 字体 Tree-shaking 注意事项

- **Outlined/Filled（TTF）不做按码点裁剪**：全部 698 个 Outlined/Filled 码点打包在单一字体 `fonts/AntIcons.ttf` 中，只要引入本包即整文件随应用发布，与实际引用数量无关。未引用码点不占运行时内存，仅占安装包体积；对包体积敏感时请结合实际需要评估。
- 这与 Material Icons 的 `--tree-shake-icons` 机制不同：本包常量虽为标准 `IconData`，但字体文件本身不会被裁剪。
- **TwoTone（SVG）按资产目录全量打包**：150 个 SVG 文件随 `assets/twotone/` 目录声明进入安装包，当前版本同样不做按引用裁剪。

## TTF vs SVG 场景差异

| 维度 | TTF（Outlined/Filled） | SVG（TwoTone） |
| --- | --- | --- |
| 渲染 | 同步、原生文本渲染，无首帧延迟 | 异步 `rootBundle` 加载资产，`flutter_svg` 解析（自定义 `twoToneColor` 时首帧有空位等待，结果已缓存） |
| 着色 | 单色，`color` 参数 | 双色，`twoToneColor` 设主色、次色自动生成；`color` 无效 |
| 体积 | 单字体文件，整体打包、不可裁剪 | 每图标一个文件，目录全量打包 |
| 依赖 | 无额外依赖 | 依赖 `flutter_svg` |
| 适用 | 高频小图标、列表/按钮/导航等单色场景 | 需要双色视觉层次的品牌化、强调性场景 |

## 注意事项

1. **twoTone 需要资产加载**：TwoTone 图标首次渲染需异步读取 SVG 资产，请避免在 `build` 中同步依赖其像素结果；色彩替换结果按「路径 + 主色 + 次色」缓存，重复渲染无额外开销。
2. **`color` 与 `twoToneColor` 互不越界**：`color` 只影响 TTF 图标，`twoToneColor` 只影响 TwoTone 图标，传错模式不会生效也不会报错。
3. **常量名必须带风格后缀**：`AntIcons.check` 不存在，应为 `AntIcons.checkOutlined`。
4. **无障碍**：功能性图标务必传 `semanticLabel`；纯装饰图标可省略。
5. **版本状态**：本包处于 beta 阶段，1.0.0 前 API 可能调整，生产使用请关注 CHANGELOG。
