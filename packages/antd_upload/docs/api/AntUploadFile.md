<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntUploadFile

> 种类：类

```dart
class AntUploadFile
```

上传文件信息。

它描述的是「实际文件」而不是业务模型；业务侧额外字段放到泛型
`extra` 槽里（或使用 `AntUpload<T>` 的 `itemBuilder` 自行渲染）。

## 构造函数

### `AntUploadFile({required this.uid, required this.name, this.status = AntUploadStatus.done, this.size, this.url, this.thumbUrl, this.percent = 0, this.response, this.extra})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `uid` | `String` | 可选 | — |
| `name` | `String` | 可选 | — |
| `status` | `AntUploadStatus` | = AntUploadStatus.done | — |
| `size` | `int?` | 可选 | — |
| `url` | `String?` | 可选 | — |
| `thumbUrl` | `String?` | 可选 | — |
| `percent` | `int` | = 0 | — |
| `response` | `dynamic` | 可选 | — |
| `extra` | `T?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `extra` | `T?` | 业务侧额外数据（不参与 ==/hashCode） |
| `name` | `String` | 文件名 |
| `percent` | `int` | 上传进度（0-100） |
| `response` | `dynamic` | 服务端响应数据 |
| `size` | `int?` | 文件大小（字节） |
| `status` | `AntUploadStatus` | 上传状态 |
| `thumbUrl` | `String?` | 缩略图地址 |
| `uid` | `String` | 唯一标识 |
| `url` | `String?` | 文件下载地址 |

## 属性

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `hashCode` | `int` | — |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `==` | `bool` | — |
| `copyWith` | `AntUploadFile<T>` | 复制并修改属性 |

