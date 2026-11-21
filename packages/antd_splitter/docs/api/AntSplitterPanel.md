<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSplitterPanel

> 种类：类

```dart
class AntSplitterPanel
```

分隔面板 — AntSplitter 的子面板。

对齐 antd React Splitter.Panel 组件，须在 `AntSplitter` 内使用。

```dart
AntSplitterPanel(
  defaultSize: 200,
  min: 100,
  max: 400,
  child: Text('面板内容'),
)
```

## 构造函数

### `AntSplitterPanel({super.key, this.defaultSize, this.size, this.min, this.max, this.resizable = true, this.collapsible = false, this.child})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `defaultSize` | `double?` | 可选 | — |
| `size` | `double?` | 可选 | — |
| `min` | `double?` | 可选 | — |
| `max` | `double?` | 可选 | — |
| `resizable` | `bool` | = true | — |
| `collapsible` | `bool` | = false | — |
| `child` | `Widget?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget?` | 子元素 |
| `collapsible` | `bool` | 是否可折叠 |
| `defaultSize` | `double?` | 初始面板尺寸（逻辑像素） |
| `max` | `double?` | 最大尺寸（逻辑像素） |
| `min` | `double?` | 最小尺寸（逻辑像素） |
| `resizable` | `bool` | 是否可拖拽调整尺寸 |
| `size` | `double?` | 受控面板尺寸（逻辑像素） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

