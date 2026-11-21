/// AntUpload 文件上传
///
/// 文件选择上传组件，支持文件列表展示、上传进度、删除等。
///
/// 对齐 antd React Upload 组件，支持：
/// - [fileList] / [defaultFileList] / [listType] / [showUploadList]
/// - [onChange] / [onRemove] / [onPreview]
/// - [maxCount] / [multiple] / [disabled] / [accept]
/// - [customRequest] 自定义上传逻辑
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_upload_types.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

export 'ant_upload_types.dart';

/// 文件上传组件
class AntUpload extends StatefulWidget {
  const AntUpload({
    super.key,
    this.fileList,
    this.defaultFileList = const [],
    this.listType = AntUploadListType.text,
    this.showUploadList = true,
    this.disabled = false,
    this.multiple = false,
    this.maxCount,
    this.accept,
    this.onChange,
    this.onRemove,
    this.onPreview,
    this.onSelectFiles,
    this.customRequest,
    this.uploadButtonText,
    this.uploadButtonIcon,
  });

  /// 受控：文件列表
  final List<AntUploadFile>? fileList;

  /// 非受控：文件列表初始值
  final List<AntUploadFile> defaultFileList;

  /// 列表展示类型
  final AntUploadListType listType;

  /// 是否展示文件列表
  final bool showUploadList;

  /// 是否禁用
  final bool disabled;

  /// 是否支持多选
  final bool multiple;

  /// 最大上传数量
  final int? maxCount;

  /// 接受的文件类型
  final String? accept;

  /// 文件状态变化回调
  final void Function(AntUploadFile file, List<AntUploadFile> fileList)?
      onChange;

  /// 删除文件回调，返回 false 可阻止删除
  final Future<bool> Function(AntUploadFile file)? onRemove;

  /// 点击文件链接或图片回调
  final void Function(AntUploadFile file)? onPreview;

  /// 点击上传按钮时触发文件选择的回调
  /// 返回待上传的文件列表，组件会自动调用 customRequest
  final Future<List<AntUploadFile>> Function()? onSelectFiles;

  /// 自定义上传实现
  final Future<void> Function(AntUploadFile file, void Function(AntUploadFile updatedFile) updateFile)?
      customRequest;

  /// 上传按钮文案
  final String? uploadButtonText;

  /// 上传按钮图标
  final IconData? uploadButtonIcon;

  @override
  State<AntUpload> createState() => _AntUploadState();
}

class _AntUploadState extends State<AntUpload> {
  late List<AntUploadFile> _fileList;

  @override
  void initState() {
    super.initState();
    _fileList = List<AntUploadFile>.from(widget.fileList ?? widget.defaultFileList);
  }

  @override
  void didUpdateWidget(AntUpload oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fileList != null) {
      _fileList = List<AntUploadFile>.from(widget.fileList!);
    }
  }

  List<AntUploadFile> get _currentFileList =>
      widget.fileList ?? _fileList;

  bool get _reachedMaxCount {
    final max = widget.maxCount;
    if (max == null) return false;
    return _currentFileList.where((f) => f.status != AntUploadStatus.removed).length >= max;
  }

  void _notifyChange(AntUploadFile file, List<AntUploadFile> list) {
    widget.onChange?.call(file, List<AntUploadFile>.from(list));
  }

  void _updateFileInList(AntUploadFile updated) {
    if (widget.fileList == null) {
      setState(() {
        final index = _fileList.indexWhere((f) => f.uid == updated.uid);
        if (index >= 0) {
          _fileList[index] = updated;
        }
      });
    }
    _notifyChange(updated, _currentFileList);
  }

  Future<void> _handleSelect() async {
    if (widget.disabled || _reachedMaxCount) return;
    if (widget.onSelectFiles == null) return;

    final newFiles = await widget.onSelectFiles!();
    if (newFiles.isEmpty) return;

    // 如果达到 maxCount，截断
    var filesToAdd = newFiles;
    final max = widget.maxCount;
    if (max != null) {
      final current = _currentFileList.where((f) => f.status != AntUploadStatus.removed).length;
      final remaining = max - current;
      if (remaining <= 0) return;
      if (!widget.multiple) {
        filesToAdd = newFiles.take(1).toList();
      } else {
        filesToAdd = newFiles.take(remaining).toList();
      }
    } else if (!widget.multiple) {
      filesToAdd = newFiles.take(1).toList();
    }

    for (final file in filesToAdd) {
      final uploadingFile = file.copyWith(status: AntUploadStatus.uploading, percent: 0);
      if (widget.fileList == null) {
        setState(() {
          _fileList.add(uploadingFile);
        });
      }
      _notifyChange(uploadingFile, _currentFileList);

      // 执行上传
      if (widget.customRequest != null) {
        widget.customRequest!(uploadingFile, _updateFileInList);
      } else {
        // 无自定义请求时直接标记为完成
        _updateFileInList(uploadingFile.copyWith(
          status: AntUploadStatus.done,
          percent: 100,
        ),);
      }
    }
  }

  Future<void> _handleRemove(AntUploadFile file) async {
    if (widget.disabled) return;
    if (widget.onRemove != null) {
      final shouldRemove = await widget.onRemove!(file);
      if (!shouldRemove) return;
    }
    final removed = file.copyWith(status: AntUploadStatus.removed);
    if (widget.fileList == null) {
      setState(() {
        _fileList.removeWhere((f) => f.uid == file.uid);
      });
    }
    _notifyChange(removed, _currentFileList);
  }

  void _handlePreview(AntUploadFile file) {
    if (widget.disabled) return;
    widget.onPreview?.call(file);
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final visibleFiles = _currentFileList
        .where((f) => f.status != AntUploadStatus.removed)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTrigger(t),
        if (widget.showUploadList && visibleFiles.isNotEmpty) ...[
          SizedBox(height: 8.h),
          _buildFileList(t, visibleFiles),
        ],
      ],
    );
  }

  Widget _buildTrigger(AntThemeData t) {
    if (widget.listType == AntUploadListType.pictureCard) {
      return GestureDetector(
        onTap: widget.disabled || _reachedMaxCount ? null : _handleSelect,
        child: Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            color: widget.disabled ? t.colorBgContainerDisabled : t.colorBgContainer,
            border: Border.all(
              color: widget.disabled ? t.colorBorder : t.colorSplit,
            ),
            borderRadius: BorderRadius.circular(t.borderRadiusSM.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.uploadButtonIcon ?? AntIcons.plusOutlined,
                size: 24.r,
                color: widget.disabled ? t.colorTextDisabled : t.colorTextTertiary,
              ),
              if (widget.uploadButtonText != null) ...[
                SizedBox(height: 4.h),
                Text(
                  widget.uploadButtonText!,
                  style: TextStyle(
                    fontSize: t.fontSizeSM.sp,
                    color: widget.disabled ? t.colorTextDisabled : t.colorTextTertiary,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: widget.disabled || _reachedMaxCount ? null : _handleSelect,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: (t.controlHeight - t.fontSizeLG) / 2,
        ),
        decoration: BoxDecoration(
          color: widget.disabled ? t.colorBgContainerDisabled : t.colorBgContainer,
          border: Border.all(color: widget.disabled ? t.colorBorder : t.colorPrimary),
          borderRadius: BorderRadius.circular(t.borderRadius.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.uploadButtonIcon ?? AntIcons.uploadOutlined,
              size: 16.r,
              color: widget.disabled ? t.colorTextDisabled : t.colorPrimary,
            ),
            SizedBox(width: 8.w),
            Text(
              widget.uploadButtonText ?? '上传',
              style: TextStyle(
                fontSize: t.fontSize.sp,
                color: widget.disabled ? t.colorTextDisabled : t.colorPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileList(AntThemeData t, List<AntUploadFile> files) {
    if (widget.listType == AntUploadListType.pictureCard) {
      return Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: [
          for (final file in files)
            _PictureCardItem(
              file: file,
              disabled: widget.disabled,
              theme: t,
              onRemove: () => _handleRemove(file),
              onPreview: () => _handlePreview(file),
            ),
        ],
      );
    }

    return Column(
      children: [
        for (final file in files)
          _FileListItem(
            file: file,
            listType: widget.listType,
            disabled: widget.disabled,
            theme: t,
            onRemove: () => _handleRemove(file),
            onPreview: () => _handlePreview(file),
          ),
      ],
    );
  }
}

/// 文字/图片列表项
class _FileListItem extends StatelessWidget {
  const _FileListItem({
    required this.file,
    required this.listType,
    required this.disabled,
    required this.theme,
    required this.onRemove,
    required this.onPreview,
  });

  final AntUploadFile file;
  final AntUploadListType listType;
  final bool disabled;
  final AntThemeData theme;
  final VoidCallback onRemove;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final t = theme;
    final isError = file.status == AntUploadStatus.error;
    final isUploading = file.status == AntUploadStatus.uploading;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          // 图片缩略图（picture 模式）
          if (listType == AntUploadListType.picture) ...[
            _buildThumb(t),
            SizedBox(width: 8.w),
          ],
          // 状态图标
          if (isUploading)
            SizedBox(
              width: 16.r,
              height: 16.r,
              child: CircularProgressIndicator(
                strokeWidth: 2.r,
                color: t.colorPrimary,
              ),
            )
          else if (isError)
            Icon(AntIcons.closeOutlined, size: 16.r, color: t.colorError)
          else
            Icon(AntIcons.checkCircleFilled, size: 16.r, color: t.colorPrimary),
          SizedBox(width: 8.w),
          // 文件名
          Expanded(
            child: GestureDetector(
              onTap: disabled ? null : onPreview,
              child: Text(
                file.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: t.fontSizeSM.sp,
                  color: isError
                      ? t.colorError
                      : disabled
                          ? t.colorTextDisabled
                          : t.colorText,
                  decoration: file.url != null && !disabled
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
            ),
          ),
          // 删除按钮
          if (!disabled)
            GestureDetector(
              onTap: onRemove,
              child: Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: Icon(
                  AntIcons.closeOutlined,
                  size: 16.r,
                  color: t.colorTextTertiary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildThumb(AntThemeData t) {
    if (file.thumbUrl != null || file.url != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(t.borderRadiusSM.r),
        child: Image.network(
          file.thumbUrl ?? file.url!,
          width: 40.w,
          height: 40.w,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholderThumb(t),
        ),
      );
    }
    return _placeholderThumb(t);
  }

  Widget _placeholderThumb(AntThemeData t) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: t.colorFillSecondary,
        borderRadius: BorderRadius.circular(t.borderRadiusSM.r),
      ),
      child: Icon(
        AntIcons.pictureOutlined,
        size: 20.r,
        color: t.colorTextQuaternary,
      ),
    );
  }
}

/// 图片卡片项
class _PictureCardItem extends StatelessWidget {
  const _PictureCardItem({
    required this.file,
    required this.disabled,
    required this.theme,
    required this.onRemove,
    required this.onPreview,
  });

  final AntUploadFile file;
  final bool disabled;
  final AntThemeData theme;
  final VoidCallback onRemove;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final t = theme;
    final isUploading = file.status == AntUploadStatus.uploading;
    final isError = file.status == AntUploadStatus.error;

    return SizedBox(
      width: 80.w,
      height: 80.w,
      child: Stack(
        children: [
          // 图片或占位
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(t.borderRadiusSM.r),
              child: (file.thumbUrl != null || file.url != null)
                  ? Image.network(
                      file.thumbUrl ?? file.url!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(t),
                    )
                  : _placeholder(t),
            ),
          ),
          // 上传中遮罩
          if (isUploading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(t.borderRadiusSM.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${file.percent}%',
                      style: TextStyle(
                        fontSize: t.fontSizeSM.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    SizedBox(
                      width: 48.w,
                      child: LinearProgressIndicator(
                        value: file.percent / 100,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 2.h,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          // 错误遮罩
          if (isError)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(t.borderRadiusSM.r),
                ),
                child: Icon(AntIcons.exclamationCircleOutlined, color: Colors.white, size: 24.r),
              ),
            ),
          // 操作按钮（非上传中且非禁用）
          if (!isUploading && !disabled)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: EdgeInsets.all(2.r),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(AntIcons.closeOutlined, size: 14.r, color: Colors.white),
                ),
              ),
            ),
          // 点击预览
          if (!isUploading && !disabled)
            Positioned.fill(
              child: GestureDetector(
                onTap: onPreview,
                behavior: HitTestBehavior.translucent,
              ),
            ),
        ],
      ),
    );
  }

  Widget _placeholder(AntThemeData t) {
    return Container(
      color: t.colorFillSecondary,
      child: Icon(
        AntIcons.pictureOutlined,
        size: 24.r,
        color: t.colorTextQuaternary,
      ),
    );
  }
}