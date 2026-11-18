/// AntQRCode — antd React QRCode 的 Flutter 实现
///
/// API 与 antd v6 QRCode 对齐（三方渲染引擎经中间层映射，不泄漏 SDK 语义）：
/// - [value] — 二维码内容
/// - [size] — 尺寸（默认与 antd 一致 160）
/// - [errorLevel] — 纠错等级 L/M/Q/H
/// - [color] — 前景色
/// - [bgColor] — 背景色
/// - [icon] — 中间图标模式
/// - [iconSize] — 中间图标尺寸
/// - [status] — active / expired / scanned
/// - [onRefresh] — 过期后点击刷新回调
/// - [bordered] — 是否显示边框
///
/// ```dart
/// AntQRCode(value: 'https://example.com')
/// AntQRCode(value: 'https://example.com', status: AntQRCodeStatus.expired, onRefresh: () {})
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

import 'ant_qr_code_types.dart';
export 'ant_qr_code_types.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// 默认尺寸（对齐 antd v6 默认 160）
const double _kDefaultSize = 160;

/// 中间图标默认尺寸
const double _kDefaultIconSize = 40;

// ============================================================
// AntQRCode
// ============================================================

/// 二维码 — 展示二维码的组件。
///
/// 对齐 antd React QRCode 组件。
class AntQRCode extends StatelessWidget {
  const AntQRCode({
    super.key,
    required this.value,
    this.size = _kDefaultSize,
    this.errorLevel = AntQRCodeErrorLevel.m,
    this.color,
    this.bgColor,
    this.icon = false,
    this.iconSize = _kDefaultIconSize,
    this.status = AntQRCodeStatus.active,
    this.onRefresh,
    this.bordered = true,
  });

  /// 二维码内容。
  final String value;

  /// 尺寸（逻辑像素，内部按 .w 缩放）。
  final double size;

  /// 纠错等级。
  final AntQRCodeErrorLevel errorLevel;

  /// 前景色（二维码点色），默认取主题文字色。
  final Color? color;

  /// 背景色，默认取主题容器背景色。
  final Color? bgColor;

  /// 是否在二维码中心显示图标。
  final bool icon;

  /// 中间图标尺寸。
  final double iconSize;

  /// 二维码状态。
  final AntQRCodeStatus status;

  /// 过期后点击刷新回调。
  final VoidCallback? onRefresh;

  /// 是否显示边框。
  final bool bordered;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final resolvedBg = bgColor ?? theme.colorBgContainer;
    final resolvedColor = color ?? theme.colorText;

    return Container(
      width: size.w,
      height: size.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: resolvedBg,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: bordered
            ? Border.all(color: theme.colorSplit, width: 1)
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildQRView(resolvedColor, resolvedBg),
          if (icon && status == AntQRCodeStatus.active)
            _buildCenterIcon(resolvedBg),
          if (status != AntQRCodeStatus.active)
            _buildStatusOverlay(context, theme, resolvedBg),
        ],
      ),
    );
  }

  /// 渲染二维码（SDK 语义经本中间层映射，外部不感知）。
  Widget _buildQRView(Color foreground, Color background) {
    return QrImageView(
      key: ValueKey<String>(value),
      data: value,
      version: QrVersions.auto,
      size: size.w,
      padding: EdgeInsets.zero,
      backgroundColor: background,
      errorCorrectionLevel: _mapErrorLevel(errorLevel),
      eyeStyle: QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: foreground,
      ),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: foreground,
      ),
    );
  }

  /// 中间图标：白底圆形遮罩 + 图标。
  Widget _buildCenterIcon(Color background) {
    return Container(
      width: iconSize.w,
      height: iconSize.w,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Icon(
        Icons.qr_code_2,
        size: (iconSize - 12).w,
        color: Colors.black87,
      ),
    );
  }

  /// 状态覆盖层（expired / scanned）。
  Widget _buildStatusOverlay(
    BuildContext context,
    AntThemeData theme,
    Color background,
  ) {
    final isExpired = status == AntQRCodeStatus.expired;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isExpired ? Icons.refresh : Icons.check_circle_outline,
          size: 24.w,
          color: isExpired ? theme.colorText : theme.colorSuccess,
        ),
        SizedBox(height: 8.w),
        Text(
          isExpired ? '二维码过期' : '已扫描',
          style: TextStyle(
            fontSize: theme.fontSizeSM,
            color: theme.colorText,
          ),
        ),
      ],
    );

    final overlay = Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
      ),
      child: isExpired && onRefresh != null
          ? GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onRefresh,
              child: content,
            )
          : content,
    );

    return overlay;
  }

  /// 纠错等级映射（中间层隔离 SDK 枚举语义）。
  int _mapErrorLevel(AntQRCodeErrorLevel level) {
    switch (level) {
      case AntQRCodeErrorLevel.l:
        return QrErrorCorrectLevel.L;
      case AntQRCodeErrorLevel.m:
        return QrErrorCorrectLevel.M;
      case AntQRCodeErrorLevel.q:
        return QrErrorCorrectLevel.Q;
      case AntQRCodeErrorLevel.h:
        return QrErrorCorrectLevel.H;
    }
  }
}
