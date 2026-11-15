import 'package:antd_flutter/src/platform/ant_ohos_channel.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NoOpAntOhosChannel', () {
    const channel = NoOpAntOhosChannel();

    test('pickFiles 返回空列表', () async {
      final result = await channel.pickFiles();
      expect(result, isEmpty);
    });

    test('requestPermissions 返回 false', () async {
      final result = await channel.requestPermissions(['ohos.permission.READ_MEDIA']);
      expect(result, isFalse);
    });

    test('checkPermission 返回 false', () async {
      final result = await channel.checkPermission('ohos.permission.READ_MEDIA');
      expect(result, isFalse);
    });
  });

  group('AntOhosChannelRegistry', () {
    tearDown(() {
      AntOhosChannelRegistry.reset();
    });

    test('默认持有 NoOp 实现', () {
      expect(AntOhosChannelRegistry.channel, isA<NoOpAntOhosChannel>());
    });

    test('register 可注入自定义实现', () {
      AntOhosChannelRegistry.register(_FakeOhosChannel());
      expect(AntOhosChannelRegistry.channel, isA<_FakeOhosChannel>());
    });

    test('reset 恢复 NoOp 实现', () {
      AntOhosChannelRegistry.register(_FakeOhosChannel());
      AntOhosChannelRegistry.reset();
      expect(AntOhosChannelRegistry.channel, isA<NoOpAntOhosChannel>());
    });
  });
}

class _FakeOhosChannel implements AntOhosChannel {
  @override
  Future<bool> checkPermission(String permission) async => true;

  @override
  Future<List<String>> pickFiles({String? typeFilter}) async => ['/fake/path.txt'];

  @override
  Future<bool> requestPermissions(List<String> permissions) async => true;
}