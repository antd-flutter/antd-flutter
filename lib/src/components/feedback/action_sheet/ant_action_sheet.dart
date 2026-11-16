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
import 'package:flutter/material.dart';

import 'ant_action_sheet_types.dart';
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
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: kAntActionSheetDuration,
  );

  OverlayEntry? _overlayEntry;

  /// 是否已发起内部关闭（遮罩/取消/closeOnAction）。
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    if (widget.visible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showOverlay();
      });
    }
    _controller.addStatusListener(_handleStatus);
  }

  @override
  void didUpdateWidget(covariant AntActionSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showOverlay();
        });
      } else {
        _closing = true;
        _controller.reverse();
      }
      return;
    }
    // 选项/文案变化时刷新已打开的浮层（延迟到帧末避免 build 期 markNeedsBuild）
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
    _controller.removeStatusListener(_handleStatus);
    _overlayEntry?.remove();
    _overlayEntry = null;
    _controller.dispose();
    super.dispose();
  }

  /// 动画结束后按需移除浮层：收起动画播放完才移除 Overlay。
  void _handleStatus(AnimationStatus status) {
    if (status == AnimationStatus.dismissed &&
        (!widget.visible || _closing)) {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null || !mounted) return;
    _closing = false;
    _controller.forward();
    final theme = AntTheme.of(context);
    final overlay = Overlay.of(context, rootOverlay: true);
    _overlayEntry = OverlayEntry(
      builder: (context) => _ActionSheetOverlay(
        sheet: widget,
        themeData: theme,
        animation: CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutCubic,
        ),
        onClose: _handleClose,
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// 内部关闭：触发回调并播放收起动画（父组件可能不更新 visible）。
  void _handleClose() {
    _closing = true;
    _controller.reverse();
    widget.onClose?.call();
  }

  @override
  Widget build(BuildContext context) {
    // 动作面板浮层通过 Overlay 渲染，本体不占布局空间。
    return const SizedBox.shrink();
  }
}

// ============================================================
// _ActionSheetOverlay — 遮罩 + 底部面板浮层
// ============================================================

class _ActionSheetOverlay extends StatelessWidget {
  const _ActionSheetOverlay({
    required this.sheet,
    required this.themeData,
    required this.animation,
    required this.onClose,
  });

  final AntActionSheet sheet;
  final AntThemeData themeData;
  final Animation<double> animation;
  final VoidCallback onClose;

  /// 点击选项。
  void _handleAction(ActionSheetAction action) {
    action.onClick?.call(action);
    if (sheet.closeOnAction) onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 遮罩（点击关闭）
        Positioned.fill(
          child: GestureDetector(
            key: kAntActionSheetMaskKey,
            onTap: onClose,
            behavior: HitTestBehavior.opaque,
            child: FadeTransition(
              opacity: animation,
              child: ColoredBox(color: themeData.colorBgMask),
            ),
          ),
        ),
        // 底部面板（从下滑入）
        Positioned(
          key: kAntActionSheetPanelKey,
          left: 0,
          right: 0,
          bottom: 0,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: _buildPanel(),
          ),
        ),
      ],
    );
  }

  Widget _buildPanel() {
    final theme = themeData;
    return SafeArea(
      top: false,
      bottom: sheet.safeArea,
      child: Material(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.vertical(top: Radius.circular(theme.borderRadiusLG)),
        elevation: 8,
        shadowColor: theme.colorShadow,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 顶部附加说明
            if (sheet.extraDescription != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
                child: Text(
                  sheet.extraDescription!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: theme.colorTextSecondary,
                  ),
                ),
              ),
            // 动作选项
            ..._buildActions(theme),
            // 取消按钮（独立灰色区域）
            if (sheet.cancelText != null) ...[
              SizedBox(height: 8.w),
              Container(
                color: theme.colorFillQuaternary,
                padding: EdgeInsets.symmetric(vertical: 4.w),
                child: GestureDetector(
                  key: kAntActionSheetCancelKey,
                  onTap: onClose,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14.w),
                    alignment: Alignment.center,
                    child: Text(
                      sheet.cancelText!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: theme.colorText,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: action.disabled ? null : () => _handleAction(action),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.w),
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
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                if (action.description != null) ...[
                  SizedBox(height: 2.w),
                  Text(
                    action.description!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
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
      );
    }
    return children;
  }
}
