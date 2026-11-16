import 'package:antd_flutter_plus/src/components/data_display/image/ant_image.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _okUrl = 'https://example.com/a.png';
const _previewUrl = 'https://preview.example.com/preview.png';

/// 错误路径使用不存在的资源图触发：测试环境 HTTP 固定 400 且
/// flutter_cache_manager 依赖 path_provider，异步错误无法推进；
/// 资源图加载失败走同一 errorBuilder 逻辑，可同步验证。
const _badAssetSrc = 'assets/images/nonexistent.png';

Future<void> _pumpErrorPath(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(_wrap(child));
  await tester.pump();
  await tester.pump();
}

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
  group('AntImage 基础渲染', () {
    testWidgets('network src renders CachedNetworkImage', (tester) async {
      await tester.pumpWidget(_wrap(const AntImage(src: _okUrl)));
      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });

    testWidgets('asset src renders Image.asset', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntImage(src: 'assets/images/demo.png')),
      );
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isA<AssetImage>());
    });

    testWidgets('radius applies ClipRRect border radius', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntImage(src: _okUrl, radius: 16)),
      );
      final clip = tester.widget<ClipRRect>(find.byType(ClipRRect));
      final borderRadius = clip.borderRadius.resolve(TextDirection.ltr);
      expect(borderRadius.topLeft.x, 16);
    });

    testWidgets('fit is passed through to image', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntImage(src: _okUrl, fit: BoxFit.contain)),
      );
      final image =
          tester.widget<Image>(find.byType(Image, skipOffstage: true).first);
      expect(image.fit, BoxFit.contain);
      await tester.pumpWidget(_wrap(const AntImage(src: _okUrl)));
      final cached =
          tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
      expect(cached.fit, BoxFit.cover);
    });

    testWidgets('width/height are applied', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntImage(src: _okUrl, width: 200, height: 120)),
      );
      final size = tester.getSize(find.byType(AntImage));
      expect(size.width, 200);
      expect(size.height, 120);
    });
  });

  group('AntImage 预览', () {
    testWidgets('preview false: tap does nothing', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntImage(src: _okUrl, preview: false)),
      );
      await tester.pump();
      await tester.tap(find.byType(AntImage));
      await tester.pump();
      expect(find.byType(InteractiveViewer), findsNothing);
    });

    testWidgets('preview true: tap opens fullscreen overlay', (tester) async {
      await tester.pumpWidget(_wrap(const AntImage(src: _okUrl)));
      await tester.pump();
      await tester.tap(find.byType(AntImage));
      await tester.pump();
      expect(find.byType(InteractiveViewer), findsOneWidget);
      // 关闭按钮存在。
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('close button dismisses overlay', (tester) async {
      await tester.pumpWidget(_wrap(const AntImage(src: _okUrl)));
      await tester.pump();
      await tester.tap(find.byType(AntImage));
      await tester.pump();
      expect(find.byType(InteractiveViewer), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();
      expect(find.byType(InteractiveViewer), findsNothing);
    });

    testWidgets('previewSrc is used for fullscreen preview', (tester) async {
      await tester.pumpWidget(
        _wrap(const AntImage(src: _okUrl, previewSrc: _previewUrl)),
      );
      await tester.pump();
      await tester.tap(find.byType(AntImage));
      await tester.pump();
      // 预览浮层中的大图地址使用 previewSrc。
      final overlays = tester.widgetList<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );
      expect(
        overlays.map((w) => w.imageUrl),
        contains(_previewUrl),
      );
    });

    testWidgets('PreviewGroup: tap shows arrows and page indicator',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntImagePreviewGroup(
            children: [
              AntImage(src: _okUrl),
              AntImage(src: _previewUrl),
            ],
          ),
        ),
      );
      await tester.pump();
      // 点击第二张图。
      await tester.tap(find.byType(AntImage).at(1));
      await tester.pump();
      expect(find.byType(InteractiveViewer), findsOneWidget);
      expect(find.text('2 / 2'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('PreviewGroup: arrows switch between images', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntImagePreviewGroup(
            children: [
              AntImage(src: _okUrl),
              AntImage(src: _previewUrl),
            ],
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byType(AntImage).at(0));
      await tester.pump();
      expect(find.text('1 / 2'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pump();
      expect(find.text('2 / 2'), findsOneWidget);
    });
  });

  group('AntImage 加载失败', () {
    testWidgets('error shows default fallback placeholder', (tester) async {
      await _pumpErrorPath(tester, const AntImage(src: _badAssetSrc));
      expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
      expect(find.text(AntImageDefaults.errorText), findsOneWidget);
    });

    testWidgets('errorWidget customizes error placeholder', (tester) async {
      await _pumpErrorPath(
        tester,
        const AntImage(
          src: _badAssetSrc,
          errorWidget: Text('自定义失败'),
        ),
      );
      expect(find.text('自定义失败'), findsOneWidget);
      expect(find.byIcon(Icons.broken_image_outlined), findsNothing);
    });

    testWidgets('fallback shows fallback image widget', (tester) async {
      await _pumpErrorPath(
        tester,
        const AntImage(
          src: _badAssetSrc,
          fallback: _okUrl,
        ),
      );
      // 主图加载失败后渲染 fallback 网络（CachedNetworkImage）。
      final cached = tester
          .widgetList<CachedNetworkImage>(find.byType(CachedNetworkImage))
          .map((w) => w.imageUrl);
      expect(cached, contains(_okUrl));
      expect(find.text(AntImageDefaults.errorText), findsNothing);
    });

    testWidgets('onError callback fires on load failure', (tester) async {
      var errorCount = 0;
      await _pumpErrorPath(
        tester,
        AntImage(src: _badAssetSrc, onError: () => errorCount++),
      );
      expect(errorCount, 1);
    });
  });

  group('AntImage 加载占位', () {
    testWidgets('placeholder shows while loading', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntImage(
            src: _okUrl,
            placeholder: Text('加载中占位'),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('加载中占位'), findsOneWidget);
    });

    testWidgets('default placeholder shows progress indicator', (tester) async {
      await tester.pumpWidget(_wrap(const AntImage(src: _okUrl)));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
