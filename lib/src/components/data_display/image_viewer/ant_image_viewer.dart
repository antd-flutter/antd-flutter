/// AntImageViewer — antd-mobile ImageViewer 的 Flutter 实现
///
/// API 与 antd-mobile v5 ImageViewer / MultiImageViewer 对齐：
/// - [AntImageViewer.images] — 图片地址列表（http 开头走网络，其余走资源图）
/// - [AntImageViewer.open] — 受控显示开关
/// - [AntImageViewer.defaultIndex] — 初始展示下标
/// - [AntImageViewer.onClose] — 关闭回调（点击遮罩/关闭按钮/单图轻点）
/// - [AntImageViewer.afterClose] — 关闭动画结束后的回调
/// - [AntImageViewer.maxZoomRatio] — 最大缩放倍数（InteractiveViewer 边界）
/// - [AntImageViewer.enableCompositeZoom] — 是否开启双击缩放
///
/// 全屏 Overlay：暗色遮罩 + InteractiveViewer 缩放拖拽 +
/// PageView 左右切换 + 页码指示 + 关闭按钮。
///
/// ```dart
/// AntImageViewer(
///   images: ['https://example.com/a.png', 'https://example.com/b.png'],
///   open: visible,
///   onClose: () => setState(() => visible = false),
/// )
/// ```
library;

import 'package:antd_flutter_plus/src/components/data_display/image_viewer/ant_image_viewer_types.dart';

export 'package:antd_flutter_plus/src/components/data_display/image_viewer/ant_image_viewer_types.dart';

import 'package:antd_theme/antd_theme.dart';

import 'package:flutter/material.dart';

/// 图片查看器 — 全屏浏览多张图片，支持缩放与左右切换。
///
/// 对齐 antd-mobile MultiImageViewer 组件（组件本身支持多图）。
class AntImageViewer extends StatefulWidget {
  const AntImageViewer({
    super.key,
    required this.images,
    required this.open,
    this.defaultIndex = AntImageViewerDefaults.defaultIndex,
    this.onClose,
    this.afterClose,
    this.maxZoomRatio = AntImageViewerDefaults.maxZoomRatio,
    this.enableCompositeZoom = true,
  });

  /// 图片地址列表。
  final List<String> images;

  /// 受控显示开关。
  final bool open;

  /// 初始展示下标。
  final int defaultIndex;

  /// 关闭回调（遮罩轻点/关闭按钮/单图轻点触发，由外部控制 [open] 关闭）。
  final VoidCallback? onClose;

  /// 关闭动画结束后的回调。
  final VoidCallback? afterClose;

  /// 最大缩放倍数（InteractiveViewer maxScale 边界），默认 3。
  final double maxZoomRatio;

  /// 是否开启双击缩放，默认开启。
  final bool enableCompositeZoom;

  @override
  State<AntImageViewer> createState() => _AntImageViewerState();
}

class _AntImageViewerState extends State<AntImageViewer>
    with SingleTickerProviderStateMixin {
  /// 遮罩淡入淡出控制器。
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AntImageViewerDefaults.animationDuration,
  );

  /// 当前挂在 Overlay 上的浮层。
  OverlayEntry? _entry;

  @override
  void initState() {
    super.initState();
    if (widget.open) {
      // 避免在构建期间修改 Overlay，延后到首帧完成后再插入。
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.open) _insertEntry();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AntImageViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open && !oldWidget.open) {
      // 避免在构建期间修改 Overlay，延后到本帧结束再插入。
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.open && _entry == null) _insertEntry();
      });
    } else if (!widget.open && oldWidget.open) {
      _removeEntry(animated: true);
    }
  }

  @override
  void dispose() {
    _removeEntry(animated: false);
    _controller.dispose();
    super.dispose();
  }

  /// 插入全屏浮层并播放淡入动画。
  void _insertEntry() {
    if (_entry != null) return;
    final overlay = Overlay.of(context, rootOverlay: true);
    _entry = OverlayEntry(
      builder: (_) => _AntImageViewerOverlay(
        images: widget.images,
        initialIndex: widget.defaultIndex,
        maxZoomRatio: widget.maxZoomRatio,
        enableCompositeZoom: widget.enableCompositeZoom,
        onClose: widget.onClose,
        opacity: _controller,
      ),
    );
    overlay.insert(_entry!);
    _controller.forward(from: 0);
  }

  /// 移除浮层；[animated] 为 true 时先播放淡出动画再回调 [AntImageViewer.afterClose]。
  void _removeEntry({required bool animated}) {
    final entry = _entry;
    if (entry == null) return;
    _entry = null;
    if (!animated) {
      entry.remove();
      _controller.value = 0;
      return;
    }
    _controller.reverse().whenComplete(() {
      if (entry.mounted) entry.remove();
      widget.afterClose?.call();
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

/// 全屏预览浮层：暗色遮罩 + InteractiveViewer 缩放 +
/// PageView 左右切换 + 页码指示 + 关闭按钮。
class _AntImageViewerOverlay extends StatefulWidget {
  const _AntImageViewerOverlay({
    required this.images,
    required this.initialIndex,
    required this.maxZoomRatio,
    required this.enableCompositeZoom,
    required this.onClose,
    required this.opacity,
  });

  /// 图片地址列表。
  final List<String> images;

  /// 初始展示下标。
  final int initialIndex;

  /// 最大缩放倍数。
  final double maxZoomRatio;

  /// 是否开启双击缩放。
  final bool enableCompositeZoom;

  /// 关闭回调。
  final VoidCallback? onClose;

  /// 遮罩透明度动画。
  final Animation<double> opacity;

  @override
  State<_AntImageViewerOverlay> createState() => _AntImageViewerOverlayState();
}

class _AntImageViewerOverlayState extends State<_AntImageViewerOverlay> {
  late int _index = widget.initialIndex.clamp(0, widget.images.length - 1);

  late final PageController _pageController =
      PageController(initialPage: _index);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: widget.opacity,
        builder: (context, _) => IgnorePointer(
          ignoring: widget.opacity.value == 0,
          child: Opacity(
            opacity: widget.opacity.value,
            child: Material(
              color: Colors.black
                  .withValues(alpha: AntImageViewerDefaults.barrierAlpha),
              child: Stack(
                children: [
                  // 图片区：PageView 左右切换，单页内 InteractiveViewer 缩放。
                  Positioned.fill(
                    child: PageView.builder(
                      itemCount: widget.images.length,
                      controller: _pageController,
                      onPageChanged: (index) =>
                          setState(() => _index = index),
                      itemBuilder: (_, index) => _buildZoomablePage(
                        context,
                        src: widget.images[index],
                      ),
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
                  // 页码指示。
                  Positioned(
                    bottom: MediaQuery.paddingOf(context).bottom + 24.w,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        '${_index + 1} / ${widget.images.length}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 单页：轻点关闭，双击缩放（可配），拖拽缩放边界为 maxZoomRatio。
  Widget _buildZoomablePage(BuildContext context, {required String src}) {
    final controller = TransformationController();
    bool zoomed = false;
    return GestureDetector(
      onTap: widget.onClose,
      onDoubleTap: widget.enableCompositeZoom
          ? () {
              if (zoomed) {
                controller.value = Matrix4.identity();
              } else {
                final scale = Matrix4.diagonal3Values(
                  widget.maxZoomRatio,
                  widget.maxZoomRatio,
                  1,
                );
                controller.value = scale;
              }
              zoomed = !zoomed;
            }
          : null,
      child: InteractiveViewer(
        maxScale: widget.maxZoomRatio,
        minScale: 1.0,
        transformationController: controller,
        child: Center(
          child: AntImageViewerDefaults.buildImage(
            context,
            src: src,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  /// 半透明白色图标按钮（关闭/切换）。
  Widget _buildIconButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: const BoxDecoration(
          color: Colors.black26,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 22.w, color: Colors.white),
      ),
    );
  }
}
