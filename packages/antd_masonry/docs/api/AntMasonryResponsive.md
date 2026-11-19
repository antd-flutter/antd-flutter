<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntMasonryResponsive

> 种类：类

```dart
class AntMasonryResponsive
```

瀑布流响应式列数配置。

根据容器宽度选择列数，断点与 antd 栅格断点对齐：
- xs: < 576
- sm: >= 576
- md: >= 768
- lg: >= 992
- xl: >= 1200
- xxl: >= 1600

## 构造函数

### `AntMasonryResponsive({this.xs, this.sm, this.md, this.lg, this.xl, this.xxl})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `xs` | `int?` | 可选 | — |
| `sm` | `int?` | 可选 | — |
| `md` | `int?` | 可选 | — |
| `lg` | `int?` | 可选 | — |
| `xl` | `int?` | 可选 | — |
| `xxl` | `int?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `lg` | `int?` | >= 992px 列数 |
| `md` | `int?` | >= 768px 列数 |
| `sm` | `int?` | >= 576px 列数 |
| `xl` | `int?` | >= 1200px 列数 |
| `xs` | `int?` | < 576px 列数 |
| `xxl` | `int?` | >= 1600px 列数 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `resolve` | `int` | 根据容器宽度解析列数 |

