<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTabBar

> 种类：类

```dart
class AntTabBar
```

底部标签栏 — 移动端页面底部 Tab 切换。

对齐 antd-mobile TabBar 组件，图标 + 标题 + 角标，
激活项高亮 colorPrimary，支持受控与非受控模式。

```dart
AntTabBar(
  items: [
    AntTabBarItem(key: 'home', title: '首页', icon: Icons.home),
    AntTabBarItem(key: 'me', title: '我的', icon: Icons.person),
  ],
  onChange: (key) => print(key),
)
```

## 构造函数

### `AntTabBar({super.key, required this.items, this.activeKey, this.defaultActiveKey, this.onChange, this.border = true, this.safeArea = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<AntTabBarItem>` | 可选 | — |
| `activeKey` | `String?` | 可选 | — |
| `defaultActiveKey` | `String?` | 可选 | — |
| `onChange` | `ValueChanged<String>?` | 可选 | — |
| `border` | `bool` | = true | — |
| `safeArea` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `activeKey` | `String?` | 受控激活项 key |
| `border` | `bool` | 是否显示顶部边框 |
| `defaultActiveKey` | `String?` | 非受控默认激活项 key |
| `items` | `List<AntTabBarItem>` | 标签项列表 |
| `onChange` | `ValueChanged<String>?` | 切换回调 |
| `safeArea` | `bool` | 是否适配底部安全区 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntTabBar>` | — |

