/// AntPasscodeInput — antd-mobile PasscodeInput 密码格子输入的 Flutter 实现
///
/// API 与 antd-mobile React PasscodeInput 对齐：
/// - [AntPasscodeInput] — 密码格子输入（value/length/plain/error/separated/onFill）
///
/// 移动端：点击格子唤起底部 [AntNumberKeyboard] 浮层，格子内显示闪烁光标；
/// 桌面端：格子覆盖透明 [TextField] 采集系统键盘输入（不弹软键盘）。
///
/// ```dart
/// AntPasscodeInput(
///   length: 6,
///   plain: false,
///   onFill: (v) => print('filled: $v'),
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';

export 'package:antd_keyboard/src/passcode_input/ant_passcode_input_types.dart';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../engines/input_platform.dart';
import '../engines/keyboard_overlay.dart';
import '../number_keyboard/ant_number_keyboard.dart';

/// 密码格子输入 — 用于验证码/密码场景的格子输入组件。
class AntPasscodeInput extends StatefulWidget {
  const AntPasscodeInput({
    super.key,
    this.value,
    this.defaultValue = '',
    this.onChange,
    this.onFill,
    this.onFocus,
    this.onBlur,
    this.length = 6,
    this.plain = false,
    this.error = false,
    this.separated = false,
    this.keyboard = true,
    this.autofocus = false,
    this.cellSize,
    this.cellGap,
    this.dotSize,
    this.borderRadius,
  });

  /// 受控当前值。
  final String? value;

  /// 非受控初始值。
  final String defaultValue;

  /// 值变化回调。
  final ValueChanged<String>? onChange;

  /// 填满回调（值长度首次达到 [length] 时触发，删减后再次填满会再次触发）。
  final ValueChanged<String>? onFill;

  /// 聚焦回调。
  final VoidCallback? onFocus;

  /// 失焦回调。
  final VoidCallback? onBlur;

  /// 格子数量。
  final int length;

  /// 是否明文展示。
  final bool plain;

  /// 是否错误状态（切换为 true 时播放抖动动画）。
  final bool error;

  /// 是否格子分离。
  final bool separated;

  /// 是否内置数字键盘。
  final bool keyboard;

  /// 是否自动聚焦（移动端自动展开键盘，桌面端自动取焦）。
  final bool autofocus;

  /// 格子尺寸（默认 ant.s(40)，对齐 antd-mobile）。
  final double? cellSize;

  /// 格子间距（separated 模式默认 ant.s(6)）。
  final double? cellGap;

  /// 掩码圆点尺寸（默认 ant.s(10)）。
  final double? dotSize;

  /// 圆角（默认 ant.s(8)）。
  final double? borderRadius;

  @override
  State<AntPasscodeInput> createState() => _AntPasscodeInputState();
}

class _AntPasscodeInputState extends State<AntPasscodeInput>
    with SingleTickerProviderStateMixin {
  late String _internalValue;
  bool _active = false;
  bool _fillNotified = false;

  /// 桌面端系统输入支持（透明 TextField 覆盖格子区域采集输入）。
  late final bool _desktop = isDesktopInputPlatform();

  /// 移动端底部弹出键盘控制器。
  final AntKeyboardOverlayController _kb = AntKeyboardOverlayController();
  TextEditingController? _desktopController;
  FocusNode? _desktopFocus;
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  String get _currentValue => widget.value ?? _internalValue;

  @override
  void initState() {
    super.initState();
    _internalValue = _sanitize(widget.defaultValue);
    if (_desktop) {
      _desktopController = TextEditingController(text: _internalValue)
        ..addListener(_handleDesktopInput);
      _desktopFocus = FocusNode()..addListener(_handleDesktopFocus);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _maybeFill(_currentValue);
      if (widget.autofocus) {
        if (_desktop) {
          _desktopFocus?.requestFocus();
        } else {
          _showKeyboard();
        }
      }
    });
    if (widget.error) _shake.forward(from: 0);
  }

  @override
  void didUpdateWidget(covariant AntPasscodeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.error && !oldWidget.error) {
      _shake.forward(from: 0);
    }
    if (widget.value != null && widget.value != oldWidget.value) {
      final next = _sanitize(widget.value!);
      _internalValue = next;
      final controller = _desktopController;
      if (controller != null && controller.text != next) {
        controller.value = TextEditingValue(
          text: next,
          selection: TextSelection.collapsed(offset: next.length),
        );
      }
      if (next.length < widget.length) _fillNotified = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _maybeFill(_currentValue);
      });
    }
  }

  @override
  void dispose() {
    _kb.dispose();
    _desktopController?.dispose();
    _desktopFocus?.dispose();
    _shake.dispose();
    super.dispose();
  }

  String _sanitize(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    return digits.length > widget.length
        ? digits.substring(0, widget.length)
        : digits;
  }

  void _handleDesktopInput() {
    final controller = _desktopController;
    if (controller == null) return;
    final next = _sanitize(controller.text);
    if (next != controller.text) {
      controller.value = TextEditingValue(
        text: next,
        selection: TextSelection.collapsed(offset: next.length),
      );
    }
    _handleChange(next);
  }

  void _handleDesktopFocus() {
    final focused = _desktopFocus?.hasFocus ?? false;
    if (focused == _active) return;
    setState(() => _active = focused);
    if (focused) {
      widget.onFocus?.call();
    } else {
      widget.onBlur?.call();
    }
  }

  void _handleChange(String raw) {
    final next = _sanitize(raw);
    if (next == _currentValue) return;
    if (widget.value == null) {
      setState(() => _internalValue = next);
    }
    widget.onChange?.call(next);
    _maybeFill(next);
  }

  void _maybeFill(String value) {
    if (value.length < widget.length) {
      _fillNotified = false;
      return;
    }
    if (_fillNotified) return;
    _fillNotified = true;
    widget.onFill?.call(value);
  }

  void _showKeyboard() {
    if (!widget.keyboard || _desktop) return;
    if (_active) return;
    setState(() => _active = true);
    _kb.show(
      context,
      AntNumberKeyboard(
        value: _currentValue,
        maxLength: widget.length,
        onChange: _handleChange,
      ),
      onDismiss: () {
        if (!mounted) return;
        setState(() => _active = false);
        widget.onBlur?.call();
      },
    );
    widget.onFocus?.call();
  }

  void _hideKeyboard() {
    if (_desktop) {
      _desktopFocus?.unfocus();
      return;
    }
    if (!_active) return;
    _kb.hide();
  }

  void _toggleActive() {
    if (_desktop) {
      if (_desktopFocus?.hasFocus ?? false) {
        _desktopFocus?.unfocus();
      } else {
        _desktopFocus?.requestFocus();
      }
      return;
    }
    if (!widget.keyboard) return;
    if (_active) {
      _hideKeyboard();
    } else {
      _showKeyboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ant = AntTheme.of(context);
    final cellSize = widget.cellSize ?? ant.s(40);
    final gap = widget.cellGap ?? ant.s(6);
    final radius = widget.borderRadius ?? ant.s(8);
    final danger = ant.colorError;
    final borderColor =
        widget.error ? danger : (_active ? ant.colorPrimary : ant.colorBorder);
    final cells = _buildCells(
      ant,
      cellSize: cellSize,
      gap: gap,
      radius: radius,
      borderColor: borderColor,
      danger: danger,
    );

    Widget body = widget.separated
        ? cells
        : Container(
            decoration: BoxDecoration(
              color: ant.colorBgContainer,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: borderColor, width: ant.s(1)),
              boxShadow: _active && !widget.error
                  ? [
                      BoxShadow(
                        color: ant.colorPrimary,
                        blurRadius: ant.s(2),
                      ),
                    ]
                  : null,
            ),
            clipBehavior: Clip.antiAlias,
            child: cells,
          );

    if (_desktop) {
      body = Stack(
        children: [
          body,
          Positioned.fill(
            // 透明采集层：只负责接收系统键盘输入，不参与任何视觉呈现。
            // 桌面端 TextField 默认装饰会在格子上方画出一条边线，故整体隐藏。
            child: Opacity(
              opacity: 0,
              child: Material(
                type: MaterialType.transparency,
                child: TextField(
                  controller: _desktopController,
                  focusNode: _desktopFocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(widget.length),
                  ],
                  showCursor: false,
                  enableSuggestions: false,
                  autocorrect: false,
                  style: TextStyle(
                    fontSize: 1,
                    color: ant.colorText.withValues(alpha: 0),
                  ),
                  cursorColor: ant.colorPrimary.withValues(alpha: 0),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isCollapsed: true,
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _toggleActive,
      child: AnimatedBuilder(
        animation: _shake,
        builder: (context, child) {
          final dx = _shakeOffset(_shake.value) * ant.s(5);
          return Transform.translate(offset: Offset(dx, 0), child: child);
        },
        child: body,
      ),
    );
  }

  /// antd-mobile shake 关键帧：0 → -4 → 5 → -5 → 4 → 0（px）。
  double _shakeOffset(double t) {
    if (t <= 0 || t >= 1) return 0;
    const frames = [0.0, -0.8, 1.0, -1.0, 0.8, 0.0];
    final scaled = t * (frames.length - 1);
    final index = scaled.floor().clamp(0, frames.length - 2);
    final local = scaled - index;
    return frames[index] + (frames[index + 1] - frames[index]) * local;
  }

  Widget _buildCells(
    AntThemeData ant, {
    required double cellSize,
    required double gap,
    required double radius,
    required Color borderColor,
    required Color danger,
  }) {
    final chars = _currentValue.characters.toList();
    final showCaret = _active && chars.length < widget.length;
    final cells = <Widget>[];
    for (var i = 0; i < widget.length; i++) {
      final filled = i < chars.length;
      final isCaret = showCaret && i == chars.length;
      cells.add(
        SizedBox(
          width: cellSize,
          height: cellSize,
          child: Container(
            key: ValueKey('ant-passcode-cell-$i'),
            decoration: widget.separated
                ? BoxDecoration(
                    color: ant.colorBgContainer,
                    borderRadius: BorderRadius.circular(radius),
                    border: Border.all(
                      color: widget.error
                          ? danger
                          : (isCaret ? ant.colorPrimary : ant.colorBorder),
                      width: ant.s(1),
                    ),
                    boxShadow: isCaret && !widget.error
                        ? [
                            BoxShadow(
                              color: ant.colorPrimary,
                              blurRadius: ant.s(2),
                            ),
                          ]
                        : null,
                  )
                : BoxDecoration(
                    border: i == widget.length - 1
                        ? null
                        : Border(
                            right: BorderSide(
                              color: ant.colorBorder,
                              width: ant.s(1),
                            ),
                          ),
                  ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (filled)
                    widget.plain
                        ? Text(
                            chars[i],
                            style: TextStyle(
                              fontSize: ant.s(20),
                              fontWeight: FontWeight.w500,
                              color: ant.colorText,
                            ),
                          )
                        : Container(
                            width: widget.dotSize ?? ant.s(10),
                            height: widget.dotSize ?? ant.s(10),
                            decoration: BoxDecoration(
                              color: ant.colorText,
                              shape: BoxShape.circle,
                            ),
                          ),
                  if (isCaret) ...[
                    if (filled) SizedBox(width: ant.s(2)),
                    _AntCaret(
                      color: ant.colorPrimary,
                      height: cellSize * 0.55,
                      width: ant.s(1.5),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
      if (widget.separated && i != widget.length - 1) {
        cells.add(SizedBox(width: gap));
      }
    }
    return Row(mainAxisSize: MainAxisSize.min, children: cells);
  }
}

class _AntCaret extends StatefulWidget {
  const _AntCaret({
    required this.color,
    required this.height,
    required this.width,
  });

  final Color color;
  final double height;
  final double width;

  @override
  State<_AntCaret> createState() => _AntCaretState();
}

class _AntCaretState extends State<_AntCaret>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final visible = _controller.value < 0.5;
        return Opacity(opacity: visible ? 1 : 0, child: child);
      },
      child: Container(
        key: const ValueKey('ant-passcode-caret'),
        width: widget.width,
        height: widget.height,
        color: widget.color,
      ),
    );
  }
}
