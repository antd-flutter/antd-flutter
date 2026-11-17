<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntResponsive

> 种类：类

```dart
class AntResponsive
```

响应式布局信息 InheritedModel（按 aspect 细粒度依赖）。

由 `AntResponsiveInit` 在树中注入：

```dart
AntResponsiveInit(
  // child 保持稳定实例，builder 重建时嵌入同一 child 实现局部刷新
  child: const MyPage(),
  builder: (context, data, child) => MaterialApp(home: child!),
)
```

## 构造函数

### `AntResponsive({super.key, required this.data, required super.child})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `data` | `AntLayoutData` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `data` | `AntLayoutData` | 当前布局数据快照 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `updateShouldNotify` | `bool` | — |
| `updateShouldNotifyDependent` | `bool` | — |
| `breakpointOf` | `AntBreakpoint?` | 仅依赖断点 aspect |
| `deviceTypeOf` | `AntDeviceType` | 仅依赖设备类型 aspect |
| `foldStateOf` | `AntFoldState` | 仅依赖折叠态 aspect |
| `maybeOf` | `AntLayoutData?` | 依赖整体布局数据（任一字段变化即 rebuild） |
| `of` | `AntLayoutData` | 依赖整体布局数据 |
| `platformOf` | `TargetPlatform` | 仅依赖平台 aspect |
| `scaleFactorOf` | `double` | 仅依赖缩放因子 aspect（桌面超宽等比放大时 > 1，默认恒 1.0） |
| `widthOf` | `double` | 仅依赖宽度 aspect |

