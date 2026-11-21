<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntFloatingPanel

> 种类：类

```dart
class AntFloatingPanel
```

浮动面板 — 可拖拽的底部浮动面板，在锚点间平滑移动并动画吸附。

对齐 antd-mobile v5 FloatingPanel 组件。

## 构造函数

### `AntFloatingPanel({super.key, this.anchors = _kDefaultAnchors, this.handleHeight = _kDefaultHandleHeight, this.handle, this.contentHeight, this.onHeightChange, this.controller, required this.child})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `anchors` | `List<double>` | = _kDefaultAnchors | — |
| `handleHeight` | `double` | = _kDefaultHandleHeight | — |
| `handle` | `Widget?` | 可选 | — |
| `contentHeight` | `double?` | 可选 | — |
| `onHeightChange` | `AntFloatingPanelHeightChange?` | 可选 | — |
| `controller` | `AntFloatingPanelController?` | 可选 | — |
| `child` | `Widget` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `anchors` | `List<double>` | 锚点高度比例列表（0~1，相对基准高度，需升序） |
| `child` | `Widget` | 面板内容 |
| `contentHeight` | `double?` | 内容基准总高度（逻辑像素） |
| `controller` | `AntFloatingPanelController?` | 程序化控制器（R35）：吸附到锚点/展开/收起/重置，高度比例经其监听读取 |
| `handle` | `Widget?` | 自定义把手 Widget |
| `handleHeight` | `double` | 拖拽把手区域高度（逻辑像素） |
| `onHeightChange` | `AntFloatingPanelHeightChange?` | 高度变化回调，参数为当前高度比例（0~1） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntFloatingPanel>` | — |

