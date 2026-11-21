/// 平台输入形态判定 — 供虚拟键盘族组件（NumberKeyboard/PasscodeInput/VirtualInput）
/// 区分移动端与桌面端交互形态。
///
/// - 移动端（iOS/Android）：点击输入区域唤起自定义虚拟键盘；
/// - 桌面端（macOS/Windows/Linux 及桌面 Web）：表现为普通输入框，走系统键盘输入。
library;

import 'package:flutter/foundation.dart';

/// 当前是否为桌面平台（桌面端不使用自定义虚拟键盘，直接走系统输入）
bool isDesktopInputPlatform() {
  final p = defaultTargetPlatform;
  if (kIsWeb) {
    return p == TargetPlatform.windows ||
        p == TargetPlatform.macOS ||
        p == TargetPlatform.linux;
  }
  return p == TargetPlatform.windows ||
      p == TargetPlatform.macOS ||
      p == TargetPlatform.linux;
}
