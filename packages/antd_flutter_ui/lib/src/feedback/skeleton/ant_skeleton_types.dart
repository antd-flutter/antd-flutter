/// AntSkeleton 类型定义 — 对齐 antd React Skeleton 的配置项
library;

/// 骨架屏头像配置。
class AntSkeletonAvatar {
  const AntSkeletonAvatar({
    this.show = true,
    this.size,
    this.shape = AntSkeletonAvatarShape.circle,
  });

  /// 是否显示头像占位。
  final bool show;

  /// 头像尺寸（像素，未设置时按组件默认值）。
  final double? size;

  /// 头像形状。
  final AntSkeletonAvatarShape shape;
}

/// 骨架屏头像形状。
enum AntSkeletonAvatarShape { circle, square }

/// 骨架屏标题行配置。
class AntSkeletonTitle {
  const AntSkeletonTitle({this.show = true, this.width});

  /// 是否显示标题占位。
  final bool show;

  /// 标题行宽度（逻辑像素或比例 0~1，null 时使用默认值）。
  final double? width;
}

/// 骨架屏段落配置。
class AntSkeletonParagraph {
  const AntSkeletonParagraph({this.show = true, this.rows = 3, this.width});

  /// 是否显示段落占位。
  final bool show;

  /// 段落行数。
  final int rows;

  /// 每行宽度（与 [rows] 等长的列表，或单值；null 时使用默认宽度策略）。
  final Object? width;
}
