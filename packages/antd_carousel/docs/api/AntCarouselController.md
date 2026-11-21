<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCarouselController

> 种类：类

```dart
class AntCarouselController
```

AntCarousel 外部控制器 — 用于 `goTo` 跳转到指定面板。

```dart
final controller = AntCarouselController();
AntCarousel(children: [...], controller: controller);
controller.goTo(2);
```

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_state` | `AntCarouselStateApi?` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `attach` | `void` | 绑定轮播实例（由组件内部调用，外部勿用） |
| `detach` | `void` | 解绑轮播实例（由组件内部调用，外部勿用） |
| `goTo` | `void` | 跳转到指定面板 index |

