import 'package:antd_theme/antd_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(AntOhosChannelRegistry.reset);
  tearDown(AntOhosChannelRegistry.reset);

  test('defaults to the NoOp channel', () async {
    expect(AntOhosChannelRegistry.channel, isA<NoOpAntOhosChannel>());
    expect(await AntOhosChannelRegistry.channel.pickFiles(), isEmpty);
    expect(
      await AntOhosChannelRegistry.channel.requestPermissions(const []),
      isFalse,
    );
    expect(AntOhosChannelRegistry.channel.getFoldStateSync(), AntFoldState.unknown);
  });

  test('register replaces the channel and reset restores NoOp', () async {
    final fake = _FakeOhosChannel();
    AntOhosChannelRegistry.register(fake);
    expect(AntOhosChannelRegistry.channel, same(fake));
    expect(await AntOhosChannelRegistry.channel.checkPermission('p'), isTrue);

    AntOhosChannelRegistry.reset();
    expect(AntOhosChannelRegistry.channel, isA<NoOpAntOhosChannel>());
  });
}

class _FakeOhosChannel implements AntOhosChannel {
  @override
  Future<bool> checkPermission(String permission) async => true;

  @override
  AntFoldState getFoldStateSync() => AntFoldState.folded;

  @override
  Future<List<String>> pickFiles({String? typeFilter}) async => <String>['a'];

  @override
  Future<bool> requestPermissions(List<String> permissions) async => true;
}
