/// AntImage — 类型定义与默认配置
///
/// 存放 AntImage 组件的默认值常量与公共占位构建器，
/// 与组件实现（ant_image.dart）分离，便于复用与维护。
library;

import 'package:antd_theme/antd_theme.dart';

import 'package:flutter/material.dart';

// ============================================================
// 默认配置
// ============================================================

/// AntImage 默认配置与公共构建器。
class AntImageDefaults {
  const AntImageDefaults._();

  /// 图片地址的网络前缀判断关键字。
  static const String networkPrefix = 'http';

  /// 默认加载失败提示文字。
  static const String errorText = '图片加载失败';

  /// 默认预览遮罩背景透明度。
  static const double previewBarrierAlpha = 0.85;

  /// 预览图片最大缩放倍数。
  static const double previewMaxScale = 5.0;

  /// 判断图片地址是否为网络图片（http/https 开头）。
  static bool isNetworkSrc(String src) => src.startsWith(networkPrefix);

  /// 默认加载中占位：居中圆形进度指示器。
  static Widget defaultPlaceholder(AntThemeData theme) {
    return Center(
      child: SizedBox(
        width: 24.w,
        height: 24.w,
        child: CircularProgressIndicator(
          strokeWidth: 2.w,
          color: theme.colorPrimary,
        ),
      ),
    );
  }

  /// 默认加载失败占位：断裂图片 icon + 提示文字。
  static Widget defaultError(AntThemeData theme) {
    return Container(
      color: theme.colorFillSecondary,
      alignment: Alignment.center,
      padding: EdgeInsets.all(8.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: 24.w,
            color: theme.colorTextQuaternary,
          ),
          SizedBox(height: 4.w),
          Text(
            errorText,
            style: TextStyle(
              fontSize: 12.sp,
              color: theme.colorTextQuaternary,
            ),
          ),
        ],
      ),
    );
  }
}
