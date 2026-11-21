import 'package:antd_image_viewer_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('gallery app renders', (tester) async {
    await tester.pumpWidget(const AntdImageViewerGalleryApp());
    await tester.pump();
    expect(find.text('ImageViewer 图片查看器'), findsOneWidget);
  });
}
