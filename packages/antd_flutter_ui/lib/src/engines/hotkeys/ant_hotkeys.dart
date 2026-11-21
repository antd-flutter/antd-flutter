/// R37 AntHotkeys — 通用热键包裹 widget。
///
/// 任意控件都可挂接热键：
/// ```dart
/// AntHotkeys(
///   bindings: [
///     AntHotkeyBinding(
///       keys: {LogicalKeyboardKey.keyS},
///       modifiers: {AntHotkeyModifier.ctrl},
///       when: () => _canSave,
///       onTrigger: _save,
///     ),
///   ],
///   child: child,
/// )
/// ```
/// 绑定在 widget 挂载期间全局生效（不要求子树持有焦点），卸载即注销；
/// `bindings` 变化时增量同步注册。既有 API 向后兼容——不包裹则无热键行为。
library;

import 'package:flutter/widgets.dart';

import 'hotkey_binding.dart';
import 'hotkey_registry.dart';

/// 热键包裹 widget。
class AntHotkeys extends StatefulWidget {
  const AntHotkeys({
    super.key,
    required this.bindings,
    required this.child,
  });

  /// 快捷键绑定列表（挂载期间全局生效）。
  final List<AntHotkeyBinding> bindings;

  /// 子组件。
  final Widget child;

  @override
  State<AntHotkeys> createState() => _AntHotkeysState();
}

class _AntHotkeysState extends State<AntHotkeys> {
  List<AntHotkeyBinding> _registered = const <AntHotkeyBinding>[];

  @override
  void initState() {
    super.initState();
    _syncBindings();
  }

  @override
  void didUpdateWidget(AntHotkeys oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.bindings, widget.bindings)) _syncBindings();
  }

  void _syncBindings() {
    final registry = HotkeyRegistry.instance;
    for (final binding in _registered) {
      registry.unregister(binding);
    }
    _registered = List.of(widget.bindings);
    for (final binding in _registered) {
      registry.register(binding);
    }
  }

  @override
  void dispose() {
    final registry = HotkeyRegistry.instance;
    for (final binding in _registered) {
      registry.unregister(binding);
    }
    _registered = const <AntHotkeyBinding>[];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
