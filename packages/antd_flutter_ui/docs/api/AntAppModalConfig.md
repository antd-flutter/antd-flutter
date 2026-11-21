<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntAppModalConfig

> 种类：类

```dart
class AntAppModalConfig
```

AntApp 全局 modal 默认配置。

## 构造函数

### `AntAppModalConfig({this.okText, this.cancelText, this.maskClosable, this.width})`

创建 modal 全局默认配置。

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `okText` | `String?` | 可选 | — |
| `cancelText` | `String?` | 可选 | — |
| `maskClosable` | `bool?` | 可选 | — |
| `width` | `double?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `cancelText` | `String?` | 默认取消按钮文案 |
| `maskClosable` | `bool?` | 默认点击遮罩是否可关闭 |
| `okText` | `String?` | 默认确认按钮文案 |
| `width` | `double?` | 默认弹窗宽度 |

