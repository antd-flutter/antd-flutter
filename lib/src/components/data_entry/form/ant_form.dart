/// AntForm — antd React Form 的 Flutter 实现
///
/// API 与 antd React Form 对齐：
/// - [controller] — 表单控制器，用于编程式读写值、校验、提交、重置
/// - [initialValues] — 表单初始值
/// - [onFinish] — 校验通过后的提交回调
/// - [onFinishFailed] — 校验失败的回调
/// - [layout] — 表单布局（horizontal/vertical/inline）
/// - [disabled] — 禁用全部表单项
///
/// ```dart
/// AntForm(
///   controller: controller,
///   onFinish: (values) => print(values),
///   children: [
///     AntFormItem<String>(
///       name: 'username',
///       label: '用户名',
///       rules: [AntFormFieldRule.required(message: '请输入用户名')],
///       builder: (field) => AntInput(
///         value: field.value ?? '',
///         onChanged: field.didChange,
///       ),
///     ),
///   ],
/// )
/// ```
library;

import 'package:antd_flutter_plus/src/components/data_entry/form/ant_form_types.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

export 'package:antd_flutter_plus/src/components/data_entry/form/ant_form_types.dart';

// ============================================================
// AntFormController
// ============================================================

/// 表单控制器，管理字段值、错误与校验。
///
/// 通过 [AntForm.controller] 传入表单后，可用它编程式读写字段值、
/// 触发校验、提交或重置表单。
class AntFormController extends ChangeNotifier {
  final Map<String, dynamic> _values = {};
  final Map<String, String?> _errors = {};
  final Map<String, List<AntFormFieldRule>> _rules = {};
  Map<String, dynamic> _initialValues = {};
  VoidCallback? _submitHandler;

  /// 提交表单（触发校验，通过回调 onFinish，失败回调 onFinishFailed）
  void submit() => _submitHandler?.call();

  /// 设置初始值（由 AntForm.initState 调用）
  void _setInitialValues(Map<String, dynamic> values) {
    _initialValues = Map<String, dynamic>.from(values);
  }

  /// 注册字段（由 AntFormItem.didChangeDependencies 调用）
  void _registerField(String name, List<AntFormFieldRule> rules, dynamic initialValue) {
    _rules[name] = rules;
    if (!_values.containsKey(name)) {
      _values[name] = initialValue ?? _initialValues[name];
    }
  }

  /// 注销字段
  void _unregisterField(String name) {
    _rules.remove(name);
  }

  /// 获取字段值
  dynamic getValue(String name) => _values[name];

  /// 获取字段错误文案
  String? getError(String name) => _errors[name];

  /// 设置字段值
  ///
  /// [validate] 为 true 时同步触发该字段校验。
  void setValue(String name, dynamic value, {bool validate = false}) {
    _values[name] = value;
    if (validate) {
      _validateField(name);
    }
    notifyListeners();
  }

  /// 获取全部字段值（副本）
  Map<String, dynamic> getValues() => Map<String, dynamic>.from(_values);

  /// 获取全部错误（仅含未通过的字段）
  Map<String, String> getErrors() {
    final result = <String, String>{};
    _errors.forEach((name, error) {
      if (error != null) result[name] = error;
    });
    return result;
  }

  /// 校验全部字段，返回是否全部通过。
  ///
  /// 校验结果同时写入 [getError]，可通过 [getErrors] 获取。
  Future<bool> validate() async {
    var hasError = false;
    for (final name in _rules.keys) {
      final error = _validateFieldValue(name, _values[name]);
      _errors[name] = error;
      if (error != null) hasError = true;
    }
    notifyListeners();
    return !hasError;
  }

  /// 校验单个字段
  String? _validateField(String name) {
    final error = _validateFieldValue(name, _values[name]);
    _errors[name] = error;
    return error;
  }

  String? _validateFieldValue(String name, dynamic value) {
    for (final rule in _rules[name] ?? const <AntFormFieldRule>[]) {
      final error = rule.validate(value);
      if (error != null) return error;
    }
    return null;
  }

  /// 清除全部错误
  void clearErrors() {
    _errors.clear();
    notifyListeners();
  }

  /// 重置表单（恢复初始值并清除错误）
  void reset() {
    _values
      ..clear()
      ..addAll(_initialValues);
    _errors.clear();
    notifyListeners();
  }

  /// 是否存在校验错误
  bool get hasErrors => _errors.values.any((e) => e != null);
}

// ============================================================
// _FormScope (InheritedWidget)
// ============================================================

class _FormScope extends InheritedWidget {
  const _FormScope({
    required this.controller,
    required this.layout,
    required this.labelWidth,
    required this.disabled,
    required this.submit,
    required super.child,
  });

  final AntFormController controller;
  final AntFormLayout layout;
  final double? labelWidth;
  final bool disabled;
  final VoidCallback submit;

  static _FormScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FormScope>();
  }

  @override
  bool updateShouldNotify(_FormScope oldWidget) {
    return controller != oldWidget.controller ||
        layout != oldWidget.layout ||
        labelWidth != oldWidget.labelWidth ||
        disabled != oldWidget.disabled;
  }
}

// ============================================================
// AntForm
// ============================================================

/// 表单容器组件。
///
/// 通过 [AntFormItem] 组合表单字段，通过 [controller] 管理表单数据。
class AntForm extends StatefulWidget {
  const AntForm({
    super.key,
    this.controller,
    this.initialValues,
    this.onFinish,
    this.onFinishFailed,
    this.layout = AntFormLayout.vertical,
    this.labelWidth,
    this.disabled = false,
    required this.children,
  });

  /// 表单控制器（传入后可通过它编程式操作表单）
  final AntFormController? controller;

  /// 表单初始值
  final Map<String, dynamic>? initialValues;

  /// 校验通过后的提交回调
  final ValueChanged<Map<String, dynamic>>? onFinish;

  /// 校验失败的回调
  final ValueChanged<Map<String, String>>? onFinishFailed;

  /// 表单布局
  final AntFormLayout layout;

  /// 水平布局下标签宽度
  final double? labelWidth;

  /// 是否禁用全部表单项
  final bool disabled;

  /// 表单子项
  final List<Widget> children;

  @override
  State<AntForm> createState() => _AntFormState();

  /// 获取给定 [context] 最近的上层 AntFormController
  static AntFormController? controllerOf(BuildContext context) {
    return _FormScope.of(context)?.controller;
  }
}

class _AntFormState extends State<AntForm> {
  AntFormController? _internalController;

  AntFormController get _controller =>
      widget.controller ?? (_internalController ??= AntFormController());

  @override
  void initState() {
    super.initState();
    _controller._submitHandler = _submit;
    if (widget.initialValues != null) {
      _controller._setInitialValues(widget.initialValues!);
    }
  }

  @override
  void didUpdateWidget(AntForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValues != oldWidget.initialValues &&
        widget.initialValues != null) {
      _controller._setInitialValues(widget.initialValues!);
    }
  }

  Future<void> _submit() async {
    final valid = await _controller.validate();
    if (!mounted) return;
    if (valid) {
      widget.onFinish?.call(_controller.getValues());
    } else {
      widget.onFinishFailed?.call(_controller.getErrors());
    }
  }

  @override
  Widget build(BuildContext context) {
    return _FormScope(
      controller: _controller,
      layout: widget.layout,
      labelWidth: widget.labelWidth,
      disabled: widget.disabled,
      submit: _submit,
      child: widget.layout == AntFormLayout.inline
          ? Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: widget.children,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.children,
            ),
    );
  }
}

// ============================================================
// AntFormField — 传递给 builder 的字段状态
// ============================================================

/// 表单字段状态，通过 [AntFormItem.builder] 传递给表单控件。
class AntFormField<T> {
  const AntFormField({
    required this.value,
    this.errorText,
    required this.didChange,
  });

  /// 当前字段值
  final T? value;

  /// 当前校验错误文案（无错误时为 null）
  final String? errorText;

  /// 更新字段值（触发校验取决于 validateTrigger）
  final ValueChanged<T> didChange;
}

// ============================================================
// AntFormItem
// ============================================================

/// 表单字段组件，包裹单个表单控件并提供标签、校验与错误提示。
///
/// 通过 [builder] 获取字段状态（值/错误），将表单控件与表单数据绑定：
///
/// ```dart
/// AntFormItem<String>(
///   name: 'username',
///   label: '用户名',
///   rules: [AntFormFieldRule.required(message: '请输入用户名')],
///   builder: (field) => AntInput(
///     value: field.value ?? '',
///     onChanged: field.didChange,
///   ),
/// )
/// ```
class AntFormItem<T> extends StatefulWidget {
  const AntFormItem({
    super.key,
    this.name,
    this.label,
    this.rules,
    this.required,
    this.help,
    this.extra,
    this.initialValue,
    this.validateTrigger = AntFormValidateTrigger.onChange,
    required this.builder,
  });

  /// 字段名（注册到表单控制器的键）
  final String? name;

  /// 标签文案
  final String? label;

  /// 校验规则列表
  final List<AntFormFieldRule>? rules;

  /// 是否必填（为 true 时自动添加必填规则并显示星号）
  final bool? required;

  /// 帮助文案（始终显示在控件下方）
  final String? help;

  /// 额外信息（显示在错误/帮助文案下方）
  final String? extra;

  /// 字段初始值
  final T? initialValue;

  /// 校验触发时机
  final AntFormValidateTrigger validateTrigger;

  /// 表单控件构建器
  final Widget Function(AntFormField<T> field) builder;

  @override
  State<AntFormItem<T>> createState() => _AntFormItemState<T>();
}

class _AntFormItemState<T> extends State<AntFormItem<T>> {
  AntFormController? _controller;
  _FormScope? _scope;
  T? _localValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scope = _FormScope.of(context);
    if (scope != _scope) {
      _scope = scope;
      _controller = scope?.controller;
    }
    if (widget.name != null && _controller != null) {
      _controller!._registerField(
        widget.name!,
        _effectiveRules(),
        widget.initialValue,
      );
    }
  }

  @override
  void dispose() {
    if (widget.name != null && _controller != null) {
      _controller!._unregisterField(widget.name!);
    }
    super.dispose();
  }

  List<AntFormFieldRule> _effectiveRules() {
    final rules = <AntFormFieldRule>[...?widget.rules];
    if (widget.required == true && !rules.any((r) => r.required)) {
      rules.insert(
        0,
        AntFormFieldRule.required(message: '请输入${widget.label ?? '该项'}'),
      );
    }
    return rules;
  }

  bool get _isRequired {
    if (widget.required == true) return true;
    return (widget.rules ?? const <AntFormFieldRule>[])
        .any((r) => r.required);
  }

  T? get _currentValue {
    if (widget.name != null && _controller != null) {
      return _controller!.getValue(widget.name!) as T? ?? widget.initialValue;
    }
    return _localValue ?? widget.initialValue;
  }

  String? get _currentError {
    if (widget.name != null && _controller != null) {
      return _controller!.getError(widget.name!);
    }
    return null;
  }

  void _didChange(T value) {
    // 相等性检查：值未变化时跳过，避免 build 期间通知循环
    if (value == _currentValue) return;
    setState(() => _localValue = value);
    if (widget.name != null && _controller != null) {
      _controller!.setValue(
        widget.name!,
        value,
        validate: widget.validateTrigger == AntFormValidateTrigger.onChange,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final scope = _scope;
    final disabled = scope?.disabled ?? false;
    final layout = scope?.layout ?? AntFormLayout.vertical;

    return ListenableBuilder(
      listenable: _controller ?? const _NoListen(),
      builder: (context, _) {
        final field = AntFormField<T>(
          value: _currentValue,
          errorText: _currentError,
          didChange: _didChange,
        );
        final control = widget.builder(field);
        return _buildLayout(
          t: t,
          layout: layout,
          labelWidth: scope?.labelWidth,
          disabled: disabled,
          control: control,
          errorText: _currentError,
        );
      },
    );
  }

  Widget _buildLayout({
    required AntThemeData t,
    required AntFormLayout layout,
    required double? labelWidth,
    required bool disabled,
    required Widget control,
    required String? errorText,
  }) {
    final labelWidget = _buildLabel(t);
    final errorWidget = _buildError(t, errorText);
    final helpWidget = widget.help != null
        ? Padding(
            padding: EdgeInsets.only(top: 4.sp),
            child: Text(
              widget.help!,
              style: TextStyle(
                fontSize: t.fontSizeSM,
                color: t.colorTextTertiary,
              ),
            ),
          )
        : null;
    final extraWidget = widget.extra != null
        ? Padding(
            padding: EdgeInsets.only(top: 4.sp),
            child: Text(
              widget.extra!,
              style: TextStyle(
                fontSize: t.fontSizeSM,
                color: t.colorTextTertiary,
              ),
            ),
          )
        : null;

    final bottomColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (errorWidget != null) errorWidget,
        if (helpWidget != null) helpWidget,
        if (extraWidget != null) extraWidget,
      ],
    );

    if (layout == AntFormLayout.horizontal && labelWidget != null) {
      return Padding(
        padding: EdgeInsets.only(bottom: (errorText != null || widget.help != null) ? 8.sp : 16.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: labelWidth ?? 100.w,
              child: labelWidget,
            ),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                control,
                if (bottomColumn.children.isNotEmpty) bottomColumn,
              ],
            ),),
          ],
        ),
      );
    }

    if (layout == AntFormLayout.inline) {
      return Padding(
        padding: EdgeInsets.only(right: 16.w, bottom: 8.sp),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (labelWidget != null) ...[
              labelWidget,
              SizedBox(width: 8.w),
            ],
            control,
          ],
        ),
      );
    }

    // vertical（默认）
    return Padding(
      padding: EdgeInsets.only(bottom: 16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (labelWidget != null) ...[
            labelWidget,
            SizedBox(height: 8.sp),
          ],
          control,
          if (bottomColumn.children.isNotEmpty) bottomColumn,
        ],
      ),
    );
  }

  Widget? _buildLabel(AntThemeData t) {
    if (widget.label == null) return null;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.sp),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isRequired)
            Padding(
              padding: EdgeInsets.only(right: 4.sp),
              child: Text(
                '*',
                style: TextStyle(
                  fontSize: t.fontSize,
                  color: t.colorError,
                ),
              ),
            ),
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: t.fontSize,
              color: t.colorText,
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildError(AntThemeData t, String? errorText) {
    if (errorText == null) return null;
    return Padding(
      padding: EdgeInsets.only(top: 4.sp),
      child: Text(
        errorText,
        style: TextStyle(
          fontSize: t.fontSizeSM,
          color: t.colorError,
        ),
      ),
    );
  }
}

/// 空监听器（无控制器时使用）
class _NoListen implements Listenable {
  const _NoListen();

  @override
  void addListener(VoidCallback listener) {}

  @override
  void removeListener(VoidCallback listener) {}
}