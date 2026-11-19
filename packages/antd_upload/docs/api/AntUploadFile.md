<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntUploadFile

> 种类：类

```dart
class AntUploadFile
```

上传文件信息

## 构造函数

### `AntUploadFile({required this.uid, required this.name, this.status = AntUploadStatus.done, this.size, this.url, this.thumbUrl, this.percent = 0, this.response})`

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

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
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
| `copyWith` | `AntUploadFile` | 复制并修改属性 |

