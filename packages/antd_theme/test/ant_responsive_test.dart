// ignore_for_file: lines_longer_than_80_chars
/// AntResponsive 单元测试 — 断点解析、通知去重、细粒度 aspect、平台字段、折叠态。
library;

import 'dart:ui' show DisplayFeature, DisplayFeatureState, DisplayFeatureType;

import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/foundation.dart'
    show ValueListenable, debugDefaultTargetPlatformOverride;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: deprecated_member_use
import 'package:material_ui/material_ui.dart' show MaterialApp;

void main() {
  // ================================================================
  // AntBreakpoint 解析（AntLayoutData.breakpoint）
  // ================================================================
  group('AntLayoutData 断点解析', () {
    AntLayoutData dataOfWidth(double width) => AntLayoutData(
          width: width,
          breakpoint: AntBreakpoint.fromWidth(width),
          deviceType: AntDeviceType.phone,
          orientation: AntOrientation.portrait,
          foldState: AntFoldState.flat,
          targetPlatform: TargetPlatform.android,
          isOhos: false,
          isDesktop: false,
        );

    test('fromWidth 边界解析', () {
      expect(AntBreakpoint.fromWidth(479), isNull);
      expect(AntBreakpoint.fromWidth(480), AntBreakpoint.xs);
      expect(AntBreakpoint.fromWidth(768), AntBreakpoint.md);
      expect(AntBreakpoint.fromWidth(1920), AntBreakpoint.xxxl);
    });

    test('断点 aspect 随宽度正确解析', () {
      expect(dataOfWidth(400).breakpoint, isNull);
      expect(dataOfWidth(800).breakpoint, AntBreakpoint.md);
    });
  });

  // ================================================================
  // == 去重 — 值相等不重复通知
  // ================================================================
  group('通知去重', () {
    test('ValueNotifier 相同值赋值不触发通知', () {
      const a = AntLayoutData(
        width: 375,
        breakpoint: null,
        deviceType: AntDeviceType.phone,
        orientation: AntOrientation.portrait,
        foldState: AntFoldState.unknown,
        targetPlatform: TargetPlatform.android,
        isOhos: false,
        isDesktop: false,
      );
      const b = AntLayoutData(
        width: 375,
        breakpoint: null,
        deviceType: AntDeviceType.phone,
        orientation: AntOrientation.portrait,
        foldState: AntFoldState.unknown,
        targetPlatform: TargetPlatform.android,
        isOhos: false,
        isDesktop: false,
      );
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);

      var notified = 0;
      final notifier = ValueNotifier<AntLayoutData>(a);
      notifier.addListener(() => notified++);
      notifier.value = b; // == 相等，不通知
      expect(notified, 0);
      notifier.value = const AntLayoutData(
        width: 768,
        breakpoint: AntBreakpoint.md,
        deviceType: AntDeviceType.phone,
        orientation: AntOrientation.portrait,
        foldState: AntFoldState.unknown,
        targetPlatform: TargetPlatform.android,
        isOhos: false,
        isDesktop: false,
      );
      expect(notified, 1);
      notifier.dispose();
    });

    test('任一字段变化即不相等', () {
      const base = AntLayoutData(
        width: 375,
        breakpoint: null,
        deviceType: AntDeviceType.phone,
        orientation: AntOrientation.portrait,
        foldState: AntFoldState.unknown,
        targetPlatform: TargetPlatform.android,
        isOhos: false,
        isDesktop: false,
      );

      expect(
        AntLayoutData(
              width: 800,
              breakpoint: AntBreakpoint.md,
              deviceType: base.deviceType,
              orientation: base.orientation,
              foldState: base.foldState,
              targetPlatform: base.targetPlatform,
              isOhos: base.isOhos,
              isDesktop: base.isDesktop,
            ) ==
            base,
        isFalse,
      );
      expect(
        AntLayoutData(
              width: base.width,
              breakpoint: base.breakpoint,
              deviceType: base.deviceType,
              orientation: base.orientation,
              foldState: AntFoldState.halfOpened,
              targetPlatform: base.targetPlatform,
              isOhos: base.isOhos,
              isDesktop: base.isDesktop,
            ) ==
            base,
        isFalse,
      );
      expect(
        AntLayoutData(
              width: base.width,
              breakpoint: base.breakpoint,
              deviceType: base.deviceType,
              orientation: base.orientation,
              foldState: base.foldState,
              targetPlatform: base.targetPlatform,
              isOhos: true,
              isDesktop: base.isDesktop,
            ) ==
            base,
        isFalse,
      );
    });
  });

  // ================================================================
  // 折叠态推导（displayFeatures）
  // ================================================================
  group('foldStateFromDisplayFeatures', () {
    test('无折叠特征 → flat', () {
      expect(
        AntLayoutData.foldStateFromDisplayFeatures(const []),
        AntFoldState.flat,
      );
    });

    test('hinge + halfOpened 姿势 → halfOpened', () {
      final features = [
        const DisplayFeature(
          bounds: Rect.fromLTRB(0, 0, 24, 800),
          type: DisplayFeatureType.hinge,
          state: DisplayFeatureState.postureHalfOpened,
        ),
      ];
      expect(
        AntLayoutData.foldStateFromDisplayFeatures(features),
        AntFoldState.halfOpened,
      );
    });

    test('hinge + flat 姿势 → flat', () {
      final features = [
        const DisplayFeature(
          bounds: Rect.fromLTRB(0, 0, 24, 800),
          type: DisplayFeatureType.hinge,
          state: DisplayFeatureState.postureFlat,
        ),
      ];
      expect(
        AntLayoutData.foldStateFromDisplayFeatures(features),
        AntFoldState.flat,
      );
    });

    test('fold 特征 → folded', () {
      final features = [
        const DisplayFeature(
          bounds: Rect.fromLTRB(0, 0, 8, 800),
          type: DisplayFeatureType.fold,
          state: DisplayFeatureState.unknown,
        ),
      ];
      expect(
        AntLayoutData.foldStateFromDisplayFeatures(features),
        AntFoldState.folded,
      );
    });

    test('cutout 特征不影响折叠态', () {
      final features = [
        const DisplayFeature(
          bounds: Rect.fromLTRB(0, 0, 375, 40),
          type: DisplayFeatureType.cutout,
          state: DisplayFeatureState.unknown,
        ),
      ];
      expect(
        AntLayoutData.foldStateFromDisplayFeatures(features),
        AntFoldState.flat,
      );
    });
  });

  // ================================================================
  // Widget 集成 — AntResponsiveInit / AntResponsive / 细粒度 aspect
  // ================================================================
  group('AntResponsiveInit 细粒度 aspect', () {
    testWidgets('断点跨越时 breakpoint 订阅者 rebuild，platform 订阅者不 rebuild',
        (tester) async {
      tester.view.physicalSize = const Size(500, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      var breakpointBuilds = 0;
      var platformBuilds = 0;
      AntBreakpoint? lastBreakpoint;

      final child = Column(
        children: [
          Builder(
            builder: (context) {
              breakpointBuilds++;
              lastBreakpoint = AntResponsive.breakpointOf(context);
              return SizedBox(
                key: ValueKey('bp-$lastBreakpoint'),
                child: const SizedBox(),
              );
            },
          ),
          Builder(
            builder: (context) {
              platformBuilds++;
              return Text(
                'platform-${AntResponsive.platformOf(context).name}',
              );
            },
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: AntResponsiveInit(
            child: child,
            builder: (context, data, child) => Column(children: [child!]),
          ),
        ),
      );
      await tester.pump();

      expect(lastBreakpoint, AntBreakpoint.xs);
      final buildsAfterFirst = breakpointBuilds;
      final platformBuildsAfterFirst = platformBuilds;

      // 宽度 500 → 560（同在 xs 断点内（<576），仅 width aspect 变化）
      tester.view.physicalSize = const Size(560, 800);
      await tester.pumpAndSettle();
      // 仅 width aspect 变化：breakpoint/platform 订阅者均不应 rebuild
      expect(breakpointBuilds, buildsAfterFirst);
      expect(platformBuilds, platformBuildsAfterFirst);

      // 跨越 md 断点
      tester.view.physicalSize = const Size(900, 800);
      await tester.pumpAndSettle();
      expect(lastBreakpoint, AntBreakpoint.md);
      expect(breakpointBuilds, buildsAfterFirst + 1);
      // platform aspect 未变化，不 rebuild
      expect(platformBuilds, platformBuildsAfterFirst);
    });

    testWidgets('同断点内宽度变化：width 订阅者 rebuild，breakpoint 订阅者不 rebuild',
        (tester) async {
      tester.view.physicalSize = const Size(375, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      var widthBuilds = 0;
      var breakpointBuilds = 0;

      final child = Column(
        children: [
          Builder(
            builder: (context) {
              widthBuilds++;
              return Text('w-${AntResponsive.widthOf(context)}');
            },
          ),
          Builder(
            builder: (context) {
              breakpointBuilds++;
              return Text(
                'bp-${AntResponsive.breakpointOf(context)?.name}',
              );
            },
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: AntResponsiveInit(
            child: child,
            builder: (context, data, child) => Column(children: [child!]),
          ),
        ),
      );
      await tester.pump();
      final w0 = widthBuilds;
      final bp0 = breakpointBuilds;

      tester.view.physicalSize = const Size(400, 800); // 同在 xs 内
      await tester.pumpAndSettle();
      expect(widthBuilds, w0 + 1);
      expect(breakpointBuilds, bp0);
    });

    testWidgets('AntResponsiveScope 提供 ValueListenable 且值去重', (tester) async {
      tester.view.physicalSize = const Size(375, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      var notified = 0;
      var listenerAttached = false;
      ValueListenable<AntLayoutData>? listenable;

      await tester.pumpWidget(
        MaterialApp(
          home: AntResponsiveInit(
            child: const SizedBox(),
            builder: (context, data, child) {
              listenable = AntResponsiveScope.layoutListenableOf(context);
              if (!listenerAttached) {
                listenerAttached = true;
                listenable!.addListener(() => notified++);
              }
              return child!;
            },
          ),
        ),
      );
      await tester.pumpAndSettle(); // 等初始 post-frame 同步完成
      expect(listenable, isNotNull);
      expect(listenable!.value.width, 375);
      notified = 0; // 只统计后续变化

      // 宽度变化 → 通知一次
      tester.view.physicalSize = const Size(800, 800);
      await tester.pumpAndSettle();
      expect(listenable!.value.width, 800);
      // 值变化仅通知一次（post-frame 同步值相等，不重复通知）
      expect(notified, 1);
      expect(listenable!.value.width, 800);
    });

    testWidgets('of 在无包裹时 maybeOf 返回 null', (tester) async {
      AntLayoutData? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              result = AntResponsive.maybeOf(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(result, isNull);
    });
  });

  // ================================================================
  // 平台字段
  // ================================================================
  group('AntLayoutData 平台字段', () {
    testWidgets('测试环境（android 非 web）字段正确', (tester) async {
      AntLayoutData? data;
      await tester.pumpWidget(
        MaterialApp(
          home: AntResponsiveInit(
            child: const SizedBox(),
            builder: (context, d, child) {
              data = d;
              return child!;
            },
          ),
        ),
      );
      await tester.pump();

      expect(data, isNotNull);
      expect(data!.targetPlatform, TargetPlatform.android);
      expect(data!.isOhos, isFalse); // 标准 SDK 下恒为 false
      expect(data!.isDesktop, isFalse);
      // 测试默认 surface 800x600 → android + 800 宽 → tablet
      expect(data!.deviceType, AntDeviceType.tablet);
    });
  });

  // ================================================================
  // 设备类型判定
  // ================================================================
  group('defaultDeviceTypeOf', () {
    MediaQueryData mqOf(double width) => MediaQueryData(
          size: Size(width, 800),
        );

    test('移动端按宽度判定 phone/tablet', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      expect(
        AntLayoutData.defaultDeviceTypeOf(mqOf(500)),
        AntDeviceType.phone,
      );
      expect(
        AntLayoutData.defaultDeviceTypeOf(mqOf(768)),
        AntDeviceType.tablet,
      );
      debugDefaultTargetPlatformOverride = null;
    });

    test('桌面平台判定 desktop', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      expect(
        AntLayoutData.defaultDeviceTypeOf(mqOf(375)),
        AntDeviceType.desktop,
      );
      debugDefaultTargetPlatformOverride = null;
    });
  });
}
