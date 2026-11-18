<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCol

> 种类：类

```dart
class AntCol
```

栅格列 — 24 栅格系统的列容器。

对齐 antd React Col 组件，须在 `AntRow` 内使用。

```dart
AntCol(span: 8, child: Text('1/3'))
AntCol(span: 8, offset: 8, child: Text('偏移1/3'))
AntCol(flex: 1, child: Text('弹性'))
```

## 构造函数

### `AntCol({super.key, this.span, this.offset = 0, this.flex, this.child})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `span` | `int?` | 可选 | — |
| `offset` | `int` | = 0 | — |
| `flex` | `double?` | 可选 | — |
| `child` | `Widget?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget?` | 子元素 |
| `flex` | `double?` | flex 弹性值 |
| `offset` | `int` | 栅格左侧偏移，取值 0-24 |
| `span` | `int?` | 栅格占位，取值 1-24 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

