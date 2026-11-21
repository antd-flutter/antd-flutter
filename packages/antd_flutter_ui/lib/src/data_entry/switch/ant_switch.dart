/// AntSwitch — antd Switch 开关的 Flutter 实现
///
/// 在两种互斥状态间切换，支持加载中、禁用、自定义文案。
///
/// ```dart
/// AntSwitch(
///   checked: true,
///   onChange: (v) => print(v),
///   checkedChildren: Text('开'),
///   unCheckedChildren: Text('关'),
/// )
/// ```
library;

import 'package:antd_flutter_ui/src/data_entry/switch/ant_switch_types.dart';
import '../../feedback/loading/ant_loading.dart';
import 'package:antd_theme/antd_theme.dart';

export 'package:antd_flutter_ui/src/data_entry/switch/ant_switch_types.dart';
import 'package:material_ui/material_ui.dart';

/// 开关组件 — 对齐 antd React Switch。
class AntSwitch extends StatefulWidget {
  const AntSwitch({
    super.key,
    this.checked,
    this.defaultChecked = false,
    this.disabled = false,
    this.loading = false,
    this.size = AntSwitchSize.middle,
    this.checkedChildren,
    this.unCheckedChildren,
    this.onChange,
    this.autofocus = false,
  });

  /// 受控选中状态。
  final bool? checked;

  /// 非受控初始选中状态。
  final bool defaultChecked;

  /// 是否禁用。
  final bool disabled;

  /// 是否加载中（此时不可切换）。
  final bool loading;

  /// 尺寸。
  final AntSwitchSize size;

  /// 选中时显示的内容。
  final Widget? checkedChildren;

  /// 未选中时显示的内容。
  final Widget? unCheckedChildren;

  /// 变化回调。
  final ValueChanged<bool>? onChange;

  /// 是否自动聚焦。
  final bool autofocus;

  @override
  State<AntSwitch> createState() => _AntSwitchState();
}

class _AntSwitchState extends State<AntSwitch> {
  late bool _checked;

  @override
  void initState() {
    super.initState();
    _checked = widget.checked ?? widget.defaultChecked;
  }

  @override
  void didUpdateWidget(AntSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.checked != null && widget.checked != _checked) {
      _checked = widget.checked!;
    }
  }

  void _toggle() {
    if (widget.disabled || widget.loading) return;
    final next = !_checked;
    setState(() => _checked = next);
    widget.onChange?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final isSmall = widget.size == AntSwitchSize.small;
    final trackW = t.s((isSmall ? 28 : 40));
    final trackH = t.s((isSmall ? 16 : 22));
    final thumbSize = trackH - t.s(4);
    final padding = t.s(2);

    final isChecked = widget.checked ?? _checked;
    final isDisabled = widget.disabled;
    final isLoading = widget.loading;

    final activeColor = isDisabled
        ? t.colorBgContainerDisabled
        : t.colorPrimary;
    final inactiveColor = isDisabled
        ? t.colorBgContainerDisabled
        : t.colorFillSecondary.withValues(alpha: 0.6);

    final childTextSize = t.s((isSmall ? 10 : 12));
    final childColor = isDisabled ? t.colorTextDisabled : Colors.white;

    return GestureDetector(
      onTap: _toggle,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: trackW,
        height: trackH,
        decoration: BoxDecoration(
          color: isChecked ? activeColor : inactiveColor,
          borderRadius: BorderRadius.circular(trackH / 2),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 文案
            AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: isChecked ? 1 : 0,
              child: isChecked
                  ? Padding(
                      padding: EdgeInsets.only(right: thumbSize + padding * 2),
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: childTextSize,
                          color: childColor,
                        ),
                        child: widget.checkedChildren ?? const SizedBox.shrink(),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: !isChecked ? 1 : 0,
              child: !isChecked
                  ? Padding(
                      padding: EdgeInsets.only(left: thumbSize + padding * 2),
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: childTextSize,
                          color: childColor,
                        ),
                        child: widget.unCheckedChildren ?? const SizedBox.shrink(),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            // 滑块
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: isChecked ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.all(padding),
                width: thumbSize,
                height: thumbSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: t.s(2),
                      offset: Offset(0, t.s(1)),
                    ),
                  ],
                ),
                child: isLoading
                    ? Padding(
                        padding: EdgeInsets.all(t.s(2)),
                        child: AntLoading(
                          size: t.s(16),
                          color: t.colorPrimary,
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}