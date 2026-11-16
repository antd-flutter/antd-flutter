/// AntDialog — antd-mobile Dialog（移动端对话框）的 Flutter 实现
///
/// 与桌面版 [AntModal]（lib/src/components/feedback/modal/）区分：
/// 本组件为 antd-mobile 体系的移动端形态 — 居中小卡片（约 0.7 屏宽）、
/// 按钮居中横向均分、缩放淡入动画。
///
/// API 对齐 antd-mobile v5 Dialog：
/// - [AntDialog.visible] — 受控显示
/// - [AntDialog.mode] — alert（单按钮）/ confirm（双按钮）
/// - [AntDialog.title] / [AntDialog.content] — 标题与内容
/// - [AntDialog.actions] — 自定义按钮区
/// - [AntDialog.closeOnMaskClick] — 遮罩点击关闭（默认 true）
/// - [AntDialog.onClick] — 点击按钮回调
/// - [AntDialog.alert] / [AntDialog.confirm] — 函数式快捷方法（返回 `Future<bool>`）
///
/// ```dart
/// AntDialog(visible: true, title: '提示', content: Text('内容'));
/// final ok = await AntDialog.confirm(context, content: const Text('确定吗？'));
/// ```
library;

import 'dart:async';

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_dialog_types.dart';
export 'ant_dialog_types.dart';

// ============================================================
// 测试定位 Key
// ============================================================

/// 遮罩标记 key，便于测试定位。
const Key kAntDialogMaskKey = ValueKey<String>('AntDialogMask');

/// 对话框卡片标记 key。
const Key kAntDialogCardKey = ValueKey<String>('AntDialogCard');

/// 确认按钮标记 key。
const Key kAntDialogOkButtonKey = ValueKey<String>('AntDialogOkButton');

/// 取消按钮标记 key。
const Key kAntDialogCancelButtonKey = ValueKey<String>('AntDialogCancelButton');

/// 自定义动作按钮 key 前缀，完整 key 为 ValueKey('AntDialogAction_$index')。
const String kAntDialogActionKeyPrefix = 'AntDialogAction_';

/// 默认按钮区哨兵（区分「未传 actions」与「显式传 null 隐藏按钮区」）。
const Object _defaultActions = r'__AntDialogDefaultActions__';

// ============================================================
// AntDialog
// ============================================================

/// 对话框 — 移动端模态弹窗，用于重要信息确认或内容展示。
///
/// 对齐 antd-mobile v5 Dialog 组件：受控 [visible]、居中小卡片、
/// 按钮横向均分居中排列、alert/confirm 双模式、actions 自定义按钮区、
/// 遮罩点击关闭。
class AntDialog extends StatefulWidget {
  const AntDialog({
    super.key,
    this.visible = false,
    this.mode = AntDialogMode.alert,
    this.title,
    this.content,
    this.okText = kAntDialogDefaultOkText,
    this.cancelText = kAntDialogDefaultCancelText,
    this.actions = _defaultActions,
    this.closeOnMaskClick = true,
    this.onClick,
    this.widthFactor = kAntDialogDefaultWidthFactor,
  });

  /// 受控显示状态。
  final bool visible;

  /// 展示模式：alert 单按钮 / confirm 双按钮。
  final AntDialogMode mode;

  /// 标题。
  final String? title;

  /// 内容。
  final Widget? content;

  /// 确认按钮文案。
  final String okText;

  /// 取消按钮文案。
  final String cancelText;

  /// 自定义按钮区；显式传 null 隐藏整个按钮区。
  final Object? actions;

  /// 点击遮罩是否关闭（默认 true）。
  final bool closeOnMaskClick;

  /// 点击任意按钮回调（在关闭前触发）。
  final VoidCallback? onClick;

  /// 卡片宽度占屏宽比例（默认 0.7）。
  final double widthFactor;

  /// 是否使用默认按钮组。
  bool get useDefaultActions => identical(actions, _defaultActions);

  /// actions 是否为显式 null（隐藏按钮区）。
  bool get actionsHidden => actions == null;

  /// 弹出 alert 风格对话框（仅确认按钮），用户点击确认返回 true。
  ///
  /// ```dart
  /// await AntDialog.alert(context, title: '提示', content: const Text('操作成功'));
  /// ```
  static Future<bool> alert(
    BuildContext context, {
    String? title,
    required Widget content,
    String okText = kAntDialogDefaultOkText,
    bool closeOnMaskClick = true,
    VoidCallback? onClick,
    List<AntDialogAction>? actions,
  }) {
    return _showFunctionDialog(
      context,
      mode: AntDialogMode.alert,
      title: title,
      content: content,
      okText: okText,
      closeOnMaskClick: closeOnMaskClick,
      onClick: onClick,
      actions: actions,
    );
  }

  /// 弹出 confirm 风格对话框（确认 + 取消双按钮），
  /// 确认返回 true，取消或遮罩关闭返回 false。
  ///
  /// ```dart
  /// final ok = await AntDialog.confirm(
  ///   context, title: '确认', content: const Text('确定删除吗？'));
  /// ```
  static Future<bool> confirm(
    BuildContext context, {
    String? title,
    required Widget content,
    String okText = kAntDialogDefaultOkText,
    String cancelText = kAntDialogDefaultCancelText,
    bool closeOnMaskClick = true,
    VoidCallback? onClick,
  }) {
    return _showFunctionDialog(
      context,
      mode: AntDialogMode.confirm,
      title: title,
      content: content,
      okText: okText,
      cancelText: cancelText,
      closeOnMaskClick: closeOnMaskClick,
      onClick: onClick,
    );
  }

  @override
  State<AntDialog> createState() => _AntDialogState();
}

class _AntDialogState extends State<AntDialog> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget.visible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showOverlay();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AntDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showOverlay();
        });
      } else {
        _hideOverlay();
      }
      return;
    }
    if (_overlayEntry != null && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _overlayEntry != null) {
          _overlayEntry!.markNeedsBuild();
        }
      });
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _showOverlay() {
    if (_overlayEntry != null || !mounted) return;
    final theme = AntTheme.of(context);
    final overlay = Overlay.of(context, rootOverlay: true);
    _overlayEntry = OverlayEntry(
      builder: (context) => _DialogOverlay(
        config: _DialogConfig(
          mode: widget.mode,
          title: widget.title,
          content: widget.content,
          okText: widget.okText,
          cancelText: widget.cancelText,
          actions: widget.actions,
          useDefaultActions: widget.useDefaultActions,
          actionsHidden: widget.actionsHidden,
          closeOnMaskClick: widget.closeOnMaskClick,
          widthFactor: widget.widthFactor,
        ),
        themeData: theme,
        onClick: widget.onClick,
        onClose: _hideOverlay,
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // 对话框浮层通过 Overlay 渲染，本体不占布局空间。
    return const SizedBox.shrink();
  }
}

// ============================================================
// _DialogConfig — 对话框配置快照
// ============================================================

class _DialogConfig {
  const _DialogConfig({
    required this.mode,
    required this.title,
    required this.content,
    required this.okText,
    required this.cancelText,
    required this.actions,
    required this.useDefaultActions,
    required this.actionsHidden,
    required this.closeOnMaskClick,
    required this.widthFactor,
  });

  final AntDialogMode mode;
  final String? title;
  final Widget? content;
  final String okText;
  final String cancelText;
  final Object? actions;
  final bool useDefaultActions;
  final bool actionsHidden;
  final bool closeOnMaskClick;
  final double widthFactor;

  /// 解析出的自定义按钮列表。
  List<AntDialogAction> get parsedActions =>
      (actions as List<AntDialogAction>?) ?? const <AntDialogAction>[];
}

// ============================================================
// _DialogOverlay — 遮罩 + 居中小卡片（缩放淡入动画）
// ============================================================

class _DialogOverlay extends StatefulWidget {
  const _DialogOverlay({
    required this.config,
    required this.themeData,
    this.onClick,
    this.onClose,
    this.completer,
  });

  final _DialogConfig config;
  final AntThemeData themeData;

  /// 点击任意按钮回调。
  final VoidCallback? onClick;

  /// 受控 AntDialog 的移除浮层回调。
  final VoidCallback? onClose;

  /// 函数式用法的结果 Completer。
  final Completer<bool>? completer;

  @override
  State<_DialogOverlay> createState() => _DialogOverlayState();
}

class _DialogOverlayState extends State<_DialogOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: kAntDialogAnimationDuration,
    reverseDuration: kAntDialogAnimationDuration,
  )..forward();
  late final CurvedAnimation _curve =
      CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  bool _closing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleAction(bool result, {VoidCallback? actionOnClick}) {
    if (_closing) return;
    widget.onClick?.call();
    actionOnClick?.call();
    final completer = widget.completer;
    if (completer != null && !completer.isCompleted) {
      completer.complete(result);
    }
    _dismiss();
  }

  void _handleMask() {
    if (!widget.config.closeOnMaskClick) return;
    final completer = widget.completer;
    if (completer != null && !completer.isCompleted) {
      completer.complete(false);
    }
    _dismiss();
  }

  void _dismiss() {
    if (_closing) return;
    _closing = true;
    _controller.reverse().whenComplete(() {
      widget.onClose?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    final theme = widget.themeData;

    final card = Container(
      key: kAntDialogCardKey,
      width: MediaQuery.of(context).size.width * config.widthFactor,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG.r),
        boxShadow: [
          BoxShadow(
            color: theme.colorShadow.withValues(alpha: 0.2),
            blurRadius: 24.r,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (config.title != null) ...[
            Text(
              config.title!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorTextHeading,
              ),
            ),
            SizedBox(height: 12.w),
          ],
          if (config.content != null)
            DefaultTextStyle(
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: theme.fontSize,
                color: theme.colorText,
              ),
              child: config.content!,
            ),
          if (config.title != null || config.content != null)
            SizedBox(height: 24.w),
          if (config.useDefaultActions)
            _buildDefaultActions(theme, config)
          else if (!config.actionsHidden)
            _buildCustomActions(theme, config.parsedActions),
        ],
      ),
    );

    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // 遮罩（淡入）
            Positioned.fill(
              child: FadeTransition(
                opacity: _curve,
                child: GestureDetector(
                  key: kAntDialogMaskKey,
                  onTap: _handleMask,
                  behavior: HitTestBehavior.opaque,
                  child: ColoredBox(color: theme.colorBgMask),
                ),
              ),
            ),
            // 卡片（缩放淡入，居中）
            Align(
              alignment: Alignment.center,
              child: FadeTransition(
                opacity: _curve,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.92, end: 1).animate(_curve),
                  child: card,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 默认按钮区：alert 单按钮 / confirm 双按钮，横向均分。
  Widget _buildDefaultActions(AntThemeData theme, _DialogConfig config) {
    final isConfirm = config.mode == AntDialogMode.confirm;
    final buttons = <Widget>[
      if (isConfirm)
        _ActionButton(
          key: kAntDialogCancelButtonKey,
          text: config.cancelText,
          themeData: theme,
          onTap: () => _handleAction(false),
        ),
      _ActionButton(
        key: kAntDialogOkButtonKey,
        text: config.okText,
        themeData: theme,
        primary: true,
        bold: true,
        onTap: () => _handleAction(true),
      ),
    ];
    return _buildButtonRow(theme, buttons);
  }

  /// 自定义按钮区。
  Widget _buildCustomActions(AntThemeData theme, List<AntDialogAction> actions) {
    final buttons = <Widget>[
      for (var i = 0; i < actions.length; i++)
        _ActionButton(
          key: ValueKey('$kAntDialogActionKeyPrefix$i'),
          text: actions[i].text,
          themeData: theme,
          primary: actions[i].primary,
          bold: actions[i].bold,
          onTap: () => _handleAction(true, actionOnClick: actions[i].onClick),
        ),
    ];
    return _buildButtonRow(theme, buttons);
  }

  Widget _buildButtonRow(AntThemeData theme, List<Widget> buttons) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.colorBorder)),
      ),
      child: Row(children: [
        for (var i = 0; i < buttons.length; i++) ...[
          if (i > 0) Container(width: 0.5, height: 44.w, color: theme.colorBorder),
          Expanded(child: buttons[i]),
        ],
      ],),
    );
  }
}

// ============================================================
// _ActionButton — 移动端对话框按钮（文字居中）
// ============================================================

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.text,
    required this.themeData,
    this.primary = false,
    this.bold = false,
    this.onTap,
  });

  final String text;
  final AntThemeData themeData;
  final bool primary;
  final bool bold;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 44.w,
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            color: primary ? themeData.colorPrimary : themeData.colorText,
          ),
        ),
      ),
    );
  }
}

/// 函数式弹出对话框的内部实现。
Future<bool> _showFunctionDialog(
  BuildContext context, {
  required AntDialogMode mode,
  String? title,
  required Widget content,
  String okText = kAntDialogDefaultOkText,
  String cancelText = kAntDialogDefaultCancelText,
  bool closeOnMaskClick = true,
  VoidCallback? onClick,
  List<AntDialogAction>? actions,
}) {
  final completer = Completer<bool>();
  final overlay = Overlay.of(context, rootOverlay: true);
  final theme = AntTheme.of(context);
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => _DialogOverlay(
      config: _DialogConfig(
        mode: mode,
        title: title,
        content: content,
        okText: okText,
        cancelText: cancelText,
        actions: actions,
        useDefaultActions: actions == null,
        actionsHidden: false,
        closeOnMaskClick: closeOnMaskClick,
        widthFactor: kAntDialogDefaultWidthFactor,
      ),
      themeData: theme,
      onClick: onClick,
      onClose: entry.remove,
      completer: completer,
    ),
  );
  overlay.insert(entry);
  return completer.future;
}
