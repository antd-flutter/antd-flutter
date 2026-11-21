<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntCalendarHeaderRenderConfig

> 种类：类

```dart
class AntCalendarHeaderRenderConfig
```

自定义头部渲染配置（antd v6 `headerRender` 的 config 对齐）。

## 构造函数

### `AntCalendarHeaderRenderConfig({required this.value, required this.type, required this.onChange, required this.onTypeChange})`

创建头部渲染配置。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `DateTime` | 可选 | — |
| `type` | `AntCalendarMode` | 可选 | — |
| `onChange` | `ValueChanged<DateTime>` | 可选 | — |
| `onTypeChange` | `ValueChanged<AntCalendarMode>` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `onChange` | `ValueChanged<DateTime>` | 头部改动日期时调用（对应 antd v6 onChange(date)） |
| `onTypeChange` | `ValueChanged<AntCalendarMode>` | 头部切换面板模式时调用（对应 antd v6 onTypeChange(type)） |
| `type` | `AntCalendarMode` | 当前面板模式（month / year） |
| `value` | `DateTime` | 当前值（选中日期，未选中时回退焦点日） |

