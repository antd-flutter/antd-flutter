/// AntResult 类型定义 — 对齐 antd React Result 的配置项
library;

import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

/// Result 结果状态。
enum AntResultStatus {
  /// 成功 — 对勾图标。
  success,

  /// 错误 — 叉号图标。
  error,

  /// 信息 — 信息图标。
  info,

  /// 警告 — 警告图标。
  warning,

  /// 404 — 页面不存在（数字大字）。
  notFound,

  /// 403 — 无权限（数字大字）。
  forbidden,

  /// 500 — 服务器错误（数字大字）。
  serverError;

  /// 语义状态对应的默认图标。
  IconData get icon {
    switch (this) {
      case AntResultStatus.success:
        return AntIcons.checkCircleFilled;
      case AntResultStatus.error:
        return AntIcons.closeCircleFilled;
      case AntResultStatus.info:
        return AntIcons.infoCircleFilled;
      case AntResultStatus.warning:
        return AntIcons.warningFilled;
      case AntResultStatus.notFound:
      case AntResultStatus.forbidden:
      case AntResultStatus.serverError:
        return AntIcons.questionCircleOutlined;
    }
  }

  /// 状态对应的展示文案（语义名或数字）。
  String get statusLabel {
    switch (this) {
      case AntResultStatus.success:
        return 'success';
      case AntResultStatus.error:
        return 'error';
      case AntResultStatus.info:
        return 'info';
      case AntResultStatus.warning:
        return 'warning';
      case AntResultStatus.notFound:
        return '404';
      case AntResultStatus.forbidden:
        return '403';
      case AntResultStatus.serverError:
        return '500';
    }
  }
}

/// 各状态展示数字大字时的文案。
extension AntResultStatusLabel on AntResultStatus {
  /// 数字型状态展示的大字（非数字型状态返回 null）。
  String? get numericLabel {
    switch (this) {
      case AntResultStatus.notFound:
        return '404';
      case AntResultStatus.forbidden:
        return '403';
      case AntResultStatus.serverError:
        return '500';
      default:
        return null;
    }
  }
}
