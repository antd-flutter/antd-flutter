<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；源码 barrel 变更后重跑 gen-docs 命令 -->

# antd_theme API 索引

> 自动生成时间：2026-11-17T14:07:12.498256；共 41 个顶层导出。
>
> antd_theme — Ant Design v6 主题系统
> 
> - [AntThemeData] — 完整主题数据（light / dark / fromSeed 工厂）
> - [AntTheme] — InheritedWidget 主题注入（自动桥接 Flutter `Theme`）
> - [AntMaterialTheme] — AntThemeData → Flutter ThemeData 转换扩展
> - [AntBreakpoint] — 响应式断点（xs ~ xxxl）
> - [AntScreenUtilInit] — 屏幕适配初始化（.w / .sp / .r，禁止 .h）
> 
> 文件按 R25/R26 细粒度分层：
> - `src/enum/` — 枚举与形态定义（AntBreakpoint / AntDeviceType /
>   AntOrientation / AntFoldState / AntLayoutAspect）
> - `src/types/` — 纯数据类型与回调签名（AntLayoutData / AntFoldStateProvider /
>   AntThemeData 子令牌数据类）
> - 主体实现 — ant_theme_data / ant_theme / ant_material_bridge /
>   ant_responsive / ant_platform / ant_screen_util 等

## 顶层导出

### 类（24）

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `AntBreakpoints` | 类 | 断点判断工具 |
| `AntControlHeightTokens` | 类 | 控件高度令牌 |
| `AntFontTokens` | 类 | 字体令牌 |
| `AntLayoutData` | 类 | 布局信息不可变快照 |
| `AntMotionTokens` | 类 | 动效令牌 |
| `AntPlatform` | 类 | AntPlatform — 平台检测工具类 封装 defaultTargetPlatform，区分 desktop… |
| `AntRadiusTokens` | 类 | 圆角令牌 |
| `AntResponsive` | 类 | 响应式布局信息 InheritedModel（按 aspect 细粒度依赖） |
| `AntResponsiveInit` | 类 | AntResponsive 初始化 Widget |
| `AntResponsiveScope` | 类 | 布局信息订阅源（非 Widget 场景） |
| `AntScreenTokens` | 类 | 屏幕断点令牌 |
| `AntScreenUtilInit` | 类 | AntScreenUtil 初始化 Widget |
| `AntSizeTokens` | 类 | 尺寸令牌 |
| `AntTheme` | 类 | AntTheme 主题注入 Widget |
| `AntThemeBuilder` | 类 | 一个便捷的 Builder，在 build 时提供 AntThemeData |
| `AntThemeData` | 类 | Ant Design 主题数据 — 完整令牌集 |
| `AntThemeScope` | 类 | AntTheme 内部的 InheritedWidget，负责 AntThemeData 的就近读取与 数据变更通… |
| `FontSizeResolvers` | 类 | — |
| `REdgeInsets` | 类 | — |
| `REdgeInsetsDirectional` | 类 | — |
| `RPadding` | 类 | — |
| `RSizedBox` | 类 | — |
| `RebuildFactors` | 类 | — |
| `ScreenUtil` | 类 | — |

### 枚举（6）

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `AntBreakpoint` | 枚举 | Ant Design 响应式断点枚举 |
| `AntDeviceType` | 枚举 | 设备类型 |
| `AntFoldState` | 枚举 | 折叠屏状态 |
| `AntLayoutAspect` | 枚举 | 布局信息 aspect，用于细粒度依赖拆分 |
| `AntOrientation` | 枚举 | 屏幕方向 |
| `DeviceType` | 枚举 | — |

### 混入（1）

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `SU` | 混入 | — |

### 扩展（6）

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `AntMaterialTheme` | 扩展 | antd 主题 → Flutter Material 主题转换扩展 |
| `BorderRadiusExtension` | 扩展 | — |
| `BoxConstraintsExtension` | 扩展 | — |
| `EdgeInsetsExtension` | 扩展 | — |
| `RadiusExtension` | 扩展 | — |
| `SizeExtension` | 扩展 | — |

### 类型定义（4）

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `AntFoldStateProvider` | 类型定义 | 折叠态外部提供器签名（如 OHOS 经 AntOhosChannel 同步返回） |
| `FontSizeResolver` | 类型定义 | — |
| `RebuildFactor` | 类型定义 | — |
| `ScreenUtilInitBuilder` | 类型定义 | — |

## 类 / 枚举成员

### `AntThemeData`（239 个公开成员，超过 30 不逐项展开，完整清单见包内 catalog 文档）

### `AntTheme`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | 方法 | — |
| `child` | 字段 | 子组件 |
| `data` | 字段 | 当前主题数据 |
| `of` | 静态方法 | 获取最近祖先 AntTheme 中的主题数据 |

### `AntThemeScope`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `data` | 字段 | 当前主题数据 |
| `updateShouldNotify` | 方法 | — |

### `AntThemeBuilder`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | 方法 | — |
| `builder` | 字段 | 构建回调 |

### `AntMaterialTheme`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `toThemeData` | 方法 | 转换为 Flutter ThemeData |

### `AntBreakpoints`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `AntBreakpoints._` | 构造 | — |
| `isBetween` | 静态方法 | 屏幕宽度是否在 min 和 max 之间（含边界） |
| `isDown` | 静态方法 | 屏幕宽度是否 < bp 的最小宽度 |
| `isUp` | 静态方法 | 屏幕宽度是否 ≥ bp 的最小宽度 |

### `AntPlatform`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `AntPlatform._` | 构造 | — |
| `isAndroid` | 静态方法 | 当前是否为 Android |
| `isDesktop` | 静态方法 | 当前是否为桌面平台（web / windows / macos / linux） |
| `isIOS` | 静态方法 | 当前是否为 iOS |
| `isLinux` | 静态方法 | 当前是否为 Linux |
| `isMacOS` | 静态方法 | 当前是否为 macOS |
| `isMobile` | 静态方法 | 当前是否为移动平台（android / ios / ohos） |
| `isOhos` | 静态方法 | 当前是否为鸿蒙（ohos） 隔离实现：标准 Flutter SDK 的 Platform 类无 isOhos 属性… |
| `isWeb` | 静态方法 | 当前是否为 Web 环境 |
| `isWindows` | 静态方法 | 当前是否为 Windows |
| `name` | 静态方法 | 当前平台名称（用于日志/调试） |
| `showScrollbar` | 静态方法 | 是否显示滚动条 桌面端显示 ScrollbarTheme，移动端隐藏 |
| `supportsHover` | 静态方法 | 是否支持悬停（hover）反馈 桌面端启用 PointerRegion 悬停反馈，移动端跳过 |
| `supportsKeyboard` | 静态方法 | 是否支持键盘焦点遍历（Tab 遍历 + 快捷键） 桌面端支持 FocusNode/Shortcuts，移动端跳过 |
| `useTouchRipple` | 静态方法 | 是否使用触摸涟漪（InkWell ripple）反馈 移动端启用 InkWell 涟漪，桌面端禁用涟漪改用 hov… |

### `AntResponsiveScope`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `layoutListenableOf` | 静态方法 | 获取布局数据 ValueListenable（依赖整体数据变化） |
| `maybeOf` | 静态方法 | 获取最近的订阅源 |
| `notifier` | 字段 | 布局数据通知器 |
| `updateShouldNotify` | 方法 | — |

### `AntResponsive`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `breakpointOf` | 静态方法 | 仅依赖断点 aspect |
| `data` | 字段 | 当前布局数据快照 |
| `deviceTypeOf` | 静态方法 | 仅依赖设备类型 aspect |
| `foldStateOf` | 静态方法 | 仅依赖折叠态 aspect |
| `maybeOf` | 静态方法 | 依赖整体布局数据（任一字段变化即 rebuild） |
| `of` | 静态方法 | 依赖整体布局数据 |
| `platformOf` | 静态方法 | 仅依赖平台 aspect |
| `scaleFactorOf` | 静态方法 | 仅依赖缩放因子 aspect（桌面超宽等比放大时 > 1，默认恒 1.0） |
| `updateShouldNotify` | 方法 | — |
| `updateShouldNotifyDependent` | 方法 | — |
| `widthOf` | 静态方法 | 仅依赖宽度 aspect |

### `AntResponsiveInit`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `builder` | 字段 | 构建回调，携带当前布局快照 |
| `child` | 字段 | 透传子树（稳定实例，配合 builder 实现局部刷新） |
| `createState` | 方法 | — |
| `foldStateProvider` | 字段 | 折叠态外部提供器（OHOS channel 等），null 时自动推导 |

### `AntScreenUtilInit`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `allowScaleUp` | 字段 | 是否允许桌面超宽等比放大 |
| `builder` | 字段 | 构建回调 |
| `child` | 字段 | 传入的 child，避免重建 |
| `createState` | 方法 | — |
| `defaultMaxScaleFactor` | 静态属性 | 桌面默认放大倍率封顶值 |
| `designSize` | 字段 | 设计稿尺寸，默认 375×812 |
| `desktopBreakpoint` | 字段 | 桌面模式宽度阈值（逻辑像素） |
| `maxScaleFactor` | 字段 | 放大倍率封顶保护 |
| `maxWidth` | 字段 | 桌面基准宽度上限（逻辑像素） |
| `minTextAdapt` | 字段 | 是否根据系统字体大小缩放文字 |
| `resolveDesktopScale` | 静态方法 | 计算桌面模式下生效的 designSize 与缩放因子（纯函数，便于测试） |
| `scaleFactorListenable` | 静态方法 | 当前桌面缩放因子（只读视图，见 scaleFactorNotifier） |
| `scaleFactorNotifier` | 静态属性 | 当前桌面缩放因子的全局通知器（非放大时恒为 1.0） |
| `splitScreenMode` | 字段 | 是否支持分屏模式 |

### `RPadding`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createRenderObject` | 方法 | — |
| `padding` | 字段 | The amount of space by which to inset the child. |

### `REdgeInsets`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `REdgeInsets.all` | 构造 | Creates adapt insets where all the offsets are value |
| `REdgeInsets.fromLTRB` | 构造 | Creates adapt insets from offsets from the left, top, rig… |
| `REdgeInsets.only` | 构造 | Creates adapt insets with only the given values non-zero |
| `REdgeInsets.symmetric` | 构造 | Creates adapt insets with symmetrical vertical and horizo… |

### `REdgeInsetsDirectional`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `REdgeInsetsDirectional.all` | 构造 | Creates insets where all the offsets are value |
| `REdgeInsetsDirectional.fromSTEB` | 构造 | Creates adapt insets from offsets from the start, top, en… |
| `REdgeInsetsDirectional.only` | 构造 | Creates insets with only the given values non-zero |

### `RSizedBox`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `RSizedBox.fromSize` | 构造 | — |
| `RSizedBox.horizontal` | 构造 | — |
| `RSizedBox.square` | 构造 | — |
| `RSizedBox.vertical` | 构造 | — |
| `createRenderObject` | 方法 | — |
| `updateRenderObject` | 方法 | — |

### `ScreenUtil`（35 个公开成员，超过 30 不逐项展开，完整清单见包内 catalog 文档）

### `DeviceType`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `fuchsia` | 枚举值 | — |
| `linux` | 枚举值 | — |
| `mac` | 枚举值 | — |
| `mobile` | 枚举值 | — |
| `tablet` | 枚举值 | — |
| `web` | 枚举值 | — |
| `windows` | 枚举值 | — |

### `RebuildFactors`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `always` | 静态方法 | — |
| `change` | 静态方法 | — |
| `none` | 静态方法 | — |
| `orientation` | 静态方法 | — |
| `size` | 静态方法 | — |
| `sizeAndViewInsets` | 静态方法 | — |

### `FontSizeResolvers`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `diagonal` | 静态方法 | — |
| `diameter` | 静态方法 | — |
| `height` | 静态方法 | — |
| `radius` | 静态方法 | — |
| `width` | 静态方法 | — |

### `SizeExtension`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `dg` | 属性 | ScreenUtil.diagonal |
| `dm` | 属性 | ScreenUtil.diameter |
| `h` | 属性 | ScreenUtil.setHeight |
| `horizontalSpace` | 属性 | ScreenUtil.setWidth |
| `horizontalSpaceDiagonal` | 属性 | ScreenUtil.diagonal |
| `horizontalSpaceDiameter` | 属性 | ScreenUtil.diameter |
| `horizontalSpaceRadius` | 属性 | ScreenUtil.radius |
| `r` | 属性 | ScreenUtil.radius |
| `sh` | 属性 | 屏幕高度的倍数 Multiple of screen height |
| `sm` | 属性 | — |
| `sp` | 属性 | ScreenUtil.setSp |
| `spMax` | 属性 | — |
| `spMin` | 属性 | smart size :  it check your value |
| `sw` | 属性 | 屏幕宽度的倍数 Multiple of screen width |
| `verticalSpace` | 属性 | ScreenUtil.setHeight |
| `verticalSpaceFromWidth` | 属性 | ScreenUtil.setVerticalSpacingFromWidth |
| `verticalSpacingDiagonal` | 属性 | ScreenUtil.diagonal |
| `verticalSpacingDiameter` | 属性 | ScreenUtil.diameter |
| `verticalSpacingRadius` | 属性 | ScreenUtil.radius |
| `w` | 属性 | ScreenUtil.setWidth |

### `EdgeInsetsExtension`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `dg` | 属性 | — |
| `dm` | 属性 | — |
| `h` | 属性 | — |
| `r` | 属性 | Creates adapt insets using r SizeExtension. |
| `w` | 属性 | — |

### `BorderRadiusExtension`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `h` | 属性 | — |
| `r` | 属性 | Creates adapt BorderRadius using r SizeExtension. |
| `w` | 属性 | — |

### `RadiusExtension`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `dg` | 属性 | — |
| `dm` | 属性 | — |
| `h` | 属性 | — |
| `r` | 属性 | Creates adapt Radius using r SizeExtension. |
| `w` | 属性 | — |

### `BoxConstraintsExtension`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `h` | 属性 | — |
| `hw` | 属性 | Creates adapt BoxConstraints using h-w SizeExtension. |
| `r` | 属性 | Creates adapt BoxConstraints using r SizeExtension. |
| `w` | 属性 | — |

### `AntBreakpoint`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `<` | 方法 | 当前断点是否 < other |
| `<=` | 方法 | 当前断点是否 ≤ other |
| `>` | 方法 | 当前断点是否 > other |
| `>=` | 方法 | 当前断点是否 ≥ other |
| `fromWidth` | 静态方法 | 从屏幕宽度解析当前命中的最大断点 |
| `lg` | 枚举值 | 大屏（≥992） |
| `md` | 枚举值 | 中屏（≥768） |
| `minWidth` | 字段 | 断点最小宽度（逻辑像素） |
| `of` | 静态方法 | 从 BuildContext 解析当前断点（基于窗口宽度） |
| `sm` | 枚举值 | 小屏（≥576） |
| `xl` | 枚举值 | 超大屏（≥1200） |
| `xs` | 枚举值 | 超小屏（≥480） |
| `xxl` | 枚举值 | 特大屏（≥1600） |
| `xxxl` | 枚举值 | 巨屏（≥1920） |

### `AntDeviceType`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `desktop` | 枚举值 | 桌面（windows / macos / linux） |
| `phone` | 枚举值 | 手机（宽度 < 768 的移动端） |
| `tablet` | 枚举值 | 平板（宽度 >= 768 的移动端） |
| `web` | 枚举值 | Web |

### `AntOrientation`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `landscape` | 枚举值 | — |
| `portrait` | 枚举值 | — |

### `AntFoldState`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `flat` | 枚举值 | 完全展开（大屏单屏） |
| `folded` | 枚举值 | 折叠（合上） |
| `halfOpened` | 枚举值 | 半折叠（悬停态，铰链姿势 half-opened） |
| `unknown` | 枚举值 | 未知（平台无法获取折叠信息时的默认值） |

### `AntLayoutAspect`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `breakpoint` | 枚举值 | 断点 |
| `deviceType` | 枚举值 | 设备类型 |
| `foldState` | 枚举值 | 折叠态 |
| `orientation` | 枚举值 | 方向 |
| `platform` | 枚举值 | 平台信息（targetPlatform / isOhos / isDesktop） |
| `scaleFactor` | 枚举值 | 桌面超宽等比缩放因子（scaleFactor） |
| `width` | 枚举值 | 宽度（任意像素变化） |

### `AntLayoutData`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `==` | 方法 | — |
| `AntLayoutDatafromMediaQuery` | 构造 | 从 MediaQueryData 构建布局快照 |
| `breakpoint` | 字段 | 当前命中的最大断点 |
| `defaultDeviceTypeOf` | 静态方法 | 设备类型判定（宽度 + 平台综合） |
| `deviceType` | 字段 | 设备类型（宽度 + 平台综合判定） |
| `foldState` | 字段 | 折叠屏状态 |
| `foldStateFromDisplayFeatures` | 静态方法 | 从 MediaQueryData.displayFeatures 推导折叠态 |
| `hashCode` | 属性 | — |
| `isDesktop` | 字段 | 是否为桌面类平台（web / windows / macos / linux） |
| `isOhos` | 字段 | 是否为鸿蒙平台 |
| `orientation` | 字段 | 屏幕方向 |
| `scaleFactor` | 字段 | 桌面超宽等比缩放因子 |
| `targetPlatform` | 字段 | 目标平台 |
| `toString` | 方法 | — |
| `width` | 字段 | 窗口逻辑宽度 |

### `AntFontTokens`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `fontHeight` | 字段 | — |
| `fontHeightLG` | 字段 | — |
| `fontHeightSM` | 字段 | — |
| `fontSize` | 字段 | — |
| `fontSizeHeading1` | 字段 | — |
| `fontSizeHeading2` | 字段 | — |
| `fontSizeHeading3` | 字段 | — |
| `fontSizeHeading4` | 字段 | — |
| `fontSizeHeading5` | 字段 | — |
| `fontSizeIcon` | 字段 | — |
| `fontSizeLG` | 字段 | — |
| `fontSizeSM` | 字段 | — |
| `fontSizeXL` | 字段 | — |
| `fontWeightStrong` | 字段 | — |
| `lineHeight` | 字段 | — |
| `lineHeightHeading1` | 字段 | — |
| `lineHeightHeading2` | 字段 | — |
| `lineHeightHeading3` | 字段 | — |
| `lineHeightHeading4` | 字段 | — |
| `lineHeightHeading5` | 字段 | — |
| `lineHeightLG` | 字段 | — |
| `lineHeightSM` | 字段 | — |

### `AntRadiusTokens`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `borderRadius` | 字段 | — |
| `borderRadiusLG` | 字段 | — |
| `borderRadiusOuter` | 字段 | — |
| `borderRadiusSM` | 字段 | — |
| `borderRadiusXS` | 字段 | — |

### `AntSizeTokens`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `size` | 字段 | — |
| `sizeLG` | 字段 | — |
| `sizeMD` | 字段 | — |
| `sizeMS` | 字段 | — |
| `sizeSM` | 字段 | — |
| `sizeXL` | 字段 | — |
| `sizeXS` | 字段 | — |
| `sizeXXL` | 字段 | — |
| `sizeXXS` | 字段 | — |

### `AntControlHeightTokens`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `controlHeightLG` | 字段 | — |
| `controlHeightSM` | 字段 | — |
| `controlHeightXS` | 字段 | — |
| `controlInteractiveSize` | 字段 | — |

### `AntMotionTokens`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `easeInBack` | 字段 | — |
| `easeInOut` | 字段 | — |
| `easeInOutCirc` | 字段 | — |
| `easeInQuint` | 字段 | — |
| `easeOut` | 字段 | — |
| `easeOutBack` | 字段 | — |
| `easeOutCirc` | 字段 | — |
| `easeOutQuint` | 字段 | — |
| `fast` | 字段 | — |
| `mid` | 字段 | — |
| `slow` | 字段 | — |

### `AntScreenTokens`

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `lg` | 字段 | — |
| `lgMax` | 字段 | — |
| `lgMin` | 字段 | — |
| `md` | 字段 | — |
| `mdMax` | 字段 | — |
| `mdMin` | 字段 | — |
| `sm` | 字段 | — |
| `smMax` | 字段 | — |
| `smMin` | 字段 | — |
| `xl` | 字段 | — |
| `xlMax` | 字段 | — |
| `xlMin` | 字段 | — |
| `xs` | 字段 | — |
| `xsMax` | 字段 | — |
| `xsMin` | 字段 | — |
| `xxl` | 字段 | — |
| `xxlMax` | 字段 | — |
| `xxlMin` | 字段 | — |
| `xxxl` | 字段 | — |
| `xxxlMin` | 字段 | — |

