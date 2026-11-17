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

import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'ant_modal_types.dart';
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

class _AntModalState extends State<AntModal> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget.open) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showOverlay();
      });
    }
  }

  @override
  void didUpdateWidget(covariant AntModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.open != oldWidget.open) {
      if (widget.open) {
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
      builder: (context) => _ModalOverlay(
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
// _ModalOverlay — 遮罩 + 卡片（缩放淡入动画）
// ============================================================

class _ModalOverlay extends StatefulWidget {
  const _ModalOverlay({
    required this.config,
    required this.themeData,
    this.onOk,
    this.onCancel,
    this.onClose,
    this.completer,
  });

  final _ModalConfig config;
  final AntThemeData themeData;
  final VoidCallback? onOk;
  final VoidCallback? onCancel;

  /// 受控 AntModal 的移除浮层回调。
  final VoidCallback? onClose;

  /// 函数式用法的结果 Completer。
  final Completer<bool?>? completer;

  @override
  State<_ModalOverlay> createState() => _ModalOverlayState();
}

class _ModalOverlayState extends State<_ModalOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: kAntModalAnimationDuration,
    reverseDuration: kAntModalAnimationDuration,
  )..forward();
  late final CurvedAnimation _curve =
      CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  bool _closing = false;
  bool _confirmLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    if (fireCallback) widget.onCancel?.call();
    widget.completer?.complete(false);
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
      key: kAntModalCardKey,
      width: config.width,
      padding: EdgeInsets.all(24.w),
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
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.colorTextHeading,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              if (config.closable)
                GestureDetector(
                  key: kAntModalCloseKey,
                  onTap: _handleCancel,
                  behavior: HitTestBehavior.opaque,
                  child: Icon(
                    Icons.close,
                    size: 16.w,
                    color: theme.colorTextSecondary,
                  ),
                ),
            ],
          ),
          if (config.title != null) SizedBox(height: 12.w),
          if (config.content != null)
            DefaultTextStyle(
              style: TextStyle(
                fontSize: theme.fontSize,
                color: theme.colorText,
              ),
              child: config.content!,
            ),
          SizedBox(height: 24.w),
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

    return Positioned.fill(
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // 遮罩（直接 Positioned.fill 于 Stack，保证铺满全屏可点击）
            Positioned.fill(
              child: FadeTransition(
                opacity: _curve,
                child: GestureDetector(
                  key: kAntModalMaskKey,
                  onTap: () {
                    if (!config.maskClosable) return;
                    _handleCancel();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: ColoredBox(color: theme.colorBgMask),
                ),
              ),
            ),
            // 卡片（缩放淡入）
            Align(
              alignment:
                  config.centered ? Alignment.center : Alignment.topCenter,
              child: Padding(
                padding: config.centered
                    ? EdgeInsets.zero
                    : EdgeInsets.only(top: 100.w),
                child: FadeTransition(
                  opacity: _curve,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.92, end: 1).animate(_curve),
                    child: card,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
        SizedBox(width: 8.w),
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
      onClose: entry.remove,
      completer: completer,
    ),
  );
  overlay.insert(entry);
  return completer.future;
}
