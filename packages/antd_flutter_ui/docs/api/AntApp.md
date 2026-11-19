<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntApp

> 种类：类

```dart
class AntApp
```

全局上下文根组件 — 为全局反馈组件提供无需页面 context 的静态入口。

对齐 antd React App 组件。

## 构造函数

### `AntApp({super.key, required this.child, this.navigatorKey, this.message, this.notification, this.modal})`

创建 AntApp。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `child` | `Widget` | 可选 | — |
| `navigatorKey` | `GlobalKey<NavigatorState>?` | 可选 | — |
| `message` | `AntAppMessageConfig?` | 可选 | — |
| `notification` | `AntAppNotificationConfig?` | 可选 | — |
| `modal` | `AntAppModalConfig?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `child` | `Widget` | 包裹的组件子树，通常放在 MaterialApp 的 home / 路由内部 |
| `message` | `AntAppMessageConfig?` | message 全局默认配置 |
| `modal` | `AntAppModalConfig?` | modal 全局默认配置 |
| `navigatorKey` | `GlobalKey<NavigatorState>?` | 与 MaterialApp 共享的 NavigatorKey（可选） |
| `notification` | `AntAppNotificationConfig?` | notification 全局默认配置 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntApp>` | — |
| `of` | `AntAppState` | 获取最近祖先 AntApp 的状态（StaticApi） |

