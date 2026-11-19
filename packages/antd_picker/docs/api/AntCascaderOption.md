<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCascaderOption

> 种类：类

```dart
class AntCascaderOption
```

级联选项

## 构造函数

### `AntCascaderOption({required this.value, required this.label, this.children, this.disabled = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `String` | 可选 | — |
| `label` | `String` | 可选 | — |
| `children` | `List<AntCascaderOption>?` | 可选 | — |
| `disabled` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `children` | `List<AntCascaderOption>?` | 子选项 |
| `disabled` | `bool` | 是否禁用 |
| `label` | `String` | 选项标签 |
| `value` | `String` | 选项值 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `isLeaf` | `bool` | 是否为叶子节点（无子选项） |

