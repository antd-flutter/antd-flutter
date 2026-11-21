<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntTooltipController

> 种类：类

```dart
class AntTooltipController
```

`AntTooltip` 的程序化控制器（R35.2 受控操作 Controller 化）。

Flutter 惯例模式（参考 `ScrollController` / EasyRefreshController）：
组件挂载时自动 `attach`，卸载时自动 `detach`；使用方无需
GlobalKey 或自维护 bool state + setState，直接调用
`show` / `hide` / `toggle` 即可。

```dart
final _controller = AntTooltipController();

AntTooltip(controller: _controller, tooltip: ..., child: ...);
_controller.show(); // 程序化打开
```

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_delegate` | `AntTooltipControlDelegate?` | — |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `isAttached` | `bool` | 是否已绑定到挂载的 AntTooltip |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `attach` | `void` | 绑定 State（组件 initState 时自动调用，一般无需手动调用） |
| `detach` | `void` | 解绑 State（组件 dispose 时自动调用，一般无需手动调用） |
| `hide` | `void` | 隐藏气泡 |
| `show` | `void` | 显示气泡 |
| `toggle` | `void` | 切换气泡显示状态（打开↔关闭） |

