/// AntImage — antd React Image 的 Flutter 实现
///
/// API 与 antd React Image 对齐：
/// - [AntImage.src] — 图片地址（http 开头走网络，其余走资源图）
/// - [AntImage.width] / [AntImage.height] — 尺寸（.w 缩放）
/// - [AntImage.fit] — 填充模式
/// - [AntImage.radius] — 圆角
/// - [AntImage.preview] — 点击全屏预览（默认 true，自绘 Overlay）
/// - [AntImage.previewSrc] — 预览图地址（默认用 src）
/// - [AntImage.fallback] — 加载失败占位图地址
/// - [AntImage.errorWidget] — 加载失败自定义占位
/// - [AntImage.placeholder] — 加载中自定义占位
/// - [AntImagePreviewGroup] — 预览组（多图左右切换）
///
/// ```dart
/// AntImage(src: 'https://example.com/a.png', width: 200, height: 120)
/// AntImagePreviewGroup(children: [AntImage(src: 'a.png'), AntImage(src: 'b.png')])
/// ```
library;

import 'package:antd_flutter_plus/src/components/data_display/image/ant_image_types.dart';

export 'package:antd_flutter_plus/src/components/data_display/image/ant_image_types.dart';

import 'package:antd_theme/antd_theme.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

// ============================================================
// AntImage
// ============================================================

/// 图片 — 可预览的图片容器，支持网络/资源图、加载占位与失败回退。
///
/// 对齐 antd React Image 组件。网络图片经
/// [_buildNetworkImage] 统一接入 cached_network_image 缓存加载。
class AntImage extends StatefulWidget {
  const AntImage({
    super.key,
    required this.src,
    this.previewSrc,
    this.width,
    this.height,
    this.fit,
    this.radius,
    this.preview = true,
    this.placeholder,
    this.fallback,
    this.errorWidget,
    this.onError,
    this.previewFit = BoxFit.contain,
  });

  /// 图片地址，http/https 开头走网络加载，其余按资源图处理。
  final String src;

  /// 预览大图地址，为空时使用 [src]。
  final String? previewSrc;

  /// 显示宽度（.w 缩放）。
  final double? width;

  /// 显示高度（.w 缩放）。
  final double? height;

  /// 图片填充模式。
  final BoxFit? fit;

  /// 圆角半径（.r 缩放），为空时取主题大圆角。
  final double? radius;

  /// 是否点击弹出全屏预览，默认 true。
  final bool preview;

  /// 加载中自定义占位，为空时显示进度指示器。
  final Widget? placeholder;

  /// 加载失败占位图地址（antd fallback 语义）。
  final String? fallback;

  /// 加载失败自定义占位，优先级高于 [fallback]。
  final Widget? errorWidget;

  /// 图片加载失败回调。
  final VoidCallback? onError;

  /// 预览大图填充模式，默认 contain。
  final BoxFit previewFit;

  /// 实际生效的预览地址。
  String get _resolvedPreviewSrc => previewSrc ?? src;

  @override
  State<AntImage> createState() => _AntImageState();
}

class _AntImageState extends State<AntImage> {
  /// 网络图中间件封装调用点：展示态图片（含 fallback 占位图）。
  Widget _buildNetworkImage(
    BuildContext context, {
    required String url,
    required AntThemeData theme,
    required BoxFit fit,
  }) {
    return _cachedNetworkImage(
      url: url,
      fit: fit,
      width: widget.width?.w,
      height: widget.height?.w,
      placeholder: (_, __) =>
          widget.placeholder ?? AntImageDefaults.defaultPlaceholder(theme),
      errorWidget: (_, __, ___) {
        widget.onError?.call();
        return _resolveErrorChild(context, theme);
      },
    );
  }

  /// 失败占位解析：errorWidget > fallback 图 > 默认 icon + 文字。
  Widget _resolveErrorChild(BuildContext context, AntThemeData theme) {
    final custom = widget.errorWidget;
    if (custom != null) return custom;
    final fallbackSrc = widget.fallback;
    if (fallbackSrc != null) {
      return _buildFallbackImage(fallbackSrc, theme);
    }
    return AntImageDefaults.defaultError(theme);
  }

  /// 加载失败占位图（fallback），同样区分网络/资源图。
  Widget _buildFallbackImage(String src, AntThemeData theme) {
    final fit = widget.fit ?? BoxFit.cover;
    if (AntImageDefaults.isNetworkSrc(src)) {
      // 占位图自身不再嵌套失败回退，避免递归。
      return _cachedNetworkImage(
        url: src,
        fit: fit,
        width: widget.width?.w,
        height: widget.height?.w,
      );
    }
    return Image.asset(
      src,
      width: widget.width?.w,
      height: widget.height?.w,
      fit: fit,
    );
  }

  void _showPreview(BuildContext context) {
    final scope = _AntImageGroupScope.maybeOf(context);
    final previewSrc = widget._resolvedPreviewSrc;
    final sources = scope?.sources ?? [previewSrc];
    var index = scope == null ? 0 : sources.indexOf(previewSrc);
    if (index < 0) index = 0;

    final overlay = Overlay.of(context, rootOverlay: true);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _AntImagePreviewOverlay(
        sources: sources,
        initialIndex: index,
        fit: widget.previewFit,
        onClose: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final radius =
        BorderRadius.circular((widget.radius ?? theme.borderRadiusLG).r);

    Widget content = _buildImageBody(context, theme);
    content = ClipRRect(borderRadius: radius, child: content);

    if (widget.preview) {
      content = GestureDetector(
        onTap: () => _showPreview(context),
        child: content,
      );
    }

    return SizedBox(
      width: widget.width?.w,
      height: widget.height?.w,
      child: content,
    );
  }

  Widget _buildImageBody(BuildContext context, AntThemeData theme) {
    final src = widget.src;
    final fit = widget.fit ?? BoxFit.cover;

    if (AntImageDefaults.isNetworkSrc(src)) {
      return _buildNetworkImage(
        context,
        url: src,
        theme: theme,
        fit: fit,
      );
    }
    // 资源图路径。
    return Image.asset(
      src,
      fit: fit,
      errorBuilder: (_, __, ___) {
        widget.onError?.call();
        return _resolveErrorChild(context, theme);
      },
    );
  }
}

// ============================================================
// AntImagePreviewGroup
// ============================================================

/// 图片预览组 — 包裹一组 [AntImage]，点击任意一张
/// 可在全屏预览内左右切换组内图片。
///
/// 对齐 antd React Image.PreviewGroup 组件。
class AntImagePreviewGroup extends StatelessWidget {
  const AntImagePreviewGroup({super.key, required this.children});

  /// 组内图片列表。
  final List<AntImage> children;

  /// 收集组内所有可预览地址（去重保序）。
  List<String> get _sources {
    final list = <String>[];
    for (final image in children) {
      final src = image._resolvedPreviewSrc;
      if (!list.contains(src)) list.add(src);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return _AntImageGroupScope(
      sources: _sources,
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.w,
        children: children,
      ),
    );
  }
}

/// 预览组作用域：向子 [AntImage] 下发组内预览地址列表。
class _AntImageGroupScope extends InheritedWidget {
  const _AntImageGroupScope({
    required this.sources,
    required super.child,
  });

  /// 组内预览地址列表。
  final List<String> sources;

  static _AntImageGroupScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_AntImageGroupScope>();

  @override
  bool updateShouldNotify(_AntImageGroupScope oldWidget) =>
      oldWidget.sources != sources;
}

// ============================================================
// 全屏预览 Overlay（自绘，避免平台差异）
// ============================================================

/// 全屏预览浮层：暗色遮罩 + InteractiveViewer 缩放 +
/// 关闭按钮 + 组内左右切换。
class _AntImagePreviewOverlay extends StatefulWidget {
  const _AntImagePreviewOverlay({
    required this.sources,
    required this.initialIndex,
    required this.fit,
    required this.onClose,
  });

  /// 可切换的预览地址列表。
  final List<String> sources;

  /// 初始展示的下标。
  final int initialIndex;

  /// 大图填充模式。
  final BoxFit fit;

  /// 关闭回调。
  final VoidCallback onClose;

  @override
  State<_AntImagePreviewOverlay> createState() =>
      _AntImagePreviewOverlayState();
}

class _AntImagePreviewOverlayState extends State<_AntImagePreviewOverlay> {
  late int _index = widget.initialIndex.clamp(0, widget.sources.length - 1);

  bool get _hasMultiple => widget.sources.length > 1;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.black
            .withValues(alpha: AntImageDefaults.previewBarrierAlpha),
        child: Stack(
          children: [
            // 点击遮罩空白区域关闭。
            Positioned.fill(
              child: GestureDetector(
                onTap: widget.onClose,
                behavior: HitTestBehavior.opaque,
              ),
            ),
            // 大图区域：可缩放。
            Positioned.fill(
              child: InteractiveViewer(
                maxScale: AntImageDefaults.previewMaxScale,
                child: Center(child: _buildPreviewImage(context)),
              ),
            ),
            // 关闭按钮。
            Positioned(
              top: MediaQuery.paddingOf(context).top + 16.w,
              right: 16.w,
              child: _buildIconButton(
                icon: Icons.close,
                onTap: widget.onClose,
              ),
            ),
            // 左右切换箭头。
            if (_hasMultiple) ...[
              Positioned(
                top: 0,
                bottom: 0,
                left: 12.w,
                child: Center(
                  child: _buildIconButton(
                    icon: Icons.chevron_left,
                    onTap: _index > 0 ? () => setState(() => _index--) : null,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                right: 12.w,
                child: Center(
                  child: _buildIconButton(
                    icon: Icons.chevron_right,
                    onTap: _index < widget.sources.length - 1
                        ? () => setState(() => _index++)
                        : null,
                  ),
                ),
              ),
              // 页码指示。
              Positioned(
                bottom: MediaQuery.paddingOf(context).bottom + 24.w,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    '${_index + 1} / ${widget.sources.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 网络图中间件封装调用点：预览大图（原图解码，不限制尺寸）。
  Widget _buildPreviewImage(BuildContext context) {
    final theme = AntTheme.of(context);
    final src = widget.sources[_index];
    if (AntImageDefaults.isNetworkSrc(src)) {
      return _cachedNetworkImage(
        url: src,
        fit: widget.fit,
        placeholder: (_, __) => AntImageDefaults.defaultPlaceholder(theme),
        errorWidget: (_, __, ___) => Icon(
          Icons.broken_image_outlined,
          size: 48.w,
          color: Colors.white54,
        ),
      );
    }
    return Image.asset(src, fit: widget.fit);
  }

  Widget _buildIconButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: const BoxDecoration(
          color: Colors.white24,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 22.w, color: Colors.white),
      ),
    );
  }
}

// ============================================================
// 网络图中间件封装（cached_network_image 隔离层）
// ============================================================

/// cached_network_image 中间件封装：AntImage 所有的 SDK 调用
/// 集中在此一处，业务代码只使用该封装。
Widget _cachedNetworkImage({
  required String url,
  required BoxFit fit,
  double? width,
  double? height,
  Widget Function(BuildContext context, String url)? placeholder,
  Widget Function(BuildContext context, String url, Object error)? errorWidget,
}) {
  return CachedNetworkImage(
    imageUrl: url,
    width: width,
    height: height,
    fit: fit,
    placeholder: placeholder,
    errorWidget: errorWidget,
  );
}
