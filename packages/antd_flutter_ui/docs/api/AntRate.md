<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntRate

> 种类：类

```dart
class AntRate
```

评分 — 评分组件，支持半星与自定义图标。

对齐 antd React Rate 组件。

## 构造函数

### `AntRate({super.key, this.value, this.defaultValue = 0, this.count = 5, this.onChange, this.allowHalf = false, this.allowClear = false, this.disabled = false, this.character, this.autofocus = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `double?` | 可选 | — |
| `defaultValue` | `double` | = 0 | — |
| `count` | `int` | = 5 | — |
| `onChange` | `ValueChanged<double>?` | 可选 | — |
| `allowHalf` | `bool` | = false | — |
| `allowClear` | `bool` | = false | — |
| `disabled` | `bool` | = false | — |
| `character` | `IconData?` | 可选 | — |
| `autofocus` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `allowClear` | `bool` | 是否允许再次点击清除 |
| `allowHalf` | `bool` | 是否允许半选 |
| `autofocus` | `bool` | 是否自动聚焦 |
| `character` | `IconData?` | 自定义字符图标 |
| `count` | `int` | 星星总数 |
| `defaultValue` | `double` | 非受控初始评分 |
| `disabled` | `bool` | 是否禁用 |
| `onChange` | `ValueChanged<double>?` | 评分变化回调 |
| `value` | `double?` | 受控评分值 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntRate>` | — |

