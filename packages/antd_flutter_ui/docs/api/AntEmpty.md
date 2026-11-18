<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntEmpty

> 种类：类

```dart
class AntEmpty
```

空状态 — 空状态时的展示占位图。

对齐 antd React Empty 组件。

## 构造函数

### `AntEmpty({super.key, this.description = '暂无数据', this.image = AntEmptyImage.standard, this.imageWidget, this.child})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `description` | `String?` | = '暂无数据' | — |
| `image` | `AntEmptyImage` | = AntEmptyImage.standard | — |
| `imageWidget` | `Widget?` | 可选 | — |
| `child` | `Widget?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget?` | 底部额外内容 |
| `description` | `String?` | 描述文字 |
| `image` | `AntEmptyImage` | 图片样式预设 |
| `imageWidget` | `Widget?` | 自定义图片 Widget（优先级高于 image） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_buildDefaultImage` | `Widget` | — |
| `build` | `Widget` | — |

