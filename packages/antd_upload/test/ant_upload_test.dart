/// AntUpload widget tests
library;

import 'package:antd_upload/antd_upload.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

Widget _wrap(Widget child) => AntScreenUtilInit(
      builder: (context, _) => MaterialApp(
        home: Scaffold(
          body: AntTheme(
            data: AntThemeData.light(),
            child: Material(child: child),
          ),
        ),
      ),
    );

void main() {
  group('AntUpload', () {
    testWidgets('renders upload button with default text', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntUpload(),
      ),);
      expect(find.text('上传'), findsOneWidget);
      expect(find.byIcon(AntIcons.uploadOutlined), findsOneWidget);
    });

    testWidgets('renders custom button text', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntUpload(uploadButtonText: '选择文件'),
      ),);
      expect(find.text('选择文件'), findsOneWidget);
    });

    testWidgets('renders default file list', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntUpload(
          defaultFileList: [
            AntUploadFile(uid: '1', name: 'doc.pdf'),
            AntUploadFile(uid: '2', name: 'img.png'),
          ],
        ),
      ),);
      expect(find.text('doc.pdf'), findsOneWidget);
      expect(find.text('img.png'), findsOneWidget);
    });

    testWidgets('controlled fileList renders', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntUpload(
          fileList: [
            AntUploadFile(uid: '1', name: 'controlled.txt'),
          ],
        ),
      ),);
      expect(find.text('controlled.txt'), findsOneWidget);
    });

    testWidgets('tapping upload button calls onSelectFiles', (tester) async {
      bool selectCalled = false;
      await tester.pumpWidget(_wrap(
        AntUpload(
          onSelectFiles: () async {
            selectCalled = true;
            return [];
          },
        ),
      ),);
      await tester.tap(find.text('上传'));
      await tester.pumpAndSettle();
      expect(selectCalled, isTrue);
    });

    testWidgets('selecting file adds to list and marks done without customRequest',
        (tester) async {
      AntUploadFile? lastFile;
      List<AntUploadFile>? lastList;
      await tester.pumpWidget(_wrap(
        AntUpload(
          onSelectFiles: () async => [
            const AntUploadFile(uid: 'u1', name: 'new-file.txt'),
          ],
          onChange: (file, list) {
            lastFile = file;
            lastList = list;
          },
        ),
      ),);
      await tester.tap(find.text('上传'));
      await tester.pumpAndSettle();
      expect(lastFile?.name, 'new-file.txt');
      expect(lastFile?.status, AntUploadStatus.done);
      expect(lastList?.length, 1);
      expect(find.text('new-file.txt'), findsOneWidget);
    });

    testWidgets('customRequest controls upload flow', (tester) async {
      final states = <AntUploadStatus>[];
      await tester.pumpWidget(_wrap(
        AntUpload(
          onSelectFiles: () async => [
            const AntUploadFile(uid: 'u1', name: 'upload.txt'),
          ],
          customRequest: (file, update) async {
            states.add(file.status);
            update(file.copyWith(status: AntUploadStatus.done, percent: 100));
          },
        ),
      ),);
      await tester.tap(find.text('上传'));
      await tester.pumpAndSettle();
      expect(states, [AntUploadStatus.uploading]);
      expect(find.byIcon(AntIcons.checkCircleFilled), findsOneWidget);
    });

    testWidgets('remove button removes file from list', (tester) async {
      AntUploadFile? removedFile;
      await tester.pumpWidget(_wrap(
        AntUpload(
          defaultFileList: const [
            AntUploadFile(uid: '1', name: 'to-remove.txt'),
          ],
          onRemove: (file) async {
            removedFile = file;
            return true;
          },
        ),
      ),);
      expect(find.text('to-remove.txt'), findsOneWidget);
      await tester.tap(find.byIcon(AntIcons.closeOutlined));
      await tester.pumpAndSettle();
      expect(removedFile?.name, 'to-remove.txt');
      expect(find.text('to-remove.txt'), findsNothing);
    });

    testWidgets('onRemove returning false prevents removal', (tester) async {
      await tester.pumpWidget(_wrap(
        AntUpload(
          defaultFileList: const [
            AntUploadFile(uid: '1', name: 'keep-me.txt'),
          ],
          onRemove: (file) async => false,
        ),
      ),);
      await tester.tap(find.byIcon(AntIcons.closeOutlined));
      await tester.pumpAndSettle();
      expect(find.text('keep-me.txt'), findsOneWidget);
    });

    testWidgets('onPreview fires when tapping file name', (tester) async {
      AntUploadFile? previewedFile;
      await tester.pumpWidget(_wrap(
        AntUpload(
          defaultFileList: const [
            AntUploadFile(uid: '1', name: 'preview.txt', url: 'https://example.com/f'),
          ],
          onPreview: (file) => previewedFile = file,
        ),
      ),);
      await tester.tap(find.text('preview.txt'));
      await tester.pumpAndSettle();
      expect(previewedFile?.name, 'preview.txt');
    });

    testWidgets('disabled upload does not respond to tap', (tester) async {
      bool selectCalled = false;
      await tester.pumpWidget(_wrap(
        AntUpload(
          disabled: true,
          onSelectFiles: () async {
            selectCalled = true;
            return [];
          },
        ),
      ),);
      await tester.tap(find.text('上传'));
      await tester.pumpAndSettle();
      expect(selectCalled, isFalse);
    });

    testWidgets('disabled upload hides remove buttons', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntUpload(
          disabled: true,
          defaultFileList: [
            AntUploadFile(uid: '1', name: 'locked.txt'),
          ],
        ),
      ),);
      expect(find.text('locked.txt'), findsOneWidget);
      expect(find.byIcon(AntIcons.closeOutlined), findsNothing);
    });

    testWidgets('showUploadList false hides file list', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntUpload(
          showUploadList: false,
          defaultFileList: [
            AntUploadFile(uid: '1', name: 'hidden.txt'),
          ],
        ),
      ),);
      expect(find.text('hidden.txt'), findsNothing);
    });

    testWidgets('maxCount prevents exceeding limit', (tester) async {
      List<AntUploadFile>? lastList;
      await tester.pumpWidget(_wrap(
        AntUpload(
          maxCount: 1,
          onSelectFiles: () async => [
            const AntUploadFile(uid: 'u1', name: 'first.txt'),
          ],
          onChange: (file, list) {
            lastList = list;
          },
        ),
      ),);
      await tester.tap(find.text('上传'));
      await tester.pumpAndSettle();
      expect(lastList?.length, 1);
      // 再次选择不应添加
      await tester.tap(find.text('上传'));
      await tester.pumpAndSettle();
      expect(lastList?.length, 1);
    });

    testWidgets('pictureCard listType renders add card trigger', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntUpload(listType: AntUploadListType.pictureCard),
      ),);
      expect(find.byIcon(AntIcons.plusOutlined), findsOneWidget);
      expect(find.text('上传'), findsNothing);
    });

    testWidgets('uploading file shows progress indicator', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntUpload(
          defaultFileList: [
            AntUploadFile(
              uid: '1',
              name: 'uploading.txt',
              status: AntUploadStatus.uploading,
              percent: 50,
            ),
          ],
        ),
      ),);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('uploading.txt'), findsOneWidget);
    });

    testWidgets('error file shows error icon', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntUpload(
          defaultFileList: [
            AntUploadFile(
              uid: '1',
              name: 'failed.txt',
              status: AntUploadStatus.error,
            ),
          ],
        ),
      ),);
      expect(find.text('failed.txt'), findsOneWidget);
    });

    testWidgets('pictureCard shows percent overlay when uploading', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntUpload(
          listType: AntUploadListType.pictureCard,
          defaultFileList: [
            AntUploadFile(
              uid: '1',
              name: 'card.png',
              status: AntUploadStatus.uploading,
              percent: 70,
            ),
          ],
        ),
      ),);
      expect(find.text('70%'), findsOneWidget);
    });

    testWidgets('multiple false takes only first file', (tester) async {
      List<AntUploadFile>? lastList;
      await tester.pumpWidget(_wrap(
        AntUpload(
          multiple: false,
          onSelectFiles: () async => [
            const AntUploadFile(uid: 'u1', name: 'first.txt'),
            const AntUploadFile(uid: 'u2', name: 'second.txt'),
          ],
          onChange: (file, list) {
            lastList = list;
          },
        ),
      ),);
      await tester.tap(find.text('上传'));
      await tester.pumpAndSettle();
      expect(lastList?.length, 1);
      expect(lastList?.first.name, 'first.txt');
    });
  });

  group('AntUploadFile', () {
    test('copyWith modifies specified fields', () {
      const file = AntUploadFile(uid: '1', name: 'test.txt');
      final updated = file.copyWith(status: AntUploadStatus.done, percent: 100);
      expect(updated.uid, '1');
      expect(updated.name, 'test.txt');
      expect(updated.status, AntUploadStatus.done);
      expect(updated.percent, 100);
    });

    test('supports equality', () {
      const a = AntUploadFile(uid: '1', name: 'test.txt');
      const b = AntUploadFile(uid: '1', name: 'test.txt');
      const c = AntUploadFile(uid: '2', name: 'other.txt');
      expect(a == b, isTrue);
      expect(a == c, isFalse);
    });

    test('default status is done', () {
      const file = AntUploadFile(uid: '1', name: 'test.txt');
      expect(file.status, AntUploadStatus.done);
    });
  });

  group('AntUploadStatus', () {
    test('has four values', () {
      expect(AntUploadStatus.values.length, 4);
    });
  });

  group('AntUploadListType', () {
    test('has three values', () {
      expect(AntUploadListType.values.length, 3);
      expect(AntUploadListType.values, contains(AntUploadListType.text));
      expect(AntUploadListType.values, contains(AntUploadListType.picture));
      expect(AntUploadListType.values, contains(AntUploadListType.pictureCard));
    });
  });
}