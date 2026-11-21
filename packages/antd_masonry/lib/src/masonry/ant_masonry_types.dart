/// AntMasonry 类型定义
library;

/// 瀑布流响应式列数配置。
///
/// 根据容器宽度选择列数，断点与 antd 栅格断点对齐：
/// - xs: < 576
/// - sm: >= 576
/// - md: >= 768
/// - lg: >= 992
/// - xl: >= 1200
/// - xxl: >= 1600
class AntMasonryResponsive {
  const AntMasonryResponsive({
    this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
  });

  /// < 576px 列数。
  final int? xs;

  /// >= 576px 列数。
  final int? sm;

  /// >= 768px 列数。
  final int? md;

  /// >= 992px 列数。
  final int? lg;

  /// >= 1200px 列数。
  final int? xl;

  /// >= 1600px 列数。
  final int? xxl;

  /// 根据容器宽度解析列数。
  ///
  /// 从大到小匹配断点，未匹配时返回 [fallback]。
  int resolve(double width, {int fallback = 3}) {
    if (width >= 1600) return xxl ?? xl ?? lg ?? md ?? sm ?? xs ?? fallback;
    if (width >= 1200) return xl ?? lg ?? md ?? sm ?? xs ?? fallback;
    if (width >= 992) return lg ?? md ?? sm ?? xs ?? fallback;
    if (width >= 768) return md ?? sm ?? xs ?? fallback;
    if (width >= 576) return sm ?? xs ?? fallback;
    return xs ?? fallback;
  }
}