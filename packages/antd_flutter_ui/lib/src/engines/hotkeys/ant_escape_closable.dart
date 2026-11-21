/// R37 弹层 Esc 关闭统一接线 — 弹层内容包裹件。
///
/// 供不经 [AntPopupOverlay] 承载的全屏弹层（Dialog/Drawer/Modal/
/// ActionSheet/Popup）在 OverlayEntry 内容外包裹一层，挂载期间注册
/// Esc 关闭绑定，卸载即注销。临时绑定（transient），参与 LIFO——
/// 多层弹层同时打开时栈顶先关，不触发冲突警告。
library;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'hotkey_binding.dart';
import 'hotkey_registry.dart';

/// Esc 关闭包裹件。
class AntEscapeClosable extends StatefulWidget {
  const AntEscapeClosable({
    super.key,
    required this.onEscape,
    required this.child,
    this.enabled = true,
  });

  /// 按 Esc 时回调（组件关闭动作）。
  final VoidCallback onEscape;

  /// 弹层内容。
  final Widget child;

  /// 是否启用（组件不希望 Esc 关闭时传 false，行为退化为直通）。
  final bool enabled;

  @override
  State<AntEscapeClosable> createState() => _AntEscapeClosableState();
}

class _AntEscapeClosableState extends State<AntEscapeClosable> {
  AntHotkeyBinding? _binding;

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(AntEscapeClosable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled ||
        oldWidget.onEscape != widget.onEscape) {
      _sync();
    }
  }

  void _sync() {
    final registry = HotkeyRegistry.instance;
    final old = _binding;
    if (old != null) registry.unregister(old);
    if (!widget.enabled) {
      _binding = null;
      return;
    }
    _binding = AntHotkeyBinding(
      keys: {LogicalKeyboardKey.escape},
      // 控制键：输入框聚焦内仍触发（焦点语义默认跳过的是字符类热键）。
      ignoreWithinEditable: false,
      transient: true,
      debugLabel: 'AntEscapeClosable',
      onTrigger: widget.onEscape,
    );
    registry.register(_binding!);
  }

  @override
  void dispose() {
    final binding = _binding;
    if (binding != null) HotkeyRegistry.instance.unregister(binding);
    _binding = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
