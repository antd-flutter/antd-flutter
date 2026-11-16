/// AntImageViewer — 类型定义与默认配置
///
/// 存放 AntImageViewer 组件的默认值常量与公共工具，
/// 与组件实现（ant_image_viewer.dart）分离，便于复用与维护。
///
/// 对齐 antd-mobile ImageViewer 的默认配置。
library;

import 'package:antd_theme/antd_theme.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

/// AntImageViewer 默认配置与公共构建器。
class AntImageViewerDefaults {
  const AntImageViewerDefaults._();

  /// 图片地址的网络前缀判断关键字。
  static const String networkPrefix = 'http';

  /// 默认最大缩放倍数。
  static const double maxZoomRatio = 3.0;

  /// 默认初始展示下标。
  static const int defaultIndex = 0;

  /// 遮罩背景不透明度。
  static const double barrierAlpha = 0.85;

  /// 开关动画时长。
  static const Duration animationDuration = Duration(milliseconds: 200);

  /// 判断图片地址是否为网络图片（http/https 开头）。
  static bool isNetworkSrc(String src) => src.startsWith(networkPrefix);

  /// 构建单张大图：网络图走缓存加载，其余按资源图处理，
  /// 加载中/失败均给出占位。
  static Widget buildImage(
    BuildContext context, {
    required String src,
    required BoxFit fit,
    AntThemeData? theme,
  }) {
    final resolvedTheme = theme ?? AntTheme.of(context);
    if (isNetworkSrc(src)) {
      return CachedNetworkImage(
        imageUrl: src,
        fit: fit,
        placeholder: (_, __) => defaultPlaceholder(resolvedTheme),
        errorWidget: (_, __, ___) => defaultError(resolvedTheme),
      );
    }
    return Image.asset(
      src,
      fit: fit,
      errorBuilder: (_, __, ___) => defaultError(resolvedTheme),
    );
  }

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.broken_image_outlined,
          size: 48.w,
          color: Colors.white70,
        ),
        SizedBox(height: 8.w),
        Text(
          '图片加载失败',
          style: TextStyle(fontSize: 14.sp, color: Colors.white70),
        ),
      ],
    );
  }
}
