/// AntMentions types — 提及组件的类型定义
library;

/// 提及选项（旧模型，自 1.x 起推荐直接用
/// `AntMentions<T>(options: List<T>)` 配合 `labelOf` / `valueOf`）。
@Deprecated('不再需要构造选项模型，直接传 List<T> + labelOf/valueOf；本类将在 2.0 移除')
class AntMentionsOption {
  const AntMentionsOption({
    required this.value,
    this.label,
    this.disabled = false,
  });

  /// 选项值（插入到文本中的内容）
  final String value;

  /// 显示文本（默认与 value 相同）
  final String? label;

  /// 是否禁用
  final bool disabled;

  /// 显示文本
  String get displayLabel => label ?? value;
}

/// 提及组件尺寸
enum AntMentionsSize {
  /// 大号
  large,

  /// 中号（默认）
  middle,

  /// 小号
  small,
}
