<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSplitter

> 种类：类

```dart
class AntSplitter
```

可拖拽分隔面板 — 自由拖拽调整各区域大小的分隔布局。

对齐 antd React Splitter 组件，面板只能通过 `AntSplitterPanel` 提供。

```dart
AntSplitter(
  children: [
    AntSplitterPanel(defaultSize: 200, child: Text('左')),
    AntSplitterPanel(child: Text('右')),
  ],
)
```

## 构造函数

### `AntSplitter({super.key, this.layout = AntSplitterLayout.horizontal, this.lazy = false, this.children = const [], this.onResize, this.onResizeStart, this.onResizeEnd, this.onCollapse, this.onDraggerDoubleClick})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `layout` | `AntSplitterLayout` | = AntSplitterLayout.horizontal | — |
| `lazy` | `bool` | = false | — |
| `children` | `List<AntSplitterPanel>` | = const [] | — |
| `onResize` | `ValueChanged<List<double>>?` | 可选 | — |
| `onResizeStart` | `ValueChanged<List<double>>?` | 可选 | — |
| `onResizeEnd` | `ValueChanged<List<double>>?` | 可选 | — |
| `onCollapse` | `AntSplitterCollapseCallback?` | 可选 | — |
| `onDraggerDoubleClick` | `ValueChanged<int>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `children` | `List<AntSplitterPanel>` | 面板列表 |
| `layout` | `AntSplitterLayout` | 布局方向 |
| `lazy` | `bool` | 懒模式 |
| `onCollapse` | `AntSplitterCollapseCallback?` | 折叠/展开回调 |
| `onDraggerDoubleClick` | `ValueChanged<int>?` | 双击拖拽器回调，参数为拖拽器索引（位于面板 index 与 index+1 之间） |
| `onResize` | `ValueChanged<List<double>>?` | 面板尺寸变化回调，参数为各面板当前尺寸（逻辑像素） |
| `onResizeEnd` | `ValueChanged<List<double>>?` | 拖拽结束回调 |
| `onResizeStart` | `ValueChanged<List<double>>?` | 拖拽开始前回调 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntSplitter>` | — |

