/// AntInputField — 输入族共享的基础字段（TextFormField 封装）
///
/// 参考 antd Input 规范与 zino_ui ZinoTextFormField 的实现方式：
/// - 单一 TextFormField 承载边框/填充/hover/禁用/校验态，显式覆盖全局
///   `inputDecorationTheme`，杜绝主题默认样式渗入（如禁用态 hover 局部填充、双边框）
/// - `standalone` 模式：字段自绘边框与填充（AntInput / AntInputTextArea 使用）
/// - `embedded` 模式：无边框无填充，由外层容器统一绘制（Stepper / InputNumber /
///   SearchBar / PasscodeInput 桌面态 / VirtualInput 桌面态使用）
///
/// 内部共享组件，不进 barrel 导出。
library;

import 'package:antd_flutter_ui/src/data_entry/input/ant_input_types.dart';
import 'package:antd_theme/antd_theme.dart';
// 项目约定：material 系组件统一经 material_ui（vendored material）引入，
// 与主包其它组件保持同一类系，避免跨 Material 类系查找失败
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// 根据尺寸获取高度
double antFieldHeightOf(AntThemeData t, AntInputSize size) {
  switch (size) {
    case AntInputSize.large:
      return t.controlHeightLG;
    case AntInputSize.middle:
      return t.controlHeight;
    case AntInputSize.small:
      return t.controlHeightSM;
  }
}

/// 根据尺寸获取字号
double antFieldFontSizeOf(AntThemeData t, AntInputSize size) {
  switch (size) {
    case AntInputSize.large:
      return t.fontSizeLG;
    case AntInputSize.middle:
      return t.fontSize;
    case AntInputSize.small:
      return t.fontSizeSM;
  }
}

/// 根据状态获取边框色
Color antFieldBorderColorOf(
  AntThemeData t,
  AntInputStatus status, {
  bool focused = false,
}) {
  switch (status) {
    case AntInputStatus.error:
      return t.colorError;
    case AntInputStatus.warning:
      return t.colorWarning;
    case AntInputStatus.normal:
      return focused ? t.colorPrimary : t.colorBorder;
  }
}

class AntInputField extends StatelessWidget {
  const AntInputField({
    super.key,
    this.size = AntInputSize.middle,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction,
    this.placeholder,
    this.prefix,
    this.suffix,
    this.status = AntInputStatus.normal,
    this.mode = AntInputFieldMode.standalone,
    this.bordered = true,
    this.contentPadding,
    this.minLines = 1,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
  });

  /// 尺寸。
  final AntInputSize size;

  final TextEditingController? controller;
  final FocusNode? focusNode;

  /// 是否启用（false = 禁用态：填充色/光标/鼠标样式联动）。
  final bool enabled;

  final bool readOnly;
  final bool obscureText;
  final int? maxLength;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  /// 键盘动作按钮（如 TextInputAction.search）。
  final TextInputAction? textInputAction;
  final String? placeholder;

  /// 前缀（置于字段内部，带标准水平内边距）。
  final Widget? prefix;

  /// 后缀（置于字段内部，带标准水平内边距）。
  final Widget? suffix;

  /// 校验状态。
  final AntInputStatus status;

  /// 呈现模式。
  final AntInputFieldMode mode;

  /// standalone 模式下是否绘制边框（false = 无边框变体）。
  final bool bordered;

  /// 覆盖内容内边距（embedded 模式常用 EdgeInsets.zero）。
  final EdgeInsetsGeometry? contentPadding;

  final int minLines;
  final int? maxLines;
  final TextAlign textAlign;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  /// 回车提交回调。
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final height = antFieldHeightOf(t, size);
    final fontSize = antFieldFontSizeOf(t, size).sp;
    final standalone = mode == AntInputFieldMode.standalone;

    final radius = BorderRadius.circular(t.borderRadius.w);
    InputBorder borderOf(Color color, {double width = 1}) =>
        OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: color, width: width));
    const noneBorder = InputBorder.none;

    // 边框色：standalone 自绘；embedded 一律 none
    final idleColor = antFieldBorderColorOf(t, status);
    final focusColor = antFieldBorderColorOf(t, status, focused: true);
    final disabledColor = t.colorBorder;

    InputBorder border;
    InputBorder enabledBorder;
    InputBorder focusedBorder;
    InputBorder disabledBorder;
    InputBorder errorBorder;
    InputBorder focusedErrorBorder;
    if (!standalone || !bordered) {
      border = noneBorder;
      enabledBorder = noneBorder;
      focusedBorder = noneBorder;
      disabledBorder = noneBorder;
      errorBorder = noneBorder;
      focusedErrorBorder = noneBorder;
    } else {
      // antd 规范：1px 边框，聚焦主色加粗（模拟 focus ring）
      border = borderOf(idleColor);
      enabledBorder = borderOf(idleColor);
      focusedBorder = borderOf(focusColor, width: 2);
      disabledBorder = borderOf(disabledColor);
      errorBorder = borderOf(t.colorError);
      focusedErrorBorder = borderOf(t.colorError, width: 2);
      if (status == AntInputStatus.warning) {
        errorBorder = borderOf(t.colorWarning);
        focusedErrorBorder = borderOf(t.colorWarning, width: 2);
      }
    }

    final fillColor = enabled ? t.colorBgContainer : t.colorBgContainerDisabled;

    final decoration = InputDecoration(
      // 显式全状态覆盖，防止全局 inputDecorationTheme（filled/hoverColor/outline）渗入
      isDense: true,
      filled: standalone,
      fillColor: fillColor,
      // 禁用/悬浮不产生局部填充高亮（修复禁用态 hover 只显示一部分的问题）
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      border: border,
      enabledBorder: enabledBorder,
      focusedBorder: focusedBorder,
      disabledBorder: disabledBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: focusedErrorBorder,
      counterText: '',
      hintText: placeholder,
      hintStyle: TextStyle(fontSize: fontSize, color: t.colorTextPlaceholder),
      contentPadding: contentPadding ??
          EdgeInsets.symmetric(
            horizontal: t.marginSM.w,
            vertical: (height - fontSize) / 2,
          ),
      prefixIcon: prefix != null
          ? _FieldSlot(
              height: height,
              isLeading: true,
              child: prefix!,
            )
          : null,
      prefixIconConstraints: BoxConstraints(minHeight: height.w, minWidth: 0),
      suffixIcon: suffix != null
          ? _FieldSlot(
              height: height,
              isLeading: false,
              child: suffix!,
            )
          : null,
      suffixIconConstraints: BoxConstraints(minHeight: height.w, minWidth: 0),
    );

    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscureText,
      maxLength: maxLength,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      autofocus: autofocus,
      minLines: minLines,
      maxLines: maxLines,
      textAlign: textAlign,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(
        fontSize: fontSize,
        color: enabled ? t.colorText : t.colorTextDisabled,
      ),
      cursorColor: t.colorPrimary,
      mouseCursor: !enabled
          ? SystemMouseCursors.basic
          : readOnly
              ? SystemMouseCursors.basic
              : SystemMouseCursors.text,
      decoration: decoration,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      // 点击字段外部统一失焦（与 antd 行为一致；桌面端系统键盘同样适用）
      onTapOutside: (_) => focusNode?.unfocus(),
    );
  }
}

/// 字段内部前/后缀槽位（标准水平内边距 + 垂直居中）
class _FieldSlot extends StatelessWidget {
  const _FieldSlot({
    required this.child,
    required this.height,
    required this.isLeading,
  });

  final Widget child;
  final double height;
  final bool isLeading;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: isLeading ? t.marginSM.w : t.marginXS.w,
        right: isLeading ? t.marginXS.w : t.marginSM.w,
      ),
      child: child,
    );
  }
}

/// 字段呈现模式
enum AntInputFieldMode {
  /// 字段自绘边框与填充（AntInput / AntInputTextArea）
  standalone,

  /// 无边框无填充，由外层容器统一绘制（Stepper / InputNumber / SearchBar 等）
  embedded,
}
