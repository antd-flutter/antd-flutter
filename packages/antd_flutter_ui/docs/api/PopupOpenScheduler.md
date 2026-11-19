<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# PopupOpenScheduler

> 种类：混入

```dart
mixin PopupOpenScheduler
```

受控 open 调度 mixin — show/hide 统一延迟到帧末。

受控 `open` 切换通常由父级 `setState` 触发，发生在 build 阶段；
直接调用 `Overlay.insert()` 会在 build 阶段 markNeedsBuild 报错，
因此受控开关一律经 `schedulePopupOpen` 延迟到帧末执行。

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `schedulePopupOpen` | `void` | 帧末执行受控开关的 show/hide |

