/// AntImageUploader — antd-mobile ImageUploader 图片上传的 Flutter 实现
///
/// API 与 antd-mobile React ImageUploader 对齐：
/// - [AntImageUploader] — 图片上传（value/maxCount/columns/preview/deletable）
/// - 数据源为任意模型 `List<T>`，用 [urlOf] / [statusOf] / [itemBuilder] 取数与渲染
///
/// ```dart
/// AntImageUploader<MyImage>(
///   maxCount: 3,
///   urlOf: (img) => img.thumbUrl,
///   statusOf: (img) => img.uploading
///       ? AntImageUploadStatus.uploading
///       : AntImageUploadStatus.done,
///   onPickImage: () async => [MyImage(...)],
///   onChange: (items) => print(items.length),
/// )
/// ```
library;

import 'package:antd_flutter_ui/src/data_entry/image_uploader/ant_image_uploader_types.dart';
import '../../feedback/loading/ant_loading.dart';
import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_ui/src/data_entry/image_uploader/ant_image_uploader_types.dart';

import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

/// 图片上传 — 图片选择、预览与删除的网格组件。
///
/// 对齐 antd-mobile React ImageUploader。通过 [onPickImage] 回调
/// 获取待上传图片，组件负责网格展示、预览与删除。
class AntImageUploader<T> extends StatefulWidget {
  const AntImageUploader({
    super.key,
    this.value,
    this.defaultValue = const [],
    this.onChange,
    this.onPickImage,
    this.onDelete,
    this.urlOf,
    this.statusOf,
    this.itemBuilder,
    this.previewBuilder,
    this.onCountExceed,
    this.maxCount = 0,
    this.columns = 4,
    this.deletable = true,
    this.showUpload = true,
    this.preview = true,
    this.imageFit = BoxFit.cover,
    this.uploadIcon = AntIcons.plusOutlined,
  });

  /// 受控图片列表。
  final List<T>? value;

  /// 非受控初始列表。
  final List<T> defaultValue;

  /// 列表变化回调。
  final ValueChanged<List<T>>? onChange;

  /// 选图回调（返回新增图片列表）。
  final Future<List<T>> Function()? onPickImage;

  /// 删除回调（返回 false 阻止删除）。
  final bool Function(T item)? onDelete;

  /// 图片地址，缺省：`T` 是 [String] 时直接使用，
  /// 是 [AntImageUploadItem] 时取 `url`，否则抛 [StateError]。
  final String Function(T item)? urlOf;

  /// 上传状态，缺省：`T` 是 [AntImageUploadItem] 时取 `status`，否则视为完成。
  final AntImageUploadStatus Function(T item)? statusOf;

  /// 自定义图片格子内容（默认 `Image.network`）。
  /// 外层点击预览与右上角删除按钮仍由组件提供。
  final Widget Function(BuildContext context, T item, int index)? itemBuilder;

  /// 自定义全屏预览内容，缺省用 `Image.network(url)` 全屏展示。
  final Widget Function(BuildContext context, T item)? previewBuilder;

  /// 超出最大数量回调。
  final ValueChanged<int>? onCountExceed;

  /// 最大图片数量（0 为不限制）。
  final int maxCount;

  /// 每行列数。
  final int columns;

  /// 是否可删除。
  final bool deletable;

  /// 是否显示上传按钮。
  final bool showUpload;

  /// 是否点击预览。
  final bool preview;

  /// 图片填充模式。
  final BoxFit imageFit;

  /// 上传按钮图标。
  final IconData uploadIcon;

  @override
  State<AntImageUploader<T>> createState() => _AntImageUploaderState<T>();
}

class _AntImageUploaderState<T> extends State<AntImageUploader<T>> {
  late List<T> _internalValue;

  List<T> get _currentValue => widget.value ?? _internalValue;

  /// 图片地址。
  String _urlOf(T item) {
    final fn = widget.urlOf;
    if (fn != null) return fn(item);
    if (item is String) return item;
    if (item is AntImageUploadItem) return item.url;
    throw StateError(
      'AntImageUploader: 无法从 $T 提取图片地址，请提供 urlOf。',
    );
  }

  /// 上传状态。
  AntImageUploadStatus _statusOf(T item) {
    final fn = widget.statusOf;
    if (fn != null) return fn(item);
    if (item is AntImageUploadItem) return item.status;
    return AntImageUploadStatus.done;
  }

  @override
  void initState() {
    super.initState();
    _internalValue = List.from(widget.defaultValue);
  }

  @override
  void didUpdateWidget(covariant AntImageUploader<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != oldWidget.value) {
      _internalValue = List.from(widget.value!);
    }
  }

  void _emitChange(List<T> next) {
    if (widget.value != null) {
      widget.onChange?.call(next);
    } else {
      setState(() => _internalValue = next);
      widget.onChange?.call(next);
    }
  }

  Future<void> _handleUpload() async {
    if (widget.onPickImage == null) return;
    if (widget.maxCount > 0 && _currentValue.length >= widget.maxCount) {
      return;
    }
    final picked = await widget.onPickImage!();
    if (picked.isEmpty) return;
    var toAdd = picked;
    if (widget.maxCount > 0) {
      final remaining = widget.maxCount - _currentValue.length;
      if (picked.length > remaining) {
        widget.onCountExceed?.call(picked.length - remaining);
        toAdd = picked.take(remaining).toList();
      }
    }
    if (toAdd.isEmpty) return;
    _emitChange([..._currentValue, ...toAdd]);
  }

  void _handleDelete(int index) {
    final item = _currentValue[index];
    if (widget.onDelete != null && !widget.onDelete!(item)) return;
    final next = List<T>.from(_currentValue)..removeAt(index);
    _emitChange(next);
  }

  void _showPreview(int index) {
    final item = _currentValue[index];
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => widget.previewBuilder != null
            ? widget.previewBuilder!(context, item)
            : _ImagePreviewPage(url: _urlOf(item), fit: widget.imageFit),
      ),
    );
  }

  bool get _canAdd =>
      widget.maxCount <= 0 || _currentValue.length < widget.maxCount;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = t.marginXS;
        final cellSize = (constraints.maxWidth - gap * (widget.columns - 1)) /
            widget.columns;

        final children = <Widget>[];
        for (var i = 0; i < _currentValue.length; i++) {
          children.add(
            SizedBox(
              width: cellSize,
              height: cellSize,
              child: _buildImageCell(t, i),
            ),
          );
        }
        if (widget.showUpload && _canAdd) {
          children.add(
            SizedBox(
              width: cellSize,
              height: cellSize,
              child: _buildUploadCell(t),
            ),
          );
        }

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: children,
        );
      },
    );
  }

  Widget _buildImageCell(AntThemeData t, int index) {
    final item = _currentValue[index];
    final status = _statusOf(item);
    return GestureDetector(
      onTap: widget.preview ? () => _showPreview(index) : null,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (widget.itemBuilder != null)
            widget.itemBuilder!(context, item, index)
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(t.borderRadiusSM),
              child: Image.network(
                _urlOf(item),
                fit: widget.imageFit,
                errorBuilder: (_, __, ___) => Container(
                  color: t.colorFillSecondary,
                  alignment: Alignment.center,
                  child: Icon(
                    AntIcons.pictureOutlined,
                    size: t.s(24),
                    color: t.colorTextQuaternary,
                  ),
                ),
              ),
            ),
          if (status == AntImageUploadStatus.uploading)
            ClipRRect(
              borderRadius: BorderRadius.circular(t.borderRadiusSM),
              child: Container(
                color: Colors.black.withValues(alpha: 0.4),
                alignment: Alignment.center,
                child: AntLoading(
                  size: t.s(20),
                  color: Colors.white,
                ),
              ),
            ),
          if (status == AntImageUploadStatus.failed)
            ClipRRect(
              borderRadius: BorderRadius.circular(t.borderRadiusSM),
              child: Container(
                color: Colors.black.withValues(alpha: 0.4),
                alignment: Alignment.center,
                child: Icon(
                  AntIcons.exclamationCircleOutlined,
                  size: t.s(24),
                  color: Colors.white,
                ),
              ),
            ),
          if (widget.deletable)
            Positioned(
              top: t.s(2),
              right: t.s(2),
              child: GestureDetector(
                onTap: () => _handleDelete(index),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.all(t.s(2)),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    AntIcons.closeOutlined,
                    size: t.s(14),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUploadCell(AntThemeData t) {
    return GestureDetector(
      onTap: _handleUpload,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: t.colorBorder, width: t.s(1)),
          borderRadius: BorderRadius.circular(t.borderRadiusSM),
          color: t.colorFillSecondary,
        ),
        alignment: Alignment.center,
        child: Icon(
          widget.uploadIcon,
          size: t.s(28),
          color: t.colorTextQuaternary,
        ),
      ),
    );
  }
}

/// 全屏预览页
class _ImagePreviewPage extends StatelessWidget {
  const _ImagePreviewPage({required this.url, required this.fit});

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: InteractiveViewer(
            child: Image.network(
              url,
              fit: fit,
              errorBuilder: (_, __, ___) => const Icon(
                AntIcons.pictureOutlined,
                size: 64,
                color: Colors.white54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
