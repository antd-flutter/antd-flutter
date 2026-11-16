import 'package:antd_flutter_plus/src/components/data_display/image_viewer/ant_image_viewer.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

/// 固定失败的资源路径：不依赖真实网络。
const String kMissingAsset = 'assets/images/not_exist.png';

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Stack(
            children: [
              const Text('页面内容'),
              child,
            ],
          ),
        ),
      ),
    ),
  );
}

/// 受控宿主：外部切换 open。
class _Host extends StatefulWidget {
  const _Host({
    required this.images,
    this.initialOpen = false,
  });

  final List<String> images;
  final bool initialOpen;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late bool open = widget.initialOpen;

  @override
  Widget build(BuildContext context) {
    return _wrap(
      Column(
        children: [
          TextButton(
            key: const Key('toggle'),
            onPressed: () => setState(() => open = !open),
            child: Text(open ? '关闭' : '打开'),
          ),
          AntImageViewer(
            images: widget.images,
            open: open,
            onClose: () => setState(() => open = false),
          ),
        ],
      ),
    );
  }
}

void main() {
  group('AntImageViewer', () {
    testWidgets('open=true shows mask and first image', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntImageViewer(
          images: [kMissingAsset, kMissingAsset],
          open: true,
        ),
      ),);
      await tester.pumpAndSettle();
      // 暗色遮罩 + 图片渲染组件存在，页面底层内容仍在其下。
      expect(find.byType(Material), findsWidgets);
      expect(find.byType(InteractiveViewer), findsOneWidget);
      expect(
        find.byWidgetPredicate((w) => w is Image || w is CachedNetworkImage),
        findsAtLeastNWidgets(1),
      );
    });

    testWidgets('open=false shows nothing', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntImageViewer(
          images: [kMissingAsset, kMissingAsset],
          open: false,
        ),
      ),);
      await tester.pumpAndSettle();
      expect(find.byType(InteractiveViewer), findsNothing);
      expect(find.byType(PageView), findsNothing);
    });

    testWidgets('multi images show page indicator', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntImageViewer(
          images: [kMissingAsset, kMissingAsset, kMissingAsset],
          open: true,
        ),
      ),);
      await tester.pumpAndSettle();
      expect(find.text('1 / 3'), findsOneWidget);
    });

    testWidgets('defaultIndex sets initial page', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntImageViewer(
          images: [kMissingAsset, kMissingAsset, kMissingAsset],
          open: true,
          defaultIndex: 1,
        ),
      ),);
      await tester.pumpAndSettle();
      expect(find.text('2 / 3'), findsOneWidget);
    });

    testWidgets('swipe left updates page indicator', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntImageViewer(
          images: [kMissingAsset, kMissingAsset, kMissingAsset],
          open: true,
        ),
      ),);
      await tester.pumpAndSettle();

      await tester.fling(find.byType(PageView), const Offset(-600, 0), 2000);
      await tester.pumpAndSettle();
      expect(find.text('2 / 3'), findsOneWidget);

      await tester.fling(find.byType(PageView), const Offset(600, 0), 2000);
      await tester.pumpAndSettle();
      expect(find.text('1 / 3'), findsOneWidget);
    });

    testWidgets('close button triggers onClose', (tester) async {
      var closed = false;
      await tester.pumpWidget(_wrap(
        AntImageViewer(
          images: const [kMissingAsset],
          open: true,
          onClose: () => closed = true,
        ),
      ),);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(closed, isTrue);
    });

    testWidgets('InteractiveViewer respects maxZoomRatio', (tester) async {
      await tester.pumpWidget(_wrap(
        const AntImageViewer(
          images: [kMissingAsset],
          open: true,
          maxZoomRatio: 4.5,
        ),
      ),);
      await tester.pumpAndSettle();

      final viewer =
          tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));
      expect(viewer.maxScale, 4.5);
      expect(viewer.minScale, 1.0);
    });

    testWidgets('double tap zooms in with composite zoom enabled',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const AntImageViewer(
          images: [kMissingAsset],
          open: true,
          maxZoomRatio: 3.0,
        ),
      ),);
      await tester.pumpAndSettle();

      final center = tester.getCenter(find.byType(InteractiveViewer));
      await tester.tap(find.byType(InteractiveViewer));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tapAt(center);
      await tester.pumpAndSettle();

      final viewer =
          tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));
      final transform = viewer.transformationController!.value;
      expect(transform.getMaxScaleOnAxis(), closeTo(3.0, 0.01));
    });

    testWidgets('double tap does not zoom when composite zoom disabled',
        (tester) async {
      await tester.pumpWidget(_wrap(
        const AntImageViewer(
          images: [kMissingAsset],
          open: true,
          enableCompositeZoom: false,
        ),
      ),);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(InteractiveViewer));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byType(InteractiveViewer));
      await tester.pumpAndSettle();

      final viewer =
          tester.widget<InteractiveViewer>(find.byType(InteractiveViewer));
      expect(viewer.transformationController!.value.getMaxScaleOnAxis(),
          closeTo(1.0, 0.01),);
    });

    testWidgets('afterClose fires after close animation', (tester) async {
      var closed = false;
      var afterClosed = false;
      await tester.pumpWidget(AntScreenUtilInit(
        builder: (context, _) => MaterialApp(
          home: Scaffold(
            body: AntTheme(
              data: AntThemeData.light(),
              child: _AfterCloseHost(
                onClose: () => closed = true,
                afterClose: () => afterClosed = true,
              ),
            ),
          ),
        ),
      ),);
      await tester.pumpAndSettle();

      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();
      expect(find.byType(PageView), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      // 关闭动画中：onClose 已触发，afterClose 尚未触发。
      await tester.pump(const Duration(milliseconds: 100));
      expect(closed, isTrue);
      expect(afterClosed, isFalse);

      await tester.pumpAndSettle();
      expect(afterClosed, isTrue);
      expect(find.byType(PageView), findsNothing);
    });

    testWidgets('overlay removed from screen when open toggles false',
        (tester) async {
      await tester.pumpWidget(const _Host(
        images: [kMissingAsset, kMissingAsset],
        initialOpen: true,
      ),);
      await tester.pumpAndSettle();
      expect(find.text('1 / 2'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      // 受控关闭后浮层移除，页码指示消失。
      expect(find.text('1 / 2'), findsNothing);
      expect(find.byType(PageView), findsNothing);
    });
  });
}

/// afterClose 测试宿主：外部控制 open 开关。
class _AfterCloseHost extends StatefulWidget {
  const _AfterCloseHost({this.onClose, this.afterClose});

  final VoidCallback? onClose;
  final VoidCallback? afterClose;

  @override
  State<_AfterCloseHost> createState() => _AfterCloseHostState();
}

class _AfterCloseHostState extends State<_AfterCloseHost> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () => setState(() => open = true),
          child: const Text('打开'),
        ),
        AntImageViewer(
          images: const [kMissingAsset],
          open: open,
          onClose: () {
            widget.onClose?.call();
            setState(() => open = false);
          },
          afterClose: widget.afterClose,
        ),
      ],
    );
  }
}
