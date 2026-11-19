/// 虚拟键盘/格子输入模型 — NumberKeyboard 族（NumberKeyboard/PasscodeInput/
/// VirtualInput）共用的按键序生成与文本缓冲逻辑。
///
/// P08 拆分时自主包 `data_entry/number_keyboard/ant_number_keyboard.dart`
/// 键盘族共享引擎（antd_keyboard 包内），逻辑与注释保持不变。
library;

import 'dart:math';

/// 数字键盘按键序（1-9），支持乱序。
///
/// 对齐 antd-mobile React NumberKeyboard 的 `randomOrder` 行为。
List<String> buildNumberKeyOrder({bool randomOrder = false}) {
  final digits = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];
  if (randomOrder) {
    final random = Random();
    digits.shuffle(random);
  }
  return digits;
}

/// 键盘输入缓冲 — 受控/非受控两种模式下的按键追加与退格。
///
/// 纯文本逻辑（无 UI 状态），组件层据返回值决定是否 setState。
class KeyboardInputBuffer {
  KeyboardInputBuffer({String initialText = '', this.maxLength})
      : text = initialText;

  /// 当前缓冲文本。
  String text;

  /// 最大输入长度（null 不限制）。
  final int? maxLength;

  /// 按键追加，超长时返回 null（不产生变更）。
  String? append(String key) {
    if (maxLength != null && text.length >= maxLength!) return null;
    return text + key;
  }

  /// 退格，空文本时返回 null（不产生变更）。
  String? backspace() {
    if (text.isEmpty) return null;
    return text.substring(0, text.length - 1);
  }
}
