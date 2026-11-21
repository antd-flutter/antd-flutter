<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntIndexBar

> 种类：类

```dart
class AntIndexBar
```

索引栏 — 通讯录式字母索引导航。

对齐 antd-mobile IndexBar 组件，右侧竖排索引字母，
支持点击与垂直拖动选择，选中时中央显示字母提示气泡。

```dart
AntIndexBar(
  items: [
    AntIndexBarItem(key: 'A', child: Text('A 组内容')),
    AntIndexBarItem(key: 'B', child: Text('B 组内容')),
  ],
  onChange: (key) => print(key),
)
```

## 构造函数

### `AntIndexBar({super.key, required this.items, this.onChange})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `items` | `List<AntIndexBarItem>` | 可选 | — |
| `onChange` | `ValueChanged<String>?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `items` | `List<AntIndexBarItem>` | 分组项列表 |
| `onChange` | `ValueChanged<String>?` | 索引切换回调 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntIndexBar>` | — |

