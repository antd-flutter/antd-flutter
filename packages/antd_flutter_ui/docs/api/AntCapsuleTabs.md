<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCapsuleTabs

> 种类：类

```dart
class AntCapsuleTabs
```

胶囊选项卡 — 圆角胶囊形选项卡组，激活项白色凸起。

对齐 antd-mobile CapsuleTabs 组件，整体灰色圆角容器，
激活项白色背景 + 阴影，常用于筛选切换。

```dart
AntCapsuleTabs(
  items: [
    AntCapsuleTabItem(key: 'a', title: '选项一'),
    AntCapsuleTabItem(key: 'b', title: '选项二'),
  ],
  onChange: (key) => print(key),
)
```

## 构造函数

### `AntCapsuleTabs({super.key, required this.items, this.activeKey, this.defaultActiveKey, this.onChange})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<AntCapsuleTabItem>` | 可选 | — |
| `activeKey` | `String?` | 可选 | — |
| `defaultActiveKey` | `String?` | 可选 | — |
| `onChange` | `ValueChanged<String>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `activeKey` | `String?` | 受控激活项 key |
| `defaultActiveKey` | `String?` | 非受控默认激活项 key |
| `items` | `List<AntCapsuleTabItem>` | 选项卡项列表 |
| `onChange` | `ValueChanged<String>?` | 切换回调 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntCapsuleTabs>` | — |

