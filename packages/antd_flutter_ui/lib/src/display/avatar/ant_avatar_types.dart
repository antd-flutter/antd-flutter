/// AntAvatar 类型定义
library;

/// 头像尺寸预设。
enum AntAvatarSize {
  /// 大号 40px
  large,

  /// 默认 32px
  standard,

  /// 小号 24px
  small,
}

/// 头像形状。
enum AntAvatarShape {
  /// 圆形
  circle,

  /// 方形（圆角）
  square,
}

/// 将尺寸预设解析为像素值。
double antAvatarSizeToPx(AntAvatarSize size) {
  switch (size) {
    case AntAvatarSize.large:
      return 40;
    case AntAvatarSize.standard:
      return 32;
    case AntAvatarSize.small:
      return 24;
  }
}