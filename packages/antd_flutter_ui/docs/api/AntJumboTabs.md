<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntJumboTabs

> 种类：类

```dart
class AntJumboTabs
```

大选项卡 — 主标题 + 描述的大尺寸选项卡，常用于服务分类。

对齐 antd-mobile JumboTabs 组件，每个选项卡含主标题与描述，
激活项主标题高亮 + 底部指示条。

```dart
AntJumboTabs(
  items: [
    AntJumboTabItem(key: 'a', title: '全部', description: '所有订单'),
    AntJumboTabItem(key: 'b', title: '待付款', description: '等待付款'),
  ],
  onChange: (key) => print(key),
)
```

## 构造函数

### `AntJumboTabs({super.key, required this.items, this.activeKey, this.defaultActiveKey, this.onChange})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<AntJumboTabItem>` | 可选 | — |
| `activeKey` | `String?` | 可选 | — |
| `defaultActiveKey` | `String?` | 可选 | — |
| `onChange` | `ValueChanged<String>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `activeKey` | `String?` | 受控激活项 key |
| `defaultActiveKey` | `String?` | 非受控默认激活项 key |
| `items` | `List<AntJumboTabItem>` | 选项卡项列表 |
| `onChange` | `ValueChanged<String>?` | 切换回调 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntJumboTabs>` | — |

