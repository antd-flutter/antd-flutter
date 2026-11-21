<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntPopupTriggerRegion

> 种类：类

```dart
class AntPopupTriggerRegion
```

统一触发区域（点击 + 悬停 + 移动端 hover 降级）。

用 `Listener` 而非 `GestureDetector` 检测点击：Listener 不参与手势竞技场，
当触发元素是 AntButton 等自带手势识别的组件时，子组件手势仍正常生效，
同时弹层触发不会被竞技场判负（GestureDetector 会被最内层识别器抢走 tap）。

平台适配降级：移动端（Android/iOS/ohos）没有 hover 交互，
hover 降级为点击的判定由调用方（组件 State）按平台解析后传入——
`hoverEnabled` 仅在桌面端为 true；移动端 hover 调用方会以 `tapEnabled`
上报点击触发。区域内部不读取平台，避免重建期接线漂移。

## 构造函数

### `AntPopupTriggerRegion({super.key, required this.child, this.onTap, this.tapEnabled = false, this.onHoverEnter, this.onHoverExit, this.hoverEnabled = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `child` | `Widget` | 可选 | — |
| `onTap` | `VoidCallback?` | 可选 | — |
| `tapEnabled` | `bool` | = false | — |
| `onHoverEnter` | `VoidCallback?` | 可选 | — |
| `onHoverExit` | `VoidCallback?` | 可选 | — |
| `hoverEnabled` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget` | 触发元素 |
| `hoverEnabled` | `bool` | 是否启用悬停触发（调用方已按平台解析：仅桌面端为 true） |
| `onHoverEnter` | `VoidCallback?` | 鼠标移入回调（仅 hoverEnabled 时接线） |
| `onHoverExit` | `VoidCallback?` | 鼠标移出回调（仅 hoverEnabled 时接线） |
| `onTap` | `VoidCallback?` | 点击（指针抬起）回调 |
| `tapEnabled` | `bool` | 是否启用点击触发 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

