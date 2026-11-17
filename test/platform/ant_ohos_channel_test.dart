// ignore_for_file: lines_longer_than_80_chars
/// AntOhosChannel 折叠态扩展测试 — 抽象接口 + NoOp 默认实现 + mock 注册。
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter_test/flutter_test.dart';

/// 折叠态 mock 实现
class _MockFoldChannel implements AntOhosChannel {
  @override
  AntFoldState getFoldStateSync() => AntFoldState.halfOpened;

  @override
  Future<List<String>> pickFiles({String? typeFilter}) async => const [];

  @override
  Future<bool> requestPermissions(List<String> permissions) async => false;

  @override
  Future<bool> checkPermission(String permission) async => false;
}

void main() {
  group('AntOhosChannel 折叠态（P05）', () {
    test('NoOp 默认实现返回 unknown', () {
      expect(
        const NoOpAntOhosChannel().getFoldStateSync(),
        AntFoldState.unknown,
      );
    });

    test('注册 mock 后透出折叠态，reset 恢复 NoOp', () {
      AntOhosChannelRegistry.register(_MockFoldChannel());
      expect(
        AntOhosChannelRegistry.channel.getFoldStateSync(),
        AntFoldState.halfOpened,
      );

      AntOhosChannelRegistry.reset();
      expect(
        AntOhosChannelRegistry.channel.getFoldStateSync(),
        AntFoldState.unknown,
      );
    });

    test('折叠态经 AntResponsiveInit.foldStateProvider 并入布局数据', () async {
      AntOhosChannelRegistry.register(_MockFoldChannel());
      addTearDown(AntOhosChannelRegistry.reset);

      // 主工程测试环境带 WidgetsBinding，可直接构造 AntLayoutData 验证
      // foldStateProvider 优先于 displayFeatures 推导。
      final data = AntLayoutData.fromMediaQuery(
        MediaQueryData(size: const Size(800, 1200)),
        foldState: AntOhosChannelRegistry.channel.getFoldStateSync(),
      );
      expect(data.foldState, AntFoldState.halfOpened);
    });
  });
}
