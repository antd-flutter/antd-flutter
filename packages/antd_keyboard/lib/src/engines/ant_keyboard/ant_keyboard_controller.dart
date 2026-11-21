import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// 键盘文本绑定：把 [AntKeyboardController] 连接到真实的
/// [TextEditingController] / [FocusNode]。
///
/// 设计吸收自 `flutter_onscreen_keyboard` 的 `OnscreenKeyboardController`
/// 与 field state 绑定：软键盘不再只回调字符串，而是直接在光标/选区处编辑
/// 文本，支持 inputFormatters、`enter` 提交/换行、`tab` 插入、emoji 退格。
@immutable
class AntKeyboardFieldBinding {
  const AntKeyboardFieldBinding({
    required this.controller,
    this.focusNode,
    this.maxLines = 1,
    this.inputFormatters = const [],
    this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final int maxLines;
  final List<TextInputFormatter> inputFormatters;
  final ValueChanged<String>? onChanged;
}

/// 通用键盘控制器 — 修饰键 / 模式 / 文本绑定 / 物理键盘协作。
///
/// 保持无外部依赖即可使用：不传 [AntKeyboard.controller] 时键盘内部自建一个，
/// 传入后可由业务侧驱动 Shift/CapsLock、切换模式、或绑定输入框。
class AntKeyboardController extends ChangeNotifier {
  AntKeyboardController({String? initialMode, bool capsLock = false})
      : _modeName = initialMode,
        _capsOn = capsLock;

  String? _modeName;
  bool _shiftOn = false;
  bool _capsOn = false;
  AntKeyboardFieldBinding? _binding;
  bool _disposed = false;

  /// 当前模式名（null 表示使用布局默认模式）。
  String? get modeName => _modeName;

  /// Shift 是否按下（一次性修饰）。
  bool get shiftOn => _shiftOn;

  /// CapsLock 是否开启（持久修饰）。
  bool get capsOn => _capsOn;

  /// 是否输出大写/副字符。
  ///
  /// 与参考库一致采用 XOR：Shift 与 CapsLock 同时开启时回到小写，
  /// 和物理键盘行为一致。
  bool get shiftActive => _shiftOn != _capsOn;

  /// 当前绑定的输入框（未绑定时为 null）。
  AntKeyboardFieldBinding? get binding => _binding;
  TextEditingController? get textController => _binding?.controller;
  FocusNode? get focusNode => _binding?.focusNode;

  /// 是否已绑定真实输入框。
  bool get hasAttachedField => _binding != null;

  /// 绑定输入框；绑定后文本键直接编辑该 controller。
  void attach({
    required TextEditingController controller,
    FocusNode? focusNode,
    int maxLines = 1,
    List<TextInputFormatter> inputFormatters = const [],
    ValueChanged<String>? onChanged,
  }) {
    _binding = AntKeyboardFieldBinding(
      controller: controller,
      focusNode: focusNode,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
    );
    _notify();
  }

  /// 兼容参考库命名。
  void attachTextField(
    TextEditingController controller, {
    FocusNode? focusNode,
    int maxLines = 1,
    List<TextInputFormatter> inputFormatters = const [],
    ValueChanged<String>? onChanged,
  }) {
    attach(
      controller: controller,
      focusNode: focusNode,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
    );
  }

  /// 解绑输入框。
  void detachTextField() {
    if (_binding == null) return;
    _binding = null;
    _notify();
  }

  /// 在光标/选区处插入文本；未绑定输入框时返回 false。
  bool insert(String text) {
    final binding = _binding;
    if (binding == null || text.isEmpty) return false;
    final controller = binding.controller;
    var value = controller.value;
    var start = value.selection.start;
    var end = value.selection.end;
    if (start < 0 || end < 0) {
      start = end = value.text.length;
    }
    if (start > end) {
      final tmp = start;
      start = end;
      end = tmp;
    }
    var inserted = text;
    for (final formatter in binding.inputFormatters) {
      inserted = formatter
          .formatEditUpdate(
            TextEditingValue.empty,
            TextEditingValue(text: inserted),
          )
          .text;
    }
    if (inserted.isEmpty) return false;
    final nextText = value.text.replaceRange(start, end, inserted);
    final next = TextEditingValue(
      text: nextText,
      selection: TextSelection.collapsed(offset: start + inserted.length),
      composing: TextRange.empty,
    );
    if (next == value) return false;
    controller.value = next;
    binding.onChanged?.call(nextText);
    return true;
  }

  /// 退格：有选区删选区，否则删光标前一个「字素」（emoji 不会被拦腰截断）。
  bool backspace() {
    final binding = _binding;
    if (binding == null) return false;
    final controller = binding.controller;
    final value = controller.value;
    var start = value.selection.start;
    var end = value.selection.end;
    if (!value.selection.isValid) {
      start = end = value.text.length;
    }
    if (start > end) {
      final tmp = start;
      start = end;
      end = tmp;
    }
    if (start == end) {
      if (start == 0) return false;
      final left = value.text.substring(0, start);
      final grapheme = left.characters.last;
      start -= grapheme.length;
    }
    final nextText = value.text.replaceRange(start, end, '');
    final next = TextEditingValue(
      text: nextText,
      selection: TextSelection.collapsed(offset: start),
      composing: TextRange.empty,
    );
    controller.value = next;
    binding.onChanged?.call(nextText);
    return true;
  }

  /// 回车：单行输入框失焦提交，多行插入换行。
  void newline() {
    final binding = _binding;
    if (binding == null) return;
    if (binding.maxLines > 1) {
      insert('\n');
    } else {
      binding.focusNode?.unfocus();
    }
  }

  /// 制表符。
  void tab() => insert('\t');

  /// 设置模式，非法模式名忽略。
  void setMode(String? name) {
    if (_modeName == name) return;
    _modeName = name;
    _notify();
  }

  /// 在给定模式列表里切换到下一个（首个为默认时自动跳过）。
  String? cycleMode(List<String> names) {
    if (names.isEmpty) return null;
    final current = _modeName ?? names.first;
    final index = names.indexOf(current);
    final next = names[(index < 0 ? 0 : index + 1) % names.length];
    setMode(next);
    return next;
  }

  /// 切换 Shift（一次性）。
  void toggleShift() {
    _shiftOn = !_shiftOn;
    _notify();
  }

  /// 切换 CapsLock（持久）。
  void toggleCaps() {
    _capsOn = !_capsOn;
    _notify();
  }

  /// 输入一个字符后复位一次性 Shift。
  void consumeShift() {
    if (!_shiftOn) return;
    _shiftOn = false;
    _notify();
  }

  /// 清空所有修饰态。
  void resetModifiers() {
    if (!_shiftOn && !_capsOn) return;
    _shiftOn = false;
    _capsOn = false;
    _notify();
  }

  void _notify() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
