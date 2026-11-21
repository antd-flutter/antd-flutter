<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntRefreshController

> 种类：类

```dart
class AntRefreshController
```

刷新组件 Controller 基类：统一 `isAttached` 生命周期状态与未挂载保护。

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_attached` | `bool` | — |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `isAttached` | `bool` | 是否已挂载到组件（组件 initState 时 attach，dispose 时 detach） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_requireAttached` | `void` | 未挂载时抛错（对齐 ScrollController 无 position 时 assert 的惯例） |
| `_setAttached` | `void` | 更新挂载状态（组件内部调用） |

