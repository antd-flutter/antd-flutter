<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# ScreenUtil

> 种类：类

```dart
class ScreenUtil
```

## 构造函数

### `ScreenUtil()`

### `ScreenUtil._()`

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_data` | `MediaQueryData` | — |
| `_elementsToRebuild` | `Set<Element>?` | — |
| `_minTextAdapt` | `bool` | — |
| `_orientation` | `Orientation` | 屏幕方向 |
| `_splitScreenMode` | `bool` | — |
| `_uiSize` | `Size` | UI设计中手机尺寸 , dp Size of the phone in UI Design , dp |
| `fontSizeResolver` | `FontSizeResolver?` | — |
| `_enableScaleText` | `bool Function()` | — |
| `_enableScaleWH` | `bool Function()` | — |
| `_instance` | `ScreenUtil` | — |
| `defaultSize` | `Size` | — |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `bottomBarHeight` | `double` | 底部安全区距离 dp The offset from the bottom, in dp |
| `orientation` | `Orientation` | 获取屏幕方向 Get screen orientation |
| `pixelRatio` | `double?` | 设备的像素密度 The size of the media in logical pixels (e.g, the… |
| `scaleHeight` | `double` | The ratio of actual height to UI design |
| `scaleText` | `double` | — |
| `scaleWidth` | `double` | 实际尺寸与UI设计的比例 The ratio of actual width to UI design |
| `screenHeight` | `double` | 当前设备高度 dp The vertical extent of this size |
| `screenWidth` | `double` | 当前设备宽度 dp The horizontal extent of this size. |
| `statusBarHeight` | `double` | 状态栏高度 dp 刘海屏会更高 The offset from the top, in dp |
| `textScaleFactor` | `double` | 每个逻辑像素的字体像素数，字体的缩放比例 The number of font pixels for each l… |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `deviceType` | `DeviceType` | — |
| `diagonal` | `double` | Adapt according to the both width and height |
| `diameter` | `double` | Adapt according to the maximum value of scale width and s… |
| `radius` | `double` | 根据宽度或高度中的较小值进行适配 Adapt according to the smaller of width … |
| `setHeight` | `double` | 根据UI设计的设备高度适配 当发现UI设计中的一屏显示的与当前样式效果不符合时, 或者形状有差异时,建议使用此方法… |
| `setHorizontalSpacing` | `SizedBox` | — |
| `setHorizontalSpacingDiagonal` | `SizedBox` | — |
| `setHorizontalSpacingDiameter` | `SizedBox` | — |
| `setHorizontalSpacingRadius` | `SizedBox` | — |
| `setSp` | `double` | 字体大小适配方法 |
| `setVerticalSpacing` | `SizedBox` | — |
| `setVerticalSpacingDiagonal` | `SizedBox` | — |
| `setVerticalSpacingDiameter` | `SizedBox` | — |
| `setVerticalSpacingFromWidth` | `SizedBox` | — |
| `setVerticalSpacingRadius` | `SizedBox` | — |
| `setWidth` | `double` | 根据UI设计的设备宽度适配 高度也可以根据这个来做适配可以保证不变形,比如你想要一个正方形的时候 |
| `configure` | `void` | — |
| `enableScale` | `void` | Enable scale if the enableWH return false, the width and … |
| `ensureScreenSize` | `Future<void>` | Manually wait for window size to be initialized Recommend… |
| `ensureScreenSizeAndInit` | `Future<void>` | — |
| `init` | `void` | Initializing the library. |
| `registerToBuild` | `void` | ### Experimental Register current page and all its descen… |

