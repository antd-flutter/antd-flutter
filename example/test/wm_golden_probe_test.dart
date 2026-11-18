// 临时探针：WatermarkPage 整页渲染出图 + 像素级越界断言（页面级多水印回归）
//
// 断言逻辑：水印灰为中性灰（R≈G≈B 且 180<v<250，colorText 0.15 透明度
// 叠加白底的典型值 ≈216）；「区块容器 x 范围之外」与「区块间隙行」
// 属于水印不应出现的区域，这两处水印灰像素必须为 0。
//
// 注意 1：material_ui 是 Material fork 包，其 ListTile 需要 material_ui 的
// Material 祖先，必须用 material_ui 的 MaterialApp/Scaffold（与真实 app 一致）。
// 注意 2：AntScreenUtilInit 持续调度帧导致 pumpAndSettle 不收敛，
// 必须用有限 pump；toImage 用 runAsync+timeout 保证全路径有界。
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:antd_flutter_example/pages/watermark_page.dart';
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// 容器左右边界（页面 padding 16 + 容器圆角容差）。
const int _kContainerLeft = 17;
const int _kContainerRight = 1006;

bool _isWatermarkGray(int r, int g, int b) =>
    (r - g).abs() < 4 && (g - b).abs() < 4 && 180 < r && r < 250;

Future<void> _pumpPage(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1024, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(AntScreenUtilInit(
    builder: (_, __) => MaterialApp(home: Scaffold(body: WatermarkPage())),
  ));
  await tester.pump();
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

Future<ByteData> _capturePage(WidgetTester tester) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find
        .ancestor(
          of: find.byType(WatermarkPage),
          matching: find.byType(RepaintBoundary),
        )
        .first,
  );
  // runAsync + timeout：Impeller 下 toImage 偶发挂起，保底不无限等待。
  final image = await tester
      .runAsync(() => boundary.toImage(pixelRatio: 1.0))
      .timeout(const Duration(seconds: 20));
  if (image == null) {
    fail('boundary.toImage 返回 null（测试环境截图不可用）');
  }
  final data = await tester
      .runAsync(() => image.toByteData(format: ui.ImageByteFormat.rawRgba))
      .timeout(const Duration(seconds: 20));
  if (data == null) {
    fail('image.toByteData 返回 null');
  }
  return data;
}

void main() {
  testWidgets('多水印页面级不越界（像素断言）', (tester) async {
    await _pumpPage(tester);
    // ignore: avoid_print
    print('wm_probe: [1/3] 页面渲染完成');
    final data = await _capturePage(tester);
    // ignore: avoid_print
    print('wm_probe: [2/3] 截图完成，开始像素分析');

    final w = 1024, h = 1400;
    int marginGray = 0;
    // 先找区块间隙行：容器 x 范围内整行均为页面背景 tint (254,247,255)。
    const pageBgR = 254, pageBgG = 247, pageBgB = 255;
    final isGapRow = List<bool>.filled(h, true);
    for (var y = 0; y < h; y++) {
      for (var x = _kContainerLeft; x <= _kContainerRight; x++) {
        final p = data.getUint32((y * w + x) * 4);
        final r = (p >> 16) & 0xFF, g = (p >> 8) & 0xFF, b = p & 0xFF;
        if (r != pageBgR || g != pageBgG || b != pageBgB) {
          isGapRow[y] = false;
          break;
        }
      }
    }

    for (var y = 0; y < h; y++) {
      // 页边距列：容器 x 范围之外不允许水印灰
      for (final range in [
        [0, _kContainerLeft],
        [_kContainerRight + 1, w],
      ]) {
        for (var x = range[0]; x < range[1]; x++) {
          final p = data.getUint32((y * w + x) * 4);
          if (_isWatermarkGray((p >> 16) & 0xFF, (p >> 8) & 0xFF, p & 0xFF)) {
            marginGray++;
          }
        }
      }
      // 区块间隙行
      if (isGapRow[y]) {
        for (var x = _kContainerLeft; x <= _kContainerRight; x++) {
          final p = data.getUint32((y * w + x) * 4);
          if (_isWatermarkGray((p >> 16) & 0xFF, (p >> 8) & 0xFF, p & 0xFF)) {
            marginGray++;
          }
        }
      }
    }
    // ignore: avoid_print
    print('wm_probe: [3/3] 页边距/间隙区水印灰像素 = $marginGray（期望 0）');
    expect(marginGray, 0, reason: '水印越界绘制到区块容器外（页边距/间隙）');
  });

  testWidgets('WatermarkPage 整页 golden 出图', (tester) async {
    await _pumpPage(tester);
    await expectLater(
      find.byType(WatermarkPage),
      matchesGoldenFile('goldens/wm_page_probe.png'),
    );
  });
}
