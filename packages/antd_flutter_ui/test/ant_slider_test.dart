import 'package:antd_flutter_ui/src/data_entry/slider/ant_slider.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

/// 自定义模型：温度刻度。
class _Stop {
  const _Stop(this.value, this.label);

  final double value;
  final String label;
}

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

void main() {
  group('AntSlider', () {
    testWidgets('renders by default', (tester) async {
      await tester.pumpWidget(_wrap(const AntSlider<double>()));
      expect(find.byType(AntSlider<double>), findsOneWidget);
    });

    testWidgets('tooltipVisible shows value', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSlider<double>(
            defaultValue: 30,
            tooltipVisible: true,
          ),
        ),
      );
      expect(find.text('30'), findsOneWidget);
    });

    testWidgets('tap updates value', (tester) async {
      double? changed;
      await tester.pumpWidget(
        _wrap(
          AntSlider<double>(
            defaultValue: 0,
            onChange: (v) => changed = v,
          ),
        ),
      );
      // 点击轨道右侧
      await tester.tapAt(
        tester.getCenter(find.byType(AntSlider<double>)) + const Offset(100, 0),
      );
      await tester.pump();
      expect(changed, isNotNull);
      expect(changed! > 0, true);
    });

    testWidgets('disabled prevents interaction', (tester) async {
      double? changed;
      await tester.pumpWidget(
        _wrap(
          AntSlider<double>(
            defaultValue: 0,
            disabled: true,
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tapAt(
        tester.getCenter(find.byType(AntSlider<double>)) + const Offset(100, 0),
      );
      await tester.pump();
      expect(changed, null);
    });

    testWidgets('controlled value updates display', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSlider<double>(
            value: 50,
            tooltipVisible: true,
          ),
        ),
      );
      expect(find.text('50'), findsOneWidget);
    });

    testWidgets('marks render labels', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntSlider<double>(
            defaultValue: 30,
            marks: const [0.0, 50.0, 100.0],
            markLabelOf: (value) => value.toInt().toString(),
          ),
        ),
      );
      expect(find.text('50'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
    });

    testWidgets('onChangeEnd fires after tap', (tester) async {
      double? endValue;
      await tester.pumpWidget(
        _wrap(
          AntSlider<double>(
            defaultValue: 0,
            onChangeEnd: (v) => endValue = v,
          ),
        ),
      );
      await tester.tapAt(
        tester.getCenter(find.byType(AntSlider<double>)) + const Offset(100, 0),
      );
      await tester.pump();
      expect(endValue, isNotNull);
    });

    testWidgets('step snaps value', (tester) async {
      double? changed;
      await tester.pumpWidget(
        _wrap(
          AntSlider<double>(
            defaultValue: 0,
            min: 0,
            max: 100,
            step: 10,
            onChange: (v) => changed = v,
          ),
        ),
      );
      await tester.tapAt(
        tester.getCenter(find.byType(AntSlider<double>)) + const Offset(100, 0),
      );
      await tester.pump();
      expect(changed! % 10, 0);
    });
  });
  group('AntSlider — 自定义模型', () {
    testWidgets('自定义模型：markValueOf/markLabelOf 驱动刻度', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntSlider<_Stop>(
            defaultValue: 30,
            marks: const [
              _Stop(0, '0°C'),
              _Stop(50, '50°C'),
              _Stop(100, '100°C'),
            ],
            markValueOf: (stop) => stop.value,
            markLabelOf: (stop) => stop.label,
          ),
        ),
      );
      expect(find.text('0°C'), findsOneWidget);
      expect(find.text('50°C'), findsOneWidget);
      expect(find.text('100°C'), findsOneWidget);
    });

    testWidgets('自定义模型：缺省 markLabelOf 用 item 文本', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntSlider<_Stop>(
            defaultValue: 0,
            marks: const [_Stop(20, '低'), _Stop(80, '高')],
            markValueOf: (stop) => stop.value,
          ),
        ),
      );
      expect(find.textContaining('_Stop'), findsNWidgets(2));
    });
  });

  group('AntSlider — 提示气泡悬浮（回归）', () {
    testWidgets('tooltip overlay does not affect layout height',
        (tester) async {
      double? heightWith;
      await tester.pumpWidget(
        _wrap(
          AntSlider<double>(
            tooltipVisible: true,
            defaultValue: 50,
            onChange: (_) {},
          ),
        ),
      );
      heightWith = tester.getSize(find.byType(AntSlider<double>)).height;
      await tester.pumpWidget(
        _wrap(
          AntSlider<double>(
            tooltipVisible: false,
            defaultValue: 50,
            onChange: (_) {},
          ),
        ),
      );
      final heightWithout =
          tester.getSize(find.byType(AntSlider<double>)).height;
      expect(heightWith, heightWithout);
    });

    testWidgets('bubble stays within track bounds', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AntSlider<double>(
            tooltipVisible: true,
            defaultValue: 100,
            min: 0,
            max: 100,
          ),
        ),
      );
      // 值为 max 时气泡应夹持在轨道内（不越出右边界）
      final bubbleCenter = tester.getCenter(find.text('100'));
      final sliderRight = tester.getTopRight(find.byType(AntSlider<double>)).dx;
      expect(bubbleCenter.dx, lessThan(sliderRight));
    });
  });
}
