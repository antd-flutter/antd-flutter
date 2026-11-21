<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntFloatButton

> 种类：类

```dart
class AntFloatButton
```

Ant Design 浮动按钮。

视觉属性从 `AntThemeData` 令牌实时解析，
与 antd v6 `float-button/style/index.ts` 逐值对齐。

## 构造函数

### `AntFloatButton({super.key, this.icon, this.content, this.type = AntFloatButtonType.normal, this.shape = AntFloatButtonShape.circle, this.href, this.disabled = false, this.badge, this.tooltip, this.onClick})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `icon` | `Widget?` | 可选 | — |
| `content` | `Widget?` | 可选 | — |
| `type` | `AntFloatButtonType` | = AntFloatButtonType.normal | — |
| `shape` | `AntFloatButtonShape` | = AntFloatButtonShape.circle | — |
| `href` | `String?` | 可选 | — |
| `disabled` | `bool` | = false | — |
| `badge` | `AntFloatButtonBadge?` | 可选 | — |
| `tooltip` | `String?` | 可选 | — |
| `onClick` | `VoidCallback?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `badge` | `AntFloatButtonBadge?` | 角标配置 |
| `content` | `Widget?` | 自定义内容 Widget（icon 为空时使用） |
| `disabled` | `bool` | 禁用状态 |
| `href` | `String?` | 链接地址（API 对齐 antd，Flutter 中建议通过 onClick 处理跳转） |
| `icon` | `Widget?` | 图标 Widget（与 content 二选一，icon 优先） |
| `onClick` | `VoidCallback?` | 点击回调 |
| `shape` | `AntFloatButtonShape` | 按钮形状 |
| `tooltip` | `String?` | 提示文字 |
| `type` | `AntFloatButtonType` | 按钮类型 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntFloatButton>` | — |

