<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntFooter

> 种类：类

```dart
class AntFooter
```

页脚 — 页面底部说明与回顶部入口。

对齐 antd-mobile Footer 组件。

## 构造函数

### `AntFooter({super.key, this.content = kAntFooterDefaultContent, this.onClick, this.child, this.style})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `content` | `String` | = kAntFooterDefaultContent | — |
| `onClick` | `GestureTapCallback?` | 可选 | — |
| `child` | `Widget?` | 可选 | — |
| `style` | `BoxDecoration?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget?` | 自定义内容，传入时覆盖 content |
| `content` | `String` | 底部文案，默认 Foot 返回顶部 |
| `onClick` | `GestureTapCallback?` | 点击回调（如返回顶部，由使用方实现） |
| `style` | `BoxDecoration?` | 容器样式透传 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

