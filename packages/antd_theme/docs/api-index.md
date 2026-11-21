<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；源码 /// 注释变更后重跑 gen-docs -->

# antd_theme API 文档总览

> 自动生成时间：2026-11-21T23:54:46.569223；共 26 个公开 API，详情见 `api/<名称>.md` 独立页面。

## 类（19）

| 名称 | 说明 |
| --- | --- |
| [`AntBreakpoints`](api/AntBreakpoints.md) | 断点判断工具 |
| [`AntControlHeightTokens`](api/AntControlHeightTokens.md) | 控件高度令牌 |
| [`AntFontTokens`](api/AntFontTokens.md) | 字体令牌 |
| [`AntLayoutData`](api/AntLayoutData.md) | 布局信息不可变快照 |
| [`AntMotionTokens`](api/AntMotionTokens.md) | 动效令牌 |
| [`AntOverlayMaterial`](api/AntOverlayMaterial.md) | 浮层内容基座 |
| [`AntPlatform`](api/AntPlatform.md) | AntPlatform — 平台检测工具类 封装 defaultTargetPlatform，区分 desktop… |
| [`AntRadiusTokens`](api/AntRadiusTokens.md) | 圆角令牌 |
| [`AntResponsive`](api/AntResponsive.md) | 响应式布局信息 InheritedModel（按 aspect 细粒度依赖） |
| [`AntResponsiveInit`](api/AntResponsiveInit.md) | AntResponsive 初始化 Widget |
| [`AntResponsiveScope`](api/AntResponsiveScope.md) | 布局信息订阅源（非 Widget 场景） |
| [`AntScale`](api/AntScale.md) | 统一缩放因子 —— 所有设计尺寸乘以该因子 |
| [`AntScreenTokens`](api/AntScreenTokens.md) | 屏幕断点令牌 |
| [`AntScreenUtilInit`](api/AntScreenUtilInit.md) | 兼容入口：历史上用于初始化 flutterscreenutil |
| [`AntSizeTokens`](api/AntSizeTokens.md) | 尺寸令牌 |
| [`AntTheme`](api/AntTheme.md) | AntTheme 主题注入 Widget |
| [`AntThemeBuilder`](api/AntThemeBuilder.md) | 一个便捷的 Builder，在 build 时提供 AntThemeData |
| [`AntThemeData`](api/AntThemeData.md) | Ant Design 主题数据 — 完整令牌集 |
| [`AntThemeScope`](api/AntThemeScope.md) | AntTheme 内部的 InheritedWidget，负责 AntThemeData 的就近读取与 数据变更通… |

## 枚举（5）

| 名称 | 说明 |
| --- | --- |
| [`AntBreakpoint`](api/AntBreakpoint.md) | Ant Design 响应式断点枚举 |
| [`AntDeviceType`](api/AntDeviceType.md) | 设备类型 |
| [`AntFoldState`](api/AntFoldState.md) | 折叠屏状态 |
| [`AntLayoutAspect`](api/AntLayoutAspect.md) | 布局信息 aspect，用于细粒度依赖拆分 |
| [`AntOrientation`](api/AntOrientation.md) | 屏幕方向 |

## 扩展（1）

| 名称 | 说明 |
| --- | --- |
| [`AntMaterialTheme`](api/AntMaterialTheme.md) | antd 主题 → Flutter Material 主题转换扩展 |

## 类型定义（1）

| 名称 | 说明 |
| --- | --- |
| [`AntFoldStateProvider`](api/AntFoldStateProvider.md) | 折叠态外部提供器签名（如 OHOS 经 AntOhosChannel 同步返回） |

