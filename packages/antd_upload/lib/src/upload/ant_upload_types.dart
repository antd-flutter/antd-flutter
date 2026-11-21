/// AntUpload 类型定义
library;

/// 上传文件状态
enum AntUploadStatus {
  /// 上传中
  uploading,

  /// 已完成
  done,

  /// 上传失败
  error,

  /// 已移除
  removed,
}

/// 上传列表展示类型
enum AntUploadListType {
  /// 文字列表
  text,

  /// 图片列表
  picture,

  /// 图片卡片
  pictureCard,
}

/// 上传文件信息
class AntUploadFile {
  const AntUploadFile({
    required this.uid,
    required this.name,
    this.status = AntUploadStatus.done,
    this.size,
    this.url,
    this.thumbUrl,
    this.percent = 0,
    this.response,
  });

  /// 唯一标识
  final String uid;

  /// 文件名
  final String name;

  /// 上传状态
  final AntUploadStatus status;

  /// 文件大小（字节）
  final int? size;

  /// 文件下载地址
  final String? url;

  /// 缩略图地址
  final String? thumbUrl;

  /// 上传进度（0-100）
  final int percent;

  /// 服务端响应数据
  final dynamic response;

  /// 复制并修改属性
  AntUploadFile copyWith({
    String? uid,
    String? name,
    AntUploadStatus? status,
    int? size,
    String? url,
    String? thumbUrl,
    int? percent,
    dynamic response,
  }) {
    return AntUploadFile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      status: status ?? this.status,
      size: size ?? this.size,
      url: url ?? this.url,
      thumbUrl: thumbUrl ?? this.thumbUrl,
      percent: percent ?? this.percent,
      response: response ?? this.response,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AntUploadFile &&
          uid == other.uid &&
          name == other.name &&
          status == other.status &&
          size == other.size &&
          url == other.url &&
          thumbUrl == other.thumbUrl &&
          percent == other.percent;

  @override
  int get hashCode =>
      Object.hash(uid, name, status, size, url, thumbUrl, percent);
}

/// 上传进度信息
class AntUploadProgressInfo {
  const AntUploadProgressInfo({
    required this.percent,
    this.loaded,
    this.total,
  });

  /// 进度百分比（0-100）
  final int percent;

  /// 已上传字节数
  final int? loaded;

  /// 总字节数
  final int? total;
}