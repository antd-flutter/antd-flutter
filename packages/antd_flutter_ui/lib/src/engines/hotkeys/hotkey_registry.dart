/// R37 热键注册中心 — 全局键盘监听 + 绑定分发 + 注册/注销 + 冲突检测。
///
/// 基于 `HardwareKeyboard` 全局 key 事件（桌面端/Flutter test 的
/// `tester.sendKeyEvent` 均走此通道，不依赖 Focus 结构，弹层类无焦点场景
/// 也能收到 Esc）。分发语义：
/// - **LIFO**：后注册的绑定先命中（弹层栈顶优先关闭），命中即终止传播；
/// - **焦点语义**：焦点位于可编辑文本（EditableText）内时，默认跳过含
///   字符类按键且 `ignoreWithinEditable` 为 true 的绑定（字母热键不误触
///   打字）；Esc 等控制键绑定不受影响。
library;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'hotkey_binding.dart';

/// 热键注册中心（全局单例）。
///
/// ```dart
/// HotkeyRegistry.instance.register(binding);
/// HotkeyRegistry.instance.unregister(binding);
/// ```
class HotkeyRegistry {
  HotkeyRegistry._();

  static final HotkeyRegistry instance = HotkeyRegistry._();

  final List<AntHotkeyBinding> _bindings = <AntHotkeyBinding>[];
  bool _handlerInstalled = false;

  /// 当前已注册绑定数（测试用）。
  @visibleForTesting
  int get bindingCount => _bindings.length;

  /// 注册绑定；首个注册时安装全局 HardwareKeyboard 监听。
  /// 同组合的重复注册（非临时绑定）输出冲突警告。
  void register(AntHotkeyBinding binding) {
    _bindings.add(binding);
    _ensureHandler();
    if (!binding.transient) _warnConflicts(binding);
  }

  /// 注销绑定。
  void unregister(AntHotkeyBinding binding) {
    _bindings.remove(binding);
    if (_bindings.isEmpty) {
      // 全部注销后移除监听，避免常驻回调。
      HardwareKeyboard.instance.removeHandler(_handleKey);
      _handlerInstalled = false;
    }
  }

  /// 注销所有绑定（测试隔离用）。
  @visibleForTesting
  void clear() {
    _bindings.clear();
    if (_handlerInstalled) {
      HardwareKeyboard.instance.removeHandler(_handleKey);
      _handlerInstalled = false;
    }
  }

  void _ensureHandler() {
    if (_handlerInstalled) return;
    HardwareKeyboard.instance.addHandler(_handleKey);
    _handlerInstalled = true;
  }

  bool _handleKey(KeyEvent event) {
    // 仅 KeyDown 触发一次；KeyRepeat/KeyUp 不重复触发。
    if (event is! KeyDownEvent) return false;
    return dispatch();
  }

  /// 按当前按下状态分发：LIFO 遍历，首个命中（组合匹配 + when 通过 +
  /// 焦点语义通过）的绑定触发回调并终止传播。
  bool dispatch() {
    final pressed = HardwareKeyboard.instance.logicalKeysPressed;
    final modifiers = resolveActiveModifiers(pressed);
    final withinEditable = _focusWithinEditable();
    for (final binding in _bindings.reversed) {
      if (!binding.matches(pressed, modifiers)) continue;
      final when = binding.when;
      if (when != null && !when()) continue;
      // 焦点语义：输入框内默认跳过字符类热键（Esc 等控制键仍触发）。
      if (withinEditable &&
          binding.ignoreWithinEditable &&
          binding.containsCharacterKey) {
        continue;
      }
      binding.onTrigger();
      return true;
    }
    return false;
  }

  /// 焦点是否位于可编辑文本（EditableText）内。
  static bool _focusWithinEditable() {
    final context = FocusManager.instance.primaryFocus?.context;
    if (context is! Element) return false;
    if (context.widget is EditableText) return true;
    var found = false;
    context.visitAncestorElements((element) {
      if (element.widget is EditableText) {
        found = true;
        return false;
      }
      return true;
    });
    return found;
  }

  /// 冲突检测：同组合的非临时绑定同时存在时输出警告（不阻止注册——
  /// LIFO 分发保证后注册者先命中，运行时不中断）。
  void _warnConflicts(AntHotkeyBinding binding) {
    for (final other in _bindings) {
      if (identical(other, binding) || other.transient) continue;
      if (other.combo == binding.combo) {
        debugPrint(
          'HotkeyRegistry: 热键组合「${binding.combo}」存在重复绑定'
          '（${other.debugLabel ?? 'anonymous'} 与 '
          '${binding.debugLabel ?? 'anonymous'}）；'
          '两者均会注册，按 LIFO 后注册先命中，请确认是否预期。',
        );
      }
    }
  }
}
