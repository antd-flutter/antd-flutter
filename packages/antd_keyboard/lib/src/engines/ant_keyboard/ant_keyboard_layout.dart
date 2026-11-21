/// AntKeyboardLayout — 通用屏上键盘布局模型（仿 flutter_onscreen_keyboard
/// `KeyboardLayout`/`KeyboardMode` 设计，MIT，完全仿造改造不引依赖）
///
/// - 按键统一模型 [AntKeyboardKey]：文本键（主字符 + 副字符 secondary +
///   长按变体 variants）与动作键（shift/capslock/modeSwitch/enter/tab 等）
/// - **多模式布局**：[AntKeyboardLayout.modes]（如 letters/symbols），
///   经 modeSwitch 动作键循环切换；单模式布局 `rows` 直接构造
/// - 预设布局：numeric / decimal / text（多模式 QWERTY+符号）/ symbol /
///   email / qwertyDesktop（完整桌面 QWERTY）
/// - 自定义布局：直接构造 [AntKeyboardLayout]（rows 或 modes，可扩展新布局）
library;

import 'package:material_ui/material_ui.dart';

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

  /// Shift（一次性大写/副字符，输入后自动复位）
  shift,

  /// CapsLock（持久大写/副字符锁定）
  capslock,

  /// 布局模式切换（循环 modes）
  modeSwitch,

  /// 回车/换行
  enter,

  /// Tab（仅触发 onKey，由调用方决定语义）
  tab,

  /// 占位（不渲染交互内容）
  none,
}

/// 键盘按键统一模型
class AntKeyboardKey {
  /// 文本输入键
  ///
  /// - [secondary]：副字符（Shift/CapsLock 激活时输出，如数字行 `1`→`!`）
  /// - [variants]：长按备选字符（如字母重音）
  const AntKeyboardKey.text(
    this.text, {
    this.secondary,
    this.variants = const [],
    this.flex = 1,
  })  : action = AntKeyAction.text,
        actionLabel = null,
        canHold = false;

  /// 动作键
  const AntKeyboardKey.action(
    this.action, {
    this.actionLabel,
    this.flex = 1,
    this.canHold = false,
  })  : text = null,
        secondary = null,
        variants = const [];

  /// 文本键主字符（动作键可为 null，配合 [actionLabel] 显示）
  final String? text;

  /// 副字符（Shift/CapsLock 激活时优先于主字符输出）
  final String? secondary;

  /// 动作类型
  final AntKeyAction action;

  /// 动作键显示文本（如 '确定'）
  final String? actionLabel;

  /// 长按备选字符
  final List<String> variants;

  /// 行内宽度权重
  final int flex;

  /// 是否支持按住持续触发（参考库 canHold；当前用于退格连删语义标记）
  final bool canHold;

  bool get isBackspace => action == AntKeyAction.backspace;

  bool get hasVariants => variants.isNotEmpty;
}

/// 键盘行
///
/// [leading] / [trailing] 对齐参考库 `KeyboardRow`：在按键序列两端插入固定
/// 宽度的附加组件（如桌面端的拖拽把手、左侧功能列），按键本身仍按 flex 平分。
class AntKeyboardRow {
  const AntKeyboardRow(
    this.keys, {
    this.leading,
    this.trailing,
  });

  final List<AntKeyboardKey> keys;
  final Widget? leading;
  final Widget? trailing;
}

/// 键盘布局
class AntKeyboardLayout {
  /// 单模式布局
  const AntKeyboardLayout({required List<AntKeyboardRow> rows})
      : this._(rows: rows);

  /// 多模式布局（参考库 KeyboardMode 设计）：modeSwitch 动作键循环切换
  const AntKeyboardLayout.modes(
    Map<String, List<AntKeyboardRow>> modes, {
    String? initialModeName,
  }) : this._(
          rows: const [],
          modes: modes,
          initialMode: initialModeName,
        );

  const AntKeyboardLayout._({
    required this.rows,
    this.modes,
    this.initialMode,
  });

  /// 单模式行（多模式布局返回初始模式行）
  final List<AntKeyboardRow> rows;

  /// 多模式注册表（null = 单模式）
  final Map<String, List<AntKeyboardRow>>? modes;

  /// 初始模式名
  final String? initialMode;

  /// 数字键盘（antd-mobile NumberKeyboard 形态；customKey 由调用方传入槽位）
  static AntKeyboardLayout numeric({String? customKey}) => AntKeyboardLayout(
        rows: [
          const AntKeyboardRow(_digits123),
          const AntKeyboardRow(_digits456),
          const AntKeyboardRow(_digits789),
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
          AntKeyboardRow(_digits123),
          AntKeyboardRow(_digits456),
          AntKeyboardRow(_digits789),
          AntKeyboardRow([
            AntKeyboardKey.text('.'),
            AntKeyboardKey.text('0'),
            AntKeyboardKey.action(AntKeyAction.backspace),
          ]),
        ],
      );

  /// 文本键盘（多模式：letters/symbols，参考库 MobileKeyboardLayout 设计）
  ///
  /// - letters：QWERTY 小写（Shift/CapsLock 大写，字母长按出重音）
  /// - symbols：数字行（Shift 出符号）+ 符号行 + 切换/空格/回车
  static AntKeyboardLayout text() => AntKeyboardLayout.modes(
        {
          'letters': _lettersMode(),
          'symbols': _symbolsBarMode(),
        },
      );

  /// 符号键盘（单模式全量符号）
  static AntKeyboardLayout symbol() => const AntKeyboardLayout(
        rows: [
          AntKeyboardRow([
            AntKeyboardKey.text('1', secondary: '~'),
            AntKeyboardKey.text('2', secondary: '`'),
            AntKeyboardKey.text('3', secondary: '|'),
            AntKeyboardKey.text('4', secondary: '•'),
            AntKeyboardKey.text('5', secondary: '√'),
            AntKeyboardKey.text('6', secondary: 'π'),
            AntKeyboardKey.text('7', secondary: '÷'),
            AntKeyboardKey.text('8', secondary: '×'),
            AntKeyboardKey.text('9', secondary: '§'),
            AntKeyboardKey.text('0', secondary: '∆'),
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
          ..._lettersMode().take(3),
          const AntKeyboardRow([
            AntKeyboardKey.text('@'),
            AntKeyboardKey.text('.'),
            AntKeyboardKey.action(AntKeyAction.space, flex: 3),
            AntKeyboardKey.action(AntKeyAction.backspace),
          ]),
        ],
      );

  /// 完整桌面 QWERTY（参考库 DesktopKeyboardLayout 设计，MIT 吸收）：
  /// 数字行（secondary 符号）/ Tab 行 / CapsLock 行 / Shift 行 / 空格+Enter 行
  static AntKeyboardLayout qwertyDesktop() => const AntKeyboardLayout(
        rows: [
          AntKeyboardRow([
            AntKeyboardKey.text('`', secondary: '~'),
            AntKeyboardKey.text('1', secondary: '!'),
            AntKeyboardKey.text('2', secondary: '@'),
            AntKeyboardKey.text('3', secondary: '#'),
            AntKeyboardKey.text('4', secondary: r'$'),
            AntKeyboardKey.text('5', secondary: '%'),
            AntKeyboardKey.text('6', secondary: '^'),
            AntKeyboardKey.text('7', secondary: '&'),
            AntKeyboardKey.text('8', secondary: '*'),
            AntKeyboardKey.text('9', secondary: '('),
            AntKeyboardKey.text('0', secondary: ')'),
            AntKeyboardKey.text('-', secondary: '_'),
            AntKeyboardKey.text('=', secondary: '+'),
            AntKeyboardKey.action(AntKeyAction.backspace, flex: 2),
          ]),
          AntKeyboardRow([
            AntKeyboardKey.action(AntKeyAction.tab, flex: 2),
            AntKeyboardKey.text('q'),
            AntKeyboardKey.text('w'),
            AntKeyboardKey.text('e'),
            AntKeyboardKey.text('r'),
            AntKeyboardKey.text('t'),
            AntKeyboardKey.text('y'),
            AntKeyboardKey.text('u'),
            AntKeyboardKey.text('i'),
            AntKeyboardKey.text('o'),
            AntKeyboardKey.text('p'),
            AntKeyboardKey.text('[', secondary: '{'),
            AntKeyboardKey.text(']', secondary: '}'),
            AntKeyboardKey.text(r'\', secondary: '|'),
          ]),
          AntKeyboardRow([
            AntKeyboardKey.action(AntKeyAction.capslock, flex: 2),
            AntKeyboardKey.text('a', variants: ['á', 'à', 'â', 'ä']),
            AntKeyboardKey.text('s'),
            AntKeyboardKey.text('d'),
            AntKeyboardKey.text('f'),
            AntKeyboardKey.text('g'),
            AntKeyboardKey.text('h'),
            AntKeyboardKey.text('j'),
            AntKeyboardKey.text('k'),
            AntKeyboardKey.text('l'),
            AntKeyboardKey.text(';', secondary: ':'),
            AntKeyboardKey.text("'", secondary: '"'),
            AntKeyboardKey.action(AntKeyAction.enter, flex: 2),
          ]),
          AntKeyboardRow([
            AntKeyboardKey.action(AntKeyAction.shift, flex: 3),
            AntKeyboardKey.text('z'),
            AntKeyboardKey.text('x'),
            AntKeyboardKey.text('c', variants: ['ç']),
            AntKeyboardKey.text('v'),
            AntKeyboardKey.text('b'),
            AntKeyboardKey.text('n', variants: ['ñ']),
            AntKeyboardKey.text('m'),
            AntKeyboardKey.text(',', secondary: '<'),
            AntKeyboardKey.text('.', secondary: '>'),
            AntKeyboardKey.text('/', secondary: '?'),
            AntKeyboardKey.action(AntKeyAction.backspace, flex: 3),
          ]),
          AntKeyboardRow([
            AntKeyboardKey.action(AntKeyAction.space, flex: 8),
          ]),
        ],
      );

  // ----------------------------------------------------------
  // 内部：模式行构建
  // ----------------------------------------------------------

  static const List<AntKeyboardKey> _digits123 = [
    AntKeyboardKey.text('1', secondary: '!'),
    AntKeyboardKey.text('2', secondary: '@'),
    AntKeyboardKey.text('3', secondary: '#'),
  ];

  static const List<AntKeyboardKey> _digits456 = [
    AntKeyboardKey.text('4', secondary: r'$'),
    AntKeyboardKey.text('5', secondary: '%'),
    AntKeyboardKey.text('6', secondary: '^'),
  ];

  static const List<AntKeyboardKey> _digits789 = [
    AntKeyboardKey.text('7', secondary: '&'),
    AntKeyboardKey.text('8', secondary: '*'),
    AntKeyboardKey.text('9', secondary: '('),
  ];

  /// 字母模式（Shift/CapsLock 大写 + modeSwitch 切符号）
  static List<AntKeyboardRow> _lettersMode() => [
        const AntKeyboardRow([
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
        const AntKeyboardRow([
          AntKeyboardKey.action(AntKeyAction.none, flex: 1),
          AntKeyboardKey.text('a', variants: ['á', 'à', 'â', 'ä']),
          AntKeyboardKey.text('s'),
          AntKeyboardKey.text('d'),
          AntKeyboardKey.text('f'),
          AntKeyboardKey.text('g'),
          AntKeyboardKey.text('h'),
          AntKeyboardKey.text('j'),
          AntKeyboardKey.text('k'),
          AntKeyboardKey.text('l'),
          AntKeyboardKey.action(AntKeyAction.none, flex: 1),
        ]),
        const AntKeyboardRow([
          AntKeyboardKey.action(AntKeyAction.capslock, flex: 2),
          AntKeyboardKey.text('z'),
          AntKeyboardKey.text('x'),
          AntKeyboardKey.text('c', variants: ['ç']),
          AntKeyboardKey.text('v'),
          AntKeyboardKey.text('b'),
          AntKeyboardKey.text('n', variants: ['ñ']),
          AntKeyboardKey.text('m'),
          AntKeyboardKey.action(AntKeyAction.backspace, flex: 2),
        ]),
        const AntKeyboardRow([
          AntKeyboardKey.action(AntKeyAction.modeSwitch, flex: 2),
          AntKeyboardKey.action(AntKeyAction.shift, flex: 2),
          AntKeyboardKey.action(AntKeyAction.space, flex: 5),
          AntKeyboardKey.text('.'),
          AntKeyboardKey.action(AntKeyAction.enter, flex: 2),
        ]),
      ];

  /// 符号条模式（数字行 Shift 出符号 + modeSwitch 切回字母）
  static List<AntKeyboardRow> _symbolsBarMode() => [
        const AntKeyboardRow([
          AntKeyboardKey.text('1', secondary: '!'),
          AntKeyboardKey.text('2', secondary: '@'),
          AntKeyboardKey.text('3', secondary: '#'),
          AntKeyboardKey.text('4', secondary: r'$'),
          AntKeyboardKey.text('5', secondary: '%'),
          AntKeyboardKey.text('6', secondary: '^'),
          AntKeyboardKey.text('7', secondary: '&'),
          AntKeyboardKey.text('8', secondary: '*'),
          AntKeyboardKey.text('9', secondary: '('),
          AntKeyboardKey.text('0', secondary: ')'),
        ]),
        const AntKeyboardRow([
          AntKeyboardKey.action(AntKeyAction.none, flex: 1),
          AntKeyboardKey.text('-', secondary: '_'),
          AntKeyboardKey.text('/', secondary: '÷'),
          AntKeyboardKey.text(':', secondary: ';'),
          AntKeyboardKey.text('(', secondary: '['),
          AntKeyboardKey.text(')', secondary: ']'),
          AntKeyboardKey.text('¥', secondary: r'$'),
          AntKeyboardKey.text('&', secondary: '@'),
          AntKeyboardKey.text('"', secondary: "'"),
          AntKeyboardKey.action(AntKeyAction.none, flex: 1),
        ]),
        const AntKeyboardRow([
          AntKeyboardKey.action(AntKeyAction.modeSwitch, flex: 2),
          AntKeyboardKey.text('.', secondary: ','),
          AntKeyboardKey.text('?'),
          AntKeyboardKey.text('!'),
          AntKeyboardKey.text("'"),
          AntKeyboardKey.action(AntKeyAction.backspace, flex: 2),
        ]),
        const AntKeyboardRow([
          AntKeyboardKey.action(AntKeyAction.shift, flex: 2),
          AntKeyboardKey.action(AntKeyAction.space, flex: 6),
          AntKeyboardKey.action(AntKeyAction.enter, flex: 2),
        ]),
      ];
}

/// 键盘预设类型（便捷参数；自定义布局用 [AntKeyboardLayout] 直接构造）
enum AntKeyboardPreset {
  numeric,
  decimal,
  text,
  symbol,
  email,
  qwertyDesktop,
}

/// 预设注册表（AntKeyboardLayouts.of(preset) → 布局实例）
class AntKeyboardLayouts {
  const AntKeyboardLayouts._();

  static AntKeyboardLayout of(AntKeyboardPreset preset) => switch (preset) {
        AntKeyboardPreset.numeric => AntKeyboardLayout.numeric(),
        AntKeyboardPreset.decimal => AntKeyboardLayout.decimal(),
        AntKeyboardPreset.text => AntKeyboardLayout.text(),
        AntKeyboardPreset.symbol => AntKeyboardLayout.symbol(),
        AntKeyboardPreset.email => AntKeyboardLayout.email(),
        AntKeyboardPreset.qwertyDesktop => AntKeyboardLayout.qwertyDesktop(),
      };
}
