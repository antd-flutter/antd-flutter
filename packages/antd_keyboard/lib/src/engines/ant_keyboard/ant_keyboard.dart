import 'dart:async';
import 'dart:math' as math;

import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/services.dart'
    show HardwareKeyboard, KeyDownEvent, KeyEvent, LogicalKeyboardKey;
import 'package:material_ui/material_ui.dart';

import 'ant_keyboard_controller.dart';
import 'ant_keyboard_glyph.dart';
import 'ant_keyboard_key.dart';
import 'ant_keyboard_layout.dart';
import 'ant_keyboard_theme.dart';
import '../input_platform.dart';

/// 触控目标最小尺寸（移动端可点击区域不得小于 44×44）。
const double kAntKeyboardMinTouchTarget = 44.0;

/// 通用屏上键盘。
///
/// 布局引擎吸收自 `flutter_onscreen_keyboard`：按「行 → 权重 flex」排布，
/// 行支持 leading/trailing 附加组件，键分文本键 / 动作键两类；修饰态
/// （Shift/CapsLock）采用 XOR，文本通过可选的 [controller] 直接写入
/// `TextEditingController`（支持选区替换、inputFormatters、emoji 退格、
/// enter 提交/换行、tab 插入）。
///
/// 双端形态（仓库 R38 规则）：
/// - 移动端：键高 48、1px 描边、4 圆角、无 hover，对齐 antd-mobile v5；
/// - 桌面端：`colorBgElevated` 浮层 + `colorFillSecondary` 键面 +
///   `boxShadowSecondary` 阴影 + hover/pressed 反馈，对齐 antd v6。
class AntKeyboard extends StatefulWidget {
  const AntKeyboard({
    super.key,
    required this.layout,
    this.theme,
    this.controller,
    this.confirmText,
    this.onTextInput,
    this.onBackspace,
    this.onConfirm,
    this.onHide,
    this.onKey,
    this.showControlBar = false,
    this.onAlignTop,
    this.onAlignBottom,
    this.backspaceHoldDelay = const Duration(milliseconds: 700),
    this.backspaceRepeatInterval = const Duration(milliseconds: 150),
    this.handleHardwareKeys = false,
    this.showSurface = true,
    this.contentPadding,
  });

  /// 键盘布局（单模式 rows 或多模式 modes）。
  final AntKeyboardLayout layout;

  /// 主题覆盖；不传时按平台从 [AntThemeData] 派生。
  final AntKeyboardThemeData? theme;

  /// 可选控制器：绑定输入框、驱动修饰态与模式。
  final AntKeyboardController? controller;

  /// 确认键文案（动作键自身的 actionLabel 优先）。
  final String? confirmText;

  /// 文本输入回调；[controller] 已绑定输入框时仍会回调，业务侧避免二次写入。
  final ValueChanged<String>? onTextInput;

  /// 退格回调；[controller] 已绑定输入框时仍会回调。
  final VoidCallback? onBackspace;

  /// 确认 / 单行回车回调。
  final VoidCallback? onConfirm;

  /// 收起键盘回调（hide 键 / Esc）。
  final VoidCallback? onHide;

  /// 任意键点击回调（先于具体动作触发）。
  final ValueChanged<AntKeyboardKey>? onKey;

  /// 是否显示右上角的贴顶/贴底控制条。
  final bool showControlBar;

  /// 控制条「贴顶」回调。
  final VoidCallback? onAlignTop;

  /// 控制条「贴底」回调。
  final VoidCallback? onAlignBottom;

  /// 退格长按后开始连续删除的延迟。
  final Duration backspaceHoldDelay;

  /// 退格连续删除间隔。
  final Duration backspaceRepeatInterval;

  /// 是否接管桌面物理键盘（无输入框聚焦时把按键回灌到键盘）。
  final bool handleHardwareKeys;

  /// 是否绘制键盘面板背景（嵌入自定义容器时可关闭）。
  final bool showSurface;

  /// 覆盖面板内边距。
  final EdgeInsets? contentPadding;

  @override
  State<AntKeyboard> createState() => _AntKeyboardState();
}

class _AntKeyboardState extends State<AntKeyboard> {
  late final AntKeyboardController _ownedController =
      AntKeyboardController();
  AntKeyboardController get _controller =>
      widget.controller ?? _ownedController;

  Timer? _backspaceDelay;
  Timer? _backspaceRepeat;
  OverlayEntry? _variantEntry;
  Timer? _flashTimer;

  /// 物理键盘按下时短暂高亮的键（大写形式，忽略大小写比较）。
  String? _flashText;
  AntKeyAction? _flashAction;

  bool _hardwareAttached = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerChanged);
    _syncHardwareListener();
  }

  @override
  void didUpdateWidget(covariant AntKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _ownedController)
          .removeListener(_onControllerChanged);
      _controller.addListener(_onControllerChanged);
    }
    if (oldWidget.handleHardwareKeys != widget.handleHardwareKeys) {
      _syncHardwareListener();
    }
  }

  void _syncHardwareListener() {
    final shouldAttach = widget.handleHardwareKeys;
    if (shouldAttach == _hardwareAttached) return;
    _hardwareAttached = shouldAttach;
    if (shouldAttach) {
      HardwareKeyboard.instance.addHandler(_handleHardwareKey);
    } else {
      HardwareKeyboard.instance.removeHandler(_handleHardwareKey);
    }
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _cancelBackspace();
    _hideVariants();
    _flashTimer?.cancel();
    if (_hardwareAttached) {
      HardwareKeyboard.instance.removeHandler(_handleHardwareKey);
    }
    _controller.removeListener(_onControllerChanged);
    _ownedController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // 布局 / 主题
  // ---------------------------------------------------------------------------

  Map<String, List<AntKeyboardRow>> get _modes =>
      widget.layout.modes ?? const <String, List<AntKeyboardRow>>{};

  String? get _modeName {
    final modes = _modes;
    if (modes.isEmpty) return null;
    final requested = _controller.modeName;
    if (requested != null && modes.containsKey(requested)) return requested;
    final initial = widget.layout.initialMode;
    if (initial != null && modes.containsKey(initial)) return initial;
    return modes.keys.first;
  }

  List<AntKeyboardRow> get _rows {
    final modes = _modes;
    if (modes.isEmpty) return widget.layout.rows;
    return modes[_modeName] ?? modes.values.first;
  }

  AntKeyboardThemeData _resolveTheme(BuildContext context) {
    final ant = AntTheme.of(context);
    final desktop =
        widget.theme?.desktop ?? isDesktopInputPlatform();
    var resolved =
        AntKeyboardThemeData.resolve(ant, desktop: desktop).merge(widget.theme);
    final height = resolved.keyHeight;
    if (!resolved.desktop && height != null) {
      resolved = resolved.copyWith(
        keyHeight: math.max(kAntKeyboardMinTouchTarget, height),
      );
    }
    return resolved;
  }

  // ---------------------------------------------------------------------------
  // 输入
  // ---------------------------------------------------------------------------

  String _displayText(AntKeyboardKey key) {
    final text = key.text ?? '';
    if (_controller.shiftActive) {
      if (key.secondary != null) return key.secondary!;
      if (text.isNotEmpty) return text.toUpperCase();
    }
    return text;
  }

  void _emitText(String value) {
    if (value.isEmpty) return;
    if (_controller.hasAttachedField) {
      _controller.insert(value);
    }
    widget.onTextInput?.call(value);
    if (_controller.shiftOn) _controller.consumeShift();
  }

  void _deleteOnce() {
    if (_controller.hasAttachedField) {
      _controller.backspace();
    }
    widget.onBackspace?.call();
  }

  void _onBackspaceDown() {
    widget.onKey?.call(const AntKeyboardKey.action(AntKeyAction.backspace));
    _deleteOnce();
    _backspaceDelay?.cancel();
    _backspaceDelay = Timer(widget.backspaceHoldDelay, () {
      if (!mounted) return;
      _deleteOnce();
      _backspaceRepeat?.cancel();
      _backspaceRepeat = Timer.periodic(
        widget.backspaceRepeatInterval,
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

  void _handleKeyTap(AntKeyboardKey key) {
    widget.onKey?.call(key);
    switch (key.action) {
      case AntKeyAction.text:
        _emitText(_displayText(key));
      case AntKeyAction.space:
        _emitText(' ');
      case AntKeyAction.backspace:
        _deleteOnce();
      case AntKeyAction.confirm:
        widget.onConfirm?.call();
      case AntKeyAction.enter:
        if (_controller.hasAttachedField) {
          final multiline = (_controller.binding?.maxLines ?? 1) > 1;
          if (multiline) {
            _emitText('\n');
          } else {
            _controller.newline();
            widget.onConfirm?.call();
          }
        } else {
          widget.onConfirm?.call();
        }
      case AntKeyAction.hide:
        widget.onHide?.call();
      case AntKeyAction.shift:
        _controller.toggleShift();
      case AntKeyAction.capslock:
        _controller.toggleCaps();
      case AntKeyAction.modeSwitch:
        _controller.cycleMode(_modes.keys.toList());
      case AntKeyAction.tab:
        _controller.tab();
      case AntKeyAction.none:
        break;
    }
  }

  bool _handleHardwareKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    final keyboard = HardwareKeyboard.instance;
    if (keyboard.isControlPressed ||
        keyboard.isMetaPressed ||
        keyboard.isAltPressed) {
      return false;
    }
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.escape) {
      widget.onHide?.call();
      _flash(AntKeyAction.hide);
      return true;
    }
    if (key == LogicalKeyboardKey.backspace) {
      _deleteOnce();
      _flash(AntKeyAction.backspace);
      return true;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      widget.onConfirm?.call();
      _flash(AntKeyAction.enter);
      return true;
    }
    if (key == LogicalKeyboardKey.tab) {
      _handleKeyTap(const AntKeyboardKey.action(AntKeyAction.tab));
      _flash(AntKeyAction.tab);
      return true;
    }
    if (key == LogicalKeyboardKey.space) {
      _emitText(' ');
      _flash(null, text: ' ');
      return true;
    }
    final character = event.character;
    if (character == null ||
        character.isEmpty ||
        character.codeUnitAt(0) < 32) {
      return false;
    }
    _emitText(character);
    _flash(null, text: character);
    return true;
  }

  void _flash(AntKeyAction? action, {String? text}) {
    _flashTimer?.cancel();
    setState(() {
      _flashAction = action;
      _flashText = text?.toUpperCase();
    });
    _flashTimer = Timer(const Duration(milliseconds: 140), () {
      if (!mounted) return;
      setState(() {
        _flashAction = null;
        _flashText = null;
      });
    });
  }

  bool _isFlashText(String label) =>
      _flashText != null && _flashText == label.toUpperCase();

  // ---------------------------------------------------------------------------
  // 长按变体气泡
  // ---------------------------------------------------------------------------

  void _showVariants(AntKeyboardKey key, Offset globalPosition) {
    _hideVariants();
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null || key.variants.isEmpty) return;
    final theme = _resolveTheme(context);
    final screen = MediaQuery.sizeOf(context);
    const itemWidth = 44.0;
    final bubbleWidth = itemWidth * key.variants.length + 12 * 2;
    final left = (globalPosition.dx - bubbleWidth / 2)
        .clamp(8.0, math.max(8.0, screen.width - bubbleWidth - 8));
    final top = math.max(
      8.0,
      globalPosition.dy - (theme.keyHeight ?? 44) - 12,
    );

    _variantEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _hideVariants,
              child: const SizedBox.expand(),
            ),
          ),
          Positioned(
            left: left.toDouble(),
            top: top,
            child: Material(
              color: theme.surfaceColor,
              elevation: 6,
              borderRadius:
                  BorderRadius.circular(theme.keyBorderRadius ?? 6),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final variant in key.variants)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          _emitText(variant);
                          _hideVariants();
                        },
                        child: SizedBox(
                          width: itemWidth,
                          height: theme.keyHeight,
                          child: Center(
                            child: Text(
                              variant,
                              style: TextStyle(
                                fontSize: theme.fontSize,
                                color: theme.keyForegroundColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
    overlay.insert(_variantEntry!);
    setState(() {});
  }

  void _hideVariants() {
    if (_variantEntry == null) return;
    _variantEntry?.remove();
    _variantEntry = null;
    if (mounted) setState(() {});
  }

  // ---------------------------------------------------------------------------
  // 构建
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = _resolveTheme(context);
    final rows = _rows;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final pad = theme.sectionPadding ?? 8.w;
    final spacing = theme.keySpacing ?? 0;

    Widget body = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showControlBar) _buildControlBar(theme),
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) SizedBox(height: spacing),
          SizedBox(
            height: theme.keyHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (rows[i].leading != null) rows[i].leading!,
                for (var j = 0; j < rows[i].keys.length; j++) ...[
                  if (j > 0) SizedBox(width: spacing),
                  Expanded(
                    flex: rows[i].keys[j].flex,
                    child: _buildKey(rows[i].keys[j], theme),
                  ),
                ],
                if (rows[i].trailing != null) rows[i].trailing!,
              ],
            ),
          ),
        ],
      ],
    );

    final padding = widget.contentPadding ??
        EdgeInsets.fromLTRB(pad, pad, pad, pad + bottomInset);

    Widget content = Container(
      padding: padding,
      decoration: widget.showSurface
          ? BoxDecoration(
              color: theme.surfaceColor,
              borderRadius: theme.surfaceBorderRadius != null &&
                      theme.surfaceBorderRadius! > 0
                  ? BorderRadius.only(
                      topLeft: Radius.circular(theme.surfaceBorderRadius!),
                      topRight: Radius.circular(theme.surfaceBorderRadius!),
                    )
                  : null,
              border: theme.surfaceBorderColor != null &&
                      (theme.keyBorderWidth ?? 0) > 0
                  ? Border.all(
                      color: theme.surfaceBorderColor!,
                      width: theme.keyBorderWidth!,
                    )
                  : null,
              boxShadow: theme.boxShadow,
            )
          : null,
      child: body,
    );

    final radius = theme.surfaceBorderRadius ?? 0;
    if (radius > 0) {
      content = ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
        child: content,
      );
    }
    return content;
  }

  Widget _buildControlBar(AntKeyboardThemeData theme) {
    Widget button(Widget icon, VoidCallback? onTap, String label) {
      return Semantics(
        button: true,
        label: label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(theme.keySpacing ?? 4),
            child: icon,
          ),
        ),
      );
    }

    final size = (theme.iconSize ?? 22) * 0.8;
    final color = theme.actionKeyForegroundColor;
    return Padding(
      padding: EdgeInsets.only(bottom: theme.keySpacing ?? 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          button(
            AntdIcon(
              AntIcons.verticalAlignTopOutlined,
              key: const ValueKey('ant-kb-align-top'),
              size: size,
              color: color,
              semanticLabel: '贴顶',
            ),
            widget.onAlignTop,
            '贴顶',
          ),
          button(
            AntdIcon(
              AntIcons.verticalAlignBottomOutlined,
              key: const ValueKey('ant-kb-align-bottom'),
              size: size,
              color: color,
              semanticLabel: '贴底',
            ),
            widget.onAlignBottom,
            '贴底',
          ),
        ],
      ),
    );
  }

  Widget _buildKey(AntKeyboardKey key, AntKeyboardThemeData theme) {
    final radius = theme.keyBorderRadius;
    final height = theme.keyHeight;
    switch (key.action) {
      case AntKeyAction.text:
        final label = _displayText(key);
        final flashing = _isFlashText(label);
        return AntKeyboardKeyView(
          theme: theme,
          height: height,
          borderRadius: radius,
          active: flashing,
          activeBackground: theme.confirmBackgroundColor,
          onTap: () => _handleKeyTap(key),
          onLongPressStart:
              key.hasVariants ? (pos) => _showVariants(key, pos) : null,
          semanticLabel: label,
          child: Text(
            label,
            style: TextStyle(
              fontSize: theme.fontSize,
              fontWeight: FontWeight.w500,
              color: flashing
                  ? theme.confirmForegroundColor
                  : theme.keyForegroundColor,
            ),
          ),
        );
      case AntKeyAction.backspace:
        return AntKeyboardKeyView(
          theme: theme,
          height: height,
          borderRadius: radius,
          background: theme.actionKeyBackgroundColor,
          pressedBackground: theme.actionKeyPressedBackgroundColor,
          active: _flashAction == AntKeyAction.backspace,
          activeBackground: theme.confirmBackgroundColor,
          onTapDown: _onBackspaceDown,
          onTapUp: _cancelBackspace,
          onTapCancel: _cancelBackspace,
          semanticLabel: '退格',
          child: AntKeyboardGlyph(
            AntKeyboardGlyphType.backspace,
            key: const ValueKey('ant-kb-backspace'),
            size: theme.iconSize ?? 22,
            color: _flashAction == AntKeyAction.backspace
                ? theme.confirmForegroundColor!
                : theme.actionKeyForegroundColor!,
          ),
        );
      case AntKeyAction.shift:
        return _actionKey(
          theme,
          key,
          icon: AntKeyboardGlyph(
            AntKeyboardGlyphType.shift,
            key: const ValueKey('ant-kb-shift'),
            size: theme.iconSize ?? 22,
            color: _controller.shiftOn
                ? theme.confirmForegroundColor!
                : theme.actionKeyForegroundColor!,
          ),
          label: 'Shift',
          active: _controller.shiftOn,
        );
      case AntKeyAction.capslock:
        return _actionKey(
          theme,
          key,
          icon: AntKeyboardGlyph(
            AntKeyboardGlyphType.capsLock,
            key: const ValueKey('ant-kb-capslock'),
            size: theme.iconSize ?? 22,
            color: _controller.capsOn
                ? theme.confirmForegroundColor!
                : theme.actionKeyForegroundColor!,
          ),
          label: 'CapsLock',
          active: _controller.capsOn,
        );
      case AntKeyAction.modeSwitch:
        return _actionKey(
          theme,
          key,
          icon: AntdIcon(
            AntIcons.swapOutlined,
            key: const ValueKey('ant-kb-mode-switch'),
            size: theme.iconSize,
            color: theme.actionKeyForegroundColor!,
            semanticLabel: '切换键盘',
          ),
          label: '切换键盘',
        );
      case AntKeyAction.enter:
        return _actionKey(
          theme,
          key,
          icon: AntKeyboardGlyph(
            AntKeyboardGlyphType.enter,
            key: const ValueKey('ant-kb-enter'),
            size: theme.iconSize ?? 22,
            color: _flashAction == AntKeyAction.enter
                ? theme.confirmForegroundColor!
                : theme.actionKeyForegroundColor!,
          ),
          label: '回车',
          active: _flashAction == AntKeyAction.enter,
        );
      case AntKeyAction.tab:
        return _actionKey(
          theme,
          key,
          icon: AntKeyboardGlyph(
            AntKeyboardGlyphType.tab,
            key: const ValueKey('ant-kb-tab'),
            size: theme.iconSize ?? 22,
            color: _flashAction == AntKeyAction.tab
                ? theme.confirmForegroundColor!
                : theme.actionKeyForegroundColor!,
          ),
          label: 'Tab',
          active: _flashAction == AntKeyAction.tab,
        );
      case AntKeyAction.space:
        return AntKeyboardKeyView(
          theme: theme,
          height: height,
          borderRadius: radius,
          semanticLabel: '空格',
          onTap: () => _handleKeyTap(key),
          child: AntKeyboardGlyph(
            AntKeyboardGlyphType.space,
            key: const ValueKey('ant-kb-space'),
            size: theme.iconSize ?? 22,
            color: theme.keyForegroundColor!,
          ),
        );
      case AntKeyAction.hide:
        return _actionKey(
          theme,
          key,
          icon: AntdIcon(
            AntIcons.downOutlined,
            key: const ValueKey('ant-kb-hide'),
            size: theme.iconSize,
            color: _flashAction == AntKeyAction.hide
                ? theme.confirmForegroundColor!
                : theme.actionKeyForegroundColor!,
            semanticLabel: '收起键盘',
          ),
          label: '收起键盘',
          active: _flashAction == AntKeyAction.hide,
        );
      case AntKeyAction.confirm:
        final label = key.actionLabel ?? widget.confirmText ?? '确定';
        return AntKeyboardKeyView(
          theme: theme,
          height: height,
          borderRadius: radius,
          background: theme.confirmBackgroundColor,
          pressedBackground: theme.confirmBackgroundColor,
          semanticLabel: label,
          onTap: () => _handleKeyTap(key),
          child: Text(
            label,
            style: TextStyle(
              fontSize: theme.confirmFontSize ?? theme.fontSize,
              fontWeight: FontWeight.w500,
              color: theme.confirmForegroundColor,
            ),
          ),
        );
      case AntKeyAction.none:
        return const SizedBox.shrink();
    }
  }

  Widget _actionKey(
    AntKeyboardThemeData theme,
    AntKeyboardKey key, {
    required Widget icon,
    required String label,
    bool active = false,
  }) {
    return AntKeyboardKeyView(
      theme: theme,
      height: theme.keyHeight,
      borderRadius: theme.keyBorderRadius,
      background: theme.actionKeyBackgroundColor,
      pressedBackground: theme.actionKeyPressedBackgroundColor,
      active: active,
      activeBackground: theme.confirmBackgroundColor,
      semanticLabel: label,
      onTap: () => _handleKeyTap(key),
      child: icon,
    );
  }
}
