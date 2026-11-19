<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntUploadProgressInfo

> 种类：类

```dart
class AntUploadProgressInfo
```

上传进度信息

## 构造函数

### `AntUploadProgressInfo({required this.percent, this.loaded, this.total})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `percent` | `int` | 可选 | — |
| `loaded` | `int?` | 可选 | — |
| `total` | `int?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `loaded` | `int?` | 已上传字节数 |
| `percent` | `int` | 进度百分比（0-100） |
| `total` | `int?` | 总字节数 |

