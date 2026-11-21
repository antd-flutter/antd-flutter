/// AntAutoComplete 类型定义
library;

/// 自动补全尺寸
enum AntAutoCompleteSize {
  /// 大号
  large,

  /// 中号（默认）
  middle,

  /// 小号
  small,
}

/// 自动补全选项（旧模型，自 1.x 起推荐直接用
/// `AntAutoComplete<T>(options: List<T>)` 配合 `labelOf` / `valueOf`）。
@Deprecated('不再需要构造选项模型，直接传 List<T> + labelOf/valueOf；本类将在 2.0 移除')
class AntAutoCompleteOption {
  const AntAutoCompleteOption({
    required this.value,
    this.label,
    this.disabled = false,
  });

  /// 选项值（写入输入框的文本）
  final String value;

  /// 选项显示文案（默认与 value 相同）
  final String? label;

  /// 是否禁用
  final bool disabled;

  /// 显示文案
  String get displayLabel => label ?? value;
}
