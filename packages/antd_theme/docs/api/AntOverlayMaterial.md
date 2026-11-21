<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntOverlayMaterial

> 种类：类

```dart
class AntOverlayMaterial
```

浮层内容基座。

通过 `Overlay` 插入的内容不在任何 `Material` 之下，Flutter 调试模式下
会给其中的文本画出黄色下划线，`InkWell` 等也需要 `Material` 才能正常工作。
所有自行插入根 Overlay 的浮层都应包一层本组件。

## 构造函数

### `AntOverlayMaterial({super.key, required this.child})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `child` | `Widget` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

