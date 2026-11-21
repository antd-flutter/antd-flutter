<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntInputGroup

> 种类：类

```dart
class AntInputGroup
```

输入框组 — 将多个输入框组合为紧凑布局。

对齐 antd React Input.Group，compact 模式下子项边距合并。

```dart
AntInputGroup(
  compact: true,
  children: [
    AntInput(addonBefore: 'http://'),
    AntInput(placeholder: '.com'),
  ],
)
```

## 构造函数

### `AntInputGroup({super.key, this.compact = false, required this.children})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `compact` | `bool` | = false | — |
| `children` | `List<Widget>` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `children` | `List<Widget>` | 子组件 |
| `compact` | `bool` | 是否紧凑布局 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

