<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPlatform

> 种类：类

```dart
class AntPlatform
```

AntPlatform — 平台检测工具类

封装 `defaultTargetPlatform`，区分 desktop / mobile 两大交互类别，
并提供 `isOhos` 单独标识用于鸿蒙差异化处理。

主工程 `AntPlatform` 已改为本实现的 re-export，
API 完全向后兼容（isOhos / isDesktop / supportsHover 等）。

## ohos 隔离（强制约定）

标准 Flutter SDK 的 `Platform` 类无 `isOhos` 属性，
**严禁使用 `Platform.isOhos`**（会编译报错）。
统一使用 `Platform.operatingSystem == 'ohos'` 字符串匹配
（`kIsWeb` 守卫下），标准 SDK 下该比较恒为 false，
编译零错误、运行零异常。

## 构造函数

### `AntPlatform._()`

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `isAndroid` | `bool` | 当前是否为 Android |
| `isDesktop` | `bool` | 当前是否为桌面平台（web / windows / macos / linux） |
| `isIOS` | `bool` | 当前是否为 iOS |
| `isLinux` | `bool` | 当前是否为 Linux |
| `isMacOS` | `bool` | 当前是否为 macOS |
| `isMobile` | `bool` | 当前是否为移动平台（android / ios / ohos） |
| `isOhos` | `bool` | 当前是否为鸿蒙（ohos） 隔离实现：标准 Flutter SDK 的 Platform 类无 isOhos 属性… |
| `isWeb` | `bool` | 当前是否为 Web 环境 |
| `isWindows` | `bool` | 当前是否为 Windows |
| `name` | `String` | 当前平台名称（用于日志/调试） |
| `showScrollbar` | `bool` | 是否显示滚动条 桌面端显示 ScrollbarTheme，移动端隐藏 |
| `supportsHover` | `bool` | 是否支持悬停（hover）反馈 桌面端启用 PointerRegion 悬停反馈，移动端跳过 |
| `supportsKeyboard` | `bool` | 是否支持键盘焦点遍历（Tab 遍历 + 快捷键） 桌面端支持 FocusNode/Shortcuts，移动端跳过 |
| `useTouchRipple` | `bool` | 是否使用触摸涟漪（InkWell ripple）反馈 移动端启用 InkWell 涟漪，桌面端禁用涟漪改用 hov… |

