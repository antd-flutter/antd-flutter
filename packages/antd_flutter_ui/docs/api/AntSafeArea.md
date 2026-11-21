<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSafeArea

> 种类：类

```dart
class AntSafeArea
```

安全区 — 适配层实现，继承 Flutter `SafeArea`，兼容原生位置。

对齐 antd React SafeArea 组件，在刘海屏、全面屏等设备上
避免内容被状态栏或底部指示条遮挡。

```dart
AntSafeArea(position: AntSafeAreaPosition.top) // 顶部安全区占位
AntSafeArea(position: AntSafeAreaPosition.bottom) // 底部安全区占位
AntSafeArea(child: myContent) // 包装子组件并添加安全区内边距
```

## 构造函数

### `AntSafeArea({super.key, this.position = AntSafeAreaPosition.both, Widget? child, super.maintainBottomViewPadding = false, super.minimum = EdgeInsets.zero, super.left = true, super.right = true})`

创建安全区组件。

`position` 映射为原生 `top` / `bottom` 布尔参数（构造级解析）；
其余参数原样透传给 `SafeArea`，语义与 Flutter 原生一致。

`child` 为 null 时进入占位模式；原生 `SafeArea.child` 不可为 null，
此处向父类传入 `SizedBox.shrink()` 占位（不会实际渲染该占位）。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `position` | `AntSafeAreaPosition` | = AntSafeAreaPosition.both | 映射为原生 `top` / `bottom` 布尔参数（构造级解析）； 其余参数原样透传给 `SafeArea`，语义与 Flutter 原生一致。 |
| `child` | `Widget?` | 可选 | 为 null 时进入占位模式；原生 `SafeArea.child` 不可为 null， 此处向父类传入 `SizedBox.shrink()` 占位（不会实际渲染该占位）。 |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_child` | `Widget?` | 子组件 |
| `position` | `AntSafeAreaPosition` | 安全区位置 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

