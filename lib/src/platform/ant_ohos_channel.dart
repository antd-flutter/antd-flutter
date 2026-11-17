/// ohos 能力接口隔离
///
/// 鸿蒙专属能力（ArkTS platform channel / 文件选择器 / 权限）
/// 经抽象接口隔离，默认提供空实现（NoOp）。
/// 仅当 `AntPlatform.isOhos` 为 true 时才应加载真实实现。
///
/// **暂缓说明**：ArkTS 真实实现待 flutter ohos 支持 3.50 后开发。
/// 当前 NoOp 空实现确保未接入鸿蒙时不触发任何 ohos 代码路径。
library;

import 'package:antd_theme/antd_theme.dart' show AntFoldState;

/// ohos 平台能力抽象接口
///
/// 定义鸿蒙专属能力的业务语义接口，
/// 命名体现业务语义而非 SDK 语义。
abstract interface class AntOhosChannel {
  /// 打开系统文件选择器
  ///
  /// 返回所选文件的路径列表；用户取消时返回空列表。
  Future<List<String>> pickFiles({String? typeFilter});

  /// 请求权限
  ///
  /// [permissions] 为 ohos 权限标识列表（如 `ohos.permission.READ_MEDIA`）。
  /// 返回是否全部授权。
  Future<bool> requestPermissions(List<String> permissions);

  /// 检查权限是否已授权
  Future<bool> checkPermission(String permission);

  /// 获取折叠屏状态（同步返回最近一次查询结果）。
  ///
  /// 鸿蒙侧经 ArkTS `display` 模块查询折叠姿势
  /// （展开 flat / 半折 halfOpened / 折叠 folded）；
  /// 无法获取时返回 [AntFoldState.unknown]。
  AntFoldState getFoldStateSync() => AntFoldState.unknown;
}

/// AntOhosChannel 的 NoOp 空实现
///
/// 默认注册的实现，所有方法返回安全空值/false，
/// 确保未接入鸿蒙时不触发任何 ohos 代码路径。
class NoOpAntOhosChannel implements AntOhosChannel {
  const NoOpAntOhosChannel();

  @override
  Future<List<String>> pickFiles({String? typeFilter}) async {
    return const [];
  }

  @override
  Future<bool> requestPermissions(List<String> permissions) async {
    return false;
  }

  @override
  Future<bool> checkPermission(String permission) async {
    return false;
  }

  @override
  AntFoldState getFoldStateSync() => AntFoldState.unknown;
}

/// ohos 能力通道注册器
///
/// 默认持有 [NoOpAntOhosChannel]；
/// 接入鸿蒙后通过 [register] 注入 ArkTS 真实实现。
class AntOhosChannelRegistry {
  AntOhosChannelRegistry._();

  static AntOhosChannel _channel = const NoOpAntOhosChannel();

  /// 当前注册的 ohos 能力通道
  static AntOhosChannel get channel => _channel;

  /// 注册 ohos 能力通道（仅 ohos 环境调用）
  ///
  /// 接入鸿蒙后，在 main() 中调用：
  /// ```dart
  /// if (AntPlatform.isOhos) {
  ///   AntOhosChannelRegistry.register(ArkTSOhosChannel());
  /// }
  /// ```
  static void register(AntOhosChannel channel) {
    _channel = channel;
  }

  /// 重置为 NoOp 空实现（测试用）
  static void reset() {
    _channel = const NoOpAntOhosChannel();
  }
}
