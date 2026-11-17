<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntLayoutData

> 种类：类

```dart
class AntLayoutData
```

布局信息不可变快照。

## 构造函数

### `AntLayoutData({required this.width, required this.breakpoint, required this.deviceType, required this.orientation, required this.foldState, required this.targetPlatform, required this.isOhos, required this.isDesktop, this.scaleFactor = 1.0})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `width` | `double` | 可选 | — |
| `breakpoint` | `AntBreakpoint?` | 可选 | — |
| `deviceType` | `AntDeviceType` | 可选 | — |
| `orientation` | `AntOrientation` | 可选 | — |
| `foldState` | `AntFoldState` | 可选 | — |
| `targetPlatform` | `TargetPlatform` | 可选 | — |
| `isOhos` | `bool` | 可选 | — |
| `isDesktop` | `bool` | 可选 | — |
| `scaleFactor` | `double` | = 1.0 | — |

### `AntLayoutData.fromMediaQuery(MediaQueryData mq, {AntFoldState? foldState, double scaleFactor = 1.0})`

从 `MediaQueryData` 构建布局快照。

`foldState` 显式传入（如 OHOS 经 channel 返回）时优先生效；
否则从 `MediaQueryData.displayFeatures` 推导（见
`foldStateFromDisplayFeatures`）。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `mq` | `MediaQueryData` | 可选 | — |
| `foldState` | `AntFoldState?` | 可选 | 显式传入（如 OHOS 经 channel 返回）时优先生效； 否则从 `MediaQueryData.displayFeatures` 推导（见 |
| `scaleFactor` | `double` | = 1.0 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `breakpoint` | `AntBreakpoint?` | 当前命中的最大断点 |
| `deviceType` | `AntDeviceType` | 设备类型（宽度 + 平台综合判定） |
| `foldState` | `AntFoldState` | 折叠屏状态 |
| `isDesktop` | `bool` | 是否为桌面类平台（web / windows / macos / linux） |
| `isOhos` | `bool` | 是否为鸿蒙平台 |
| `orientation` | `AntOrientation` | 屏幕方向 |
| `scaleFactor` | `double` | 桌面超宽等比缩放因子 |
| `targetPlatform` | `TargetPlatform` | 目标平台 |
| `width` | `double` | 窗口逻辑宽度 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `hashCode` | `int` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `==` | `bool` | — |
| `toString` | `String` | — |
| `defaultDeviceTypeOf` | `AntDeviceType` | 设备类型判定（宽度 + 平台综合） |
| `foldStateFromDisplayFeatures` | `AntFoldState` | 从 MediaQueryData.displayFeatures 推导折叠态 |

