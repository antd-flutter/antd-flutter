/// AntResultPage 类型定义 — 对齐 antd-mobile v5 ResultPage 的配置项
library;

import 'package:material_ui/material_ui.dart';

/// ResultPage 结果页状态。
enum AntResultPageStatus {
  /// 成功。
  success,

  /// 错误。
  error,

  /// 信息。
  info,

  /// 警告。
  warning,

  /// 等待。
  waiting;

  /// 状态对应的默认语义图标。
  IconData get icon {
    switch (this) {
      case AntResultPageStatus.success:
        return Icons.check_circle;
      case AntResultPageStatus.error:
        return Icons.cancel;
      case AntResultPageStatus.info:
        return Icons.info;
      case AntResultPageStatus.warning:
        return Icons.warning;
      case AntResultPageStatus.waiting:
        return Icons.schedule;
    }
  }

  /// 状态对应的主色令牌取值函数名（便于按主题取色）。
  String get statusLabel {
    switch (this) {
      case AntResultPageStatus.success:
        return 'success';
      case AntResultPageStatus.error:
        return 'error';
      case AntResultPageStatus.info:
        return 'info';
      case AntResultPageStatus.warning:
        return 'warning';
      case AntResultPageStatus.waiting:
        return 'waiting';
    }
  }
}
