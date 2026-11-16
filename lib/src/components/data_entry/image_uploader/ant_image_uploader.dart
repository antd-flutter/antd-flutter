/// AntImageUploader — antd-mobile ImageUploader 图片上传的 Flutter 实现
///
/// API 与 antd-mobile React ImageUploader 对齐：
/// - [AntImageUploader] — 图片上传（value/maxCount/columns/preview/deletable）
/// - [AntImageUploadItem] — 图片项（url/status）
///
/// ```dart
/// AntImageUploader(
///   maxCount: 3,
///   onPickImage: () async => [AntImageUploadItem(url: 'https://example.com/a.png')],
///   onChange: (items) => print(items.length),
/// )
/// ```
library;

import 'package:antd_flutter_plus/src/components/data_entry/image_uploader/ant_image_uploader_types.dart';
import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_plus/src/components/data_entry/image_uploader/ant_image_uploader_types.dart';

import 'package:material_ui/material_ui.dart';

/// 图片上传 — 图片选择、预览与删除的网格组件。
///
/// 对齐 antd-mobile React ImageUploader。通过 [onPickImage] 回调
/// 获取待上传图片，组件负责网格展示、预览与删除。
class AntImageUploader extends StatefulWidget {
  const AntImageUploader({
    super.key,
    this.value,
    this.defaultValue = const [],
    this.onChange,
    this.onPickImage,
    this.onDelete,
    this.onCountExceed,
    this.maxCount = 0,
    this.columns = 4,
    this.deletable = true,
    this.showUpload = true,
    this.preview = true,
    this.imageFit = BoxFit.cover,
    this.uploadIcon = Icons.add,
  });

  /// 受控图片列表。
  final List<AntImageUploadItem>? value;

  /// 非受控初始列表。
  final List<AntImageUploadItem> defaultValue;

  /// 列表变化回调。
  final ValueChanged<List<AntImageUploadItem>>? onChange;

  /// 选图回调（返回新增图片列表）。
  final Future<List<AntImageUploadItem>> Function()? onPickImage;

  /// 删除回调（返回 false 阻止删除）。
  final bool Function(AntImageUploadItem)? onDelete;

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
  State<AntImageUploader> createState() => _AntImageUploaderState();
}

class _AntImageUploaderState extends State<AntImageUploader> {
  late List<AntImageUploadItem> _internalValue;

  List<AntImageUploadItem> get _currentValue =>
      widget.value ?? _internalValue;

  @override
  void initState() {
    super.initState();
    _internalValue = List.from(widget.defaultValue);
  }

  @override
  void didUpdateWidget(covariant AntImageUploader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != oldWidget.value) {
      _internalValue = List.from(widget.value!);
    }
  }

  void _emitChange(List<AntImageUploadItem> next) {
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
    final next = List<AntImageUploadItem>.from(_currentValue)
      ..removeAt(index);
    _emitChange(next);
  }

  void _showPreview(int index) {
    final item = _currentValue[index];
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => _ImagePreviewPage(
          url: item.url,
          fit: widget.imageFit,
        ),
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
        final gap = t.marginXS.w;
        final cellSize =
            (constraints.maxWidth - gap * (widget.columns - 1)) /
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
    return GestureDetector(
      onTap: widget.preview ? () => _showPreview(index) : null,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(t.borderRadiusSM.w),
            child: Image.network(
              item.url,
              fit: widget.imageFit,
              errorBuilder: (_, __, ___) => Container(
                color: t.colorFillSecondary,
                alignment: Alignment.center,
                child: Icon(
                  Icons.broken_image_outlined,
                  size: 24.w,
                  color: t.colorTextQuaternary,
                ),
              ),
            ),
          ),
          if (item.status == AntImageUploadStatus.uploading)
            ClipRRect(
              borderRadius: BorderRadius.circular(t.borderRadiusSM.w),
              child: Container(
                color: Colors.black.withValues(alpha: 0.4),
                alignment: Alignment.center,
                child: SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.w,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          if (item.status == AntImageUploadStatus.failed)
            ClipRRect(
              borderRadius: BorderRadius.circular(t.borderRadiusSM.w),
              child: Container(
                color: Colors.black.withValues(alpha: 0.4),
                alignment: Alignment.center,
                child: Icon(
                  Icons.error_outline,
                  size: 24.w,
                  color: Colors.white,
                ),
              ),
            ),
          if (widget.deletable)
            Positioned(
              top: 2.w,
              right: 2.w,
              child: GestureDetector(
                onTap: () => _handleDelete(index),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 14.w,
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
          border: Border.all(color: t.colorBorder, width: 1.w),
          borderRadius: BorderRadius.circular(t.borderRadiusSM.w),
          color: t.colorFillSecondary,
        ),
        alignment: Alignment.center,
        child: Icon(
          widget.uploadIcon,
          size: 28.w,
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
                Icons.broken_image_outlined,
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