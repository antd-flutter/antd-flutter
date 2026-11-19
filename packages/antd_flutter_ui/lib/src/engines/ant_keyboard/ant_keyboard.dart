/// AntKeyboard — 通用屏上键盘引擎（仿 flutter_onscreen_keyboard 设计，
/// MIT，完全仿造改造不引依赖）
///
/// - 渲染任意 [AntKeyboardLayout]，主题 token 化（[AntKeyboardThemeData]）
/// - 按压反馈（移动端）/ 悬停反馈（desktop 密度）
/// - 退格长按连续删除（先延迟后周期重复）
/// - 文本键长按变体：弹出备选字符条（如字母重音），点选输入
/// - 全平台可渲染：桌面端展示形态由组件/调用方显式启用（默认唤起策略按平台降级）
library;

import 'dart:async';

import 'package:antd_flutter_ui/src/engines/ant_keyboard/ant_keyboard_layout.dart';
import 'package:antd_flutter_ui/src/engines/ant_keyboard/ant_keyboard_theme.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

/// 通用屏上键盘
class AntKeyboard extends StatefulWidget {
  const AntKeyboard({
    super.key,
    required this.layout,
    this.theme,
    this.confirmText,
    this.onTextInput,
    this.onBackspace,
    this.onConfirm,
    this.onHide,
    this.onKey,
  });

  /// 布局（预设或自定义）
  final AntKeyboardLayout layout;

  /// 主题覆盖（null 时从 AntTheme 派生）
  final AntKeyboardThemeData? theme;

  /// 确认键文案（null 时不渲染独立确认键，confirm 动作键按布局显示）
  final String? confirmText;

  /// 文本输入回调（含长按变体选择）
  final ValueChanged<String>? onTextInput;

  /// 退格回调（长按连续触发）
  final VoidCallback? onBackspace;

  /// 确认回调
  final VoidCallback? onConfirm;

  /// 收起回调（hide 动作键）
  final VoidCallback? onHide;

  /// 原始按键回调（所有按键统一出口，便于扩展）
  final ValueChanged<AntKeyboardKey>? onKey;

  @override
  State<AntKeyboard> createState() => _AntKeyboardState();
}

class _AntKeyboardState extends State<AntKeyboard> {
  // 长按连续删除
  Timer? _backspaceDelay;
  Timer? _backspaceRepeat;

  // 长按变体气泡
  OverlayEntry? _variantEntry;

  @override
  void dispose() {
    _cancelBackspaceRepeat();
    _hideVariants();
    super.dispose();
  }

  void _cancelBackspaceRepeat() {
    _backspaceDelay?.cancel();
    _backspaceRepeat?.cancel();
    _backspaceDelay = null;
    _backspaceRepeat = null;
  }

  void _onBackspaceDown() {
    widget.onBackspace?.call();
    widget.onKey?.call(const AntKeyboardKey.action(AntKeyAction.backspace));
    // 长按连续删除：延迟 300ms 后每 80ms 重复
    _backspaceDelay = Timer(const Duration(milliseconds: 300), () {
      _backspaceRepeat = Timer.periodic(
        const Duration(milliseconds: 80),
        (_) => widget.onBackspace?.call(),
      );
    });
  }

  void _onBackspaceUp() => _cancelBackspaceRepeat();

  void _handleKeyTap(AntKeyboardKey key) {
    widget.onKey?.call(key);
    switch (key.action) {
      case AntKeyAction.text:
        widget.onTextInput?.call(key.text ?? '');
      case AntKeyAction.backspace:
        widget.onBackspace?.call();
      case AntKeyAction.space:
        widget.onTextInput?.call(' ');
      case AntKeyAction.confirm:
        widget.onConfirm?.call();
      case AntKeyAction.hide:
        widget.onHide?.call();
      case AntKeyAction.none:
        break;
    }
  }

  // ----------------------------------------------------------
  // 长按变体气泡
  // ----------------------------------------------------------

  void _showVariants(AntKeyboardKey key, BuildContext anchorContext) {
    if (_variantEntry != null) return;
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;
    final box = anchorContext.findRenderObject() as RenderBox?;
    if (box == null) return;
    final pos = box.localToGlobal(Offset.zero);
    final size = box.size;
    final theme = _resolveTheme();
    _variantEntry = OverlayEntry(
      builder: (ctx) {
        final itemWidth = size.width * 0.8;
        final stripWidth = key.variants.length * itemWidth;
        final left = (pos.dx + size.width / 2 - stripWidth / 2)
            .clamp(0.0, MediaQuery.of(ctx).size.width - stripWidth);
        return Stack(
          children: [
            // 点击空白关闭
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _hideVariants,
              ),
            ),
            Positioned(
              left: left,
              top: pos.dy - theme.keyHeight! - 6,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(theme.sectionPadding!),
                  decoration: BoxDecoration(
                    color: theme.keyBackgroundColor,
                    borderRadius: BorderRadius.circular(theme.keyBorderRadius!),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 6),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final v in key.variants)
                        GestureDetector(
                          onTap: () {
                            _hideVariants();
                            widget.onTextInput?.call(v);
                            widget.onKey?.call(AntKeyboardKey.text(v));
                          },
                          child: Container(
                            width: itemWidth,
                            height: theme.keyHeight,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: theme.keyPressedBackgroundColor,
                              borderRadius: BorderRadius.circular(
                                theme.keyBorderRadius!,
                              ),
                            ),
                            child: Text(
                              v,
                              style: TextStyle(
                                fontSize: theme.fontSize,
                                color: theme.keyForegroundColor,
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
        );
      },
    );
    overlay.insert(_variantEntry!);
  }

  void _hideVariants() {
    _variantEntry?.remove();
    _variantEntry = null;
  }

  AntKeyboardThemeData _resolveTheme() {
    final t = AntTheme.of(context);
    return AntKeyboardThemeData.resolve(t, desktop: widget.theme?.desktop ?? false)
        .merge(widget.theme);
  }

  @override
  Widget build(BuildContext context) {
    final theme = _resolveTheme();
    return Container(
      color: theme.surfaceColor,
      padding: EdgeInsets.all(theme.sectionPadding!),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < widget.layout.rows.length; i++) ...[
            if (i > 0) SizedBox(height: theme.keySpacing),
            Row(
              children: [
                for (var j = 0; j < widget.layout.rows[i].keys.length; j++) ...[
                  if (j > 0) SizedBox(width: theme.keySpacing),
                  Expanded(
                    flex: widget.layout.rows[i].keys[j].flex,
                    child: _buildKey(theme, widget.layout.rows[i].keys[j]),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildKey(AntKeyboardThemeData theme, AntKeyboardKey key) {
    if (key.isBackspace) {
      // 退格：onTapDown 触发单删 + 启动长按连删，onTapUp 停止（onTap 不再重复触发）
      return _KeyboardActionButton(
        theme: theme,
        isBackspace: true,
        onTapDown: _onBackspaceDown,
        onTapUp: _onBackspaceUp,
        child: Icon(
          Icons.backspace_outlined,
          size: theme.iconSize,
          color: theme.actionKeyForegroundColor,
        ),
      );
    }
    switch (key.action) {
      case AntKeyAction.text:
        return _KeyboardTextKey(
          theme: theme,
          key_: key,
          onTap: () => _handleKeyTap(key),
          onLongPress: key.hasVariants
              ? (anchorContext) => _showVariants(key, anchorContext)
              : null,
        );
      case AntKeyAction.space:
        return _KeyboardActionButton(
          theme: theme,
          onTap: () => _handleKeyTap(key),
          child: Icon(
            Icons.space_bar,
            size: theme.iconSize,
            color: theme.actionKeyForegroundColor,
          ),
        );
      case AntKeyAction.confirm:
        return _KeyboardActionButton(
          theme: theme,
          isConfirm: true,
          onTap: () => _handleKeyTap(key),
          child: Text(
            key.actionLabel ?? widget.confirmText ?? '确定',
            style: TextStyle(
              fontSize: theme.fontSize! * 0.8,
              color: theme.confirmForegroundColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      case AntKeyAction.hide:
        return _KeyboardActionButton(
          theme: theme,
          onTap: () => _handleKeyTap(key),
          child: Icon(
            Icons.keyboard_hide_outlined,
            size: theme.iconSize,
            color: theme.actionKeyForegroundColor,
          ),
        );
      case AntKeyAction.backspace:
        return const SizedBox.shrink();
      case AntKeyAction.none:
        return const SizedBox.shrink();
    }
  }
}

/// 文本键（按压反馈 + 桌面悬停反馈 + 长按变体）
class _KeyboardTextKey extends StatefulWidget {
  const _KeyboardTextKey({
    required this.theme,
    required this.key_,
    required this.onTap,
    this.onLongPress,
  });

  final AntKeyboardThemeData theme;
  final AntKeyboardKey key_;
  final VoidCallback onTap;
  final ValueChanged<BuildContext>? onLongPress;

  @override
  State<_KeyboardTextKey> createState() => _KeyboardTextKeyState();
}

class _KeyboardTextKeyState extends State<_KeyboardTextKey> {
  bool _pressed = false;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    var bg = theme.keyBackgroundColor!;
    if (theme.desktop && _hovered) bg = theme.keyHoverBackgroundColor ?? bg;
    if (_pressed) bg = theme.keyPressedBackgroundColor ?? bg;

    final key = GestureDetector(
      onTap: widget.onTap,
      onLongPressStart: widget.onLongPress == null
          ? null
          : (details) => widget.onLongPress!(context),
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: theme.keyHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(theme.keyBorderRadius!),
        ),
        child: Text(
          widget.key_.text ?? '',
          style: TextStyle(
            fontSize: theme.fontSize,
            color: theme.keyForegroundColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );

    if (!theme.desktop) return key;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: key,
    );
  }
}

/// 动作键（退格支持长按连续删除）
class _KeyboardActionButton extends StatefulWidget {
  const _KeyboardActionButton({
    required this.theme,
    required this.child,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.isBackspace = false,
    this.isConfirm = false,
  });

  final AntKeyboardThemeData theme;
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onTapDown;
  final VoidCallback? onTapUp;
  final bool isBackspace;
  final bool isConfirm;

  @override
  State<_KeyboardActionButton> createState() => _KeyboardActionButtonState();
}

class _KeyboardActionButtonState extends State<_KeyboardActionButton> {
  bool _pressed = false;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    Color bg;
    if (widget.isConfirm) {
      bg = theme.confirmBackgroundColor!;
    } else {
      bg = theme.actionKeyBackgroundColor!;
    }
    if (theme.desktop && _hovered && !widget.isConfirm) {
      bg = theme.keyHoverBackgroundColor ?? bg;
    }
    if (_pressed && !widget.isConfirm) {
      bg = theme.actionKeyPressedBackgroundColor ?? bg;
    }

    final btn = GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        setState(() => _pressed = true);
        widget.onTapDown?.call();
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTapUp?.call();
      },
      onTapCancel: () {
        setState(() => _pressed = false);
        widget.onTapUp?.call();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: theme.keyHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(theme.keyBorderRadius!),
        ),
        child: widget.child,
      ),
    );

    if (!theme.desktop) return btn;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: btn,
    );
  }
}
