/// AntForm 类型定义
library;

/// 表单布局
enum AntFormLayout {
  /// 水平布局（标签与控件同行）
  horizontal,

  /// 垂直布局（标签在控件上方，默认）
  vertical,

  /// 行内布局
  inline,
}

/// 校验触发时机
enum AntFormValidateTrigger {
  /// 值变化时触发
  onChange,

  /// 仅提交时触发
  onSubmit,
}

/// 字段校验规则
class AntFormFieldRule {
  const AntFormFieldRule({
    this.required = false,
    this.message,
    this.pattern,
    this.min,
    this.max,
    this.minLength,
    this.maxLength,
    this.type = AntFormFieldRuleType.string,
    this.validator,
  });

  /// 创建必填规则
  const AntFormFieldRule.required({this.message})
      : required = true,
        pattern = null,
        min = null,
        max = null,
        minLength = null,
        maxLength = null,
        type = AntFormFieldRuleType.string,
        validator = null;

  /// 是否必填
  final bool required;

  /// 错误提示文案（未通过校验时显示）
  final String? message;

  /// 正则表达式校验（仅对字符串值生效）
  final RegExp? pattern;

  /// 数值最小值（仅对数值类型生效）
  final double? min;

  /// 数值最大值（仅对数值类型生效）
  final double? max;

  /// 字符串最小长度
  final int? minLength;

  /// 字符串最大长度
  final int? maxLength;

  /// 值类型约束
  final AntFormFieldRuleType type;

  /// 自定义校验器，返回错误文案或 null（通过）
  final String? Function(dynamic value)? validator;

  /// 校验单个值，返回错误文案或 null（通过）
  String? validate(dynamic value) {
    if (required) {
      if (_isEmpty(value)) {
        return message ?? '该字段为必填项';
      }
    } else if (_isEmpty(value)) {
      // 非必填且值为空，跳过后续校验
      return null;
    }

    if (value is String) {
      if (pattern != null && !pattern!.hasMatch(value)) {
        return message ?? '格式不正确';
      }
      if (minLength != null && value.length < minLength!) {
        return message ?? '长度不能少于 $minLength 个字符';
      }
      if (maxLength != null && value.length > maxLength!) {
        return message ?? '长度不能超过 $maxLength 个字符';
      }
      if (type == AntFormFieldRuleType.number) {
        final parsed = double.tryParse(value);
        if (parsed == null) {
          return message ?? '请输入数字';
        }
        if (min != null && parsed < min!) {
          return message ?? '不能小于 $min';
        }
        if (max != null && parsed > max!) {
          return message ?? '不能大于 $max';
        }
      }
    }

    if (value is num) {
      if (min != null && value < min!) {
        return message ?? '不能小于 $min';
      }
      if (max != null && value > max!) {
        return message ?? '不能大于 $max';
      }
    }

    if (validator != null) {
      return validator!(value);
    }

    return null;
  }

  bool _isEmpty(dynamic value) {
    if (value == null) return true;
    if (value is String && value.isEmpty) return true;
    if (value is Iterable && value.isEmpty) return true;
    if (value is Map && value.isEmpty) return true;
    return false;
  }
}

/// 字段值类型约束
enum AntFormFieldRuleType {
  /// 字符串（默认）
  string,

  /// 数字（字符串值会被尝试解析）
  number,
}