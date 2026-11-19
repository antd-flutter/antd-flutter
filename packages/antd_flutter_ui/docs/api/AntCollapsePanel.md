<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCollapsePanel

> 种类：类

```dart
class AntCollapsePanel
```

折叠面板。

## 构造函数

### `AntCollapsePanel({this.key, required this.label, this.child, this.extra, this.disabled = false, this.forceRender = false})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `key` | `String?` | 可选 | — |
| `label` | `String` | 可选 | — |
| `child` | `Widget?` | 可选 | — |
| `extra` | `Widget?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `forceRender` | `bool` | = false | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget?` | 面板内容 |
| `disabled` | `bool` | 是否禁用 |
| `extra` | `Widget?` | 面板右侧附加内容 |
| `forceRender` | `bool` | 是否强制渲染内容（未展开也渲染，懒加载时传 true） |
| `key` | `String?` | 面板唯一标识（不传时使用 label 作为标识） |
| `label` | `String` | 面板标题 |

