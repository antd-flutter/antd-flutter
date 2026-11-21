/// AntUpload 文件上传
///
/// 文件选择上传组件，支持文件列表展示、上传进度、删除等。
///
/// 对齐 antd React Upload 组件，支持：
/// - [fileList] / [defaultFileList] / [listType] / [showUploadList]
/// - [onChange] / [onRemove] / [onPreview]
/// - [maxCount] / [multiple] / [disabled] / [accept]
/// - [customRequest] 自定义上传逻辑
/// - [itemBuilder] 自定义列表项渲染（配合 [AntUploadFile.extra] 承载业务字段）
library;

import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_upload_types.dart';

export 'ant_upload_types.dart';

/// 文件上传组件。
///
/// [AntUploadFile] 描述的是实际文件；泛型 [T] 通过
/// [AntUploadFile.extra] 承载业务侧额外数据，配合 [itemBuilder]
/// 可完全自定义列表项渲染。
class AntUpload<T> extends StatefulWidget {
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
    this.itemBuilder,
    this.uploadButtonText,
    this.uploadButtonIcon,
  });

  /// 受控：文件列表
  final List<AntUploadFile<T>>? fileList;

  /// 非受控：文件列表初始值
  final List<AntUploadFile<T>> defaultFileList;

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
  final void Function(AntUploadFile<T> file, List<AntUploadFile<T>> fileList)?
      onChange;

  /// 删除文件回调，返回 false 可阻止删除
  final Future<bool> Function(AntUploadFile<T> file)? onRemove;

  /// 点击文件链接或图片回调
  final void Function(AntUploadFile<T> file)? onPreview;

  /// 点击上传按钮时触发文件选择的回调
  /// 返回待上传的文件列表，组件会自动调用 customRequest
  final Future<List<AntUploadFile<T>>> Function()? onSelectFiles;

  /// 自定义上传实现
  final Future<void> Function(
    AntUploadFile<T> file,
    void Function(AntUploadFile<T> updatedFile) updateFile,
  )? customRequest;

  /// 列表项自定义渲染；为空时使用内置文字/图片列表项。
  ///
  /// 业务字段可从 `file.extra` 读取；删除/预览可调用外部自己的逻辑。
  final AntUploadItemBuilder<T>? itemBuilder;

  /// 上传按钮文案
  final String? uploadButtonText;

  /// 上传按钮图标
  final IconData? uploadButtonIcon;

  @override
  State<AntUpload<T>> createState() => _AntUploadState<T>();
}

class _AntUploadState<T> extends State<AntUpload<T>> {
  late List<AntUploadFile<T>> _fileList;

  @override
  void initState() {
    super.initState();
    _fileList = List<AntUploadFile<T>>.from(
      widget.fileList ?? widget.defaultFileList,
    );
  }

  @override
  void didUpdateWidget(AntUpload<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.fileList != null) {
      _fileList = List<AntUploadFile<T>>.from(widget.fileList!);
    }
  }

  List<AntUploadFile<T>> get _currentFileList => widget.fileList ?? _fileList;

  bool get _reachedMaxCount {
    final max = widget.maxCount;
    if (max == null) return false;
    return _currentFileList
            .where((f) => f.status != AntUploadStatus.removed)
            .length >=
        max;
  }

  void _notifyChange(
    AntUploadFile<T> file,
    List<AntUploadFile<T>> list,
  ) {
    widget.onChange?.call(file, List<AntUploadFile<T>>.from(list));
  }

  void _updateFileInList(AntUploadFile<T> updated) {
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
      final current = _currentFileList
          .where((f) => f.status != AntUploadStatus.removed)
          .length;
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
      final uploadingFile = file.copyWith(
        status: AntUploadStatus.uploading,
        percent: 0,
      );
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
        _updateFileInList(
          uploadingFile.copyWith(
            status: AntUploadStatus.done,
            percent: 100,
          ),
        );
      }
    }
  }

  Future<void> _handleRemove(AntUploadFile<T> file) async {
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

  void _handlePreview(AntUploadFile<T> file) {
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
          SizedBox(height: t.s(8)),
          _buildFileList(context, t, visibleFiles),
        ],
      ],
    );
  }

  Widget _buildTrigger(AntThemeData t) {
    if (widget.listType == AntUploadListType.pictureCard) {
      return GestureDetector(
        onTap: widget.disabled || _reachedMaxCount ? null : _handleSelect,
        child: Container(
          width: t.s(80),
          height: t.s(80),
          decoration: BoxDecoration(
            color: widget.disabled
                ? t.colorBgContainerDisabled
                : t.colorBgContainer,
            border: Border.all(
              color: widget.disabled ? t.colorBorder : t.colorSplit,
            ),
            borderRadius: BorderRadius.circular(t.borderRadiusSM),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.uploadButtonIcon ?? AntIcons.plusOutlined,
                size: t.s(24),
                color:
                    widget.disabled ? t.colorTextDisabled : t.colorTextTertiary,
              ),
              if (widget.uploadButtonText != null) ...[
                SizedBox(height: t.s(4)),
                Text(
                  widget.uploadButtonText!,
                  style: TextStyle(
                    fontSize: t.fontSizeSM,
                    color: widget.disabled
                        ? t.colorTextDisabled
                        : t.colorTextTertiary,
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
          horizontal: t.s(16),
          vertical: (t.controlHeight - t.fontSizeLG) / 2,
        ),
        decoration: BoxDecoration(
          color:
              widget.disabled ? t.colorBgContainerDisabled : t.colorBgContainer,
          border: Border.all(
            color: widget.disabled ? t.colorBorder : t.colorPrimary,
          ),
          borderRadius: BorderRadius.circular(t.borderRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.uploadButtonIcon ?? AntIcons.uploadOutlined,
              size: t.s(16),
              color: widget.disabled ? t.colorTextDisabled : t.colorPrimary,
            ),
            SizedBox(width: t.s(8)),
            Text(
              widget.uploadButtonText ?? '上传',
              style: TextStyle(
                fontSize: t.fontSize,
                color: widget.disabled ? t.colorTextDisabled : t.colorPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileList(
    BuildContext context,
    AntThemeData t,
    List<AntUploadFile<T>> files,
  ) {
    final itemBuilder = widget.itemBuilder;
    if (itemBuilder != null) {
      final items = [
        for (var i = 0; i < files.length; i++)
          itemBuilder(context, files[i], i),
      ];
      if (widget.listType == AntUploadListType.pictureCard) {
        return Wrap(spacing: t.s(8), runSpacing: t.s(8), children: items);
      }
      return Column(children: items);
    }

    if (widget.listType == AntUploadListType.pictureCard) {
      return Wrap(
        spacing: t.s(8),
        runSpacing: t.s(8),
        children: [
          for (final file in files)
            _PictureCardItem<T>(
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
          _FileListItem<T>(
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
class _FileListItem<T> extends StatelessWidget {
  const _FileListItem({
    required this.file,
    required this.listType,
    required this.disabled,
    required this.theme,
    required this.onRemove,
    required this.onPreview,
  });

  final AntUploadFile<T> file;
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
      padding: EdgeInsets.symmetric(vertical: t.s(4)),
      child: Row(
        children: [
          // 图片缩略图（picture 模式）
          if (listType == AntUploadListType.picture) ...[
            _buildThumb(t),
            SizedBox(width: t.s(8)),
          ],
          // 状态图标
          if (isUploading)
            SizedBox(
              width: t.s(16),
              height: t.s(16),
              child: CircularProgressIndicator(
                strokeWidth: t.s(2),
                color: t.colorPrimary,
              ),
            )
          else if (isError)
            Icon(AntIcons.closeOutlined, size: t.s(16), color: t.colorError)
          else
            Icon(AntIcons.checkCircleFilled, size: t.s(16), color: t.colorPrimary),
          SizedBox(width: t.s(8)),
          // 文件名
          Expanded(
            child: GestureDetector(
              onTap: disabled ? null : onPreview,
              child: Text(
                file.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: t.fontSizeSM,
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
                padding: EdgeInsets.only(left: t.s(8)),
                child: Icon(
                  AntIcons.closeOutlined,
                  size: t.s(16),
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
        borderRadius: BorderRadius.circular(t.borderRadiusSM),
        child: Image.network(
          file.thumbUrl ?? file.url!,
          width: t.s(40),
          height: t.s(40),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholderThumb(t),
        ),
      );
    }
    return _placeholderThumb(t);
  }

  Widget _placeholderThumb(AntThemeData t) {
    return Container(
      width: t.s(40),
      height: t.s(40),
      decoration: BoxDecoration(
        color: t.colorFillSecondary,
        borderRadius: BorderRadius.circular(t.borderRadiusSM),
      ),
      child: Icon(
        AntIcons.pictureOutlined,
        size: t.s(20),
        color: t.colorTextQuaternary,
      ),
    );
  }
}

/// 图片卡片项
class _PictureCardItem<T> extends StatelessWidget {
  const _PictureCardItem({
    required this.file,
    required this.disabled,
    required this.theme,
    required this.onRemove,
    required this.onPreview,
  });

  final AntUploadFile<T> file;
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
      width: t.s(80),
      height: t.s(80),
      child: Stack(
        children: [
          // 图片或占位
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(t.borderRadiusSM),
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
                  borderRadius: BorderRadius.circular(t.borderRadiusSM),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${file.percent}%',
                      style: TextStyle(
                        fontSize: t.fontSizeSM,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: t.s(4)),
                    SizedBox(
                      width: t.s(48),
                      child: LinearProgressIndicator(
                        value: file.percent / 100,
                        backgroundColor: Colors.white24,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: t.s(2),
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
                  borderRadius: BorderRadius.circular(t.borderRadiusSM),
                ),
                child: Icon(
                  AntIcons.exclamationCircleOutlined,
                  color: Colors.white,
                  size: t.s(24),
                ),
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
        size: t.s(24),
        color: t.colorTextQuaternary,
      ),
    );
  }
}
