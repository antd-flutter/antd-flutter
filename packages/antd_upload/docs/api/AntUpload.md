<!-- 由 scripts/gen_docs.{sh,ps1} 机械生成，勿手工编辑；修改对应源码 /// 注释后重跑 gen-docs -->

# AntUpload

> 种类：类

```dart
class AntUpload
```

文件上传组件。

`AntUploadFile` 描述的是实际文件；泛型 `T` 通过
`AntUploadFile.extra` 承载业务侧额外数据，配合 `itemBuilder`
可完全自定义列表项渲染。

## 构造函数

### `AntUpload({super.key, this.fileList, this.defaultFileList = const [], this.listType = AntUploadListType.text, this.showUploadList = true, this.disabled = false, this.multiple = false, this.maxCount, this.accept, this.onChange, this.onRemove, this.onPreview, this.onSelectFiles, this.customRequest, this.itemBuilder, this.uploadButtonText, this.uploadButtonIcon})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `fileList` | `List<AntUploadFile<T>>?` | 可选 | — |
| `defaultFileList` | `List<AntUploadFile<T>>` | = const [] | — |
| `listType` | `AntUploadListType` | = AntUploadListType.text | — |
| `showUploadList` | `bool` | = true | — |
| `disabled` | `bool` | = false | — |
| `multiple` | `bool` | = false | — |
| `maxCount` | `int?` | 可选 | — |
| `accept` | `String?` | 可选 | — |
| `onChange` | `void Function(AntUploadFile<T> file, List<AntUploadFile<T>> fileList)?` | 可选 | — |
| `onRemove` | `Future<bool> Function(AntUploadFile<T> file)?` | 可选 | — |
| `onPreview` | `void Function(AntUploadFile<T> file)?` | 可选 | — |
| `onSelectFiles` | `Future<List<AntUploadFile<T>>> Function()?` | 可选 | — |
| `customRequest` | `Future<void> Function(AntUploadFile<T> file, void Function(AntUploadFile<T> updatedFile) updateFile)?` | 可选 | — |
| `itemBuilder` | `AntUploadItemBuilder<T>?` | 可选 | — |
| `uploadButtonText` | `String?` | 可选 | — |
| `uploadButtonIcon` | `IconData?` | 可选 | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `accept` | `String?` | 接受的文件类型 |
| `customRequest` | `Future<void> Function(AntUploadFile<T> file, void Function(AntUploadFile<T> updatedFile) updateFile)?` | 自定义上传实现 |
| `defaultFileList` | `List<AntUploadFile<T>>` | 非受控：文件列表初始值 |
| `disabled` | `bool` | 是否禁用 |
| `fileList` | `List<AntUploadFile<T>>?` | 受控：文件列表 |
| `itemBuilder` | `AntUploadItemBuilder<T>?` | 列表项自定义渲染 |
| `listType` | `AntUploadListType` | 列表展示类型 |
| `maxCount` | `int?` | 最大上传数量 |
| `multiple` | `bool` | 是否支持多选 |
| `onChange` | `void Function(AntUploadFile<T> file, List<AntUploadFile<T>> fileList)?` | 文件状态变化回调 |
| `onPreview` | `void Function(AntUploadFile<T> file)?` | 点击文件链接或图片回调 |
| `onRemove` | `Future<bool> Function(AntUploadFile<T> file)?` | 删除文件回调，返回 false 可阻止删除 |
| `onSelectFiles` | `Future<List<AntUploadFile<T>>> Function()?` | 点击上传按钮时触发文件选择的回调 返回待上传的文件列表，组件会自动调用 customRequest |
| `showUploadList` | `bool` | 是否展示文件列表 |
| `uploadButtonIcon` | `IconData?` | 上传按钮图标 |
| `uploadButtonText` | `String?` | 上传按钮文案 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntUpload<T>>` | — |

