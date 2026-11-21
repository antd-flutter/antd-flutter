/// R37 热键绑定模型 — 快捷键组合 + 触发回调 + 触发条件。
///
/// 组合 = 按键集合（[keys]）+ 修饰键状态（[modifiers]，精确匹配）。
/// `Ctrl+S` 即 `keys: {keyS} + modifiers: {ctrl}`；多键组合（如 `Shift+Esc`）
/// [keys] 可含多个按键，分发时要求非修饰键的按下集合与之完全一致。
library;

import 'package:flutter/services.dart';

/// 修饰键。
enum AntHotkeyModifier { ctrl, alt, shift, meta }

/// 一组快捷键组合（按键集合 + 修饰键集合），支持相等比较用于冲突检测。
class AntHotkeyCombo {
  const AntHotkeyCombo(this.keys, this.modifiers);

  /// 非修饰键集合。
  final Set<LogicalKeyboardKey> keys;

  /// 修饰键集合。
  final Set<AntHotkeyModifier> modifiers;

  @override
  bool operator ==(Object other) {
    if (other is! AntHotkeyCombo) return false;
    return other.keys.length == keys.length &&
        other.keys.containsAll(keys) &&
        other.modifiers.length == modifiers.length &&
        other.modifiers.containsAll(modifiers);
  }

  @override
  int get hashCode => Object.hash(Object.hashAllUnordered(keys),
      Object.hashAllUnordered(modifiers),);

  @override
  String toString() {
    final mods = modifiers.map((m) => m.name).join('+');
    final keyLabels =
        keys.map((k) => k.keyLabel.isEmpty ? k.debugName ?? '?' : k.keyLabel);
    return [if (mods.isNotEmpty) mods, ...keyLabels].join('+');
  }
}

/// 单条热键绑定。
///
/// ```dart
/// AntHotkeyBinding(
///   keys: {LogicalKeyboardKey.escape},
///   ignoreWithinEditable: false, // 控制键：输入框聚焦内仍触发
///   onTrigger: close,
/// )
/// ```
class AntHotkeyBinding {
  const AntHotkeyBinding({
    required this.keys,
    this.modifiers = const {},
    required this.onTrigger,
    this.when,
    this.ignoreWithinEditable = true,
    this.transient = false,
    this.debugLabel,
  });

  /// 快捷键（非修饰键）。组合匹配时按键集合要求精确一致。
  final Set<LogicalKeyboardKey> keys;

  /// 修饰键（ctrl/alt/shift/meta），精确匹配——绑定了 shift 则必须按住 shift。
  final Set<AntHotkeyModifier> modifiers;

  /// 组合命中时触发。
  final VoidCallback onTrigger;

  /// 额外触发条件（如「弹层打开时才生效」）；null 表示无条件。
  final bool Function()? when;

  /// 输入框（EditableText）聚焦时是否忽略本绑定（默认 true）。
  ///
  /// 为 true 时若焦点位于可编辑文本内则不触发（字母类热键防止打字误触）；
  /// 控制键类绑定（Esc 等）建议传 false，输入框内仍可触发。
  final bool ignoreWithinEditable;

  /// 是否为临时绑定（弹层打开期间注册、关闭即注销，如 Esc 关闭）。
  ///
  /// 临时绑定参与 LIFO 分发（后注册先命中，弹层栈顶优先），
  /// 但**不参与**冲突检测——同一时刻多个弹层各自注册 Esc 属预期行为。
  final bool transient;

  /// 调试标签（冲突警告中标识绑定来源）。
  final String? debugLabel;

  /// 本绑定的组合。
  AntHotkeyCombo get combo => AntHotkeyCombo(keys, modifiers);

  /// 是否包含字符类按键（字母/数字/符号/空格）——输入框聚焦内默认跳过的类别。
  bool get containsCharacterKey => keys.any(_isCharacterKey);

  /// 当前按下状态是否命中本组合。
  ///
  /// [pressedKeys]：当前所有按下键（HardwareKeyboard.logicalKeysPressed）；
  /// [modifiers]：当前生效的修饰键集合。
  bool matches(Set<LogicalKeyboardKey> pressedKeys,
      Set<AntHotkeyModifier> modifiers,) {
    if (modifiers.length != this.modifiers.length) return false;
    if (!this.modifiers.containsAll(modifiers)) return false;
    final nonModifierPressed =
        pressedKeys.where((k) => !_isModifierKey(k)).toSet();
    if (nonModifierPressed.length != keys.length) return false;
    return nonModifierPressed.containsAll(keys);
  }
}

/// 判断按键是否为修饰键。
bool _isModifierKey(LogicalKeyboardKey key) {
  final modifierSet = <LogicalKeyboardKey>{
    LogicalKeyboardKey.controlLeft,
    LogicalKeyboardKey.controlRight,
    LogicalKeyboardKey.control,
    LogicalKeyboardKey.altLeft,
    LogicalKeyboardKey.altRight,
    LogicalKeyboardKey.alt,
    LogicalKeyboardKey.shiftLeft,
    LogicalKeyboardKey.shiftRight,
    LogicalKeyboardKey.shift,
    LogicalKeyboardKey.metaLeft,
    LogicalKeyboardKey.metaRight,
    LogicalKeyboardKey.meta,
  };
  return modifierSet.contains(key);
}

/// 从当前按下键集合解析生效的修饰键。
Set<AntHotkeyModifier> resolveActiveModifiers(
    Set<LogicalKeyboardKey> pressedKeys,) {
  bool any(List<LogicalKeyboardKey> keys) =>
      pressedKeys.any(keys.contains);
  return {
    if (any(const [
      LogicalKeyboardKey.controlLeft,
      LogicalKeyboardKey.controlRight,
      LogicalKeyboardKey.control,
    ]))
      AntHotkeyModifier.ctrl,
    if (any(const [
      LogicalKeyboardKey.altLeft,
      LogicalKeyboardKey.altRight,
      LogicalKeyboardKey.alt,
    ]))
      AntHotkeyModifier.alt,
    if (any(const [
      LogicalKeyboardKey.shiftLeft,
      LogicalKeyboardKey.shiftRight,
      LogicalKeyboardKey.shift,
    ]))
      AntHotkeyModifier.shift,
    if (any(const [
      LogicalKeyboardKey.metaLeft,
      LogicalKeyboardKey.metaRight,
      LogicalKeyboardKey.meta,
    ]))
      AntHotkeyModifier.meta,
  };
}

/// 是否为字符类按键（keyLabel 为单字符：字母/数字/符号/空格）。
/// Esc/Enter/Tab/方向键/F 键等控制键 label 为多字符或空，返回 false。
bool _isCharacterKey(LogicalKeyboardKey key) {
  final label = key.keyLabel;
  return label.length == 1;
}
