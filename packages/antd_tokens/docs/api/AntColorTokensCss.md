<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntColorTokensCss

> 种类：类

```dart
class AntColorTokensCss
```

CSS 字符串形式的颜色令牌（原始值，调试与导出用）。

保存 `AntColorTokens` 全部字段的 CSS 表达（hex / rgba），
便于与 antd Web 端输出对拍和序列化；运行时请优先使用
`AntColorTokens` 的 `Color` getter。

## 构造函数

### `AntColorTokensCss({required this.colorBgBase, required this.colorTextBase, required this.colorWhite, required this.colorShadow, required this.colorBgMask, required this.colorText, required this.colorTextSecondary, required this.colorTextTertiary, required this.colorTextQuaternary, this.colorTextHeading = '', this.colorTextLabel = '', this.colorTextDescription = '', this.colorTextLightSolid = '', this.colorTextPlaceholder = '', this.colorTextDisabled = '', this.colorHighlight = '', this.colorIcon = '', this.colorIconHover = '', required this.colorFill, required this.colorFillSecondary, required this.colorFillTertiary, required this.colorFillQuaternary, this.colorFillContent = '', this.colorFillContentHover = '', this.colorFillAlter = '', required this.colorBgContainer, required this.colorBgElevated, required this.colorBgLayout, required this.colorBgSpotlight, required this.colorBgBlur, this.colorBgContainerDisabled = '', required this.colorBgSolid, required this.colorBgSolidHover, required this.colorBgSolidActive, this.colorBgTextHover = '', this.colorBgTextActive = '', required this.colorBorder, required this.colorBorderSecondary, required this.colorBorderDisabled, this.colorBorderBg = '', this.colorSplit = '', required this.colorPrimary, required this.colorPrimaryBg, required this.colorPrimaryBgHover, required this.colorPrimaryBorder, required this.colorPrimaryBorderHover, required this.colorPrimaryHover, required this.colorPrimaryActive, required this.colorPrimaryTextHover, required this.colorPrimaryText, required this.colorPrimaryTextActive, required this.colorSuccess, required this.colorSuccessBg, required this.colorSuccessBgHover, required this.colorSuccessBorder, required this.colorSuccessBorderHover, required this.colorSuccessHover, required this.colorSuccessActive, required this.colorSuccessTextHover, required this.colorSuccessText, required this.colorSuccessTextActive, required this.colorError, required this.colorErrorBg, required this.colorErrorBgHover, required this.colorErrorBgHoverFilled, required this.colorErrorBgActive, required this.colorErrorBorder, required this.colorErrorBorderHover, required this.colorErrorHover, required this.colorErrorActive, required this.colorErrorTextHover, required this.colorErrorText, required this.colorErrorTextActive, this.colorErrorOutline = '', this.colorErrorAffix = '', required this.colorWarning, required this.colorWarningBg, required this.colorWarningBgHover, required this.colorWarningBorder, required this.colorWarningBorderHover, required this.colorWarningHover, required this.colorWarningActive, required this.colorWarningTextHover, required this.colorWarningText, required this.colorWarningTextActive, this.colorWarningOutline = '', this.colorWarningAffix = '', required this.colorInfo, required this.colorInfoBg, required this.colorInfoBgHover, required this.colorInfoBorder, required this.colorInfoBorderHover, required this.colorInfoHover, required this.colorInfoActive, required this.colorInfoTextHover, required this.colorInfoText, required this.colorInfoTextActive, required this.colorLink, required this.colorLinkHover, required this.colorLinkActive, this.controlOutline = '', this.controlTmpOutline = '', this.controlItemBgHover = '', this.controlItemBgActive = '', this.controlItemBgActiveHover = '', this.controlItemBgActiveDisabled = ''})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `colorBgBase` | `String` | 可选 | — |
| `colorTextBase` | `String` | 可选 | — |
| `colorWhite` | `String` | 可选 | — |
| `colorShadow` | `String` | 可选 | — |
| `colorBgMask` | `String` | 可选 | — |
| `colorText` | `String` | 可选 | — |
| `colorTextSecondary` | `String` | 可选 | — |
| `colorTextTertiary` | `String` | 可选 | — |
| `colorTextQuaternary` | `String` | 可选 | — |
| `colorTextHeading` | `String` | = '' | — |
| `colorTextLabel` | `String` | = '' | — |
| `colorTextDescription` | `String` | = '' | — |
| `colorTextLightSolid` | `String` | = '' | — |
| `colorTextPlaceholder` | `String` | = '' | — |
| `colorTextDisabled` | `String` | = '' | — |
| `colorHighlight` | `String` | = '' | — |
| `colorIcon` | `String` | = '' | — |
| `colorIconHover` | `String` | = '' | — |
| `colorFill` | `String` | 可选 | — |
| `colorFillSecondary` | `String` | 可选 | — |
| `colorFillTertiary` | `String` | 可选 | — |
| `colorFillQuaternary` | `String` | 可选 | — |
| `colorFillContent` | `String` | = '' | — |
| `colorFillContentHover` | `String` | = '' | — |
| `colorFillAlter` | `String` | = '' | — |
| `colorBgContainer` | `String` | 可选 | — |
| `colorBgElevated` | `String` | 可选 | — |
| `colorBgLayout` | `String` | 可选 | — |
| `colorBgSpotlight` | `String` | 可选 | — |
| `colorBgBlur` | `String` | 可选 | — |
| `colorBgContainerDisabled` | `String` | = '' | — |
| `colorBgSolid` | `String` | 可选 | — |
| `colorBgSolidHover` | `String` | 可选 | — |
| `colorBgSolidActive` | `String` | 可选 | — |
| `colorBgTextHover` | `String` | = '' | — |
| `colorBgTextActive` | `String` | = '' | — |
| `colorBorder` | `String` | 可选 | — |
| `colorBorderSecondary` | `String` | 可选 | — |
| `colorBorderDisabled` | `String` | 可选 | — |
| `colorBorderBg` | `String` | = '' | — |
| `colorSplit` | `String` | = '' | — |
| `colorPrimary` | `String` | 可选 | — |
| `colorPrimaryBg` | `String` | 可选 | — |
| `colorPrimaryBgHover` | `String` | 可选 | — |
| `colorPrimaryBorder` | `String` | 可选 | — |
| `colorPrimaryBorderHover` | `String` | 可选 | — |
| `colorPrimaryHover` | `String` | 可选 | — |
| `colorPrimaryActive` | `String` | 可选 | — |
| `colorPrimaryTextHover` | `String` | 可选 | — |
| `colorPrimaryText` | `String` | 可选 | — |
| `colorPrimaryTextActive` | `String` | 可选 | — |
| `colorSuccess` | `String` | 可选 | — |
| `colorSuccessBg` | `String` | 可选 | — |
| `colorSuccessBgHover` | `String` | 可选 | — |
| `colorSuccessBorder` | `String` | 可选 | — |
| `colorSuccessBorderHover` | `String` | 可选 | — |
| `colorSuccessHover` | `String` | 可选 | — |
| `colorSuccessActive` | `String` | 可选 | — |
| `colorSuccessTextHover` | `String` | 可选 | — |
| `colorSuccessText` | `String` | 可选 | — |
| `colorSuccessTextActive` | `String` | 可选 | — |
| `colorError` | `String` | 可选 | — |
| `colorErrorBg` | `String` | 可选 | — |
| `colorErrorBgHover` | `String` | 可选 | — |
| `colorErrorBgHoverFilled` | `String` | 可选 | — |
| `colorErrorBgActive` | `String` | 可选 | — |
| `colorErrorBorder` | `String` | 可选 | — |
| `colorErrorBorderHover` | `String` | 可选 | — |
| `colorErrorHover` | `String` | 可选 | — |
| `colorErrorActive` | `String` | 可选 | — |
| `colorErrorTextHover` | `String` | 可选 | — |
| `colorErrorText` | `String` | 可选 | — |
| `colorErrorTextActive` | `String` | 可选 | — |
| `colorErrorOutline` | `String` | = '' | — |
| `colorErrorAffix` | `String` | = '' | — |
| `colorWarning` | `String` | 可选 | — |
| `colorWarningBg` | `String` | 可选 | — |
| `colorWarningBgHover` | `String` | 可选 | — |
| `colorWarningBorder` | `String` | 可选 | — |
| `colorWarningBorderHover` | `String` | 可选 | — |
| `colorWarningHover` | `String` | 可选 | — |
| `colorWarningActive` | `String` | 可选 | — |
| `colorWarningTextHover` | `String` | 可选 | — |
| `colorWarningText` | `String` | 可选 | — |
| `colorWarningTextActive` | `String` | 可选 | — |
| `colorWarningOutline` | `String` | = '' | — |
| `colorWarningAffix` | `String` | = '' | — |
| `colorInfo` | `String` | 可选 | — |
| `colorInfoBg` | `String` | 可选 | — |
| `colorInfoBgHover` | `String` | 可选 | — |
| `colorInfoBorder` | `String` | 可选 | — |
| `colorInfoBorderHover` | `String` | 可选 | — |
| `colorInfoHover` | `String` | 可选 | — |
| `colorInfoActive` | `String` | 可选 | — |
| `colorInfoTextHover` | `String` | 可选 | — |
| `colorInfoText` | `String` | 可选 | — |
| `colorInfoTextActive` | `String` | 可选 | — |
| `colorLink` | `String` | 可选 | — |
| `colorLinkHover` | `String` | 可选 | — |
| `colorLinkActive` | `String` | 可选 | — |
| `controlOutline` | `String` | = '' | — |
| `controlTmpOutline` | `String` | = '' | — |
| `controlItemBgHover` | `String` | = '' | — |
| `controlItemBgActive` | `String` | = '' | — |
| `controlItemBgActiveHover` | `String` | = '' | — |
| `controlItemBgActiveDisabled` | `String` | = '' | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `colorBgBase` | `String` | 背景基色（亮 #fff / 暗 #000，派生自种子） |
| `colorBgBlur` | `String` | 毛玻璃背景色（暗色为基色 4% alpha，亮色透明） |
| `colorBgContainer` | `String` | 容器背景色（亮色等于基色，暗色 lighten 8%） |
| `colorBgContainerDisabled` | `String` | 禁用容器背景色（Alias：等于 colorFillTertiary） |
| `colorBgElevated` | `String` | 浮层背景色（暗色 lighten 12%，亮色等于基色） |
| `colorBgLayout` | `String` | 布局背景色（亮色 darken 4%，暗色等于基色） |
| `colorBgMask` | `String` | 遮罩背景色（黑色 45% 透明度） |
| `colorBgSolid` | `String` | 实底背景色（基色 100%/暗色 95% alpha） |
| `colorBgSolidActive` | `String` | 实底背景 active 色（基色 95%/暗色 90% alpha） |
| `colorBgSolidHover` | `String` | 实底背景 hover 色（基色 75%/暗色 100% alpha） |
| `colorBgSpotlight` | `String` | 聚光背景色（亮色为文字基色 85% alpha，暗色 lighten 26%） |
| `colorBgTextActive` | `String` | 文字背景 active 色（Alias：等于 colorFill） |
| `colorBgTextHover` | `String` | 文字背景 hover 色（Alias：等于 colorFillSecondary） |
| `colorBorder` | `String` | 默认边框色（背景基色 darken 15%/暗色 lighten 26%） |
| `colorBorderBg` | `String` | 边框与背景交界色（Alias：等于 colorBgContainer） |
| `colorBorderDisabled` | `String` | 禁用态边框色（与 colorBorder 同值） |
| `colorBorderSecondary` | `String` | 次级边框色（背景基色 darken 6%/暗色 lighten 19%） |
| `colorError` | `String` | 错误色色板第 6 阶主色值（色板第 6 阶） |
| `colorErrorActive` | `String` | 错误色色板第 7 阶（active 态色）（色板第 7 阶） |
| `colorErrorAffix` | `String` | 错误色缀件色（Alias：等于 colorError） |
| `colorErrorBg` | `String` | 错误色色板第 1 阶（浅背景色）（色板第 1 阶） |
| `colorErrorBgActive` | `String` | — |
| `colorErrorBgHover` | `String` | 错误色色板第 2 阶（背景 hover 色）（色板第 2 阶） |
| `colorErrorBgHoverFilled` | `String` | 错误色填充 hover 背景（色板第 2/4 阶 50% 混合） |
| `colorErrorBorder` | `String` | 错误色色板第 3 阶（边框色）（色板第 3 阶） |
| `colorErrorBorderHover` | `String` | 错误色色板第 4 阶（边框 hover 色）（色板第 4 阶） |
| `colorErrorHover` | `String` | 错误色 hover 态色值（色板第 4 阶，与 BorderHover 同阶） |
| `colorErrorOutline` | `String` | 错误色焦点轮廓色（Alias：colorErrorBg 的最小 alpha 等价色） |
| `colorErrorText` | `String` | 错误色色板第 9 阶（文字色）（色板第 9 阶） |
| `colorErrorTextActive` | `String` | 错误色色板第 10 阶（active 态文字色）（色板第 10 阶） |
| `colorErrorTextHover` | `String` | 错误色色板第 8 阶（hover 态文字色）（色板第 8 阶） |
| `colorFill` | `String` | 默认填充色（文字基色 15%/暗色 18% alpha） |
| `colorFillAlter` | `String` | 斑马纹/间隔填充色（Alias：等于 colorFillQuaternary） |
| `colorFillContent` | `String` | 内容填充色（Alias：等于 colorFillSecondary） |
| `colorFillContentHover` | `String` | 内容填充 hover 色（Alias：等于 colorFill） |
| `colorFillQuaternary` | `String` | 四级填充色（基色 2%/暗色 4% alpha） |
| `colorFillSecondary` | `String` | 次级填充色（基色 6%/暗色 12% alpha） |
| `colorFillTertiary` | `String` | 三级填充色（基色 4%/暗色 8% alpha） |
| `colorHighlight` | `String` | 高亮色（Alias：等于 colorError） |
| `colorIcon` | `String` | 图标默认色（Alias：等于 colorTextTertiary） |
| `colorIconHover` | `String` | 图标 hover 色（Alias：等于 colorText） |
| `colorInfo` | `String` | 信息色色板第 6 阶主色值（色板第 6 阶） |
| `colorInfoActive` | `String` | 信息色色板第 7 阶（active 态色）（色板第 7 阶） |
| `colorInfoBg` | `String` | 信息色色板第 1 阶（浅背景色）（色板第 1 阶） |
| `colorInfoBgHover` | `String` | 信息色色板第 2 阶（背景 hover 色）（色板第 2 阶） |
| `colorInfoBorder` | `String` | 信息色色板第 3 阶（边框色）（色板第 3 阶） |
| `colorInfoBorderHover` | `String` | 信息色色板第 4 阶（边框 hover 色）（色板第 4 阶） |
| `colorInfoHover` | `String` | 信息色 hover 态色值（色板第 4 阶，与 BorderHover 同阶） |
| `colorInfoText` | `String` | 信息色色板第 9 阶（文字色）（色板第 9 阶） |
| `colorInfoTextActive` | `String` | 信息色色板第 10 阶（active 态文字色）（色板第 10 阶） |
| `colorInfoTextHover` | `String` | 信息色色板第 8 阶（hover 态文字色）（色板第 8 阶） |
| `colorLink` | `String` | 链接色（种子 colorLink/colorInfo 色板第 6 阶） |
| `colorLinkActive` | `String` | 链接 active 色（链接色板第 7 阶） |
| `colorLinkHover` | `String` | 链接 hover 色（链接色板第 4 阶） |
| `colorPrimary` | `String` | 主色色板第 6 阶主色值（色板第 6 阶） |
| `colorPrimaryActive` | `String` | 主色色板第 7 阶（active 态色）（色板第 7 阶） |
| `colorPrimaryBg` | `String` | 主色色板第 1 阶（浅背景色）（色板第 1 阶） |
| `colorPrimaryBgHover` | `String` | 主色色板第 2 阶（背景 hover 色）（色板第 2 阶） |
| `colorPrimaryBorder` | `String` | 主色色板第 3 阶（边框色）（色板第 3 阶） |
| `colorPrimaryBorderHover` | `String` | 主色色板第 4 阶（边框 hover 色）（色板第 4 阶） |
| `colorPrimaryHover` | `String` | 主色hover 态色值（色板中间阶） |
| `colorPrimaryText` | `String` | 主色色板第 9 阶（文字色）（色板第 9 阶） |
| `colorPrimaryTextActive` | `String` | 主色色板第 10 阶（active 态文字色）（色板第 10 阶） |
| `colorPrimaryTextHover` | `String` | 主色色板第 8 阶（hover 态文字色）（色板第 8 阶） |
| `colorShadow` | `String` | 阴影基色（派生自种子 AntSeedToken.colorShadow） |
| `colorSplit` | `String` | 分割线色（Alias：colorBorderSecondary 在容器背景上的最小 alpha 等价色） |
| `colorSuccess` | `String` | 成功色色板第 6 阶主色值（色板第 6 阶） |
| `colorSuccessActive` | `String` | 成功色色板第 7 阶（active 态色）（色板第 7 阶） |
| `colorSuccessBg` | `String` | 成功色色板第 1 阶（浅背景色）（色板第 1 阶） |
| `colorSuccessBgHover` | `String` | 成功色色板第 2 阶（背景 hover 色）（色板第 2 阶） |
| `colorSuccessBorder` | `String` | 成功色色板第 3 阶（边框色）（色板第 3 阶） |
| `colorSuccessBorderHover` | `String` | 成功色色板第 4 阶（边框 hover 色）（色板第 4 阶） |
| `colorSuccessHover` | `String` | 成功色 hover 态色值（色板第 4 阶，与 BorderHover 同阶） |
| `colorSuccessText` | `String` | 成功色色板第 9 阶（文字色）（色板第 9 阶） |
| `colorSuccessTextActive` | `String` | 成功色色板第 10 阶（active 态文字色）（色板第 10 阶） |
| `colorSuccessTextHover` | `String` | 成功色色板第 8 阶（hover 态文字色）（色板第 8 阶） |
| `colorText` | `String` | 默认文字色（文字基色 88%/暗色 85% alpha） |
| `colorTextBase` | `String` | 文字基色（亮 #000 / 暗 #fff，派生自种子） |
| `colorTextDescription` | `String` | 描述文字色（Alias：等于 colorTextTertiary） |
| `colorTextDisabled` | `String` | 禁用态文字色（Alias：等于 colorTextQuaternary） |
| `colorTextHeading` | `String` | 标题文字色（Alias：等于 colorText） |
| `colorTextLabel` | `String` | 表单标签文字色（Alias：等于 colorTextSecondary） |
| `colorTextLightSolid` | `String` | 深色底上的白色文字色（Alias：等于 colorWhite） |
| `colorTextPlaceholder` | `String` | 占位符文字色（Alias：等于 colorTextQuaternary） |
| `colorTextQuaternary` | `String` | 四级文字色（基色 25% alpha） |
| `colorTextSecondary` | `String` | 次要文字色（基色 65% alpha） |
| `colorTextTertiary` | `String` | 三级文字色（基色 45% alpha） |
| `colorWarning` | `String` | 警告色色板第 6 阶主色值（色板第 6 阶） |
| `colorWarningActive` | `String` | 警告色色板第 7 阶（active 态色）（色板第 7 阶） |
| `colorWarningAffix` | `String` | 警告色缀件色（Alias：等于 colorWarning） |
| `colorWarningBg` | `String` | 警告色色板第 1 阶（浅背景色）（色板第 1 阶） |
| `colorWarningBgHover` | `String` | 警告色色板第 2 阶（背景 hover 色）（色板第 2 阶） |
| `colorWarningBorder` | `String` | 警告色色板第 3 阶（边框色）（色板第 3 阶） |
| `colorWarningBorderHover` | `String` | 警告色色板第 4 阶（边框 hover 色）（色板第 4 阶） |
| `colorWarningHover` | `String` | 警告色 hover 态色值（色板第 4 阶，与 BorderHover 同阶） |
| `colorWarningOutline` | `String` | 警告色焦点轮廓色（Alias：colorWarningBg 的最小 alpha 等价色） |
| `colorWarningText` | `String` | 警告色色板第 9 阶（文字色）（色板第 9 阶） |
| `colorWarningTextActive` | `String` | 警告色色板第 10 阶（active 态文字色）（色板第 10 阶） |
| `colorWarningTextHover` | `String` | 警告色色板第 8 阶（hover 态文字色）（色板第 8 阶） |
| `colorWhite` | `String` | 纯白色常量 #fff |
| `controlItemBgActive` | `String` | 控件条目选中背景（Alias：等于 colorPrimaryBg） |
| `controlItemBgActiveDisabled` | `String` | 控件条目选中禁用背景（Alias：等于 colorFill） |
| `controlItemBgActiveHover` | `String` | 控件条目选中 hover 背景（Alias：等于 colorPrimaryBgHover） |
| `controlItemBgHover` | `String` | 控件条目 hover 背景（Alias：等于 colorFillTertiary） |
| `controlOutline` | `String` | 控件焦点轮廓色（Alias：colorPrimaryBg 在容器背景上的最小 alpha 等价色） |
| `controlTmpOutline` | `String` | 控件临时轮廓色（Alias：等于 colorFillQuaternary） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `copyWith` | `AntColorTokensCss` | — |

