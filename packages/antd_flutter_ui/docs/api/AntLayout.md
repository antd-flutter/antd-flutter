<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntLayout

> 种类：类

```dart
class AntLayout
```

布局容器 — 协调侧边栏与主区域的页面骨架。

对齐 antd React Layout 组件，通过命名插槽组合各布局区域：

```dart
AntLayout(
  sider: AntLayoutSider(child: Text('侧边栏')),
  header: AntLayoutHeader(child: Text('顶部')),
  content: AntLayoutContent(child: Text('内容')),
  footer: AntLayoutFooter(child: Text('底部')),
)
```

## 构造函数

### `AntLayout({super.key, this.sider, this.header, this.content, this.footer})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `sider` | `AntLayoutSider?` | 可选 | — |
| `header` | `Widget?` | 可选 | — |
| `content` | `Widget?` | 可选 | — |
| `footer` | `Widget?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `content` | `Widget?` | 内容区域 |
| `footer` | `Widget?` | 底部区域 |
| `header` | `Widget?` | 顶部区域 |
| `sider` | `AntLayoutSider?` | 侧边栏区域 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

