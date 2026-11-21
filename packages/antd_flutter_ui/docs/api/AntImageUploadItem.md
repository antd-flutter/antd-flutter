<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntImageUploadItem

> 种类：类

```dart
class AntImageUploadItem
```

图片上传项（现成模型）。

也可以直接传 `List<String>`（图片地址）或任意业务模型，配合
`AntImageUploader<T>(urlOf: ..., statusOf: ..., itemBuilder: ...)`。

## 构造函数

### `AntImageUploadItem({required this.url, this.status = AntImageUploadStatus.done})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `url` | `String` | 可选 | — |
| `status` | `AntImageUploadStatus` | = AntImageUploadStatus.done | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `status` | `AntImageUploadStatus` | 上传状态 |
| `url` | `String` | 图片地址 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `hashCode` | `int` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `==` | `bool` | — |

