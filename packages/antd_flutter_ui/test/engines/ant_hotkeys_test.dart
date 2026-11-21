// R37 全局热键系统测试 — AntHotkeyBinding 组合匹配 / HotkeyRegistry 分发 /
// 冲突检测 / 焦点语义 / AntHotkeys 自定义绑定
library;

import 'package:antd_flutter_ui/src/engines/hotkeys/hotkey_binding.dart';
import 'package:antd_flutter_ui/src/engines/hotkeys/hotkey_registry.dart';
import 'package:antd_flutter_ui/src/engines/hotkeys/ant_hotkeys.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  setUp(() {
    HotkeyRegistry.instance.clear();
  });
  tearDown(() {
    HotkeyRegistry.instance.clear();
  });

  group('AntHotkeyBinding — 组合匹配', () {
    test('单键精确匹配', () {
      final binding = AntHotkeyBinding(
        keys: {LogicalKeyboardKey.keyS},
        onTrigger: () {},
      );
      expect(
        binding.matches(
          {LogicalKeyboardKey.keyS},
          const <AntHotkeyModifier>{},
        ),
        isTrue,
      );
      // 按键不一致：不匹配
      expect(
        binding.matches(
          {LogicalKeyboardKey.keyA},
          const <AntHotkeyModifier>{},
        ),
        isFalse,
      );
      // 多按了一个键：不匹配（非修饰键按下集合需完全一致）
      expect(
        binding.matches(
          {LogicalKeyboardKey.keyS, LogicalKeyboardKey.keyA},
          const <AntHotkeyModifier>{},
        ),
        isFalse,
      );
    });

    test('修饰键精确匹配（绑定了 ctrl 必须按住 ctrl）', () {
      final binding = AntHotkeyBinding(
        keys: {LogicalKeyboardKey.keyS},
        modifiers: {AntHotkeyModifier.ctrl},
        onTrigger: () {},
      );
      expect(
        binding.matches(
          {LogicalKeyboardKey.keyS},
          {AntHotkeyModifier.ctrl},
        ),
        isTrue,
      );
      expect(
        binding.matches({LogicalKeyboardKey.keyS}, const <AntHotkeyModifier>{}),
        isFalse,
      );
      expect(
        binding.matches(
          {LogicalKeyboardKey.keyS},
          {AntHotkeyModifier.ctrl, AntHotkeyModifier.shift},
        ),
        isFalse,
      );
    });

    test('修饰键不算入按键集合（左右 ctrl 等价）', () {
      final binding = AntHotkeyBinding(
        keys: {LogicalKeyboardKey.keyS},
        onTrigger: () {},
      );
      expect(
        binding.matches(
          {LogicalKeyboardKey.keyS, LogicalKeyboardKey.controlLeft},
          {AntHotkeyModifier.ctrl},
        ),
        isFalse,
      );
    });

    test('resolveActiveModifiers 解析多修饰键', () {
      final modifiers = resolveActiveModifiers({
        LogicalKeyboardKey.controlRight,
        LogicalKeyboardKey.shiftLeft,
        LogicalKeyboardKey.keyS,
      });
      expect(modifiers, {AntHotkeyModifier.ctrl, AntHotkeyModifier.shift});
    });

    test('字符类按键识别（字母是、Esc/方向键不是）', () {
      expect(
        AntHotkeyBinding(keys: {LogicalKeyboardKey.keyA}, onTrigger: () {})
            .containsCharacterKey,
        isTrue,
      );
      expect(
        AntHotkeyBinding(keys: {LogicalKeyboardKey.escape}, onTrigger: () {})
            .containsCharacterKey,
        isFalse,
      );
      expect(
        AntHotkeyBinding(keys: {LogicalKeyboardKey.arrowUp}, onTrigger: () {})
            .containsCharacterKey,
        isFalse,
      );
    });
  });

  group('HotkeyRegistry — 分发', () {
    testWidgets('组合命中触发回调', (tester) async {
      var triggered = 0;
      HotkeyRegistry.instance.register(AntHotkeyBinding(
        keys: {LogicalKeyboardKey.keyS},
        modifiers: {AntHotkeyModifier.ctrl},
        debugLabel: 'save',
        onTrigger: () => triggered++,
      ),);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyS);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyS);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      expect(triggered, 1);
    });

    testWidgets('组合不命中不触发', (tester) async {
      var triggered = 0;
      HotkeyRegistry.instance.register(AntHotkeyBinding(
        keys: {LogicalKeyboardKey.keyS},
        modifiers: {AntHotkeyModifier.ctrl},
        onTrigger: () => triggered++,
      ),);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyS);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyS);
      expect(triggered, 0);
    });

    testWidgets('when 条件不满足不触发', (tester) async {
      var triggered = 0;
      HotkeyRegistry.instance.register(AntHotkeyBinding(
        keys: {LogicalKeyboardKey.escape},
        when: () => false,
        onTrigger: () => triggered++,
      ),);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
      expect(triggered, 0);
    });

    testWidgets('LIFO：后注册先命中，命中即终止传播', (tester) async {
      var outer = 0;
      var inner = 0;
      HotkeyRegistry.instance.register(AntHotkeyBinding(
        keys: {LogicalKeyboardKey.escape},
        debugLabel: 'outer',
        onTrigger: () => outer++,
      ),);
      HotkeyRegistry.instance.register(AntHotkeyBinding(
        keys: {LogicalKeyboardKey.escape},
        transient: true,
        debugLabel: 'inner',
        onTrigger: () => inner++,
      ),);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
      expect(inner, 1);
      expect(outer, 0);
    });

    testWidgets('注销后不再触发', (tester) async {
      var triggered = 0;
      final binding = AntHotkeyBinding(
        keys: {LogicalKeyboardKey.escape},
        onTrigger: () => triggered++,
      );
      HotkeyRegistry.instance.register(binding);
      HotkeyRegistry.instance.unregister(binding);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
      expect(triggered, 0);
      expect(HotkeyRegistry.instance.bindingCount, 0);
    });

    testWidgets('冲突检测：同组合重复注册不抛错且按 LIFO 生效', (tester) async {
      var first = 0;
      var second = 0;
      HotkeyRegistry.instance.register(AntHotkeyBinding(
        keys: {LogicalKeyboardKey.keyP},
        debugLabel: 'first',
        onTrigger: () => first++,
      ),);
      // 非临时绑定同组合重复注册：输出冲突警告但不阻止注册
      HotkeyRegistry.instance.register(AntHotkeyBinding(
        keys: {LogicalKeyboardKey.keyP},
        debugLabel: 'second',
        onTrigger: () => second++,
      ),);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyP);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyP);
      expect(second, 1);
      expect(first, 0);
      expect(HotkeyRegistry.instance.bindingCount, 2);
    });
  });

  group('焦点语义 — 输入框聚焦', () {
    testWidgets('默认：字母类热键在输入框内不触发', (tester) async {
      var triggered = 0;
      HotkeyRegistry.instance.register(AntHotkeyBinding(
        keys: {LogicalKeyboardKey.keyA},
        onTrigger: () => triggered++,
      ),);
      await tester.pumpWidget(_wrap(
        const TextField(autofocus: true, key: Key('input')),
      ),);
      await tester.pump();
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyA);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyA);
      expect(triggered, 0);
    });

    testWidgets('默认：Esc 等控制键在输入框内仍触发', (tester) async {
      var triggered = 0;
      HotkeyRegistry.instance.register(AntHotkeyBinding(
        keys: {LogicalKeyboardKey.escape},
        ignoreWithinEditable: false,
        onTrigger: () => triggered++,
      ),);
      await tester.pumpWidget(_wrap(
        const TextField(autofocus: true, key: Key('input')),
      ),);
      await tester.pump();
      await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
      expect(triggered, 1);
    });

    testWidgets('ignoreWithinEditable=false：字母类热键输入框内也触发',
        (tester) async {
      var triggered = 0;
      HotkeyRegistry.instance.register(AntHotkeyBinding(
        keys: {LogicalKeyboardKey.keyA},
        ignoreWithinEditable: false,
        onTrigger: () => triggered++,
      ),);
      await tester.pumpWidget(_wrap(
        const TextField(autofocus: true, key: Key('input')),
      ),);
      await tester.pump();
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyA);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyA);
      expect(triggered, 1);
    });
  });

  group('AntHotkeys — 自定义绑定', () {
    testWidgets('挂载期绑定生效、卸载即注销', (tester) async {
      var triggered = 0;
      await tester.pumpWidget(_wrap(AntHotkeys(
        bindings: [
          AntHotkeyBinding(
            keys: {LogicalKeyboardKey.keyD},
            modifiers: {AntHotkeyModifier.alt},
            onTrigger: () => triggered++,
          ),
        ],
        child: const Text('内容'),
      ),),);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyD);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyD);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
      expect(triggered, 1);

      // 卸载后不再触发
      await tester.pumpWidget(_wrap(const Text('内容')));
      await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyD);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyD);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
      expect(triggered, 1);
      expect(HotkeyRegistry.instance.bindingCount, 0);
    });

    testWidgets('when 条件动态控制触发', (tester) async {
      var canSave = false;
      var triggered = 0;
      await tester.pumpWidget(_wrap(StatefulBuilder(
        builder: (context, setState) => AntHotkeys(
          bindings: [
            AntHotkeyBinding(
              keys: {LogicalKeyboardKey.keyS},
              modifiers: {AntHotkeyModifier.ctrl},
              when: () => canSave,
              onTrigger: () => triggered++,
            ),
          ],
          child: TextButton(
            onPressed: () => setState(() => canSave = true),
            child: const Text('enable'),
          ),
        ),
      ),),);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyS);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyS);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      expect(triggered, 0);

      await tester.tap(find.text('enable'));
      await tester.pump();
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.keyS);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.keyS);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      expect(triggered, 1);
    });
  });
}
