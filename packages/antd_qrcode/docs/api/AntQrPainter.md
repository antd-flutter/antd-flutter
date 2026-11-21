<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntQrPainter

> 种类：类

```dart
class AntQrPainter
```

QR 矩阵绘制器 — 按引擎生成的 bool 网格逐模块绘制方块。

方角绘制（antd 风格默认），定位角/对齐图案/timing/数据模块
均为矩阵深色模块，无需单独分支处理。

## 构造函数

### `AntQrPainter({required this.value, required this.errorLevel, required this.moduleColor, required this.emptyColor})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `String` | 可选 | — |
| `errorLevel` | `AntQRCodeErrorLevel` | 可选 | — |
| `moduleColor` | `Color` | 可选 | — |
| `emptyColor` | `Color` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_mappedErrorLevel` | `int` | — |
| `_matrix` | `AntQrMatrix?` | — |
| `emptyColor` | `Color` | 空模块颜色（背景） |
| `errorLevel` | `AntQRCodeErrorLevel` | 组件层纠错等级 |
| `moduleColor` | `Color` | 深色模块颜色（前景） |
| `value` | `String` | 二维码内容 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `matrix` | `AntQrMatrix` | QR 矩阵（懒生成，供测试断言） |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `paint` | `void` | — |
| `shouldRepaint` | `bool` | — |
| `_mapErrorLevel` | `int` | 纠错等级映射（中间层隔离引擎常量语义） |

