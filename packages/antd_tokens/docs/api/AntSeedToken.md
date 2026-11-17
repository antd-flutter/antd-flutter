<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSeedToken

> 种类：类

```dart
class AntSeedToken
```

Ant Design 种子令牌配置。

对应 antd v6 主题体系中的 `SeedToken`（`components/theme/themes/seed.ts`），
是整个令牌派生链的最小输入集：

```text
AntSeedToken（种子）
  → antGenFontSizes / antGenRadius / antGenSizeMapToken …（生成器，Map Token 层）
  → AntColorTokens.light / AntColorTokens.dark（颜色 Map + Alias 层）
  → AntShadowTokens.generate（Alias 层阴影）
```

修改任意种子值（如 `colorPrimary`）都会逐层传播到生成的
色板、字号阶梯、圆角阶梯与阴影，从而得到一套完整的自定义主题。

使用场景：
- 品牌定制：仅覆盖 `colorPrimary`（可连同 `colorSuccess` / `colorWarning` /
  `colorError` / `colorInfo`），派生出整套装件色板；
- 暗色主题：`AntSeedToken.dark` 工厂生成暗色种子，交给 `AntColorTokens.dark()`；
- 密度/形态调整：修改 `fontSize`、`borderRadius`、`controlHeight`、`sizeStep` 等；
- 运行时动态换肤：借助 `copyWith` 派生新种子。

注意：
- 所有字段为 `final`，定制请通过构造参数或 `copyWith`，不要原地修改；
- `colorLink` / `colorTextBase` / `colorBgBase` / `colorShadow` 用空字符串
  表示"交由算法按主题回退"，等价于 antd 的 `undefined`；
- 本包只负责令牌定义与派生算法；主题装配与 Widget 层消费在 `antd_theme`
  包中完成，业务代码通常不直接构造本类。

示例：以品牌色派生完整主题种子：

```dart
const seed = AntSeedToken(colorPrimary: '#6a3ce8');
final lightColors = AntColorTokens.light(seed);
final shadows = AntShadowTokens.generate(seed.colorShadow.isEmpty ? '#000' : seed.colorShadow);
```

与 antd 的对应关系：
- 类本身对应 `SeedTokenInterface`；
- `AntSeedToken.dark` 对应 antd `theme.darkAlgorithm` 使用的暗色种子预设。
字段默认值与 antd v6 默认种子完全一致。

## 构造函数

### `AntSeedToken({this.colorPrimary = '#1677ff', this.colorSuccess = '#52c41a', this.colorWarning = '#faad14', this.colorError = '#ff4d4f', this.colorInfo = '#1677ff', this.colorLink = '', this.colorTextBase = '', this.colorBgBase = '', this.colorShadow = '', this.fontFamily = "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, 'Noto Sans', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'", this.fontFamilyCode = "'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, Courier, monospace", this.fontSize = 14, this.lineWidth = 1, this.lineType = 'solid', this.motionUnit = 0.1, this.motionBase = 0, this.motion = true, this.motionEaseOutCirc = 'cubic-bezier(0.08, 0.82, 0.17, 1)', this.motionEaseInOutCirc = 'cubic-bezier(0.78, 0.14, 0.15, 0.86)', this.motionEaseOut = 'cubic-bezier(0.215, 0.61, 0.355, 1)', this.motionEaseInOut = 'cubic-bezier(0.645, 0.045, 0.355, 1)', this.motionEaseOutBack = 'cubic-bezier(0.12, 0.4, 0.29, 1.46)', this.motionEaseInBack = 'cubic-bezier(0.71, -0.46, 0.88, 0.6)', this.motionEaseInQuint = 'cubic-bezier(0.755, 0.05, 0.855, 0.06)', this.motionEaseOutQuint = 'cubic-bezier(0.23, 1, 0.32, 1)', this.borderRadius = 6, this.sizeUnit = 4, this.sizeStep = 4, this.sizePopupArrow = 16, this.controlHeight = 32, this.zIndexBase = 0, this.zIndexPopupBase = 1000, this.opacityImage = 1, this.wireframe = false, this.focusOutline = true})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `colorPrimary` | `String` | = '#1677ff' | — |
| `colorSuccess` | `String` | = '#52c41a' | — |
| `colorWarning` | `String` | = '#faad14' | — |
| `colorError` | `String` | = '#ff4d4f' | — |
| `colorInfo` | `String` | = '#1677ff' | — |
| `colorLink` | `String` | = '' | — |
| `colorTextBase` | `String` | = '' | — |
| `colorBgBase` | `String` | = '' | — |
| `colorShadow` | `String` | = '' | — |
| `fontFamily` | `String` | = "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, 'Noto Sans', sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'" | — |
| `fontFamilyCode` | `String` | = "'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, Courier, monospace" | — |
| `fontSize` | `double` | = 14 | — |
| `lineWidth` | `double` | = 1 | — |
| `lineType` | `String` | = 'solid' | — |
| `motionUnit` | `double` | = 0.1 | — |
| `motionBase` | `double` | = 0 | — |
| `motion` | `bool` | = true | — |
| `motionEaseOutCirc` | `String` | = 'cubic-bezier(0.08, 0.82, 0.17, 1)' | — |
| `motionEaseInOutCirc` | `String` | = 'cubic-bezier(0.78, 0.14, 0.15, 0.86)' | — |
| `motionEaseOut` | `String` | = 'cubic-bezier(0.215, 0.61, 0.355, 1)' | — |
| `motionEaseInOut` | `String` | = 'cubic-bezier(0.645, 0.045, 0.355, 1)' | — |
| `motionEaseOutBack` | `String` | = 'cubic-bezier(0.12, 0.4, 0.29, 1.46)' | — |
| `motionEaseInBack` | `String` | = 'cubic-bezier(0.71, -0.46, 0.88, 0.6)' | — |
| `motionEaseInQuint` | `String` | = 'cubic-bezier(0.755, 0.05, 0.855, 0.06)' | — |
| `motionEaseOutQuint` | `String` | = 'cubic-bezier(0.23, 1, 0.32, 1)' | — |
| `borderRadius` | `double` | = 6 | — |
| `sizeUnit` | `double` | = 4 | — |
| `sizeStep` | `double` | = 4 | — |
| `sizePopupArrow` | `double` | = 16 | — |
| `controlHeight` | `double` | = 32 | — |
| `zIndexBase` | `int` | = 0 | — |
| `zIndexPopupBase` | `int` | = 1000 | — |
| `opacityImage` | `double` | = 1 | — |
| `wireframe` | `bool` | = false | — |
| `focusOutline` | `bool` | = true | — |

### `AntSeedToken.dark({String colorTextBase = '#fff', String colorBgBase = '#000', String colorShadow = 'rgba(255, 255, 255, 0.2)'})`

Creates a dark-theme seed，对应 antd `theme.darkAlgorithm` 的暗色种子预设。

与 antd 一致：`colorPrimary` 保持不变（`#1677ff`），
暗色主色 `#1668dc` 由暗色色板算法自动生成；
仅显式设置中性色（文字/背景/阴影），便于调试和自定义。

```dart
final colors = AntColorTokens.dark(AntSeedToken.dark());
```

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `colorTextBase` | `String` | = '#fff' | — |
| `colorBgBase` | `String` | = '#000' | — |
| `colorShadow` | `String` | = 'rgba(255, 255, 255, 0.2)' | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `borderRadius` | `double` | 圆角基数（逻辑像素），对应 antd borderRadius，默认 6 |
| `colorBgBase` | `String` | 背景基色，对应 antd colorBgBase，容器/布局/边框色由其按亮度派生 |
| `colorError` | `String` | 错误色种子值，对应 antd colorError，派生 10 阶错误色板 |
| `colorInfo` | `String` | 信息色种子值，对应 antd colorInfo，派生 10 阶信息色板 |
| `colorLink` | `String` | 链接色种子值，对应 antd colorLink |
| `colorPrimary` | `String` | 品牌主色种子值，对应 antd colorPrimary |
| `colorShadow` | `String` | 阴影基色，对应 antd colorShadow，供 AntShadowTokens.generate 使用 |
| `colorSuccess` | `String` | 成功色种子值，对应 antd colorSuccess，派生 10 阶成功色板 |
| `colorTextBase` | `String` | 文字基色，对应 antd colorTextBase，所有文字/填充色由其按 alpha 派生 |
| `colorWarning` | `String` | 警告色种子值，对应 antd colorWarning，派生 10 阶警告色板 |
| `controlHeight` | `double` | 控件基准高度（逻辑像素），对应 antd controlHeight，默认 32 |
| `focusOutline` | `bool` | Whether to show focus outline |
| `fontFamily` | `String` | 正文字体族 CSS 栈，对应 antd fontFamily |
| `fontFamilyCode` | `String` | 代码字体族 CSS 栈，对应 antd fontFamilyCode |
| `fontSize` | `double` | 基准字号（逻辑像素），对应 antd fontSize，默认 14 |
| `lineType` | `String` | 线型 CSS 值，对应 antd lineType，默认 solid |
| `lineWidth` | `double` | 线宽（逻辑像素），对应 antd lineWidth，默认 1 |
| `motion` | `bool` | Whether to enable motion durations |
| `motionBase` | `double` | 动效时长基数（秒），对应 antd motionBase，默认 0 |
| `motionEaseInBack` | `String` | 动效缓动曲线（CSS cubic-bezier），对应 antd motionEaseInBack |
| `motionEaseInOut` | `String` | 动效缓动曲线（CSS cubic-bezier），对应 antd motionEaseInOut |
| `motionEaseInOutCirc` | `String` | 动效缓动曲线（CSS cubic-bezier），对应 antd motionEaseInOutCirc |
| `motionEaseInQuint` | `String` | 动效缓动曲线（CSS cubic-bezier），对应 antd motionEaseInQuint |
| `motionEaseOut` | `String` | 动效缓动曲线（CSS cubic-bezier），对应 antd motionEaseOut |
| `motionEaseOutBack` | `String` | 动效缓动曲线（CSS cubic-bezier），对应 antd motionEaseOutBack |
| `motionEaseOutCirc` | `String` | 动效缓动曲线（CSS cubic-bezier），对应 antd motionEaseOutCirc |
| `motionEaseOutQuint` | `String` | 动效缓动曲线（CSS cubic-bezier），对应 antd motionEaseOutQuint |
| `motionUnit` | `double` | 动效时长单位（秒），对应 antd motionUnit，默认 0.1 |
| `opacityImage` | `double` | 图片透明度，对应 antd opacityImage，默认 1 |
| `sizePopupArrow` | `double` | 弹出层箭头尺寸（逻辑像素），对应 antd sizePopupArrow，默认 16 |
| `sizeStep` | `double` | 尺寸步长（逻辑像素），对应 antd sizeStep，默认 4 |
| `sizeUnit` | `double` | 尺寸单位（逻辑像素），对应 antd sizeUnit，默认 4 |
| `wireframe` | `bool` | Whether to use wireframe style |
| `zIndexBase` | `int` | Z-Index 基数，对应 antd zIndexBase，默认 0 |
| `zIndexPopupBase` | `int` | 弹出层 Z-Index 基数，对应 antd zIndexPopupBase，默认 1000 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `copyWith` | `AntSeedToken` | Copies this seed with the given fields overridden |

