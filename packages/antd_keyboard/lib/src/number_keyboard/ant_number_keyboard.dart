import 'dart:async';
import 'dart:math' as math;

import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import '../engines/ant_keyboard/ant_keyboard.dart'
    show kAntKeyboardMinTouchTarget;
import '../engines/ant_keyboard/ant_keyboard_glyph.dart';
import '../engines/ant_keyboard/ant_keyboard_key.dart';
import '../engines/ant_keyboard/ant_keyboard_theme.dart';
import '../engines/input_platform.dart';
import '../engines/keyboard_input_model.dart';

/// 数字键盘 — 移动端完全对齐 antd-mobile v5 NumberKeyboard，桌面端取 antd v6
/// 浮层形态（`colorBgElevated` + `boxShadowSecondary` + 圆角 + 间距键）。
///
/// 布局：左侧 4 行数字区（75%），右侧确认列（25%，退格 48 + 确认键跨余高）；
/// 带标题/关闭按钮时顶部 34 高 header；`customKey` / `extraKey` 对齐
/// antd-mobile 的单/双自定义键规则；退格长按 700ms 后每 150ms 连删。
class AntNumberKeyboard extends StatefulWidget {
  const AntNumberKeyboard({
    super.key,
    this.value,
    this.defaultValue = '',
    this.onChange,
    this.maxLength,
    this.confirmText,
    this.onConfirm,
    this.onCancel,
    this.onInput,
    this.onDelete,
    this.randomOrder = false,
    this.customKey,
    this.extraKey,
    this.title,
    this.visible = true,
    this.onClose,
    this.theme,
    this.desktop = false,
    this.showCloseButton = true,
    this.safeArea = true,
  });

  /// 受控值（null 时使用内部缓冲）。
  final String? value;

  /// 非受控初始值。
  final String defaultValue;

  /// 值变化回调。
  final ValueChanged<String>? onChange;

  /// 最大长度。
  final int? maxLength;

  /// 确认键文案；非空时右侧出现 25% 宽的确认列。
  final String? confirmText;

  /// 确认回调。
  final VoidCallback? onConfirm;

  /// 取消/关闭回调（未提供 [onClose] 时使用）。
  final VoidCallback? onCancel;

  /// 单键输入回调（antd-mobile `onInput`），在 [onChange] 同时触发。
  final ValueChanged<String>? onInput;

  /// 退格回调（antd-mobile `onDelete`）。
  final VoidCallback? onDelete;

  /// 是否乱序数字 1-9。
  final bool randomOrder;

  /// 自定义键（显示并输入该字符串，如 `.`）。
  final String? customKey;

  /// 第二个自定义键（antd-mobile customKey 数组形态）。
  final String? extraKey;

  /// 头部标题。
  final String? title;

  /// 是否显示。
  final bool visible;

  /// 关闭回调（头部关闭按钮）。
  final VoidCallback? onClose;

  /// 主题覆盖。
  final AntKeyboardThemeData? theme;

  /// 强制桌面形态（默认按平台 + 主题判定）。
  final bool desktop;

  /// 是否显示头部关闭按钮。
  final bool showCloseButton;

  /// 移动端是否追加底部安全区高度。
  final bool safeArea;

  @override
  State<AntNumberKeyboard> createState() => _AntNumberKeyboardState();
}

class _AntNumberKeyboardState extends State<AntNumberKeyboard> {
  late final KeyboardInputBuffer _buffer = KeyboardInputBuffer(
    initialText: widget.value ?? widget.defaultValue,
    maxLength: widget.maxLength,
  );
  late List<String> _order =
      buildNumberKeyOrder(randomOrder: widget.randomOrder);

  Timer? _backspaceDelay;
  Timer? _backspaceRepeat;

  bool get _desktop =>
      widget.desktop ||
      (widget.theme?.desktop ?? isDesktopInputPlatform());

  @override
  void didUpdateWidget(covariant AntNumberKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != oldWidget.value) {
      _buffer.text = widget.value!;
    }
    if (widget.randomOrder != oldWidget.randomOrder) {
      _order = buildNumberKeyOrder(randomOrder: widget.randomOrder);
    }
  }

  @override
  void dispose() {
    _cancelBackspace();
    super.dispose();
  }

  void _applyValue(String next) {
    _buffer.text = next;
    if (widget.value == null) setState(() {});
    widget.onChange?.call(next);
  }

  void _handleText(String key) {
    final next = _buffer.append(key);
    if (next == null) return;
    _applyValue(next);
    widget.onInput?.call(key);
  }

  void _deleteOnce() {
    final next = _buffer.backspace();
    if (next == null) return;
    _applyValue(next);
    widget.onDelete?.call();
  }

  void _onBackspaceDown() {
    _deleteOnce();
    _backspaceDelay?.cancel();
    _backspaceDelay = Timer(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      _deleteOnce();
      _backspaceRepeat?.cancel();
      _backspaceRepeat = Timer.periodic(
        const Duration(milliseconds: 150),
        (_) {
          if (!mounted) return;
          _deleteOnce();
        },
      );
    });
  }

  void _cancelBackspace() {
    _backspaceDelay?.cancel();
    _backspaceDelay = null;
    _backspaceRepeat?.cancel();
    _backspaceRepeat = null;
  }

  void _close() {
    (widget.onClose ?? widget.onCancel)?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.visible) return const SizedBox.shrink();

    final ant = AntTheme.of(context);
    final desktop = _desktop;
    var theme = AntKeyboardThemeData.resolve(ant, desktop: desktop)
        .merge(widget.theme)
        .copyWith(desktop: desktop);
    if (!desktop) {
      theme = theme.copyWith(
        keyHeight: math.max(
          kAntKeyboardMinTouchTarget,
          theme.keyHeight ?? kAntNumberKeyboardKeyHeight,
        ),
      );
    }
    final rowHeight = theme.keyHeight ?? kAntNumberKeyboardKeyHeight;
    final gap = desktop ? (theme.keySpacing ?? ant.s(6)) : 1.0;
    final hasConfirm = (widget.confirmText ?? '').isNotEmpty;
    final keys = _buildKeys(hasConfirm);

    final rows = <List<String>>[];
    for (var i = 0; i < keys.length; i += 3) {
      rows.add(keys.sublist(i, math.min(i + 3, keys.length)));
    }
    if (rows.length > 4) {
      // 理论上最多 12 键 → 4 行。
      rows.removeRange(4, rows.length);
    }

    final gridHeight = rows.length * rowHeight +
        math.max(0, rows.length - 1) * gap;

    final main = SizedBox(
      height: gridHeight,
      child: Column(
        children: [
          for (var r = 0; r < rows.length; r++) ...[
            if (r > 0) SizedBox(height: gap),
            SizedBox(
              height: rowHeight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var c = 0; c < rows[r].length; c++) ...[
                    if (c > 0) SizedBox(width: gap),
                    Expanded(
                      flex: rows[r].length == 2 ? (c == 0 ? 2 : 1) : 1,
                      child: _buildKey(rows[r][c], theme, desktop),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );

    final grid = hasConfirm
        ? SizedBox(
            height: gridHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 3, child: main),
                SizedBox(width: gap),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      SizedBox(
                        height: rowHeight,
                        child: _buildBackspace(theme),
                      ),
                      SizedBox(height: gap),
                      Expanded(child: _buildConfirm(theme)),
                    ],
                  ),
                ),
              ],
            ),
          )
        : main;

    // 移动端 antd-mobile 用 1px 网格线分隔键位：间隙处露出边框色。
    final gridBody = desktop
        ? grid
        : ColoredBox(
            color: theme.keyBorderColor ?? ant.colorBorder,
            child: grid,
          );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_showHeader) _buildHeader(theme, desktop),
        Padding(
          padding: desktop
              ? EdgeInsets.all(theme.sectionPadding ?? ant.s(12))
              : EdgeInsets.zero,
          child: gridBody,
        ),
        if (!desktop && widget.safeArea)
          SizedBox(
            height: MediaQuery.paddingOf(context).bottom,
            width: double.infinity,
            child: ColoredBox(color: theme.surfaceColor ?? ant.colorBgContainer),
          ),
      ],
    );

    final radius = desktop ? (theme.surfaceBorderRadius ?? ant.s(8)) : ant.s(8);
    Widget panel = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.surfaceColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
        border: desktop && theme.surfaceBorderColor != null
            ? Border.all(
                color: theme.surfaceBorderColor!,
                width: theme.keyBorderWidth ?? ant.s(1),
              )
            : null,
        boxShadow: theme.boxShadow,
      ),
      child: content,
    );

    if (desktop) {
      panel = Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: ant.s(640)),
          child: panel,
        ),
      );
    }
    return panel;
  }

  bool get _showHeader =>
      widget.title != null ||
      (widget.showCloseButton &&
          (widget.onClose != null || widget.onCancel != null));

  List<String> _buildKeys(bool hasConfirm) {
    final keys = <String>[..._order, '0'];
    final custom = widget.customKey;
    final extra = widget.extraKey;
    if (hasConfirm) {
      if (custom != null && extra != null) {
        keys.insert(9, extra);
        keys.add(custom);
      } else {
        keys.add(custom ?? '');
      }
    } else {
      keys.insert(9, custom ?? '');
      keys.add(_backspaceToken);
    }
    return keys;
  }

  Widget _buildHeader(AntKeyboardThemeData theme, bool desktop) {
    final ant = AntTheme.of(context);
    return Container(
      height: theme.headerHeight ?? (desktop ? ant.s(40) : ant.s(34)),
      padding: EdgeInsets.symmetric(horizontal: ant.s(12)),
      decoration: BoxDecoration(
        color: theme.headerBackgroundColor ?? theme.surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: ant.colorBorder,
            width: ant.s(1),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.title ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: theme.titleFontSize ?? ant.fontSizeSM,
                color: theme.titleColor ?? ant.colorTextSecondary,
              ),
            ),
          ),
          if (widget.showCloseButton &&
              (widget.onClose != null || widget.onCancel != null))
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _close,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: ant.s(4)),
                child: AntdIcon(
                  AntIcons.downOutlined,
                  key: const ValueKey('ant-kb-collapse'),
                  size: ant.s(22),
                  color: theme.titleColor ?? ant.colorTextSecondary,
                  semanticLabel: '收起键盘',
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildKey(String token, AntKeyboardThemeData theme, bool desktop) {
    final ant = AntTheme.of(context);
    if (token == _backspaceToken) return _buildBackspace(theme);
    if (token.isEmpty) {
      // antd-mobile 确认态 11 键时的空白格。
      return const SizedBox.shrink();
    }
    final isDigit = RegExp(r'^\d$').hasMatch(token);
    // antd-mobile 的 main-confirmed-style：带确认键时自定义键/符号键也走白底。
    final hasConfirm = (widget.confirmText ?? '').isNotEmpty;
    final background = isDigit || (hasConfirm && !desktop)
        ? theme.keyBackgroundColor
        : theme.actionKeyBackgroundColor;
    final foreground = isDigit
        ? theme.keyForegroundColor
        : theme.actionKeyForegroundColor;
    return AntKeyboardKeyView(
      theme: theme,
      height: theme.keyHeight,
      borderRadius: desktop ? theme.keyBorderRadius : 0,
      background: background,
      pressedBackground: theme.keyPressedBackgroundColor,
      hoverBackground: theme.keyHoverBackgroundColor,
      showBorder: desktop,
      onTap: () => _handleText(token),
      semanticLabel: token,
      child: Text(
        token,
        style: TextStyle(
          fontSize: desktop ? ant.s(18) : ant.s(22),
          fontWeight: FontWeight.w500,
          color: foreground,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }

  Widget _buildBackspace(AntKeyboardThemeData theme) {
    final ant = AntTheme.of(context);
    return AntKeyboardKeyView(
      theme: theme,
      height: theme.keyHeight,
      borderRadius: theme.desktop ? theme.keyBorderRadius : 0,
      background: theme.keyBackgroundColor,
      pressedBackground: theme.keyPressedBackgroundColor,
      showBorder: theme.desktop,
      onTapDown: _onBackspaceDown,
      onTapUp: _cancelBackspace,
      onTapCancel: _cancelBackspace,
      semanticLabel: '退格',
      child: AntKeyboardGlyph(
        AntKeyboardGlyphType.backspace,
        key: const ValueKey('ant-kb-backspace'),
        size: theme.desktop ? (theme.iconSize ?? 22) : ant.s(24),
        color: theme.actionKeyForegroundColor!,
      ),
    );
  }

  Widget _buildConfirm(AntKeyboardThemeData theme) {
    final ant = AntTheme.of(context);
    return AntKeyboardKeyView(
      theme: theme,
      borderRadius: theme.desktop ? theme.keyBorderRadius : 0,
      background: theme.confirmBackgroundColor,
      pressedBackground: theme.confirmBackgroundColor,
      hoverBackground: theme.confirmBackgroundColor,
      showBorder: false,
      onTap: widget.onConfirm,
      semanticLabel: widget.confirmText,
      child: Center(
        child: Text(
          widget.confirmText ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: theme.desktop
                ? (theme.confirmFontSize ?? ant.s(16))
                : ant.s(16),
            fontWeight: FontWeight.w500,
            color: theme.confirmForegroundColor,
          ),
        ),
      ),
    );
  }
}

const String _backspaceToken = 'BACKSPACE';

/// 数字键盘默认键高（antd-mobile 48 / antd v6 56），与主题解析保持一致。
const double kAntNumberKeyboardKeyHeight = 48.0;
