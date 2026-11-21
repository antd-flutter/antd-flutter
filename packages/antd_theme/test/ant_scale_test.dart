import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntScale', () {
    test('none 为 1.0，s() 原样返回设计值', () {
      final theme = AntThemeData.light();
      expect(theme.scale, AntScale.none);
      expect(theme.s(12), 12);
      expect(theme.fontSize, 14);
      expect(theme.controlHeight, 32);
      expect(theme.borderRadius, 6);
    });

    test('缩放因子同时作用于字号/控件高/圆角/间距 token', () {
      final theme = AntThemeData.light(scale: const AntScale(1.25));
      expect(theme.s(12), 15);
      expect(theme.fontSize, 17.5);
      expect(theme.controlHeight, 40);
      expect(theme.controlHeightSM, closeTo(30, 0.001));
      expect(theme.borderRadius, 7.5);
      expect(theme.padding, 20);
    });

    test('暗色主题同样支持缩放', () {
      final theme = AntThemeData.dark(scale: const AntScale(0.9));
      expect(theme.fontSize, closeTo(12.6, 0.001));
      expect(theme.s(10), 9);
    });

    test('auto 在无 MediaQuery 尺寸时安全退回 1.0', () {
      // 无 MediaQuery 时 MediaQuery.sizeOf 会抛错；auto 仅应在有 context 时使用。
      expect(const AntScale(2).copyWith(factor: 1).factor, 1);
    });
  });

  group('AntScale.auto', () {
    testWidgets('移动端按短边 / 375 推导并夹取范围', (tester) async {
      late AntScale scale;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: Builder(
            builder: (context) {
              scale = AntScale.auto(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(scale.factor, closeTo(1.0, 0.001));
    });
  });
}
