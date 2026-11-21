<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntOverlayShell

> 种类：类

```dart
class AntOverlayShell
```

屏级弹层统一基座。

由各弹层组件在 OverlayEntry 中构造：
```dart
AntOverlayShell(
  open: widget.visible,
  alignment: Alignment.bottomCenter,
  slideBegin: const Offset(0, 1),
  onMaskTap: _handleClose,
  onExited: _removeOverlay,
  child: panel,
)
```

## 构造函数

### `AntOverlayShell({super.key, required this.open, required this.child, this.onExited, this.alignment = Alignment.center, this.padding = EdgeInsets.zero, this.showMask = true, this.maskColor, this.maskClosable = true, this.interceptWithoutMask = false, this.interceptBehavior = HitTestBehavior.translucent, this.onMaskTap, this.duration = const Duration(milliseconds: 220), this.curve = Curves.easeOut, this.slideBegin, this.scaleFrom = 0.92, this.maskKey, this.panelKey, this.escToClose = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `open` | `bool` | 可选 | — |
| `child` | `Widget` | 可选 | — |
| `onExited` | `VoidCallback?` | 可选 | — |
| `alignment` | `Alignment` | = Alignment.center | — |
| `padding` | `EdgeInsets` | = EdgeInsets.zero | — |
| `showMask` | `bool` | = true | — |
| `maskColor` | `Color?` | 可选 | — |
| `maskClosable` | `bool` | = true | — |
| `interceptWithoutMask` | `bool` | = false | — |
| `interceptBehavior` | `HitTestBehavior` | = HitTestBehavior.translucent | — |
| `onMaskTap` | `VoidCallback?` | 可选 | — |
| `duration` | `Duration` | = const Duration(milliseconds: 220) | — |
| `curve` | `Curve` | = Curves.easeOut | — |
| `slideBegin` | `Offset?` | 可选 | — |
| `scaleFrom` | `double` | = 0.92 | — |
| `maskKey` | `Key?` | 可选 | — |
| `panelKey` | `Key?` | 可选 | — |
| `escToClose` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `alignment` | `Alignment` | 面板在屏内的对齐方式（居中 / 底部 / 四边等） |
| `child` | `Widget` | 面板内容 |
| `curve` | `Curve` | 动画曲线 |
| `duration` | `Duration` | 出现/退出动画时长 |
| `escToClose` | `bool` | R37 打开状态下按 Esc 关闭（默认关闭——Toast/Message/Notification 等轻提示族复… |
| `interceptBehavior` | `HitTestBehavior` | 拦截层的命中行为（translucent 由 Drawer 使用，opaque 由 Toast 使用） |
| `interceptWithoutMask` | `bool` | 无遮罩时是否仍用拦截层拦截点击（Toast maskClickable=false 语义） |
| `maskClosable` | `bool` | 遮罩点击是否触发 onMaskTap |
| `maskColor` | `Color?` | 遮罩颜色（默认 antd 主题 colorBgMask） |
| `maskKey` | `Key?` | 遮罩定位 Key（供组件测试） |
| `onExited` | `VoidCallback?` | 退出动画播放完毕回调（组件在此移除 OverlayEntry） |
| `onMaskTap` | `VoidCallback?` | 遮罩（或拦截层）点击回调 |
| `open` | `bool` | 受控显示状态（false 时播放退出动画，结束后回调 onExited） |
| `padding` | `EdgeInsets` | 面板外边距（如 Modal 偏上展示的顶部留白） |
| `panelKey` | `Key?` | 面板定位 Key（供组件测试） |
| `scaleFrom` | `double` | 缩放淡入的起始缩放（slideBegin 为 null 时生效） |
| `showMask` | `bool` | 是否渲染遮罩层 |
| `slideBegin` | `Offset?` | 方向滑入起始偏移（如底部面板 Offset(0, 1)） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntOverlayShell>` | — |

