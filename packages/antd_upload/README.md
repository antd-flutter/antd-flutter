# antd_upload - Flutter upload list with custom file types

[English](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_upload/README.md) | [简体中文](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_upload/README_CN.md)

## Positioning & design

`antd_upload` is the file-list and upload-state layer of an upload flow, not a transport. It owns the trigger button, the selected-file list with progress, thumbnails, per-item status, and removal/preview affordances, while **your code** decides how files are picked and how bytes reach the server. `AntUpload<T>` is generic in the payload stored on each file record, so a row can carry a domain object (a parsed response, a document entity, a media descriptor) instead of a raw map.

Design rules:

- **Files are values.** `AntUploadFile<T>` is immutable; progress updates go through `copyWith`, so state transitions are explicit and testable.
- **Picking and transport are separate hooks.** `onSelectFiles` returns the rows to add (after your own picker or a synthetic source), and `customRequest` receives one row plus a progress callback, which is where HTTP, signing, or chunking lives.
- **Controlled and uncontrolled lists coexist.** `fileList` is the source of truth when supplied; otherwise `defaultFileList` seeds internal state and `onChange` reports every mutation.
- **The list is the visual contract.** `listType` switches between text rows and picture cards, and `showUploadList` can hide the list while keeping selection active for custom layouts.

## Installation

Requires Dart `>=3.0.0` and Flutter `>=3.10.0`.

```yaml
dependencies:
  antd_upload: ^1.0.0
```

Wrap the subtree in `AntTheme` so triggers, borders, and status colors come from the design tokens:

```dart
AntTheme(
  data: AntThemeData.light(),
  child: MaterialApp(home: YourPage()),
)
```

## Quick start

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

`onSelectFiles` returns the rows to add — in a real app that is where you invoke a platform picker. Each returned row enters the list as `uploading`; with no `customRequest` the widget marks it `done`, so this example is self-contained.

## API

[API reference](https://github.com/flutter-open/antd-flutter/blob/master/packages/antd_upload/docs/api-index.md)

### 1. Picture-card list with an owned list

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

Passing `fileList` makes the widget controlled: the new list from `onChange` must be stored, as `_apply` does, or removed rows reappear. `onRemove` returns a `Future<bool>`; returning `false` keeps the row.

### 2. Simulated transport with progress

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

`update` replaces the row with the new value; call it repeatedly for progress and finish with `AntUploadStatus.done` or `AntUploadStatus.error`. Reporting a failure this way renders the row's error state instead of leaving the uploading spinner on.

### 3. Text list with rejected rows

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

A row returned with `AntUploadStatus.error` stays visible in its failed state, so an unsupported file is shown with its reason instead of being silently dropped.

## Demo

- Live demo: https://flutter-open.github.io/antd-flutter/upload/
- Found a bug or have a question? [Open an issue](https://github.com/flutter-open/antd-flutter/issues/new/choose)

## Project structure

```text
packages/antd_upload/
├── lib/
│   ├── antd_upload.dart                 # barrel export
│   └── src/upload/
│       ├── ant_upload.dart              # trigger, list, remove and preview
│       └── ant_upload_types.dart        # file record, enums, callbacks
├── example/lib/main.dart                # runnable gallery
├── docs/api-index.md                    # generated API index
└── README.md
```

## License

MIT. See the repository [LICENSE](https://github.com/flutter-open/antd-flutter/blob/master/LICENSE).

## ☕ Buy Me a Coffee

If this project has been helpful to you, you are welcome to buy me a coffee. Thank you for your support!

| Alipay | WeChat |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/ali.jpg" width="260" alt="Alipay QR code" /> | <img src="https://raw.githubusercontent.com/flutter-open/resures-repository/master/docs/images/wechat.jpg" width="260" alt="WeChat QR code" /> |
