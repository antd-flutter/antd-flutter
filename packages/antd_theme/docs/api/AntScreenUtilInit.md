<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntScreenUtilInit

> 种类：类

```dart
class AntScreenUtilInit
```

兼容入口：历史上用于初始化 `flutter_screenutil`。

自 2026-11-21 起仓库改为 **AntScale 因子**（见 `AntScale` / `AntThemeData.s`），
不再依赖 `flutter_screenutil`；本组件仅保留为直通包装，按原样构建 `builder`，
不再进行任何屏幕缩放，也不再要求外层初始化。

新代码请直接使用 `AntTheme` + `theme.s(...)` / 尺寸 token，
需要整体缩放时给 `AntThemeData` 传 `scale: AntScale(...)` 或 `AntScale.auto(context)`。

## 构造函数

### `AntScreenUtilInit({super.key, required this.builder, this.designSize, this.desktopBreakpoint, this.allowScaleUp = false, this.maxWidth, this.maxScaleFactor})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `builder` | `Widget Function(BuildContext context, Widget? child)` | 可选 | — |
| `designSize` | `Size?` | 可选 | — |
| `desktopBreakpoint` | `double?` | 可选 | — |
| `allowScaleUp` | `bool` | = false | — |
| `maxWidth` | `double?` | 可选 | — |
| `maxScaleFactor` | `double?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `allowScaleUp` | `bool` | 已废弃，保留仅用于兼容旧调用签名 |
| `builder` | `Widget Function(BuildContext context, Widget? child)` | — |
| `designSize` | `Size?` | 已废弃，保留仅用于兼容旧调用签名 |
| `desktopBreakpoint` | `double?` | 已废弃，保留仅用于兼容旧调用签名 |
| `maxScaleFactor` | `double?` | 已废弃，保留仅用于兼容旧调用签名 |
| `maxWidth` | `double?` | 已废弃，保留仅用于兼容旧调用签名 |
| `scaleFactorNotifier` | `ValueNotifier<double>` | 兼容旧字段：缩放因子恒为 1.0 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |
| `scaleFactorListenable` | `ValueListenable<double>` | 兼容旧字段 |

