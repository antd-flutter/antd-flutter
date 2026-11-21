# antd_upload - Flutter 支持自定义文件类型的上传列表

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_upload/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_upload/README_CN.md)

## 定位与设计

`antd_upload` 负责上传流程中的**文件列表与上传状态**，不负责传输。它提供触发按钮、带进度/缩略图/状态的已选文件列表，以及删除与预览入口；文件如何选择、字节如何抵达服务端由**你的代码**决定。`AntUpload<T>` 对每条文件记录携带的负载泛型，因此一行记录可以承载领域对象（解析后的响应、文档实体、媒体描述），而不是原始 Map。

设计原则：

- **文件是值对象。** `AntUploadFile<T>` 不可变，进度更新通过 `copyWith` 生成新值，状态流转明确、可测试。
- **选择与传输是两个钩子。** `onSelectFiles` 返回要加入列表的行（由你自己的选择器或合成数据产生），`customRequest` 拿到该行与进度回调，HTTP、签名、分片都实现在这里。
- **受控与非受控列表并存。** 传入 `fileList` 时它即数据源；否则用 `defaultFileList` 作为内部初始值，每次变更通过 `onChange` 汇报。
- **列表即视觉契约。** `listType` 在文本行与图片卡片间切换，`showUploadList` 可隐藏列表，便于自定义布局时只保留选择能力。

## 安装

要求 Dart `>=3.0.0`、Flutter `>=3.10.0`。

```yaml
dependencies:
  antd_upload: ^1.0.0
```

用 `AntTheme` 包裹子树；触发器、边框与状态色均来自设计 token：

```dart
AntTheme(
  data: AntThemeData.light(),
  child: MaterialApp(home: YourPage()),
)
```

## 快速开始

```dart
import 'package:antd_theme/antd_theme.dart';
import 'package:antd_upload/antd_upload.dart';
import 'package:material_ui/material_ui.dart';

class Attachment {
  const Attachment({required this.id, required this.name});

  final String id;
  final String name;
}

Future<List<AntUploadFile<Attachment>>> pickDocuments() async {
  final stamp = DateTime.now().microsecondsSinceEpoch;
  return <AntUploadFile<Attachment>>[
    AntUploadFile<Attachment>(
      uid: 'doc-$stamp',
      name: 'report.pdf',
      size: 20480,
      extra: Attachment(id: 'doc-$stamp', name: 'report.pdf'),
    ),
  ];
}

void main() => runApp(
      AntTheme(
        data: AntThemeData.light(),
        child: MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: AntUpload<Attachment>(
                multiple: true,
                uploadButtonText: 'Select files',
                onSelectFiles: pickDocuments,
                onChange: (file, list) {
                  debugPrint('${list.length} rows, last ${file.status}');
                },
              ),
            ),
          ),
        ),
      ),
    );
```

`onSelectFiles` 返回要加入列表的行——真实项目中就在这里调用平台选择器。返回的行先以 `uploading` 进入列表；未提供 `customRequest` 时组件直接标记为 `done`，因此本示例可独立运行。

## API

[API 参考](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_upload/docs/api-index.md)

### 1. 图片卡片列表与自持列表

```dart
class GalleryUpload extends StatefulWidget {
  const GalleryUpload({super.key});

  @override
  State<GalleryUpload> createState() => _GalleryUploadState();
}

class _GalleryUploadState extends State<GalleryUpload> {
  List<AntUploadFile<Attachment>> _files = <AntUploadFile<Attachment>>[];

  void _apply(
    AntUploadFile<Attachment> file,
    List<AntUploadFile<Attachment>> list,
  ) {
    setState(() => _files = list);
  }

  @override
  Widget build(BuildContext context) {
    return AntUpload<Attachment>(
      fileList: _files,
      listType: AntUploadListType.pictureCard,
      accept: 'image/*',
      maxCount: 8,
      multiple: true,
      uploadButtonText: 'Add images',
      onSelectFiles: () async {
        final stamp = DateTime.now().microsecondsSinceEpoch;
        return <AntUploadFile<Attachment>>[
          AntUploadFile<Attachment>(
            uid: 'image-$stamp',
            name: 'photo.png',
            size: 4096,
          ),
        ];
      },
      onChange: _apply,
      onRemove: (file) async {
        debugPrint('removed ${file.uid}');
        return true;
      },
      onPreview: (file) => debugPrint('preview ${file.name}'),
    );
  }
}
```

传入 `fileList` 即为受控：必须像 `_apply` 一样保存 `onChange` 给出的新列表，否则已删除的行会重新出现。`onRemove` 返回 `Future<bool>`，返回 `false` 则保留该行。

### 2. 带进度的模拟传输

```dart
Future<void> uploadToServer(
  AntUploadFile<Attachment> file,
  void Function(AntUploadFile<Attachment> next) update,
) async {
  for (var percent = 0; percent <= 100; percent += 20) {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    update(
      file.copyWith(
        status: AntUploadStatus.uploading,
        percent: percent,
      ),
    );
  }
  update(
    file.copyWith(
      status: AntUploadStatus.done,
      percent: 100,
      url: 'https://example.com/files/${file.uid}',
    ),
  );
}

AntUpload<Attachment>(
  uploadButtonText: 'Upload',
  customRequest: uploadToServer,
  onSelectFiles: () async => <AntUploadFile<Attachment>>[
    AntUploadFile<Attachment>(
      uid: 'doc-1',
      name: 'contract.pdf',
      size: 8192,
    ),
  ],
  onChange: (file, list) => debugPrint('${file.uid}: ${file.status} ${file.percent}%'),
)
```

`update` 用新值替换该行；可反复调用以更新进度，最后以 `AntUploadStatus.done` 或 `AntUploadStatus.error` 收尾。这样上报的失败会渲染成错误状态，而不会留下一直转圈的上传中状态。

### 3. 带失败行的文本列表

```dart
AntUpload<Attachment>(
  listType: AntUploadListType.text,
  maxCount: 3,
  accept: '.pdf,.docx',
  onSelectFiles: () async => <AntUploadFile<Attachment>>[
    const AntUploadFile<Attachment>(
      uid: 'ok',
      name: 'summary.pdf',
      size: 1024,
    ),
    const AntUploadFile<Attachment>(
      uid: 'bad',
      name: 'notes.txt',
      status: AntUploadStatus.error,
    ),
  ],
  onChange: (file, list) => debugPrint('${list.length} files'),
  onRemove: (file) async => true,
)
```

以 `AntUploadStatus.error` 返回的行会以失败状态留在列表里，让不支持的文件带着原因可见，而不是被静默丢弃。

## 项目结构

```text
packages/antd_upload/
├── lib/
│   ├── antd_upload.dart                 # barrel 导出
│   └── src/upload/
│       ├── ant_upload.dart              # 触发器、列表、删除与预览
│       └── ant_upload_types.dart        # 文件记录、枚举与回调
├── example/lib/main.dart                # 可运行示例
├── docs/api-index.md                    # 生成的 API 索引
└── README.md
```

## License

MIT，详见仓库 [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE)。

## ☕ 请我喝咖啡

如果这个项目帮到了你，欢迎请我喝杯咖啡，感谢你的支持！

| 支付宝 | 微信 |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="支付宝收款码" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="微信收款码" /> |
