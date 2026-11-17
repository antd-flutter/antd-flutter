<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntResponsiveScope

> 种类：类

```dart
class AntResponsiveScope
```

布局信息订阅源（非 Widget 场景）。

持有 `ValueNotifier`<`AntLayoutData`>，值不变时（`==` 相等）不通知。

## 构造函数

### `AntResponsiveScope({super.key, required this.notifier, required super.child})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `notifier` | `ValueNotifier<AntLayoutData>` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `notifier` | `ValueNotifier<AntLayoutData>` | 布局数据通知器 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `updateShouldNotify` | `bool` | — |
| `layoutListenableOf` | `ValueListenable<AntLayoutData>` | 获取布局数据 ValueListenable（依赖整体数据变化） |
| `maybeOf` | `AntResponsiveScope?` | 获取最近的订阅源 |

