/// AntImageUploader 类型定义
library;

/// 图片上传状态
enum AntImageUploadStatus {
  /// 上传中
  uploading,

  /// 已完成
  done,

  /// 上传失败
  failed,
}

/// 图片上传项
class AntImageUploadItem {
  const AntImageUploadItem({
    required this.url,
    this.status = AntImageUploadStatus.done,
  });

  /// 图片地址
  final String url;

  /// 上传状态
  final AntImageUploadStatus status;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AntImageUploadItem &&
          url == other.url &&
          status == other.status;

  @override
  int get hashCode => Object.hash(url, status);
}