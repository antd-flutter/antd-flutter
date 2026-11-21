import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    ),
  );
}

void main() {
  group('AntImageUploader — rendering', () {
    testWidgets('renders upload button when empty', (tester) async {
      await tester.pumpWidget(_wrap(const AntImageUploader()));
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('renders image items from defaultValue', (tester) async {
      await tester.pumpWidget(_wrap(const AntImageUploader(
        defaultValue: [
          AntImageUploadItem(url: 'https://a.com/1.png'),
          AntImageUploadItem(url: 'https://a.com/2.png'),
        ],
      ),),);
      await tester.pump();
      // 两项各有删除按钮
      expect(find.byIcon(Icons.close), findsNWidgets(2));
      // 加上上传按钮
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('hide upload button when showUpload false', (tester) async {
      await tester.pumpWidget(_wrap(const AntImageUploader(
        showUpload: false,
      ),),);
      expect(find.byIcon(Icons.add), findsNothing);
    });

    testWidgets('hide upload button when maxCount reached',
        (tester) async {
      await tester.pumpWidget(_wrap(const AntImageUploader(
        maxCount: 1,
        defaultValue: [AntImageUploadItem(url: 'https://a.com/1.png')],
      ),),);
      await tester.pump();
      expect(find.byIcon(Icons.add), findsNothing);
    });

    testWidgets('no delete button when deletable false', (tester) async {
      await tester.pumpWidget(_wrap(const AntImageUploader(
        deletable: false,
        defaultValue: [AntImageUploadItem(url: 'https://a.com/1.png')],
      ),),);
      await tester.pump();
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('shows uploading indicator for uploading status',
        (tester) async {
      await tester.pumpWidget(_wrap(const AntImageUploader(
        defaultValue: [
          AntImageUploadItem(
            url: 'https://a.com/1.png',
            status: AntImageUploadStatus.uploading,
          ),
        ],
      ),),);
      expect(find.byType(AntLoading), findsOneWidget);
    });

    testWidgets('shows failed indicator for failed status', (tester) async {
      await tester.pumpWidget(_wrap(const AntImageUploader(
        defaultValue: [
          AntImageUploadItem(
            url: 'https://a.com/1.png',
            status: AntImageUploadStatus.failed,
          ),
        ],
      ),),);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });

  group('AntImageUploader — interaction', () {
    testWidgets('tap upload adds items via onChange', (tester) async {
      var changed = <AntImageUploadItem>[];
      await tester.pumpWidget(_wrap(AntImageUploader(
        onPickImage: () async =>
            [const AntImageUploadItem(url: 'https://a.com/new.png')],
        onChange: (items) => changed = items,
      ),),);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(changed.length, 1);
      expect(changed.first.url, 'https://a.com/new.png');
      // 新增项显示删除按钮
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('tap delete removes item via onChange', (tester) async {
      var changed = <AntImageUploadItem>[];
      await tester.pumpWidget(_wrap(AntImageUploader(
        defaultValue: const [
          AntImageUploadItem(url: 'https://a.com/1.png'),
          AntImageUploadItem(url: 'https://a.com/2.png'),
        ],
        onChange: (items) => changed = items,
      ),),);
      await tester.pump();
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pump();
      expect(changed.length, 1);
    });

    testWidgets('onDelete returning false prevents deletion',
        (tester) async {
      var changed = <AntImageUploadItem>[];
      await tester.pumpWidget(_wrap(AntImageUploader(
        defaultValue: const [
          AntImageUploadItem(url: 'https://a.com/1.png'),
        ],
        onDelete: (_) => false,
        onChange: (items) => changed = items,
      ),),);
      await tester.pump();
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pump();
      expect(changed, isEmpty);
    });

    testWidgets('maxCount truncates picked items and fires onCountExceed',
        (tester) async {
      var exceed = 0;
      var changed = <AntImageUploadItem>[];
      await tester.pumpWidget(_wrap(AntImageUploader(
        maxCount: 2,
        defaultValue: const [AntImageUploadItem(url: 'https://a.com/1.png')],
        onPickImage: () async => const [
          AntImageUploadItem(url: 'https://a.com/2.png'),
          AntImageUploadItem(url: 'https://a.com/3.png'),
          AntImageUploadItem(url: 'https://a.com/4.png'),
        ],
        onCountExceed: (n) => exceed = n,
        onChange: (items) => changed = items,
      ),),);
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(changed.length, 2);
      expect(exceed, 2);
    });

    testWidgets('null onPickImage does nothing on tap', (tester) async {
      await tester.pumpWidget(_wrap(const AntImageUploader()));
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      // 仍只有上传按钮，无图片项
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('tap image opens preview page', (tester) async {
      await tester.pumpWidget(_wrap(const AntImageUploader(
        defaultValue: [AntImageUploadItem(url: 'https://a.com/1.png')],
      ),),);
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

  group('AntImageUploader — controlled', () {
    testWidgets('value prop renders items', (tester) async {
      await tester.pumpWidget(_wrap(const AntImageUploader(
        value: [
          AntImageUploadItem(url: 'https://a.com/1.png'),
          AntImageUploadItem(url: 'https://a.com/2.png'),
          AntImageUploadItem(url: 'https://a.com/3.png'),
        ],
      ),),);
      await tester.pump();
      expect(find.byIcon(Icons.close), findsNWidgets(3));
    });

    testWidgets('controlled upload fires onChange only', (tester) async {
      var changed = <AntImageUploadItem>[];
      await tester.pumpWidget(_wrap(AntImageUploader(
        value: const [AntImageUploadItem(url: 'https://a.com/1.png')],
        onPickImage: () async =>
            [const AntImageUploadItem(url: 'https://a.com/2.png')],
        onChange: (items) => changed = items,
      ),),);
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(changed.length, 2);
      // 受控模式内部值不变，仍只有 1 个删除按钮
      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });
}