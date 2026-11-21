import 'package:antd_flutter_ui/src/data_entry/image_uploader/ant_image_uploader.dart';
import 'package:antd_flutter_ui/src/feedback/loading/ant_loading.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    );
}

/// 自定义模型：照片（业务里常带 id / 上传进度等字段）。
class _Photo {
  const _Photo(this.id, this.url, {this.uploading = false});

  final String id;
  final String url;
  final bool uploading;
}

void main() {
  group('AntImageUploader — rendering', () {
    testWidgets('renders upload button when empty', (tester) async {
      await tester.pumpWidget(_wrap(const AntImageUploader()));
      expect(find.byIcon(AntIcons.plusOutlined), findsOneWidget);
    });

    testWidgets('renders image items from defaultValue', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntImageUploader(
            defaultValue: [
              AntImageUploadItem(url: 'https://a.com/1.png'),
              AntImageUploadItem(url: 'https://a.com/2.png'),
            ],
          ),
        ),
      );
      await tester.pump();
      // 两项各有删除按钮
      expect(find.byIcon(AntIcons.closeOutlined), findsNWidgets(2));
      // 加上上传按钮
      expect(find.byIcon(AntIcons.plusOutlined), findsOneWidget);
    });

    testWidgets('hide upload button when showUpload false', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntImageUploader(
            showUpload: false,
          ),
        ),
      );
      expect(find.byIcon(AntIcons.plusOutlined), findsNothing);
    });

    testWidgets('hide upload button when maxCount reached', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntImageUploader(
            maxCount: 1,
            defaultValue: [AntImageUploadItem(url: 'https://a.com/1.png')],
          ),
        ),
      );
      await tester.pump();
      expect(find.byIcon(AntIcons.plusOutlined), findsNothing);
    });

    testWidgets('no delete button when deletable false', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntImageUploader(
            deletable: false,
            defaultValue: [AntImageUploadItem(url: 'https://a.com/1.png')],
          ),
        ),
      );
      await tester.pump();
      expect(find.byIcon(AntIcons.closeOutlined), findsNothing);
    });

    testWidgets('shows uploading indicator for uploading status',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntImageUploader(
            defaultValue: [
              AntImageUploadItem(
                url: 'https://a.com/1.png',
                status: AntImageUploadStatus.uploading,
              ),
            ],
          ),
        ),
      );
      expect(find.byType(AntLoading), findsOneWidget);
    });

    testWidgets('shows failed indicator for failed status', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntImageUploader(
            defaultValue: [
              AntImageUploadItem(
                url: 'https://a.com/1.png',
                status: AntImageUploadStatus.failed,
              ),
            ],
          ),
        ),
      );
      expect(find.byIcon(AntIcons.exclamationCircleOutlined), findsOneWidget);
    });
  });

  group('AntImageUploader — interaction', () {
    testWidgets('tap upload adds items via onChange', (tester) async {
      var changed = <AntImageUploadItem>[];
      await tester.pumpWidget(
        _wrap(
          AntImageUploader(
            onPickImage: () async =>
                [const AntImageUploadItem(url: 'https://a.com/new.png')],
            onChange: (items) => changed = items,
          ),
        ),
      );
      await tester.tap(find.byIcon(AntIcons.plusOutlined));
      await tester.pumpAndSettle();
      expect(changed.length, 1);
      expect(changed.first.url, 'https://a.com/new.png');
      // 新增项显示删除按钮
      expect(find.byIcon(AntIcons.closeOutlined), findsOneWidget);
    });

    testWidgets('tap delete removes item via onChange', (tester) async {
      var changed = <AntImageUploadItem>[];
      await tester.pumpWidget(
        _wrap(
          AntImageUploader(
            defaultValue: const [
              AntImageUploadItem(url: 'https://a.com/1.png'),
              AntImageUploadItem(url: 'https://a.com/2.png'),
            ],
            onChange: (items) => changed = items,
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byIcon(AntIcons.closeOutlined).first);
      await tester.pump();
      expect(changed.length, 1);
    });

    testWidgets('onDelete returning false prevents deletion', (tester) async {
      var changed = <AntImageUploadItem>[];
      await tester.pumpWidget(
        _wrap(
          AntImageUploader(
            defaultValue: const [
              AntImageUploadItem(url: 'https://a.com/1.png'),
            ],
            onDelete: (_) => false,
            onChange: (items) => changed = items,
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byIcon(AntIcons.closeOutlined).first);
      await tester.pump();
      expect(changed, isEmpty);
    });

    testWidgets('maxCount truncates picked items and fires onCountExceed',
        (tester) async {
      var exceed = 0;
      var changed = <AntImageUploadItem>[];
      await tester.pumpWidget(
        _wrap(
          AntImageUploader(
            maxCount: 2,
            defaultValue: const [
              AntImageUploadItem(url: 'https://a.com/1.png'),
            ],
            onPickImage: () async => const [
              AntImageUploadItem(url: 'https://a.com/2.png'),
              AntImageUploadItem(url: 'https://a.com/3.png'),
              AntImageUploadItem(url: 'https://a.com/4.png'),
            ],
            onCountExceed: (n) => exceed = n,
            onChange: (items) => changed = items,
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byIcon(AntIcons.plusOutlined));
      await tester.pumpAndSettle();
      expect(changed.length, 2);
      expect(exceed, 2);
    });

    testWidgets('null onPickImage does nothing on tap', (tester) async {
      await tester.pumpWidget(_wrap(const AntImageUploader()));
      await tester.tap(find.byIcon(AntIcons.plusOutlined));
      await tester.pumpAndSettle();
      // 仍只有上传按钮，无图片项
      expect(find.byIcon(AntIcons.closeOutlined), findsNothing);
    });

    testWidgets('tap image opens preview page', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntImageUploader(
            defaultValue: [AntImageUploadItem(url: 'https://a.com/1.png')],
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byType(ClipRRect).first);
      await tester.pumpAndSettle();
      expect(find.byType(InteractiveViewer), findsOneWidget);
      // 关闭预览
      await tester.tap(find.byType(InteractiveViewer));
      await tester.pumpAndSettle();
      expect(find.byType(InteractiveViewer), findsNothing);
    });
  });

  group('AntImageUploader — 自定义模型', () {
    testWidgets('自定义模型：urlOf/statusOf 驱动渲染', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntImageUploader<_Photo>(
            defaultValue: [
              _Photo('p1', 'https://a.com/1.png'),
              _Photo('p2', 'https://a.com/2.png', uploading: true),
            ],
            urlOf: _photoUrl,
            statusOf: _photoStatus,
          ),
        ),
      );
      await tester.pump();
      expect(find.byIcon(AntIcons.closeOutlined), findsNWidgets(2));
      expect(find.byType(AntLoading), findsOneWidget);
    });

    testWidgets('自定义模型：onPickImage/onChange 全链路回传模型', (tester) async {
      var changed = <_Photo>[];
      _Photo? deleted;
      await tester.pumpWidget(
        _wrap(
          AntImageUploader<_Photo>(
            defaultValue: const [_Photo('p1', 'https://a.com/1.png')],
            urlOf: _photoUrl,
            onPickImage: () async =>
                const [_Photo('p2', 'https://a.com/2.png')],
            onDelete: (photo) {
              deleted = photo;
              return false;
            },
            onChange: (items) => changed = items,
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byIcon(AntIcons.plusOutlined));
      await tester.pumpAndSettle();
      expect(changed.map((p) => p.id), ['p1', 'p2']);

      // onDelete 拦下删除
      await tester.tap(find.byIcon(AntIcons.closeOutlined).first);
      await tester.pump();
      expect(deleted?.id, 'p1');
      expect(changed.map((p) => p.id), ['p1', 'p2']);
    });

    testWidgets('自定义模型：itemBuilder 自定义格子 + previewBuilder 自定义预览',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntImageUploader<_Photo>(
            defaultValue: const [_Photo('p1', 'https://a.com/1.png')],
            urlOf: _photoUrl,
            itemBuilder: (context, photo, index) => ColoredBox(
                color: Colors.red, child: Center(child: Text(photo.id)),),
            previewBuilder: (context, photo) =>
                Scaffold(body: Center(child: Text('预览 ${photo.id}'))),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('p1'), findsOneWidget);

      await tester.tap(find.text('p1'));
      await tester.pumpAndSettle();
      expect(find.text('预览 p1'), findsOneWidget);
    });

    testWidgets('String 列表可直接作为数据源（缺省 urlOf）', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntImageUploader<String>(
            defaultValue: ['https://a.com/1.png', 'https://a.com/2.png'],
            deletable: false,
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(Image), findsNWidgets(2));
    });
  });

  group('AntImageUploader — controlled', () {
    testWidgets('value prop renders items', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntImageUploader(
            value: [
              AntImageUploadItem(url: 'https://a.com/1.png'),
              AntImageUploadItem(url: 'https://a.com/2.png'),
              AntImageUploadItem(url: 'https://a.com/3.png'),
            ],
          ),
        ),
      );
      await tester.pump();
      expect(find.byIcon(AntIcons.closeOutlined), findsNWidgets(3));
    });

    testWidgets('controlled upload fires onChange only', (tester) async {
      var changed = <AntImageUploadItem>[];
      await tester.pumpWidget(
        _wrap(
          AntImageUploader(
            value: const [AntImageUploadItem(url: 'https://a.com/1.png')],
            onPickImage: () async =>
                [const AntImageUploadItem(url: 'https://a.com/2.png')],
            onChange: (items) => changed = items,
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byIcon(AntIcons.plusOutlined));
      await tester.pumpAndSettle();
      expect(changed.length, 2);
      // 受控模式内部值不变，仍只有 1 个删除按钮
      expect(find.byIcon(AntIcons.closeOutlined), findsOneWidget);
    });
  });
}

String _photoUrl(_Photo photo) => photo.url;

AntImageUploadStatus _photoStatus(_Photo photo) => photo.uploading
    ? AntImageUploadStatus.uploading
    : AntImageUploadStatus.done;
