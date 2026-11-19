<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntImageUploader

> 种类：类

```dart
class AntImageUploader
```

图片上传 — 图片选择、预览与删除的网格组件。

对齐 antd-mobile React ImageUploader。通过 `onPickImage` 回调
获取待上传图片，组件负责网格展示、预览与删除。

## 构造函数

### `AntImageUploader({super.key, this.value, this.defaultValue = const [], this.onChange, this.onPickImage, this.onDelete, this.onCountExceed, this.maxCount = 0, this.columns = 4, this.deletable = true, this.showUpload = true, this.preview = true, this.imageFit = BoxFit.cover, this.uploadIcon = Icons.add})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `List<AntImageUploadItem>?` | 可选 | — |
| `defaultValue` | `List<AntImageUploadItem>` | = const [] | — |
| `onChange` | `ValueChanged<List<AntImageUploadItem>>?` | 可选 | — |
| `onPickImage` | `Future<List<AntImageUploadItem>> Function()?` | 可选 | — |
| `onDelete` | `bool Function(AntImageUploadItem)?` | 可选 | — |
| `onCountExceed` | `ValueChanged<int>?` | 可选 | — |
| `maxCount` | `int` | = 0 | — |
| `columns` | `int` | = 4 | — |
| `deletable` | `bool` | = true | — |
| `showUpload` | `bool` | = true | — |
| `preview` | `bool` | = true | — |
| `imageFit` | `BoxFit` | = BoxFit.cover | — |
| `uploadIcon` | `IconData` | = Icons.add | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `columns` | `int` | 每行列数 |
| `defaultValue` | `List<AntImageUploadItem>` | 非受控初始列表 |
| `deletable` | `bool` | 是否可删除 |
| `imageFit` | `BoxFit` | 图片填充模式 |
| `maxCount` | `int` | 最大图片数量（0 为不限制） |
| `onChange` | `ValueChanged<List<AntImageUploadItem>>?` | 列表变化回调 |
| `onCountExceed` | `ValueChanged<int>?` | 超出最大数量回调 |
| `onDelete` | `bool Function(AntImageUploadItem)?` | 删除回调（返回 false 阻止删除） |
| `onPickImage` | `Future<List<AntImageUploadItem>> Function()?` | 选图回调（返回新增图片列表） |
| `preview` | `bool` | 是否点击预览 |
| `showUpload` | `bool` | 是否显示上传按钮 |
| `uploadIcon` | `IconData` | 上传按钮图标 |
| `value` | `List<AntImageUploadItem>?` | 受控图片列表 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntImageUploader>` | — |

