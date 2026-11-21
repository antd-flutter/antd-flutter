<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntSideBar

> 种类：类

```dart
class AntSideBar
```

侧边导航栏 — 垂直排列的导航菜单，常用于分类筛选。

对齐 antd-mobile SideBar 组件，激活项左侧有高亮条，
白色背景 + colorPrimary 文字；非激活项灰色背景。

```dart
AntSideBar(
  items: [
    AntSideBarItem(key: 'a', title: '选项一'),
    AntSideBarItem(key: 'b', title: '选项二'),
  ],
  onChange: (key) => print(key),
)
```

## 构造函数

### `AntSideBar({super.key, required this.items, this.activeKey, this.defaultActiveKey, this.onChange})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<AntSideBarItem>` | 可选 | — |
| `activeKey` | `String?` | 可选 | — |
| `defaultActiveKey` | `String?` | 可选 | — |
| `onChange` | `ValueChanged<String>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `activeKey` | `String?` | 受控激活项 key |
| `defaultActiveKey` | `String?` | 非受控默认激活项 key |
| `items` | `List<AntSideBarItem>` | 导航项列表 |
| `onChange` | `ValueChanged<String>?` | 切换回调 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntSideBar>` | — |

