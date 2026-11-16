/// AntApp 类型定义
library;


/// AntApp 全局 message 默认配置。
///
/// 在 [AntApp] 上设置后，经 `AntApp.of(context).message.show(...)` 弹出的
/// 提示将合并这些默认值（调用处的显式参数优先）。
class AntAppMessageConfig {
  /// 创建 message 全局默认配置。
  const AntAppMessageConfig({
    this.type,
    this.duration,
    this.closable,
  });

  /// 默认提示类型。
  final AntAppMessageType? type;

  /// 默认自动关闭时长；null 表示沿用 AntMessage 内置默认值。
  final Duration? duration;

  /// 默认是否显示关闭按钮。
  final bool? closable;
}

/// AntApp 全局 notification 默认配置。
class AntAppNotificationConfig {
  /// 创建 notification 全局默认配置。
  const AntAppNotificationConfig({
    this.title,
    this.placement,
    this.duration,
    this.closable,
  });

  /// 默认通知标题（调用处未传 title 时使用）。
  final String? title;

  /// 默认展示位置。
  final AntAppNotificationPlacement? placement;

  /// 默认自动关闭时长。
  final Duration? duration;

  /// 默认是否显示关闭按钮。
  final bool? closable;
}

/// AntApp 全局 modal 默认配置。
class AntAppModalConfig {
  /// 创建 modal 全局默认配置。
  const AntAppModalConfig({
    this.okText,
    this.cancelText,
    this.maskClosable,
    this.width,
  });

  /// 默认确认按钮文案。
  final String? okText;

  /// 默认取消按钮文案。
  final String? cancelText;

  /// 默认点击遮罩是否可关闭。
  final bool? maskClosable;

  /// 默认弹窗宽度。
  final double? width;
}

/// 经 AntApp 弹出 message 的类型。
///
/// 与 AntMessage 的类型一一对应，作为 API 层的稳定入口枚举。
enum AntAppMessageType {
  /// 信息提示
  info,

  /// 成功
  success,

  /// 警告
  warning,

  /// 错误
  error,

  /// 加载中
  loading,
}

/// 经 AntApp 弹出 notification 的展示位置。
enum AntAppNotificationPlacement {
  /// 右上角
  topRight,

  /// 左上角
  topLeft,

  /// 右下角
  bottomRight,

  /// 左下角
  bottomLeft,
}
