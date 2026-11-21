/// AntKeyboardOverlayController — 虚拟键盘族底部弹出控制器
///
/// 移动端（iOS/Android）上 NumberKeyboard 应从屏幕底部悬浮弹出（antd-mobile 形态），
/// 而不是嵌入页面流挤占布局。通过 root Overlay 实现底部 dock + 全屏遮罩点击关闭。
///
/// 桌面端不使用本控制器（见 `isDesktopInputPlatform`）。
///
/// TODO(keyboard-form): 当前为简易底部 dock（无遮罩、无弹出动效）。
/// 待引入外部参考库后对齐 antd-mobile Popup 键盘形态（入场/出场动画、
/// 圆角浮层、遮罩交互），届时重构 show() 实现。
library;

import 'package:flutter/services.dart';

import 'package:antd_theme/antd_theme.dart';
// 项目约定：material 系组件统一经 material_ui 引入（同 ant_input_field）
import 'package:material_ui/material_ui.dart';

class AntKeyboardOverlayController {
  OverlayEntry? _entry;

  bool get showing => _entry != null;

  /// Esc 收起本地实现：弹出态监听硬件按键，hide 即注销（R37 语义）。
  /// 包内自实现（HardwareKeyboard），不引入 ui 包键盘引擎依赖。
  bool _handleKey(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape &&
        _entry != null) {
      hide();
      _lastDismiss?.call();
      return true;
    }
    return false;
  }

  /// 在屏幕底部弹出键盘；点击遮罩/键盘外区域触发 [onDismiss]
  void show(
    BuildContext context,
    Widget keyboard, {
    VoidCallback? onDismiss, // 保留参数兼容：不再渲染遮罩时也支持回调
    bool alignTop = false,
  }) {
    hide();
    _lastKeyboard = keyboard;
    _lastDismiss = onDismiss;
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;
    final t = AntTheme.of(context);
    _entry = OverlayEntry(
      builder: (ctx) => Stack(
        children: [
          // dock 键盘（不设全屏遮罩：不拦截输入区/页面其余点击）；
          // 贴底（默认）/贴顶两种对齐（桌面展示形态可切换）
          Positioned(
            left: 0,
            right: 0,
            top: _alignTop ? 0 : null,
            bottom: _alignTop ? null : 0,
            child: Material(
              color: t.colorBgContainer,
              elevation: 8,
              child: SafeArea(top: false, child: keyboard),
            ),
          ),
        ],
      ),
    );
    overlay.insert(_entry!);
    HardwareKeyboard.instance.addHandler(_handleKey);
  }

  void hide() {
    HardwareKeyboard.instance.removeHandler(_handleKey);
    _entry?.remove();
    _entry = null;
  }

  /// 重新弹出（保持最近一次配置）并切换对齐（贴底/贴顶）
  void realign(BuildContext context, {required bool alignTop}) {
    if (_lastKeyboard == null) return;
    show(context, _lastKeyboard!, onDismiss: _lastDismiss, alignTop: alignTop);
  }

  Widget? _lastKeyboard;
  VoidCallback? _lastDismiss;
  final bool _alignTop = false;

  /// 兼容无 Overlay 环境（如部分测试裸泵组件）：返回 false 表示未支持弹出
  static bool isOverlayAvailable(BuildContext context) =>
      Overlay.maybeOf(context, rootOverlay: true) != null;
}
