<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntAutoCenter

> 种类：类

```dart
class AntAutoCenter
```

自动居中 — 让内容在剩余空间中自动居中。

对齐 antd React AutoCenter 组件，常用于页面内容区在
导航栏与标签栏之间的剩余空间中居中展示。

```dart
AntAutoCenter(child: Text('居中内容')) // 直接居中
Column(children: [navBar, AntAutoCenter(expanded: true, child: content)]) // 弹性布局中占据剩余空间居中
```

## 构造函数

### `AntAutoCenter({super.key, this.child, this.expanded = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `child` | `Widget?` | 可选 | — |
| `expanded` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget?` | 需要居中的内容 |
| `expanded` | `bool` | 是否在 Flex 父级中占据剩余空间 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

