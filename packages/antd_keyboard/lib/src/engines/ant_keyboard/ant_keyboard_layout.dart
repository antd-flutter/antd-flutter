/// AntKeyboardLayout — 通用屏上键盘布局模型（仿 flutter_onscreen_keyboard
/// `KeyboardLayout`/`KeyboardMode` 设计，MIT，完全仿造改造不引依赖）
///
/// - 按键统一模型 [AntKeyboardKey]：文本键（可带长按变体）与动作键
/// - 预设布局：numeric / decimal / text（QWERTY）/ symbol / email
/// - 自定义布局：直接构造 [AntKeyboardLayout]（rows 任意组合，可扩展新布局）
library;

/// 按键动作类型
enum AntKeyAction {
  /// 文本输入键
  text,

  /// 退格（支持长按连续删除）
  backspace,

  /// 空格
  space,

  /// 确认
  confirm,

  /// 收起键盘
  hide,

  /// 占位（不渲染交互内容）
  none,
}

/// 键盘按键统一模型
class AntKeyboardKey {
  /// 文本输入键（[variants] 为长按备选字符，如字母重音/标点变体）
  const AntKeyboardKey.text(
    this.text, {
    this.variants = const [],
    this.flex = 1,
  }) : action = AntKeyAction.text,
       actionLabel = null;

  /// 动作键
  const AntKeyboardKey.action(
    this.action, {
    this.actionLabel,
    this.flex = 1,
  }) : text = null,
       variants = const [];

  /// 文本键主字符（动作键可为 null，配合 [actionLabel] 显示）
  final String? text;

  /// 动作类型
  final AntKeyAction action;

  /// 动作键显示文本（如 '确定'）
  final String? actionLabel;

  /// 长按备选字符
  final List<String> variants;

  /// 行内宽度权重
  final int flex;

  bool get isBackspace => action == AntKeyAction.backspace;

  bool get hasVariants => variants.isNotEmpty;
}

/// 键盘行
class AntKeyboardRow {
  const AntKeyboardRow(this.keys);
  final List<AntKeyboardKey> keys;
}

/// 键盘布局
class AntKeyboardLayout {
  const AntKeyboardLayout({required this.rows});
  final List<AntKeyboardRow> rows;

  // ----------------------------------------------------------
  // 预设布局
  // ----------------------------------------------------------

  /// 数字键盘（antd-mobile NumberKeyboard 形态；customKey 由调用方传入槽位）
  static AntKeyboardLayout numeric({String? customKey}) => AntKeyboardLayout(
        rows: [
          const AntKeyboardRow([
            AntKeyboardKey.text('1'),
            AntKeyboardKey.text('2'),
            AntKeyboardKey.text('3'),
          ]),
          const AntKeyboardRow([
            AntKeyboardKey.text('4'),
            AntKeyboardKey.text('5'),
            AntKeyboardKey.text('6'),
          ]),
          const AntKeyboardRow([
            AntKeyboardKey.text('7'),
            AntKeyboardKey.text('8'),
            AntKeyboardKey.text('9'),
          ]),
          AntKeyboardRow([
            customKey != null
                ? AntKeyboardKey.text(customKey)
                : const AntKeyboardKey.action(AntKeyAction.hide, flex: 1),
            const AntKeyboardKey.text('0'),
            const AntKeyboardKey.action(AntKeyAction.backspace),
          ]),
        ],
      );

  /// 小数键盘（数字 + 小数点）
  static AntKeyboardLayout decimal() => const AntKeyboardLayout(
        rows: [
          AntKeyboardRow([
            AntKeyboardKey.text('1'),
            AntKeyboardKey.text('2'),
            AntKeyboardKey.text('3'),
          ]),
          AntKeyboardRow([
            AntKeyboardKey.text('4'),
            AntKeyboardKey.text('5'),
            AntKeyboardKey.text('6'),
          ]),
          AntKeyboardRow([
            AntKeyboardKey.text('7'),
            AntKeyboardKey.text('8'),
            AntKeyboardKey.text('9'),
          ]),
          AntKeyboardRow([
            AntKeyboardKey.text('.'),
            AntKeyboardKey.text('0'),
            AntKeyboardKey.action(AntKeyAction.backspace),
          ]),
        ],
      );

  /// 文本键盘（QWERTY 小写，字母长按出重音/备选字符）
  static AntKeyboardLayout text() => const AntKeyboardLayout(
        rows: [
          AntKeyboardRow([
            AntKeyboardKey.text('q'),
            AntKeyboardKey.text('w'),
            AntKeyboardKey.text('e', variants: ['é', 'è', 'ê']),
            AntKeyboardKey.text('r'),
            AntKeyboardKey.text('t'),
            AntKeyboardKey.text('y', variants: ['ý', 'ÿ']),
            AntKeyboardKey.text('u', variants: ['û', 'ù', 'ü']),
            AntKeyboardKey.text('i', variants: ['î', 'ï']),
            AntKeyboardKey.text('o', variants: ['ô', 'ö', 'ò']),
            AntKeyboardKey.text('p'),
          ]),
          AntKeyboardRow([
            AntKeyboardKey.text('a', variants: ['á', 'à', 'â', 'ä']),
            AntKeyboardKey.text('s'),
            AntKeyboardKey.text('d'),
            AntKeyboardKey.text('f'),
            AntKeyboardKey.text('g'),
            AntKeyboardKey.text('h'),
            AntKeyboardKey.text('j'),
            AntKeyboardKey.text('k'),
            AntKeyboardKey.text('l'),
          ]),
          AntKeyboardRow([
            AntKeyboardKey.text('z'),
            AntKeyboardKey.text('x'),
            AntKeyboardKey.text('c', variants: ['ç']),
            AntKeyboardKey.text('v'),
            AntKeyboardKey.text('b'),
            AntKeyboardKey.text('n', variants: ['ñ']),
            AntKeyboardKey.text('m'),
            AntKeyboardKey.action(AntKeyAction.backspace),
          ]),
          AntKeyboardRow([
            AntKeyboardKey.action(AntKeyAction.space, flex: 4),
          ]),
        ],
      );

  /// 符号键盘
  static AntKeyboardLayout symbol() => const AntKeyboardLayout(
        rows: [
          AntKeyboardRow([
            AntKeyboardKey.text('1'),
            AntKeyboardKey.text('2'),
            AntKeyboardKey.text('3'),
            AntKeyboardKey.text('4'),
            AntKeyboardKey.text('5'),
            AntKeyboardKey.text('6'),
            AntKeyboardKey.text('7'),
            AntKeyboardKey.text('8'),
            AntKeyboardKey.text('9'),
            AntKeyboardKey.text('0'),
          ]),
          AntKeyboardRow([
            AntKeyboardKey.text('-'),
            AntKeyboardKey.text('/'),
            AntKeyboardKey.text(':'),
            AntKeyboardKey.text(';'),
            AntKeyboardKey.text('('),
            AntKeyboardKey.text(')'),
            AntKeyboardKey.text('¥'),
            AntKeyboardKey.text('&'),
            AntKeyboardKey.text('@'),
            AntKeyboardKey.text('"'),
          ]),
          AntKeyboardRow([
            AntKeyboardKey.text('.'),
            AntKeyboardKey.text(','),
            AntKeyboardKey.text('?'),
            AntKeyboardKey.text('!'),
            AntKeyboardKey.text("'"),
            AntKeyboardKey.action(AntKeyAction.backspace),
          ]),
        ],
      );

  /// 邮箱键盘（QWERTY + @/. 专用行）
  static AntKeyboardLayout email() => AntKeyboardLayout(
        rows: [
          ...text().rows.take(3),
          const AntKeyboardRow([
            AntKeyboardKey.text('@'),
            AntKeyboardKey.text('.'),
            AntKeyboardKey.action(AntKeyAction.space, flex: 3),
            AntKeyboardKey.action(AntKeyAction.backspace),
          ]),
        ],
      );
}
