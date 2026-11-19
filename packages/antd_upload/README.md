# antd_upload

Ant Design v6 Upload 组件的 Flutter 实现 — 文件选择上传组件，支持文件列表展示（文字/图片/图片卡片）、上传进度、多选、maxCount 限制、受控/非受控模式、预览与删除，API 对齐 antd React Upload。

> 当前为预览版本。

> R33 判定：上传为表单录入类组件（文件选择 + 列表展示，非滚动场景），不需要 sliver 支持。

> R16 上传能力隔离：组件不直接发起网络上传，上传动作通过 `customRequest` / `onSelectFiles` 回调注入，由使用方实现真实上传逻辑（含 http/dio 等任意实现），包内不引入 http/dio 三方依赖。

## 安装

```yaml
dependencies:
  antd_upload: ^0.1.0-beta.1
```

## 用法

```dart
import 'package:antd_upload/antd_upload.dart';

// ── 基础用法（文字列表） ─────────────────────────────────
AntUpload(
  onChange: (file, fileList) {},
  onSelectFiles: () async => [pickedFile],          // 注入文件选择
  customRequest: (file, updateFile) async {         // 注入上传实现
    await doUpload(file);
    updateFile(file.copyWith(status: AntUploadStatus.done, percent: 100));
  },
);

// ── 图片卡片 + 多选 ─────────────────────────────────────
AntUpload(
  listType: AntUploadListType.pictureCard,
  multiple: true,
  maxCount: 5,
);

// ── 受控模式 ────────────────────────────────────────────
AntUpload(
  fileList: _files,
  onChange: (file, fileList) => setState(() => _files = fileList),
  onRemove: (file) async => true,
  onPreview: (file) {},
);
```

## 组件

| 组件/类型 | 说明 |
| --- | --- |
| `AntUpload` | 文件上传组件 |
| `AntUploadFile` | 上传文件信息 |
| `AntUploadStatus` | 上传状态（uploading / done / error / removed） |
| `AntUploadListType` | 列表展示类型（text / picture / pictureCard） |
| `AntUploadProgressInfo` | 上传进度信息 |

## Example

完整演示见 [example](./example/README.md)，覆盖基础上传列表、多文件、上传状态（上传中/成功/失败重试）、图片预览、受控操作、自定义 item 渲染。

```bash
cd example
flutter run -d macos   # 或 -d chrome
```
