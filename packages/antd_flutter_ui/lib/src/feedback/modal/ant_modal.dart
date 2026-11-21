/// AntModal — antd React Modal（对话框）的 Flutter 实现
///
/// API 与 antd React Modal 对齐：
/// - [AntModal] — 受控 `open` 的对话框组件
/// - [showAntModal] — 函数式快捷方法（confirm 风格，返回 `Future<bool?>`）
/// - [AntModal.title] / [AntModal.content] — 标题与内容
/// - [AntModal.okText] / [AntModal.cancelText] — 按钮文案（确定 / 取消）
/// - [AntModal.onOk] / [AntModal.onCancel] — 确认/取消回调
/// - [AntModal.confirmLoading] — 确认按钮加载态
/// - [AntModal.footer] — 自定义底部（传 null 隐藏）
/// - [AntModal.width] / [AntModal.centered] — 宽度与垂直居中
/// - [AntModal.maskClosable] / [AntModal.closable] — 遮罩/右上角关闭
///
/// ```dart
/// AntModal(open: true, title: '标题', content: Text('内容'));
/// await showAntModal(context, title: '确认', content: Text('确定删除吗？'));
/// ```
library;

import 'dart:async';

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import '../../basic/button/ant_button.dart';
import '../../basic/button/ant_button_types.dart';
import '../../engines/overlay_shell.dart';
import '../../engines/popup_overlay.dart';
import 'ant_modal_types.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';
export 'ant_modal_types.dart';

// ============================================================
// 测试定位 Key
// ============================================================

/// 遮罩标记 key，便于测试定位。
const Key kAntModalMaskKey = ValueKey<String>('AntModalMask');

/// 对话框卡片标记 key。
const Key kAntModalCardKey = ValueKey<String>('AntModalCard');

/// 确认按钮标记 key。
const Key kAntModalOkButtonKey = ValueKey<String>('AntModalOkButton');

/// 取消按钮标记 key。
const Key kAntModalCancelButtonKey = ValueKey<String>('AntModalCancelButton');

/// 右上角关闭图标标记 key。
const Key kAntModalCloseKey = ValueKey<String>('AntModalClose');

/// 对话框动画时长。
const Duration kAntModalAnimationDuration = Duration(milliseconds: 200);

/// 底部默认占位标记（区分「未传 footer」与「显式传 null 隐藏 footer」）。
const String _defaultFooter = r'__AntModalDefaultFooter__';

// ============================================================
// AntModal
// ============================================================

/// 对话框 — 模态弹窗，用于重要信息确认或内容展示。
///
/// 对齐 antd React Modal 组件：受控 [open]、遮罩点击关闭、右上角关闭、
/// 确认/取消双按钮（主按钮主色）、confirmLoading 加载态、
/// footer 自定义或 null 隐藏、width 宽度与 centered 垂直居中。
class AntModal extends StatefulWidget {
  const AntModal({
    super.key,
    this.open = false,
    this.title,
    this.content,
    this.okText = kAntModalDefaultOkText,
    this.cancelText = kAntModalDefaultCancelText,
    this.onOk,
    this.onCancel,
    this.confirmLoading = false,
    this.footer = _defaultFooter,
    this.width = kAntModalDefaultWidth,
    this.maskClosable = true,
    this.closable = true,
    this.centered = false,
  });

  /// 受控打开状态。
  final bool open;

  /// 标题。
  final String? title;

  /// 内容。
  final Widget? content;

  /// 确认按钮文案。
  final String okText;

  /// 取消按钮文案。
  final String cancelText;

  /// 点击确认回调。
  final VoidCallback? onOk;

  /// 点击取消 / 遮罩 / 关闭图标回调。
  final VoidCallback? onCancel;

  /// 确认按钮加载态（加载中不可点击）。
  final bool confirmLoading;

  /// 自定义底部；显式传 null 隐藏整个底部。
  final Object? footer;

  /// 对话框宽度（逻辑像素）。
  final double? width;

  /// 点击遮罩是否关闭。
  final bool maskClosable;

  /// 是否显示右上角关闭图标。
  final bool closable;

  /// 是否垂直居中（默认偏上展示）。
  final bool centered;

  /// footer 是否为显式 null（隐藏底部）。
  bool get footerHidden => footer == null;

  /// footer 是否使用默认按钮组。
  bool get useDefaultFooter => identical(footer, _defaultFooter);

  @override
  State<AntModal> createState() => _AntModalState();
}

class _AntModalState extends State<AntModal>
    with PopupContentRefresher, PopupOpenScheduler {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget.open) {
      schedulePopupOpen(open: true, show: _showOverlay, hide: () {});
    }
  }

  @override
  void didUpdateWidget(covariant AntModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != oldWidget.open) {
      schedulePopupOpen(open: widget.open, show: _showOverlay, hide: () {});
    }
    // open 翻转 / 样式内容变化：延迟到帧末原地重建浮层（基座统一调度）
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
      builder: (context) => _ModalOverlay(
        open: widget.open,
        config: _ModalConfig(
          title: widget.title,
          content: widget.content,
          okText: widget.okText,
          cancelText: widget.cancelText,
          confirmLoading: widget.confirmLoading,
          footer: widget.footer,
          useDefaultFooter: widget.useDefaultFooter,
          footerHidden: widget.footerHidden,
          width: widget.width ?? kAntModalDefaultWidth,
          maskClosable: widget.maskClosable,
          closable: widget.closable,
          centered: widget.centered,
        ),
        themeData: theme,
        onOk: widget.onOk,
        onCancel: widget.onCancel,
        onRemove: _hideOverlay,
      ),
    );
    popupContentEntry = _overlayEntry;
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
// _ModalConfig — 对话框配置快照
// ============================================================

class _ModalConfig {
  const _ModalConfig({
    required this.title,
    required this.content,
    required this.okText,
    required this.cancelText,
    required this.confirmLoading,
    required this.footer,
    required this.useDefaultFooter,
    required this.footerHidden,
    required this.width,
    required this.maskClosable,
    required this.closable,
    required this.centered,
  });

  final String? title;
  final Widget? content;
  final String okText;
  final String cancelText;
  final bool confirmLoading;
  final Object? footer;
  final bool useDefaultFooter;
  final bool footerHidden;
  final double width;
  final bool maskClosable;
  final bool closable;
  final bool centered;
}

// ============================================================
// _ModalOverlay — 基座（AntOverlayShell）+ 卡片（缩放淡入动画）
// ============================================================

class _ModalOverlay extends StatefulWidget {
  const _ModalOverlay({
    required this.open,
    required this.config,
    required this.themeData,
    this.onOk,
    this.onCancel,
    this.onRemove,
    this.completer,
  });

  /// 初始/受控显示状态。
  final bool open;

  final _ModalConfig config;
  final AntThemeData themeData;
  final VoidCallback? onOk;
  final VoidCallback? onCancel;

  /// 退出动画播放完毕后的浮层移除回调。
  final VoidCallback? onRemove;

  /// 函数式用法的结果 Completer。
  final Completer<bool?>? completer;

  @override
  State<_ModalOverlay> createState() => _ModalOverlayState();
}

class _ModalOverlayState extends State<_ModalOverlay> {
  /// 内部 open 镜像：受控跟随 [AntModal.open]，内部关闭（按钮/遮罩/关闭图标）
  /// 时立即翻 false，由基座播放退出动画后回调 [widget.onRemove]。
  late bool _open = widget.open;
  bool _closing = false;
  bool _confirmLoading = false;

  @override
  void didUpdateWidget(covariant _ModalOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != oldWidget.open && !_closing) {
      _open = widget.open;
    }
  }

  void _handleOk() {
    if (widget.config.confirmLoading || _confirmLoading) return;
    _setConfirmLoading();
    widget.onOk?.call();
    widget.completer?.complete(true);
    _dismiss();
  }

  void _setConfirmLoading() {
    if (!widget.config.confirmLoading) return;
    setState(() => _confirmLoading = true);
  }

  void _handleCancel({bool fireCallback = true}) {
    if (_closing) return;
    if (fireCallback) widget.onCancel?.call();
    widget.completer?.complete(false);
    _dismiss();
  }

  /// 内部关闭：翻 open=false，退出动画交给基座统一播放。
  void _dismiss() {
    if (_closing) return;
    _closing = true;
    setState(() => _open = false);
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    final theme = widget.themeData;

    final card = Container(
      key: kAntModalCardKey,
      width: config.width,
      padding: EdgeInsets.all(theme.s(24)),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        boxShadow: [
          BoxShadow(
            color: theme.colorShadow.withValues(alpha: 0.2),
            blurRadius: theme.s(24),
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: config.title != null
                    ? Text(
                        config.title!,
                        style: TextStyle(
                          fontSize: theme.s(16),
                          fontWeight: FontWeight.w600,
                          color: theme.colorTextHeading,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              if (config.closable)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    key: kAntModalCloseKey,
                    onTap: _handleCancel,
                    behavior: HitTestBehavior.opaque,
                    child: Icon(
                      AntIcons.closeOutlined,
                      size: theme.s(16),
                      color: theme.colorTextSecondary,
                    ),
                  ),
                ),
            ],
          ),
          if (config.title != null) SizedBox(height: theme.s(12)),
          if (config.content != null)
            DefaultTextStyle(
              style: TextStyle(
                fontSize: theme.fontSize,
                color: theme.colorText,
              ),
              child: config.content!,
            ),
          SizedBox(height: theme.s(24)),
          if (config.useDefaultFooter) _buildDefaultFooter(theme, config),
          if (config.footerHidden)
            const SizedBox.shrink()
          else if (!config.useDefaultFooter)
            DefaultTextStyle(
              style: TextStyle(
                fontSize: theme.fontSize,
                color: theme.colorText,
              ),
              child: config.footer as Widget,
            ),
        ],
      ),
    );

    // 弹层基座：遮罩淡入淡出 + 缩放淡入动画 + 退出动画后移除浮层
    return AntOverlayShell(
      // R37 热键基座：打开状态下按 Esc 关闭（触发动作同遮罩点击）
      escToClose: true,
      open: _open,
      alignment: config.centered ? Alignment.center : Alignment.topCenter,
      padding: config.centered ? EdgeInsets.zero : EdgeInsets.only(top: theme.s(100)),
      maskKey: kAntModalMaskKey,
      onMaskTap: config.maskClosable ? () => _handleCancel() : null,
      maskClosable: true,
      duration: kAntModalAnimationDuration,
      onExited: widget.onRemove,
      child: card,
    );
  }

  Widget _buildDefaultFooter(AntThemeData theme, _ModalConfig config) {
    final loading = config.confirmLoading || _confirmLoading;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AntButton(
          key: kAntModalCancelButtonKey,
          onTap: () => _handleCancel(),
          child: Text(config.cancelText),
        ),
        SizedBox(width: theme.s(8)),
        AntButton(
          key: kAntModalOkButtonKey,
          type: AntButtonType.primary,
          loading: loading,
          onTap: loading ? null : _handleOk,
          child: Text(config.okText),
        ),
      ],
    );
  }
}

// ============================================================
// showAntModal — 函数式快捷方法
// ============================================================

/// 弹出确认风格的对话框，返回用户选择（true 确认 / false 取消 / null 被移除）。
///
/// ```dart
/// final ok = await showAntModal(
///   context,
///   title: '删除确认',
///   content: const Text('确定要删除这条记录吗？'),
/// );
/// ```
Future<bool?> showAntModal(
  BuildContext context, {
  String? title,
  Widget? content,
  String okText = kAntModalDefaultOkText,
  String cancelText = kAntModalDefaultCancelText,
  VoidCallback? onOk,
  VoidCallback? onCancel,
  bool confirmLoading = false,
  Object? footer = _defaultFooter,
  double width = kAntModalDefaultWidth,
  bool maskClosable = true,
  bool closable = true,
  bool centered = true,
}) {
  final completer = Completer<bool?>();
  final overlay = Overlay.of(context, rootOverlay: true);
  final theme = AntTheme.of(context);
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => _ModalOverlay(
      open: true,
      config: _ModalConfig(
        title: title,
        content: content,
        okText: okText,
        cancelText: cancelText,
        confirmLoading: confirmLoading,
        footer: footer,
        useDefaultFooter: identical(footer, _defaultFooter),
        footerHidden: footer == null,
        width: width,
        maskClosable: maskClosable,
        closable: closable,
        centered: centered,
      ),
      themeData: theme,
      onOk: onOk,
      onCancel: onCancel,
      onRemove: entry.remove,
      completer: completer,
    ),
  );
  overlay.insert(entry);
  return completer.future;
}
