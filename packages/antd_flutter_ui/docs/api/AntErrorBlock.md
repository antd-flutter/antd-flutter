<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntErrorBlock

> 种类：类

```dart
class AntErrorBlock
```

错误块 — 用于页面局部出现错误/空数据时的占位提示。

对齐 antd-mobile v5 ErrorBlock 组件。

## 构造函数

### `AntErrorBlock({super.key, this.status = AntErrorBlockStatus.defaultStatus, this.title, this.description, this.image, this.children})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `status` | `AntErrorBlockStatus` | = AntErrorBlockStatus.defaultStatus | — |
| `title` | `String?` | 可选 | — |
| `description` | `String?` | 可选 | — |
| `image` | `Widget?` | 可选 | — |
| `children` | `Widget?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `children` | `Widget?` | 操作区（如按钮组） |
| `description` | `String?` | 描述文案（缺省按 status 展示默认文案） |
| `image` | `Widget?` | 自定义插图（覆盖默认自绘插画） |
| `status` | `AntErrorBlockStatus` | 错误块状态（决定默认插图与文案） |
| `title` | `String?` | 主标题（缺省按 status 展示默认文案） |
| `illustrationKey` | `Key` | 插图组件 Key（便于测试定位自绘插画） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

