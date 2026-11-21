<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntThemeData

> 种类：类

```dart
class AntThemeData
```

Ant Design 主题数据 — 完整令牌集。

包含 antd `AliasToken` 的全部字段，以 Flutter 原生类型提供。

## 构造函数

### `AntThemeData._({required this.seed, required this.colors, required this.isDark, required this.font, required this.radius, required this.sizes, required this.controlHeights, required this.motion, required this.shadows, required this.screen, this.scale = AntScale.none})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `seed` | `AntSeedToken` | 可选 | — |
| `colors` | `AntColorTokens` | 可选 | — |
| `isDark` | `bool` | 可选 | — |
| `font` | `AntFontTokens` | 可选 | — |
| `radius` | `AntRadiusTokens` | 可选 | — |
| `sizes` | `AntSizeTokens` | 可选 | — |
| `controlHeights` | `AntControlHeightTokens` | 可选 | — |
| `motion` | `AntMotionTokens` | 可选 | — |
| `shadows` | `AntShadowTokens` | 可选 | — |
| `screen` | `AntScreenTokens` | 可选 | — |
| `scale` | `AntScale` | = AntScale.none | — |

### `AntThemeData._fromSeed(AntSeedToken seed, {required bool isDark, AntScale scale = AntScale.none})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `seed` | `AntSeedToken` | 可选 | — |
| `isDark` | `bool` | 可选 | — |
| `scale` | `AntScale` | = AntScale.none | — |

### `AntThemeData.dark({AntSeedToken? seed, AntScale scale = AntScale.none})`

从种子生成暗色主题。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `seed` | `AntSeedToken?` | 可选 | — |
| `scale` | `AntScale` | = AntScale.none | — |

### `AntThemeData.fromSeed(AntSeedToken seed, {bool isDark = false, AntScale scale = AntScale.none})`

从种子生成主题（自动判断亮/暗）。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `seed` | `AntSeedToken` | 可选 | — |
| `isDark` | `bool` | = false | — |
| `scale` | `AntScale` | = AntScale.none | — |

### `AntThemeData.light({AntSeedToken? seed, AntScale scale = AntScale.none})`

从种子生成亮色主题。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `seed` | `AntSeedToken?` | 可选 | — |
| `scale` | `AntScale` | = AntScale.none | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `colors` | `AntColorTokens` | 颜色令牌集 |
| `controlHeights` | `AntControlHeightTokens` | 控件高度令牌 |
| `font` | `AntFontTokens` | 字体令牌 |
| `isDark` | `bool` | 是否暗色主题 |
| `motion` | `AntMotionTokens` | 动效令牌 |
| `radius` | `AntRadiusTokens` | 圆角令牌 |
| `scale` | `AntScale` | 统一缩放因子（设计值 → 实际值） |
| `screen` | `AntScreenTokens` | 屏幕断点令牌 |
| `seed` | `AntSeedToken` | 种子令牌（原始输入） |
| `shadows` | `AntShadowTokens` | 阴影令牌 |
| `sizes` | `AntSizeTokens` | 尺寸令牌 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `borderRadius` | `double` | — |
| `borderRadiusLG` | `double` | — |
| `borderRadiusOuter` | `double` | — |
| `borderRadiusSM` | `double` | — |
| `borderRadiusXS` | `double` | — |
| `boxShadow` | `List<BoxShadow>` | — |
| `boxShadowCard` | `List<BoxShadow>` | — |
| `boxShadowDrawerDown` | `List<BoxShadow>` | — |
| `boxShadowDrawerLeft` | `List<BoxShadow>` | — |
| `boxShadowDrawerRight` | `List<BoxShadow>` | — |
| `boxShadowDrawerUp` | `List<BoxShadow>` | — |
| `boxShadowPopoverArrow` | `List<BoxShadow>` | — |
| `boxShadowSecondary` | `List<BoxShadow>` | — |
| `boxShadowTabsOverflowBottom` | `List<BoxShadow>` | — |
| `boxShadowTabsOverflowLeft` | `List<BoxShadow>` | — |
| `boxShadowTabsOverflowRight` | `List<BoxShadow>` | — |
| `boxShadowTabsOverflowTop` | `List<BoxShadow>` | — |
| `boxShadowTertiary` | `List<BoxShadow>` | — |
| `colorBgBase` | `Color` | — |
| `colorBgBlur` | `Color` | — |
| `colorBgContainer` | `Color` | — |
| `colorBgContainerDisabled` | `Color` | — |
| `colorBgElevated` | `Color` | — |
| `colorBgLayout` | `Color` | — |
| `colorBgMask` | `Color` | — |
| `colorBgSolid` | `Color` | — |
| `colorBgSolidActive` | `Color` | — |
| `colorBgSolidHover` | `Color` | — |
| `colorBgSpotlight` | `Color` | — |
| `colorBgTextActive` | `Color` | — |
| `colorBgTextHover` | `Color` | — |
| `colorBorder` | `Color` | — |
| `colorBorderBg` | `Color` | — |
| `colorBorderDisabled` | `Color` | — |
| `colorBorderSecondary` | `Color` | — |
| `colorError` | `Color` | — |
| `colorErrorActive` | `Color` | — |
| `colorErrorAffix` | `Color` | — |
| `colorErrorBg` | `Color` | — |
| `colorErrorBgActive` | `Color` | — |
| `colorErrorBgHover` | `Color` | — |
| `colorErrorBorder` | `Color` | — |
| `colorErrorBorderHover` | `Color` | — |
| `colorErrorHover` | `Color` | — |
| `colorErrorOutline` | `Color` | — |
| `colorErrorText` | `Color` | — |
| `colorErrorTextActive` | `Color` | — |
| `colorErrorTextHover` | `Color` | — |
| `colorFill` | `Color` | — |
| `colorFillAlter` | `Color` | — |
| `colorFillContent` | `Color` | — |
| `colorFillContentHover` | `Color` | — |
| `colorFillQuaternary` | `Color` | — |
| `colorFillSecondary` | `Color` | — |
| `colorFillTertiary` | `Color` | — |
| `colorHighlight` | `Color` | — |
| `colorIcon` | `Color` | — |
| `colorIconHover` | `Color` | — |
| `colorInfo` | `Color` | — |
| `colorInfoActive` | `Color` | — |
| `colorInfoBg` | `Color` | — |
| `colorInfoBgHover` | `Color` | — |
| `colorInfoBorder` | `Color` | — |
| `colorInfoBorderHover` | `Color` | — |
| `colorInfoHover` | `Color` | — |
| `colorInfoText` | `Color` | — |
| `colorInfoTextActive` | `Color` | — |
| `colorInfoTextHover` | `Color` | — |
| `colorLink` | `Color` | — |
| `colorLinkActive` | `Color` | — |
| `colorLinkHover` | `Color` | — |
| `colorPrimary` | `Color` | — |
| `colorPrimaryActive` | `Color` | — |
| `colorPrimaryBg` | `Color` | — |
| `colorPrimaryBgHover` | `Color` | — |
| `colorPrimaryBorder` | `Color` | — |
| `colorPrimaryBorderHover` | `Color` | — |
| `colorPrimaryHover` | `Color` | — |
| `colorPrimaryText` | `Color` | — |
| `colorPrimaryTextActive` | `Color` | — |
| `colorPrimaryTextHover` | `Color` | — |
| `colorShadow` | `Color` | — |
| `colorSplit` | `Color` | — |
| `colorSuccess` | `Color` | — |
| `colorSuccessActive` | `Color` | — |
| `colorSuccessBg` | `Color` | — |
| `colorSuccessBgHover` | `Color` | — |
| `colorSuccessBorder` | `Color` | — |
| `colorSuccessBorderHover` | `Color` | — |
| `colorSuccessHover` | `Color` | — |
| `colorSuccessText` | `Color` | — |
| `colorSuccessTextActive` | `Color` | — |
| `colorSuccessTextHover` | `Color` | — |
| `colorText` | `Color` | — |
| `colorTextDescription` | `Color` | — |
| `colorTextDisabled` | `Color` | — |
| `colorTextHeading` | `Color` | — |
| `colorTextLabel` | `Color` | — |
| `colorTextLightSolid` | `Color` | — |
| `colorTextPlaceholder` | `Color` | — |
| `colorTextQuaternary` | `Color` | — |
| `colorTextSecondary` | `Color` | — |
| `colorTextTertiary` | `Color` | — |
| `colorWarning` | `Color` | — |
| `colorWarningActive` | `Color` | — |
| `colorWarningAffix` | `Color` | — |
| `colorWarningBg` | `Color` | — |
| `colorWarningBgHover` | `Color` | — |
| `colorWarningBorder` | `Color` | — |
| `colorWarningBorderHover` | `Color` | — |
| `colorWarningHover` | `Color` | — |
| `colorWarningOutline` | `Color` | — |
| `colorWarningText` | `Color` | — |
| `colorWarningTextActive` | `Color` | — |
| `colorWarningTextHover` | `Color` | — |
| `colorWhite` | `Color` | — |
| `controlHeight` | `double` | — |
| `controlHeightLG` | `double` | — |
| `controlHeightSM` | `double` | — |
| `controlHeightXS` | `double` | — |
| `controlInteractiveSize` | `double` | — |
| `controlItemBgActive` | `Color` | — |
| `controlItemBgActiveDisabled` | `Color` | — |
| `controlItemBgActiveHover` | `Color` | — |
| `controlItemBgHover` | `Color` | — |
| `controlOutline` | `Color` | — |
| `controlOutlineWidth` | `double` | — |
| `controlPaddingHorizontal` | `double` | — |
| `controlPaddingHorizontalSM` | `double` | — |
| `controlTmpOutline` | `Color` | — |
| `fontFamily` | `String` | — |
| `fontFamilyCode` | `String` | — |
| `fontHeight` | `double` | — |
| `fontHeightLG` | `double` | — |
| `fontHeightSM` | `double` | — |
| `fontSize` | `double` | — |
| `fontSizeHeading1` | `double` | — |
| `fontSizeHeading2` | `double` | — |
| `fontSizeHeading3` | `double` | — |
| `fontSizeHeading4` | `double` | — |
| `fontSizeHeading5` | `double` | — |
| `fontSizeIcon` | `double` | — |
| `fontSizeLG` | `double` | — |
| `fontSizeSM` | `double` | — |
| `fontSizeXL` | `double` | — |
| `fontWeightStrong` | `int` | — |
| `lineHeight` | `double` | — |
| `lineHeightHeading1` | `double` | — |
| `lineHeightHeading2` | `double` | — |
| `lineHeightHeading3` | `double` | — |
| `lineHeightHeading4` | `double` | — |
| `lineHeightHeading5` | `double` | — |
| `lineHeightLG` | `double` | — |
| `lineHeightSM` | `double` | — |
| `lineType` | `String` | — |
| `lineWidth` | `double` | — |
| `lineWidthBold` | `double` | — |
| `lineWidthFocus` | `double` | — |
| `margin` | `double` | — |
| `marginLG` | `double` | — |
| `marginMD` | `double` | — |
| `marginSM` | `double` | — |
| `marginXL` | `double` | — |
| `marginXS` | `double` | — |
| `marginXXL` | `double` | — |
| `marginXXS` | `double` | — |
| `motionDurationFast` | `Duration` | — |
| `motionDurationMid` | `Duration` | — |
| `motionDurationSlow` | `Duration` | — |
| `motionEaseInBack` | `Curve` | — |
| `motionEaseInOut` | `Curve` | — |
| `motionEaseInOutCirc` | `Curve` | — |
| `motionEaseInQuint` | `Curve` | — |
| `motionEaseOut` | `Curve` | — |
| `motionEaseOutBack` | `Curve` | — |
| `motionEaseOutCirc` | `Curve` | — |
| `motionEaseOutQuint` | `Curve` | — |
| `opacityImage` | `double` | — |
| `opacityLoading` | `double` | — |
| `padding` | `double` | — |
| `paddingContentHorizontal` | `double` | — |
| `paddingContentHorizontalLG` | `double` | — |
| `paddingContentHorizontalSM` | `double` | — |
| `paddingContentVertical` | `double` | — |
| `paddingContentVerticalLG` | `double` | — |
| `paddingContentVerticalSM` | `double` | — |
| `paddingLG` | `double` | — |
| `paddingMD` | `double` | — |
| `paddingSM` | `double` | — |
| `paddingXL` | `double` | — |
| `paddingXS` | `double` | — |
| `paddingXXS` | `double` | — |
| `screenLG` | `int` | — |
| `screenLGMax` | `int` | — |
| `screenLGMin` | `int` | — |
| `screenMD` | `int` | — |
| `screenMDMax` | `int` | — |
| `screenMDMin` | `int` | — |
| `screenSM` | `int` | — |
| `screenSMMax` | `int` | — |
| `screenSMMin` | `int` | — |
| `screenXL` | `int` | — |
| `screenXLMax` | `int` | — |
| `screenXLMin` | `int` | — |
| `screenXS` | `int` | — |
| `screenXSMax` | `int` | — |
| `screenXSMin` | `int` | — |
| `screenXXL` | `int` | — |
| `screenXXLMax` | `int` | — |
| `screenXXLMin` | `int` | — |
| `screenXXXL` | `int` | — |
| `screenXXXLMin` | `int` | — |
| `size` | `double` | — |
| `sizeLG` | `double` | — |
| `sizeMD` | `double` | — |
| `sizeMS` | `double` | — |
| `sizePopupArrow` | `double` | — |
| `sizeSM` | `double` | — |
| `sizeXL` | `double` | — |
| `sizeXS` | `double` | — |
| `sizeXXL` | `double` | — |
| `sizeXXS` | `double` | — |
| `zIndexBase` | `int` | — |
| `zIndexPopupBase` | `int` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `s` | `double` | 设计值按当前缩放因子换算（组件内零散尺寸唯一入口） |
| `_parseCubicBezier` | `Curve` | 解析 CSS cubic-bezier 为 Flutter Curve |

