<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntLoading

> 种类：类

```dart
class AntLoading
```

加载 — 移动端轻量旋转加载图标。

对齐 antd-mobile Loading 组件：四分之三圆弧匀速旋转，
颜色默认取主题主色，可通过 `AntLoading.color`/`AntLoading.size` 定制，
传入 `AntLoading.child` 时与内容组合展示。

## 构造函数

### `AntLoading({super.key, this.color, this.size = kAntLoadingSize, this.child, this.speed = AntLoadingSpeed.normal, this.direction = kAntLoadingDefaultDirection})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `color` | `Color?` | 可选 | — |
| `size` | `double` | = kAntLoadingSize | — |
| `child` | `Widget?` | 可选 | — |
| `speed` | `AntLoadingSpeed` | = AntLoadingSpeed.normal | — |
| `direction` | `AntLoadingDirection` | = kAntLoadingDefaultDirection | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget?` | 可选内容（与转圈图标组合展示） |
| `color` | `Color?` | 图标颜色（默认主色） |
| `direction` | `AntLoadingDirection` | 内容排布方向（默认图标在左、内容在右） |
| `size` | `double` | 图标尺寸（默认 18） |
| `speed` | `AntLoadingSpeed` | 旋转速度（默认 AntLoadingSpeed.normal） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntLoading>` | — |

