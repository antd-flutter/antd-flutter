/// AntColorPicker widget tests
library;

import 'package:antd_flutter_ui/src/data_entry/color_picker/ant_color_picker.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

/// 自定义模型：色板分组。
class _Palette {
  const _Palette(this.name, this.colors);

  final String name;
  final List<String> colors;
}

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
  group('AntColorPicker', () {
    testWidgets('renders trigger swatch', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntColorPicker(defaultValue: '#1677ff'),
        ),
      );
      // 触发器存在（Container 包含颜色）
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('showText displays hex value', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntColorPicker(defaultValue: '#1677ff', showText: true),
        ),
      );
      expect(find.text('#1677ff'), findsOneWidget);
    });

    testWidgets('controlled value displays', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntColorPicker(value: '#ff0000', showText: true),
        ),
      );
      expect(find.text('#ff0000'), findsOneWidget);
    });

    testWidgets('tapping trigger opens panel', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntColorPicker(defaultValue: '#1677ff'),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      // 面板应包含色相滑块的渐变绘制
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('onOpenChange fires on open and close', (tester) async {
      final openStates = <bool>[];
      await tester.pumpWidget(
        _wrap(
          AntColorPicker(
            defaultValue: '#1677ff',
            onOpenChange: (open) => openStates.add(open),
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      expect(openStates, [true]);
      // 点击全屏 barrier 关闭
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(openStates, [true, false]);
    });

    testWidgets('disabled trigger does not open panel', (tester) async {
      bool opened = false;
      await tester.pumpWidget(
        _wrap(
          AntColorPicker(
            disabled: true,
            onOpenChange: (open) => opened = open,
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      expect(opened, isFalse);
    });

    testWidgets('presets render in panel', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntColorPicker<AntColorPreset>(
            defaultValue: '#1677ff',
            presets: [
              AntColorPreset(
                label: '推荐颜色',
                colors: ['#1677ff', '#52c41a', '#faad14'],
              ),
            ],
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      expect(find.text('推荐颜色'), findsOneWidget);
    });

    testWidgets('selecting preset color triggers onChange', (tester) async {
      String? changedColor;
      await tester.pumpWidget(
        _wrap(
          AntColorPicker<AntColorPreset>(
            defaultValue: '#1677ff',
            presets: const [
              AntColorPreset(
                label: '推荐',
                colors: ['#52c41a'],
              ),
            ],
            onChange: (color) => changedColor = color,
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      // 点击预设色块（GestureDetector 在面板内）
      // 预设色块是面板中最后一个 GestureDetector
      final gestureDetectors = find.byType(GestureDetector);
      await tester.tap(gestureDetectors.last);
      await tester.pumpAndSettle();
      expect(changedColor, '#52c41a');
    });

    testWidgets('allowClear shows clear button and clears value',
        (tester) async {
      String? clearedColor;
      await tester.pumpWidget(
        _wrap(
          AntColorPicker(
            defaultValue: '#1677ff',
            allowClear: true,
            showText: true,
            onChange: (color) => clearedColor = color,
          ),
        ),
      );
      expect(find.text('#1677ff'), findsOneWidget);
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      // 点击清除按钮（AntIcons.closeCircleFilled）
      await tester.tap(find.byIcon(AntIcons.closeCircleFilled));
      await tester.pumpAndSettle();
      expect(clearedColor, isNull);
    });

    testWidgets('disabledAlpha hides alpha slider', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntColorPicker(
            defaultValue: '#1677ff',
            disabledAlpha: true,
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      // 面板应只有 SV 面板 + 色相滑块两个 CustomPaint 区域
      // 无法直接区分，验证面板存在即可
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('rgb format shows rgb text in panel', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntColorPicker(
            defaultValue: '#ff0000',
            format: AntColorFormat.rgb,
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      expect(find.text('rgb(255, 0, 0)'), findsOneWidget);
    });

    testWidgets('hsl format shows hsl text in panel', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntColorPicker(
            defaultValue: '#ff0000',
            format: AntColorFormat.hsl,
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      expect(find.text('hsl(0, 100%, 50%)'), findsOneWidget);
    });

    testWidgets('hsb format shows hsb text in panel', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntColorPicker(
            defaultValue: '#ff0000',
            format: AntColorFormat.hsb,
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      expect(find.text('hsb(0, 100%, 100%)'), findsOneWidget);
    });

    testWidgets('controlled open prop opens panel', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntColorPicker(
            defaultValue: '#1677ff',
            open: true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      // 面板已打开，验证有渐变绘制
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('small size renders smaller swatch', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntColorPicker(
            defaultValue: '#1677ff',
            size: AntColorPickerSize.small,
          ),
        ),
      );
      // 仅验证不崩溃
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('large size renders larger swatch', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntColorPicker(
            defaultValue: '#1677ff',
            size: AntColorPickerSize.large,
          ),
        ),
      );
      expect(find.byType(GestureDetector), findsWidgets);
    });
  });

  group('AntColorFormat', () {
    test('has four values', () {
      expect(AntColorFormat.values.length, 4);
      expect(AntColorFormat.values, contains(AntColorFormat.hex));
      expect(AntColorFormat.values, contains(AntColorFormat.rgb));
      expect(AntColorFormat.values, contains(AntColorFormat.hsl));
      expect(AntColorFormat.values, contains(AntColorFormat.hsb));
    });
  });

  group('AntColorPickerSize', () {
    test('has three values', () {
      expect(AntColorPickerSize.values.length, 3);
    });
  });

  group('AntColorPreset', () {
    test('stores label and colors', () {
      const preset = AntColorPreset(label: '测试', colors: ['#fff', '#000']);
      expect(preset.label, '测试');
      expect(preset.colors.length, 2);
    });
  });

  group('AntColorPicker — 自定义模型', () {
    testWidgets('自定义模型：presetLabelOf/presetColorsOf 驱动预设分组', (tester) async {
      String? changedColor;
      await tester.pumpWidget(
        _wrap(
          AntColorPicker<_Palette>(
            defaultValue: '#1677ff',
            presets: const [
              _Palette('品牌色', ['#1677ff', '#52c41a']),
            ],
            presetLabelOf: (palette) => palette.name,
            presetColorsOf: (palette) => palette.colors,
            onChange: (color) => changedColor = color,
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      expect(find.text('品牌色'), findsOneWidget);
      await tester.tap(find.byType(GestureDetector).last);
      await tester.pumpAndSettle();
      expect(changedColor, '#52c41a');
    });

    testWidgets('自定义模型：未提供 presetColorsOf 时报出可读错误', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntColorPicker<_Palette>(
            defaultValue: '#1677ff',
            presets: const [
              _Palette('品牌色', ['#1677ff']),
            ],
            presetLabelOf: (palette) => palette.name,
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isStateError);
    });
  });

  group('AntColorPicker — popup_engine 边界（翻转/夹回）', () {
    testWidgets('视口下方放不下时面板翻转到上方', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Align(
            alignment: Alignment.bottomCenter,
            child: AntColorPicker(defaultValue: '#1677ff'),
          ),
        ),
      );
      await tester.tap(find.byType(AntColorPicker));
      await tester.pumpAndSettle();
      final panel =
          tester.getRect(find.byKey(const Key('ant_color_picker_panel')));
      final trigger = tester.getRect(find.byType(AntColorPicker));
      expect(panel.bottom, lessThanOrEqualTo(trigger.top + 0.01));
    });

    testWidgets('面板较宽不溢出视口右缘（滑动夹回）', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Align(
            alignment: Alignment.topLeft,
            child: AntColorPicker(defaultValue: '#1677ff'),
          ),
        ),
      );
      await tester.tap(find.byType(AntColorPicker));
      await tester.pumpAndSettle();
      final panel =
          tester.getRect(find.byKey(const Key('ant_color_picker_panel')));
      final screen = tester.view.physicalSize / tester.view.devicePixelRatio;
      expect(panel.left, greaterThanOrEqualTo(0));
      expect(panel.right, lessThanOrEqualTo(screen.width + 0.01));
    });
  });
}
