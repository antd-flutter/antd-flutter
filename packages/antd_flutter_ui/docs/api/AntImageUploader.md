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

### `AntImageUploader({super.key, this.value, this.defaultValue = const [], this.onChange, this.onPickImage, this.onDelete, this.urlOf, this.statusOf, this.itemBuilder, this.previewBuilder, this.onCountExceed, this.maxCount = 0, this.columns = 4, this.deletable = true, this.showUpload = true, this.preview = true, this.imageFit = BoxFit.cover, this.uploadIcon = AntIcons.plusOutlined})`

| 名称 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `List<T>?` | 可选 | — |
| `defaultValue` | `List<T>` | = const [] | — |
| `onChange` | `ValueChanged<List<T>>?` | 可选 | — |
| `onPickImage` | `Future<List<T>> Function()?` | 可选 | — |
| `onDelete` | `bool Function(T item)?` | 可选 | — |
| `urlOf` | `String Function(T item)?` | 可选 | — |
| `statusOf` | `AntImageUploadStatus Function(T item)?` | 可选 | — |
| `itemBuilder` | `Widget Function(BuildContext context, T item, int index)?` | 可选 | — |
| `previewBuilder` | `Widget Function(BuildContext context, T item)?` | 可选 | — |
| `onCountExceed` | `ValueChanged<int>?` | 可选 | — |
| `maxCount` | `int` | = 0 | — |
| `columns` | `int` | = 4 | — |
| `deletable` | `bool` | = true | — |
| `showUpload` | `bool` | = true | — |
| `preview` | `bool` | = true | — |
| `imageFit` | `BoxFit` | = BoxFit.cover | — |
| `uploadIcon` | `IconData` | = AntIcons.plusOutlined | — |

## 字段

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `columns` | `int` | 每行列数 |
| `defaultValue` | `List<T>` | 非受控初始列表 |
| `deletable` | `bool` | 是否可删除 |
| `imageFit` | `BoxFit` | 图片填充模式 |
| `itemBuilder` | `Widget Function(BuildContext context, T item, int index)?` | 自定义图片格子内容（默认 Image.network） |
| `maxCount` | `int` | 最大图片数量（0 为不限制） |
| `onChange` | `ValueChanged<List<T>>?` | 列表变化回调 |
| `onCountExceed` | `ValueChanged<int>?` | 超出最大数量回调 |
| `onDelete` | `bool Function(T item)?` | 删除回调（返回 false 阻止删除） |
| `onPickImage` | `Future<List<T>> Function()?` | 选图回调（返回新增图片列表） |
| `preview` | `bool` | 是否点击预览 |
| `previewBuilder` | `Widget Function(BuildContext context, T item)?` | 自定义全屏预览内容，缺省用 Image.network(url) 全屏展示 |
| `showUpload` | `bool` | 是否显示上传按钮 |
| `statusOf` | `AntImageUploadStatus Function(T item)?` | 上传状态，缺省：T 是 AntImageUploadItem 时取 status，否则视为完成 |
| `uploadIcon` | `IconData` | 上传按钮图标 |
| `urlOf` | `String Function(T item)?` | 图片地址，缺省：T 是 String 时直接使用， 是 AntImageUploadItem 时取 url，否则抛… |
| `value` | `List<T>?` | 受控图片列表 |

## 方法

| 名称 | 类型 | 说明 |
| --- | --- | --- |
| `createState` | `State<AntImageUploader<T>>` | — |

