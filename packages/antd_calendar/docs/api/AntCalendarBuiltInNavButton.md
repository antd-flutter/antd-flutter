<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCalendarBuiltInNavButton

> 种类：类

```dart
class AntCalendarBuiltInNavButton
```

移动端头部内置导航按钮标记（`AntCalendar.prevMonthButton` 等默认值）。

渲染器识别该类型后按主题缩放绘制内置图标；传 `null` 表示隐藏该按钮；
也可传入任意自定义 Widget 完全替换按钮外观。

## 构造函数

### `AntCalendarBuiltInNavButton(this.icon, {super.key})`

创建内置导航按钮标记。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `icon` | `IconData` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `icon` | `IconData` | 内置图标 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `build` | `Widget` | — |

