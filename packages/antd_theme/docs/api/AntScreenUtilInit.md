<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntScreenUtilInit

> 种类：类

```dart
class AntScreenUtilInit
```

AntScreenUtil 初始化 Widget。

封装 `ScreenUtilInit`，设置 antd 设计稿尺寸，并内置**桌面自适应**。

默认设计稿尺寸为 375×812（iPhone X 基准），可通过 `designSize` 自定义。

## 桌面自适应

当窗口逻辑宽度 >= `desktopBreakpoint`（默认 768）时，视为桌面环境：
designSize 自动替换为窗口实际逻辑尺寸，使缩放因子恒为 1，
`.w/.sp/.r` 值不缩放，组件保持原始逻辑像素尺寸。
窗口 resize 时自动重新计算，缩放因子始终为 1。

这样桌面端 / 桌面 Web 端组件不会被放大，而手机端 / 手机 Web 端
仍按手机设计稿正常缩放。

设 `desktopBreakpoint` 为 null 可禁用桌面自适应（始终按 `designSize` 缩放）。

## 桌面超宽等比放大

超宽屏（4K / 带鱼屏）下桌面模式因子恒为 1，布局元素会显得偏小。
可通过以下参数开启**等比放大**：

- `allowScaleUp`：是否允许超宽等比放大，默认 `false` 完全保持现状（因子恒 1）；
- `maxWidth`：桌面基准宽度上限（逻辑像素）。窗口宽度 ≤ `maxWidth` 时行为
  不变（因子 1）；超过 `maxWidth` 后 designSize 固定基于 `maxWidth` 计算，
  缩放因子 = 窗口宽度 / `maxWidth` > 1，全 UI 等比放大；
- `maxScaleFactor`：放大倍率封顶保护，超过后不再放大，
  防止极端窗口下元素过大。

组合语义示例：`allowScaleUp: true, maxWidth: 1920, maxScaleFactor: 1.5`
时，窗口宽度 2400 → 因子 = 2400 / 1920 = 1.25（全 UI 等比放大 1.25 倍）；
窗口宽度 3600 → 因子本应为 1.875，被 `maxScaleFactor` 封顶为 1.5。

放大生效时 `AntScreenUtilInit.scaleFactorListenable` 会同步暴露当前因子，
`AntResponsive` 的 `AntLayoutData.scaleFactor` 字段也随之上报，
方便业务感知当前缩放状态。

## 缩放规范

使用 `flutter_screenutil` 时**只允许以下三个扩展**：
- `.w` — 按宽度比例适配（用于宽高、间距、边框等）
- `.sp` — 按宽度和系统字体缩放适配（用于字号）
- `.r` — 按宽高较小值适配（用于圆角）

**禁止使用 `.h`**：高度在不同设备上差异过大，会导致布局异常。
所有高度需求请使用 `.w` 配合 Flex 布局（Expanded / Flexible）解决。

```dart
AntScreenUtilInit(
  builder: (context, child) => MaterialApp(...),
)
```

## 构造函数

### `AntScreenUtilInit({super.key, this.designSize = const Size(375, 812), required this.builder, this.child, this.minTextAdapt = true, this.splitScreenMode = true, this.desktopBreakpoint = 768, this.maxWidth, this.allowScaleUp = false, this.maxScaleFactor = defaultMaxScaleFactor})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `designSize` | `Size` | = const Size(375, 812) | — |
| `builder` | `Widget Function(BuildContext, Widget?)` | 可选 | — |
| `child` | `Widget?` | 可选 | — |
| `minTextAdapt` | `bool` | = true | — |
| `splitScreenMode` | `bool` | = true | — |
| `desktopBreakpoint` | `double?` | = 768 | — |
| `maxWidth` | `double?` | 可选 | — |
| `allowScaleUp` | `bool` | = false | — |
| `maxScaleFactor` | `double` | = defaultMaxScaleFactor | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `allowScaleUp` | `bool` | 是否允许桌面超宽等比放大 |
| `builder` | `Widget Function(BuildContext, Widget?)` | 构建回调 |
| `child` | `Widget?` | 传入的 child，避免重建 |
| `designSize` | `Size` | 设计稿尺寸，默认 375×812 |
| `desktopBreakpoint` | `double?` | 桌面模式宽度阈值（逻辑像素） |
| `maxScaleFactor` | `double` | 放大倍率封顶保护 |
| `maxWidth` | `double?` | 桌面基准宽度上限（逻辑像素） |
| `minTextAdapt` | `bool` | 是否根据系统字体大小缩放文字 |
| `splitScreenMode` | `bool` | 是否支持分屏模式 |
| `defaultMaxScaleFactor` | `double` | 桌面默认放大倍率封顶值 |
| `scaleFactorNotifier` | `ValueNotifier<double>` | 当前桌面缩放因子的全局通知器（非放大时恒为 1.0） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntScreenUtilInit>` | — |
| `resolveDesktopScale` | `({Size designSize, double scaleFactor})` | 计算桌面模式下生效的 designSize 与缩放因子（纯函数，便于测试） |
| `scaleFactorListenable` | `ValueListenable<double>` | 当前桌面缩放因子（只读视图，见 scaleFactorNotifier） |

