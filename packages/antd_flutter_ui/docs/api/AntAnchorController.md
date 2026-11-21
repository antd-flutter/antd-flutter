<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntAnchorController

> 种类：类

```dart
class AntAnchorController
```

锚点控制器 — 管理当前激活的锚点 key。

可用于受控模式，或与外部 ScrollController 联动：

```dart
final controller = AntAnchorController();
// 滚动时更新激活项
scrollController.addListener(() {
  controller.setActive(_computeActiveKey(scrollController));
});
```

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_activeKey` | `String?` | — |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `activeKey` | `String?` | 当前激活的锚点 key |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `dispose` | `void` | — |
| `setActive` | `void` | 设置激活的锚点 key，null 表示无激活项 |

