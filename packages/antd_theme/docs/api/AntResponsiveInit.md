<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntResponsiveInit

> 种类：类

```dart
class AntResponsiveInit
```

AntResponsive 初始化 Widget。

- 监听 `MediaQuery` 变化，快照值真正变化（`==` 不等）才通知；
- 同时注入 `AntResponsive`（Widget 依赖）与 `AntResponsiveScope`
  （非 Widget 的 `ValueListenable` / addListener 订阅入口）；
- `foldStateProvider` 用于接入平台折叠态（OHOS 经 AntOhosChannel），
  返回 null 时回落到 displayFeatures 推导。

```dart
AntResponsiveInit(
  foldStateProvider: () => isOhos
      ? AntOhosChannelRegistry.channel.getFoldStateSync()
      : null,
  builder: (context, data) => MaterialApp(...),
)
```

## 构造函数

### `AntResponsiveInit({super.key, required this.builder, this.child, this.foldStateProvider})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `builder` | `Widget Function(BuildContext context, AntLayoutData data, Widget? child)` | 可选 | — |
| `child` | `Widget?` | 可选 | — |
| `foldStateProvider` | `AntFoldStateProvider?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `builder` | `Widget Function(BuildContext context, AntLayoutData data, Widget? child)` | 构建回调，携带当前布局快照 |
| `child` | `Widget?` | 透传子树（稳定实例，配合 builder 实现局部刷新） |
| `foldStateProvider` | `AntFoldStateProvider?` | 折叠态外部提供器（OHOS channel 等），null 时自动推导 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntResponsiveInit>` | — |

