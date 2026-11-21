# Changelog

## 1.0.2

- Republished with a Web-compatible dependency chain.
- Republished to refresh pub.dev platform scoring.

## 1.0.1

- Fix pub.dev static analysis results by aligning internal dependency constraints.
- Ship the package example and tighten pubspec metadata for better pub.dev scoring.
- Documentation and changelog polish.

## 1.0.0

### AntKeyboard engine

- Layout-driven keyboard: `AntKeyboardLayout` of `AntKeyboardRow`s and `AntKeyboardKey`s, with
  `AntKeyboardLayouts.of(AntKeyboardPreset.*)` resolving the numeric, decimal, text, symbol, email and
  desktop QWERTY presets.
- Key features: long-press character variants, action keys, per-key `flex`, `leading`/`trailing` row
  slots, multi-mode layouts and modifier state.
- Long-press repeat delete with configurable hold delay and repeat interval.
- `AntKeyboardController` binding to a `TextEditingController`: grapheme-aware insert/backspace,
  selection-aware editing, newline/tab, mode cycling and shift/caps handling.
- Theme resolution from `AntTheme` with mobile and desktop metrics, plus `AntKeyboardThemeData`
  overrides merged field by field.
- `handleHardwareKeys` bridges physical-keyboard events into the on-screen keyboard.

### AntKeyboardOverlayController

- Docks any keyboard to the root overlay with bottom or top alignment.
- Enter/exit slide animation; the overlay entry is removed only after the exit animation completes.
- Optional barrier, tap-outside dismissal, Esc dismissal on desktop, and tap-region grouping so taps on
  the keyboard are not treated as outside taps.
- `realign` repositions an open overlay without losing state.

### AntNumberKeyboard

- antd-mobile compatible number pad with controlled and uncontrolled values, `maxLength`,
  `confirmText`, `randomOrder`, `customKey` and `extraKey`.
- Title bar with close button, `safeArea` handling and an opt-in desktop form.

### AntPasscodeInput

- Passcode cells with configurable `length`, `plain` text, `separated` dividers, `error` state and
  focus/blur callbacks.
- `keyboard: true` raises the numeric keyboard; desktop falls back to a transparent text field.

### AntVirtualInput

- Virtual input field with placeholder, clear action, confirm text and enter callback.
- Works with a preset keyboard, a custom `AntKeyboardLayout`, or a themed overlay keyboard, and can dock
  to the top of the screen.
- Desktop mode falls back to the system text field while keeping the same external API.

### Platform behaviour

- Mobile touch form: keys clamped to a minimum 44 touch target, pressed feedback and no hover styling.
- Desktop form: hover states, larger key metrics, overlay margins and physical-keyboard coexistence.
- Bottom safe-area inset is consumed once, by whichever layer docks the keyboard.
