<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# PopupContentRefresher

> 种类：混入

```dart
mixin PopupContentRefresher
```

弹层内容刷新 mixin — 原地重建 OverlayEntry（统一沉淀，勿再各自 remove+reinsert）。

弹层内容变化（树节点展开/勾选、数据异步加载、列表项增删等）时调用
`refreshPopupContent`，对当前 OverlayEntry 执行 `markNeedsBuild()` 原地重建：
- 出现动画（fade + scale）不重放——remove+reinsert 会重建
  AntPopupOverlay State，动画从 0 重跑造成可见闪烁；
- 面板内部滚动位置保留（Element/RenderObject 复用）；
- 无基座首帧估算尺寸（默认 240x80）导致的定位跳位。

用法：组件把弹层 OverlayEntry 赋给 `popupContentEntry`，内容变化时调
`refreshPopupContent`；builder 闭包内读取组件 State 的最新字段即可。

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_popupEntry` | `OverlayEntry?` | — |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `popupContentEntry` | `void` | 当前弹层 OverlayEntry（组件 show 时赋值，hide 时置 null） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `refreshPopupContent` | `void` | 原地重建弹层内容 |

