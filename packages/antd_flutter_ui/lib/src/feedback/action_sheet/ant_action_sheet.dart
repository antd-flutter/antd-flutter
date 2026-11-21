/// AntActionSheet — antd-mobile ActionSheet（动作面板）的 Flutter 实现
///
/// API 与 antd-mobile v5 对齐：
/// - [AntActionSheet.visible] — 受控显示状态
/// - [AntActionSheet.actions] — 动作选项列表
/// - [AntActionSheet.extraDescription] — 顶部附加说明
/// - [AntActionSheet.onClose] — 关闭回调（遮罩/取消/closeOnAction 触发）
/// - [AntActionSheet.cancelText] — 取消按钮文案（独立灰色区域）
/// - [AntActionSheet.closeOnAction] — 点击选项后是否关闭（默认 false）
/// - [AntActionSheet.safeArea] — 是否适配底部安全区（默认 true）
///
/// ```dart
/// AntActionSheet(
///   visible: show,
///   actions: [ActionSheetAction(text: '操作一')],
///   cancelText: '取消',
///   onClose: () {},
/// )
/// ```
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'ant_action_sheet_types.dart';
import '../../engines/overlay_shell.dart';
import '../../engines/popup_overlay.dart';
export 'ant_action_sheet_types.dart';

// ============================================================
// 常量与测试定位 Key
// ============================================================

/// 面板标记 key，便于测试定位面板。
const Key kAntActionSheetPanelKey = ValueKey<String>('AntActionSheetPanel');

/// 遮罩标记 key，便于测试定位遮罩。
const Key kAntActionSheetMaskKey = ValueKey<String>('AntActionSheetMask');

/// 取消按钮标记 key。
const Key kAntActionSheetCancelKey = ValueKey<String>('AntActionSheetCancel');

/// 弹出/收起动画时长。
const Duration kAntActionSheetDuration = Duration(milliseconds: 300);

// ============================================================
// AntActionSheet
// ============================================================

/// 动作面板 — 从底部弹出的一组操作选项。
///
/// 对齐 antd-mobile ActionSheet 组件：actions 列表 + 可选取消按钮，
/// 支持 danger 红色、disabled 灰显、extraDescription 附加说明、
/// closeOnAction 点击后关闭、遮罩点击关闭、底部安全区适配。
class AntActionSheet extends StatefulWidget {
  const AntActionSheet({
    super.key,
    required this.visible,
    required this.actions,
    this.extraDescription,
    this.onClose,
    this.cancelText,
    this.closeOnAction = false,
    this.safeArea = true,
  });

  /// 受控显示状态。
  final bool visible;

  /// 动作选项列表。
  final List<ActionSheetAction> actions;

  /// 顶部附加说明。
  final String? extraDescription;

  /// 关闭回调（遮罩 / 取消按钮 / closeOnAction 触发，外部应将 visible 置为 false）。
  final VoidCallback? onClose;

  /// 取消按钮文案（传入即显示独立灰色取消区域）。
  final String? cancelText;

  /// 点击选项后是否关闭面板（默认 false）。
  final bool closeOnAction;

  /// 是否适配底部安全区（默认 true）。
  final bool safeArea;

  @override
  State<AntActionSheet> createState() => _AntActionSheetState();
}

class _AntActionSheetState extends State<AntActionSheet>
    with PopupContentRefresher, PopupOpenScheduler {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget.visible) {
      schedulePopupOpen(open: true, show: _showOverlay, hide: () {});
    }
  }

  @override
  void didUpdateWidget(covariant AntActionSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      schedulePopupOpen(open: widget.visible, show: _showOverlay, hide: () {});
    }
    // visible 翻转 / 选项文案变化：延迟到帧末原地重建浮层（基座统一调度）；
    // 收起动画由基座播放，播完回调 _removeOverlay 移除浮层
    refreshPopupContent();
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    popupContentEntry = null;
    super.dispose();
  }

  void _showOverlay() {
    if (_overlayEntry != null || !mounted) return;
    final theme = AntTheme.of(context);
    final overlay = Overlay.of(context, rootOverlay: true);
    _overlayEntry = OverlayEntry(
      builder: (context) => _ActionSheetOverlay(
        open: widget.visible,
        sheet: widget,
        themeData: theme,
        onRemove: _removeOverlay,
        onExternalClose: _handleClose,
      ),
    );
    popupContentEntry = _overlayEntry;
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// 内部关闭兜底：父组件可能不更新 visible，直接移除浮层。
  void _handleClose() {
    widget.onClose?.call();
    _removeOverlay();
  }

  @override
  Widget build(BuildContext context) {
    // 动作面板浮层通过 Overlay 渲染，本体不占布局空间。
    return const SizedBox.shrink();
  }
}

// ============================================================
// _ActionSheetOverlay — 基座（AntOverlayShell）+ 底部面板
// ============================================================

class _ActionSheetOverlay extends StatefulWidget {
  const _ActionSheetOverlay({
    required this.open,
    required this.sheet,
    required this.themeData,
    required this.onRemove,
    required this.onExternalClose,
  });

  /// 初始/受控显示状态。
  final bool open;

  final AntActionSheet sheet;
  final AntThemeData themeData;

  /// 退出动画播放完毕后的浮层移除回调。
  final VoidCallback onRemove;

  /// 父级兜底关闭（父组件不更新 visible 时由宿主直接移除浮层）。
  final VoidCallback onExternalClose;

  @override
  State<_ActionSheetOverlay> createState() => _ActionSheetOverlayState();
}

class _ActionSheetOverlayState extends State<_ActionSheetOverlay> {
  /// 内部 open 镜像：受控跟随 [AntActionSheet.visible]，内部关闭
  /// （遮罩/取消/closeOnAction）时翻 false，由基座播放收起动画。
  late bool _open = widget.open;
  bool _closing = false;

  @override
  void didUpdateWidget(covariant _ActionSheetOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != oldWidget.open && !_closing) {
      _open = widget.open;
    }
  }

  /// 内部关闭：触发回调、翻 open=false 播放收起动画后移除浮层。
  void _handleClose() {
    if (_closing) return;
    _closing = true;
    widget.sheet.onClose?.call();
    setState(() => _open = false);
  }

  /// 点击选项。
  void _handleAction(ActionSheetAction action) {
    action.onClick?.call(action);
    if (widget.sheet.closeOnAction) _handleClose();
  }

  @override
  Widget build(BuildContext context) {
    // 弹层基座：遮罩淡入淡出 + 底部滑入动画 + 退出动画后移除浮层
    return AntOverlayShell(
      // R37 热键基座：打开状态下按 Esc 关闭（触发动作同遮罩点击）
      escToClose: true,
      open: _open,
      alignment: Alignment.bottomCenter,
      slideBegin: const Offset(0, 1),
      maskKey: kAntActionSheetMaskKey,
      onMaskTap: _handleClose,
      duration: kAntActionSheetDuration,
      curve: Curves.easeOutCubic,
      onExited: widget.onRemove,
      panelKey: kAntActionSheetPanelKey,
      // 桌面端宽度封顶（移动端保持全宽贴边），居中展示
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: antIsDesktopViewport(context)
              ? kAntMobileOverlayDefaultMaxWidth
              : double.infinity,
        ),
        child: _buildPanel(),
      ),
    );
  }

  AntActionSheet get sheet => widget.sheet;
  AntThemeData get themeData => widget.themeData;

  Widget _buildPanel() {
    final theme = themeData;
    // 底部安全区留白与面板同色填充（SafeArea 透明留白在深色页面下有割裂感）
    final bottomInset = sheet.safeArea ? antDeviceSafePadding().bottom : 0.0;
    final radius =
        BorderRadius.vertical(top: Radius.circular(theme.borderRadiusLG));
    // 面板整体贴底（移入安全区），安全距离作为面板内部的同色留白，
    // 阴影/圆角完整包住整个面板，不产生任何透明分界
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: theme.colorShadow.withValues(alpha: 0.5),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Material(
        color: theme.colorBgContainer,
        borderRadius: radius,
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 顶部附加说明
            if (sheet.extraDescription != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: theme.s(16), vertical: theme.s(12)),
                child: Text(
                  sheet.extraDescription!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: theme.s(13),
                    color: theme.colorTextSecondary,
                  ),
                ),
              ),
            // 动作选项
            ..._buildActions(theme),
            // 取消按钮（独立灰色区域）
            if (sheet.cancelText != null) ...[
              SizedBox(height: theme.s(8)),
              Container(
                color: theme.colorFillQuaternary,
                padding: EdgeInsets.symmetric(vertical: theme.s(4)),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    key: kAntActionSheetCancelKey,
                    onTap: _handleClose,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: theme.s(14)),
                      alignment: Alignment.center,
                      child: Text(
                        sheet.cancelText!,
                        style: TextStyle(
                          fontSize: theme.s(16),
                          color: theme.colorText,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            // 底部安全距离（面板内部同色留白，位于取消按钮之后）
            if (bottomInset > 0) SizedBox(height: bottomInset),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions(AntThemeData theme) {
    final List<Widget> children = <Widget>[];
    for (var i = 0; i < sheet.actions.length; i++) {
      final action = sheet.actions[i];
      final Color textColor = action.disabled
          ? theme.colorTextQuaternary
          : action.danger
              ? theme.colorError
              : theme.colorText;
      children.add(
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: action.disabled ? null : () => _handleAction(action),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: theme.s(16), vertical: theme.s(14)),
              decoration: BoxDecoration(
                border: i > 0
                    ? Border(
                        top: BorderSide(color: theme.colorSplit, width: 0.5),
                      )
                    : null,
              ),
              child: Column(
                children: [
                  Text(
                    action.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: theme.s(16),
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  if (action.description != null) ...[
                    SizedBox(height: theme.s(2)),
                    Text(
                      action.description!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: theme.s(12),
                        color: action.disabled
                            ? theme.colorTextQuaternary
                            : theme.colorTextTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }
    return children;
  }
}
