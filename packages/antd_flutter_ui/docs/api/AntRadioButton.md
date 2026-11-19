<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntRadioButton

> 种类：类

```dart
class AntRadioButton
```

按钮风格单选 — 搭配 `AntRadioGroup` 使用。

```dart
AntRadioGroup<String>(
  optionType: AntRadioGroupOptionType.button,
  children: [
    AntRadioButton(value: 'a', child: Text('A')),
    AntRadioButton(value: 'b', child: Text('B')),
  ],
)
```

## 构造函数

### `AntRadioButton({super.key, required this.value, required this.child, this.disabled = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `dynamic` | 可选 | — |
| `child` | `Widget` | 可选 | — |
| `disabled` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget` | 标签 |
| `disabled` | `bool` | 是否禁用 |
| `value` | `dynamic` | 值 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

