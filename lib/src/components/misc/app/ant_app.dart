/// AntApp — antd React App 的 Flutter 实现
///
/// 提供全局上下文：持有 NavigatorKey / Overlay 入口，
/// 让 message / notification / modal 等全局反馈组件可以
/// **无需页面 context** 直接调用。
///
/// API 与 antd React App 对齐：
/// - [AntApp.child] — 包裹的根组件（通常为 MaterialApp）
/// - [AntApp.navigatorKey] — 传入 MaterialApp 的 navigatorKey，
///   App 通过它获取可用的 Overlay 上下文
/// - [AntApp.message] / [AntApp.notification] / [AntApp.modal] —
///   各全局反馈的默认配置合并参数
///
/// ```dart
/// MaterialApp(
///   home: AntApp(child: HomePage()),
/// )
///
/// // 任意位置（含无 context 的工具类）：
/// AntApp.of(context).messageShow(Text('成功'));
/// ```
library;


import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_flutter_plus/src/components/misc/app/ant_app_types.dart';
export 'package:antd_flutter_plus/src/components/misc/app/ant_app_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntApp
// ============================================================

/// 全局上下文根组件 — 为全局反馈组件提供无需页面 context 的静态入口。
///
/// 对齐 antd React App 组件。
class AntApp extends StatefulWidget {
  /// 创建 AntApp。
  const AntApp({
    super.key,
    required this.child,
    this.navigatorKey,
    this.message,
    this.notification,
    this.modal,
  });

  /// 包裹的组件子树，通常放在 MaterialApp 的 home / 路由内部。
  final Widget child;

  /// 与 MaterialApp 共享的 NavigatorKey（可选）。
  ///
  /// 透传保留给需要导航 API 的场景；弹出全局反馈依赖
  /// AntApp 自身位于 Overlay 之下（即 AntApp 放在 MaterialApp 内部）。
  final GlobalKey<NavigatorState>? navigatorKey;

  /// message 全局默认配置。
  final AntAppMessageConfig? message;

  /// notification 全局默认配置。
  final AntAppNotificationConfig? notification;

  /// modal 全局默认配置。
  final AntAppModalConfig? modal;

  /// 获取最近祖先 [AntApp] 的状态（StaticApi）。
  ///
  /// 若 Widget 树中不存在 [AntApp]，抛出 [FlutterError] 并给出接入指引。
  static AntAppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_AntAppScope>();
    if (scope != null) return scope.state;
    throw FlutterError(
      'AntApp.of(context) 找不到 AntApp。\n'
      '请确保在 Widget 树上层包裹了 AntApp，例如：\n'
      '  AntApp(\n'
      '    navigatorKey: navigatorKey,\n'
      '    child: MaterialApp(navigatorKey: navigatorKey, home: ...),\n'
      '  )',
    );
  }

  @override
  State<AntApp> createState() => AntAppState();
}

// ============================================================
// AntAppState — StaticApi
// ============================================================

/// AntApp 的状态，即静态 API 句柄（对应 antd App 的 useApp 返回值）。
///
/// 经 [AntApp.of] 获取后即可在任意位置调用全局反馈，
/// 无需依赖当前页面的 [BuildContext]。
class AntAppState extends State<AntApp> {
  /// 获取弹出全局反馈所用的上下文。
  ///
  /// AntApp 应位于 MaterialApp 内部（如 `home: AntApp(...)`），
  /// 其自身 context 即位于 Overlay 之下，可直接插入全局浮层。
  BuildContext get _overlayContext {
    return context;
  }

  /// 弹出一条全局提示（委托 [AntMessage.show]，合并 [AntApp.message] 默认配置）。
  AntMessageHandle messageShow(
    Widget content, {
    AntAppMessageType? type,
    Duration? duration,
    bool? closable,
    VoidCallback? onClose,
  }) {
    final defaults = widget.message;
    final resolvedType = type ?? defaults?.type ?? AntAppMessageType.info;
    return AntMessage.show(
      _overlayContext,
      content,
      type: _mapMessageType(resolvedType),
      duration: duration ?? defaults?.duration,
      closable: closable ?? defaults?.closable ?? false,
      onClose: onClose,
    );
  }

  /// 弹出一条通知提醒框（委托 [AntNotification.show]）。
  void notificationShow(
    String messageText, {
    String? title,
    String? description,
    AntAppMessageType? type,
    AntAppNotificationPlacement? placement,
    Duration? duration,
    double? width,
    bool? closable,
    VoidCallback? onClose,
  }) {
    final defaults = widget.notification;
    AntNotification.show(
      _overlayContext,
      message: messageText,
      title: title ?? defaults?.title,
      description: description,
      type: _mapNotificationType(type ?? AntAppMessageType.info),
      placement: _mapPlacement(
        placement ?? defaults?.placement ?? AntAppNotificationPlacement.topRight,
      ),
      duration: duration ?? defaults?.duration ?? const Duration(milliseconds: 4500),
      width: width,
      closable: closable ?? defaults?.closable ?? true,
      onClose: onClose,
    );
  }

  /// 弹出确认对话框（委托 showAntModal），返回用户选择。
  Future<bool?> modal({
    String? title,
    Widget? content,
    String? okText,
    String? cancelText,
    VoidCallback? onOk,
    VoidCallback? onCancel,
    bool? maskClosable,
    double? width,
  }) {
    final defaults = widget.modal;
    return showAntModal(
      _overlayContext,
      title: title,
      content: content,
      okText: okText ?? defaults?.okText ?? kAntModalDefaultOkText,
      cancelText: cancelText ?? defaults?.cancelText ?? kAntModalDefaultCancelText,
      onOk: onOk,
      onCancel: onCancel,
      maskClosable: maskClosable ?? defaults?.maskClosable ?? true,
      width: width ?? defaults?.width ?? kAntModalDefaultWidth,
    );
  }

  // ---- 枚举映射（AntApp API 层 → 已有反馈组件枚举） ----

  AntMessageType _mapMessageType(AntAppMessageType type) {
    switch (type) {
      case AntAppMessageType.info:
        return AntMessageType.info;
      case AntAppMessageType.success:
        return AntMessageType.success;
      case AntAppMessageType.warning:
        return AntMessageType.warning;
      case AntAppMessageType.error:
        return AntMessageType.error;
      case AntAppMessageType.loading:
        return AntMessageType.loading;
    }
  }

  AntNotificationType _mapNotificationType(AntAppMessageType type) {
    switch (type) {
      case AntAppMessageType.info:
        return AntNotificationType.info;
      case AntAppMessageType.success:
        return AntNotificationType.success;
      case AntAppMessageType.warning:
        return AntNotificationType.warning;
      case AntAppMessageType.error:
        return AntNotificationType.error;
      case AntAppMessageType.loading:
        return AntNotificationType.info;
    }
  }

  AntNotificationPlacement _mapPlacement(AntAppNotificationPlacement placement) {
    switch (placement) {
      case AntAppNotificationPlacement.topRight:
        return AntNotificationPlacement.topRight;
      case AntAppNotificationPlacement.topLeft:
        return AntNotificationPlacement.topLeft;
      case AntAppNotificationPlacement.bottomRight:
        return AntNotificationPlacement.bottomRight;
      case AntAppNotificationPlacement.bottomLeft:
        return AntNotificationPlacement.bottomLeft;
    }
  }

  @override
  Widget build(BuildContext context) {
    // AntApp 自身只提供状态持有与 Inherited 注入，不渲染额外 UI。
    return _AntAppScope(state: this, child: widget.child);
  }
}

// ============================================================
// _AntAppScope — InheritedWidget
// ============================================================

class _AntAppScope extends InheritedWidget {
  const _AntAppScope({
    required this.state,
    required super.child,
  });

  final AntAppState state;

  @override
  bool updateShouldNotify(_AntAppScope oldWidget) => state != oldWidget.state;
}


