library;

/// AntDevicePreview wrapper 平台判断与预置设备单测
import 'package:antd_flutter_example/ant_device_preview.dart';
import 'package:antd_flutter_example/pages/home_page.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  group('AntDevicePreview.shouldEnable 平台判断', () {
    test('桌面平台启用（macOS/windows/linux）', () {
      for (final platform in const [
        TargetPlatform.macOS,
        TargetPlatform.windows,
        TargetPlatform.linux,
      ]) {
        debugDefaultTargetPlatformOverride = platform;
        expect(AntDevicePreview.shouldEnable, isTrue,
            reason: '$platform 应启用 device_preview');
      }
    });

    test('移动端不启用（android/ios）', () {
      for (final platform in const [
        TargetPlatform.android,
        TargetPlatform.iOS,
      ]) {
        debugDefaultTargetPlatformOverride = platform;
        expect(AntDevicePreview.shouldEnable, isFalse,
            reason: '$platform 不应启用 device_preview');
      }
    });
  });

  group('AntDevicePreview.bootstrap', () {
    test('1.x 架构无绑定安装，返回默认绑定', () {
      final binding = AntDevicePreview.bootstrap();
      expect(identical(binding, WidgetsBinding.instance), isTrue);
    });
  });

  group('AntDevicePreview.wrap 平台行为', () {
    testWidgets('移动端（测试默认 android）原样透传 app，不启用模拟',
        (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      const app = MaterialApp(home: Scaffold(body: Text('ok')));
      await tester.pumpWidget(
        Builder(builder: (context) => AntDevicePreview.wrap(context, app)),
      );
      await tester.pump();
      expect(find.text('ok'), findsOneWidget);
      expect(find.byType(DevicePreview), findsNothing);
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('桌面端（macOS）返回 DevicePreview 包装，enabled 恒为 true',
        (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      const app = MaterialApp(home: Scaffold(body: Text('ok')));
      await tester.pumpWidget(
        Builder(builder: (context) => AntDevicePreview.wrap(context, app)),
      );
      await tester.pump();
      final preview = tester.widget<DevicePreview>(find.byType(DevicePreview));
      expect(preview.enabled, isTrue);
      debugDefaultTargetPlatformOverride = null;
    });
  });

  group('AntDevicePreview.presetDevices 预置设备清单', () {
    final presets = AntDevicePreview.presetDevices;

    test('覆盖手机 / 平板 / 桌面三类（1.x 无折叠模拟，见版本调研）', () {
      final platforms = presets.map((p) => p.identifier.platform).toSet();
      expect(platforms, containsAll(const [
        TargetPlatform.iOS,
        TargetPlatform.android,
        TargetPlatform.macOS,
      ]));
      expect(presets.where((p) => p.name.toLowerCase().contains('ipad')),
          isNotEmpty);
      expect(
        presets.where((p) => p.name.contains('Desktop Window')),
        isNotEmpty,
      );
    });

    test('包含 1440 桌面窗口补齐规格', () {
      expect(
        presets.any((p) => p.name.contains('Desktop Window 1440')),
        isTrue,
      );
    });

    test('id 无重复', () {
      final ids = presets.map((p) => p.identifier.name).toSet();
      expect(ids.length, presets.length);
    });
  });

  group('locale/appBuilder 透传', () {
    test('移动端返回 null（不注入 MaterialApp）', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      expect(AntDevicePreview.appBuilder, isNull);
    });

    test('桌面端返回 appBuilder', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      expect(AntDevicePreview.appBuilder, isNotNull);
    });
  });

  group('响应式断点常量', () {
    test('宽窄屏切换断点为 840（迁移自原 isWide >= 840）', () {
      expect(kHomeWideBreakpoint, 840);
    });
  });
}
