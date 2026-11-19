<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntDropdownController

> 种类：类

```dart
class AntDropdownController
```

`AntDropdown` 的程序化控制器（R35.2 受控操作 Controller 化）。

Flutter 惯例模式（参考 `ScrollController` / EasyRefreshController）：
组件挂载时自动 `attach`，卸载时自动 `detach`；使用方无需
GlobalKey 或自维护 bool state + setState，直接调用
`show` / `hide` 即可。

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `_delegate` | `AntDropdownControlDelegate?` | — |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `isAttached` | `bool` | 是否已绑定到挂载的 AntDropdown |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `attach` | `void` | 绑定 State（组件 initState 时自动调用，一般无需手动调用） |
| `detach` | `void` | 解绑 State（组件 dispose 时自动调用，一般无需手动调用） |
| `hide` | `void` | 隐藏下拉菜单 |
| `show` | `void` | 显示下拉菜单 |

