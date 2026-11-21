/// AntColorPicker 颜色选择器
///
/// 颜色选择器组件，支持饱和度面板、色相滑块、透明度滑块、预设色板。
///
/// 对齐 antd React ColorPicker 组件，支持：
/// - [value] / [defaultValue] / [onChange] / [onChangeComplete]
/// - [disabled] / [size] / [showText] / [format]
/// - [presets] 预设颜色 / [disabledAlpha] / [allowClear]
/// - [open] / [defaultOpen] / [onOpenChange]
library;

import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'package:antd_flutter_ui/src/engines/popup_engine.dart';
import 'package:antd_flutter_ui/src/engines/popup_overlay.dart';
import 'package:antd_flutter_ui/src/data_entry/color_picker/ant_color_picker_types.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

export 'ant_color_picker_types.dart';

/// 颜色选择器组件
class AntColorPicker extends StatefulWidget {
  const AntColorPicker({
    super.key,
    this.value,
    this.defaultValue,
    this.onChange,
    this.onChangeComplete,
    this.disabled = false,
    this.size = AntColorPickerSize.middle,
    this.showText = false,
    this.format = AntColorFormat.hex,
    this.presets = const [],
    this.disabledAlpha = false,
    this.allowClear = false,
    this.open,
    this.defaultOpen = false,
    this.onOpenChange,
  });

  /// 受控：颜色值（hex 格式，如 '#1677ff'）
  final String? value;

  /// 非受控：颜色初始值（hex 格式）
  final String? defaultValue;

  /// 颜色变化回调
  final void Function(String? color)? onChange;

  /// 颜色选择完成回调（面板关闭或松手时触发）
  final void Function(String? color)? onChangeComplete;

  /// 是否禁用
  final bool disabled;

  /// 尺寸
  final AntColorPickerSize size;

  /// 是否显示颜色文本
  final bool showText;

  /// 颜色格式
  final AntColorFormat format;

  /// 预设颜色
  final List<AntColorPreset> presets;

  /// 禁用透明度
  final bool disabledAlpha;

  /// 允许清空
  final bool allowClear;

  /// 受控：面板是否打开
  final bool? open;

  /// 非受控：面板初始是否打开
  final bool defaultOpen;

  /// 面板打开/关闭回调
  final void Function(bool open)? onOpenChange;

  @override
  State<AntColorPicker> createState() => _AntColorPickerState();
}

class _AntColorPickerState extends State<AntColorPicker>
    with
        PopupOpenScheduler<AntColorPicker>,
        PopupContentRefresher<AntColorPicker> {
  /// 触发元素 GlobalKey（弹层基座 AntPopupOverlay 定位/镂空遮挡用）。
  final GlobalKey _triggerKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _internalOpen = false;
  HSVColor? _internalColor;

  /// 当前主题（组件 context 下捕获，overlay builder 经字段重读）。
  AntThemeData _themeData = AntThemeData.light();

  bool get _currentOpen => widget.open ?? _internalOpen;

  String? get _currentColorHex {
    if (widget.value != null) return widget.value;
    if (_internalColor != null) return _hsvToHex(_internalColor!);
    return null;
  }

  @override
  void initState() {
    super.initState();
    _internalOpen = widget.defaultOpen;
    final initial = widget.value ?? widget.defaultValue;
    if (initial != null) {
      _internalColor = _hexToHsv(initial);
    }
  }

  @override
  void didUpdateWidget(AntColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null && widget.value != oldWidget.value) {
      _internalColor = _hexToHsv(widget.value!);
    }
    // 受控 open 切换统一延迟到帧末执行（PopupOpenScheduler 防构建期插 Overlay）
    if (widget.open != null && widget.open != oldWidget.open) {
      schedulePopupOpen(
          open: widget.open!, show: _showOverlay, hide: () => _setOpen(false),);
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  void _setOpen(bool value) {
    if (widget.open == null) {
      if (!mounted) return;
      setState(() => _internalOpen = value);
    }
    widget.onOpenChange?.call(value);
    if (value) {
      _showOverlay();
    } else {
      _hideOverlay();
      // 关闭时触发 onChangeComplete
      if (widget.onChangeComplete != null) {
        widget.onChangeComplete!(_currentColorHex);
      }
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    if (!mounted) return;
    final theme = AntTheme.of(context);
    final currentHex = _currentColorHex;
    final hsv = _internalColor ??
        (currentHex != null
            ? _hexToHsv(currentHex)
            : HSVColor.fromColor(const Color(0xFF1677FF)));
    _themeData = theme;
    _overlayEntry = OverlayEntry(
      builder: (context) => _ColorPickerOverlay(
        triggerKey: _triggerKey,
        themeData: _themeData,
        hsv: hsv,
        presets: widget.presets,
        disabledAlpha: widget.disabledAlpha,
        allowClear: widget.allowClear,
        showText: widget.showText,
        format: widget.format,
        onColorChange: (color) {
          if (widget.value == null) {
            setState(() => _internalColor = color);
          }
          widget.onChange
              ?.call(_hsvToHex(color, disableAlpha: widget.disabledAlpha));
          refreshPopupContent();
        },
        onColorChangeComplete: (color) {
          widget.onChangeComplete
              ?.call(_hsvToHex(color, disableAlpha: widget.disabledAlpha));
        },
        onClear: () {
          if (widget.value == null) {
            setState(() => _internalColor = null);
          }
          widget.onChange?.call(null);
          refreshPopupContent();
        },
        onDismiss: () => _setOpen(false),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  double get _triggerSize {
    switch (widget.size) {
      case AntColorPickerSize.small:
        return 16.r;
      case AntColorPickerSize.middle:
        return 24.r;
      case AntColorPickerSize.large:
        return 32.r;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    final hex = _currentColorHex;
    final color = hex != null ? _parseHex(hex) : null;

    return GestureDetector(
      key: _triggerKey,
      onTap: widget.disabled ? null : () => _setOpen(!_currentOpen),
      child: Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(t.borderRadiusSM.r),
          border: Border.all(color: t.colorBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: _triggerSize,
              height: _triggerSize,
              decoration: BoxDecoration(
                color: color ?? Colors.transparent,
                borderRadius: BorderRadius.circular(t.borderRadiusXS.r),
                border: Border.all(
                  color: color == null ? t.colorSplit : Colors.transparent,
                ),
              ),
            ),
            if (widget.showText) ...[
              SizedBox(width: 8.w),
              Text(
                hex ?? '-',
                style: TextStyle(
                  fontSize: t.fontSizeSM.sp,
                  color: t.colorText,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------- 颜色转换辅助 ----------

/// 解析 hex 字符串为 Color（支持 #RGB / #RRGGBB / #AARRGGBB / #RRGGBBAA）
Color _parseHex(String hex) {
  var h = hex.replaceAll('#', '');
  if (h.length == 3) {
    h = h.split('').map((c) => '$c$c').join();
  }
  if (h.length == 6) {
    h = 'FF$h';
  } else if (h.length == 8) {
    // #RRGGBBAA → ARGB
    h = '${h.substring(6, 8)}${h.substring(0, 6)}';
  }
  final value = int.tryParse(h, radix: 16) ?? 0xFF1677FF;
  return Color(value);
}

/// hex 字符串转 HSVColor
HSVColor _hexToHsv(String hex) => HSVColor.fromColor(_parseHex(hex));

/// HSVColor 转 hex 字符串
/// [disableAlpha] 为 true 时输出 #RRGGBB，否则输出 #RRGGBBAA（有透明度时）
String _hsvToHex(HSVColor hsv, {bool disableAlpha = false}) {
  final color = hsv.toColor();
  final r = _redOf(color).toRadixString(16).padLeft(2, '0');
  final g = _greenOf(color).toRadixString(16).padLeft(2, '0');
  final b = _blueOf(color).toRadixString(16).padLeft(2, '0');
  if (disableAlpha || hsv.alpha >= 1.0) {
    return '#$r$g$b';
  }
  final a = _alphaOf(color).toRadixString(16).padLeft(2, '0');
  return '#$r$g$b$a';
}

/// Color 的红色通道（0-255）
int _redOf(Color c) => (c.r * 255.0).round().clamp(0, 255);

/// Color 的绿色通道（0-255）
int _greenOf(Color c) => (c.g * 255.0).round().clamp(0, 255);

/// Color 的蓝色通道（0-255）
int _blueOf(Color c) => (c.b * 255.0).round().clamp(0, 255);

/// Color 的透明通道（0-255）
int _alphaOf(Color c) => (c.a * 255.0).round().clamp(0, 255);

/// HSV 转 HSL 值（hue 0-360, saturation 0-1, lightness 0-1）
({double hue, double saturation, double lightness}) _hsvToHslValues(
    HSVColor hsv,) {
  final v = hsv.value;
  final s = hsv.saturation;
  final l = v * (1 - s / 2);
  final sHsl = (l == 0 || l == 1) ? 0.0 : (v - l) / (l < 0.5 ? l : 1 - l);
  return (hue: hsv.hue, saturation: sHsl, lightness: l);
}

/// 将 HSVColor 格式化为指定格式的文本
String _formatColor(HSVColor hsv, AntColorFormat format) {
  final color = hsv.toColor();
  switch (format) {
    case AntColorFormat.hex:
      return _hsvToHex(hsv);
    case AntColorFormat.rgb:
      if (hsv.alpha < 1.0) {
        return 'rgba(${_redOf(color)}, ${_greenOf(color)}, ${_blueOf(color)}, ${hsv.alpha.toStringAsFixed(2)})';
      }
      return 'rgb(${_redOf(color)}, ${_greenOf(color)}, ${_blueOf(color)})';
    case AntColorFormat.hsl:
      final hsl = _hsvToHslValues(hsv);
      if (hsv.alpha < 1.0) {
        return 'hsla(${hsl.hue.toStringAsFixed(0)}, ${(hsl.saturation * 100).toStringAsFixed(0)}%, ${(hsl.lightness * 100).toStringAsFixed(0)}%, ${hsv.alpha.toStringAsFixed(2)})';
      }
      return 'hsl(${hsl.hue.toStringAsFixed(0)}, ${(hsl.saturation * 100).toStringAsFixed(0)}%, ${(hsl.lightness * 100).toStringAsFixed(0)}%)';
    case AntColorFormat.hsb:
      if (hsv.alpha < 1.0) {
        return 'hsba(${hsv.hue.toStringAsFixed(0)}, ${(hsv.saturation * 100).toStringAsFixed(0)}%, ${(hsv.value * 100).toStringAsFixed(0)}%, ${hsv.alpha.toStringAsFixed(2)})';
      }
      return 'hsb(${hsv.hue.toStringAsFixed(0)}, ${(hsv.saturation * 100).toStringAsFixed(0)}%, ${(hsv.value * 100).toStringAsFixed(0)}%)';
  }
}

// ---------- 浮层面板 ----------

/// 颜色选择器浮层
class _ColorPickerOverlay extends StatefulWidget {
  const _ColorPickerOverlay({
    required this.triggerKey,
    required this.themeData,
    required this.hsv,
    required this.presets,
    required this.disabledAlpha,
    required this.allowClear,
    required this.showText,
    required this.format,
    required this.onColorChange,
    required this.onColorChangeComplete,
    required this.onClear,
    required this.onDismiss,
  });

  /// 触发元素 GlobalKey（弹层基座定位/镂空遮挡）。
  final GlobalKey triggerKey;
  final AntThemeData themeData;
  final HSVColor hsv;
  final List<AntColorPreset> presets;
  final bool disabledAlpha;
  final bool allowClear;
  final bool showText;
  final AntColorFormat format;
  final ValueChanged<HSVColor> onColorChange;
  final ValueChanged<HSVColor> onColorChangeComplete;
  final VoidCallback onClear;
  final VoidCallback onDismiss;

  @override
  State<_ColorPickerOverlay> createState() => _ColorPickerOverlayState();
}

class _ColorPickerOverlayState extends State<_ColorPickerOverlay> {
  late HSVColor _hsv;

  @override
  void initState() {
    super.initState();
    _hsv = widget.hsv;
  }

  void _updateColor(HSVColor color) {
    _hsv = color;
    widget.onColorChange(color);
  }

  void _completeColor() {
    widget.onColorChangeComplete(_hsv);
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.themeData;
    // 统一弹层基座：placement 首选下方，视口下方放不下自动翻转上方，
    // 面板较宽（240）由引擎滑动夹回保证不溢出视口；带箭头（antd ColorPicker 语义）。
    return AntPopupOverlay(
      targetKey: widget.triggerKey,
      placement: AntPopupPlacement.bottom,
      arrow: true,
      arrowColor: t.colorBgContainer,
      gap: 4,
      onDismiss: widget.onDismiss,
      child: Material(
        color: Colors.transparent,
        child: Container(
          key: const Key('ant_color_picker_panel'),
          width: 240.w,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: t.colorBgContainer,
            borderRadius: BorderRadius.circular(t.borderRadiusLG.r),
            border: Border.all(color: t.colorSplit),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: _buildPanelBody(t),
        ),
      ),
    );
  }

  Widget _buildPanelBody(AntThemeData t) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SV 面板
        _SvPanel(
          hsv: _hsv,
          themeData: t,
          onChanged: _updateColor,
          onComplete: _completeColor,
        ),
        SizedBox(height: 12.h),
        // 色相滑块
        _HueSlider(
          hue: _hsv.hue,
          onChanged: (hue) => _updateColor(_hsv.withHue(hue)),
          onComplete: _completeColor,
        ),
        // 透明度滑块
        if (!widget.disabledAlpha) ...[
          SizedBox(height: 8.h),
          _AlphaSlider(
            hsv: _hsv,
            onChanged: (alpha) => _updateColor(_hsv.withAlpha(alpha)),
            onComplete: _completeColor,
          ),
        ],
        // 颜色文本 + 清空按钮
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: Text(
                _formatColor(_hsv, widget.format),
                style: TextStyle(
                  fontSize: t.fontSizeSM.sp,
                  color: t.colorText,
                ),
              ),
            ),
            if (widget.allowClear)
              GestureDetector(
                onTap: widget.onClear,
                child: Icon(
                  AntIcons.closeCircleFilled,
                  size: 16.r,
                  color: t.colorTextTertiary,
                ),
              ),
          ],
        ),
        // 预设颜色
        if (widget.presets.isNotEmpty) ...[
          SizedBox(height: 12.h),
          for (final preset in widget.presets) ...[
            Text(
              preset.label,
              style: TextStyle(
                fontSize: t.fontSizeSM.sp,
                color: t.colorTextSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                for (final hex in preset.colors)
                  _PresetSwatch(
                    hex: hex,
                    themeData: t,
                    isSelected: _hsv.toColor() == _parseHex(hex),
                    onTap: () {
                      _updateColor(_hexToHsv(hex));
                      _completeColor();
                    },
                  ),
              ],
            ),
            SizedBox(height: 8.h),
          ],
        ],
      ],
    );
  }
}

// ---------- SV 饱和度-明度面板 ----------

class _SvPanel extends StatefulWidget {
  const _SvPanel({
    required this.hsv,
    required this.themeData,
    required this.onChanged,
    required this.onComplete,
  });

  final HSVColor hsv;
  final AntThemeData themeData;
  final ValueChanged<HSVColor> onChanged;
  final VoidCallback onComplete;

  @override
  State<_SvPanel> createState() => _SvPanelState();
}

class _SvPanelState extends State<_SvPanel> {
  final GlobalKey _key = GlobalKey();

  HSVColor _colorFromPosition(Offset local) {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return widget.hsv;
    final size = box.size;
    final dx = (local.dx / size.width).clamp(0.0, 1.0);
    // SV 面板纵向：顶部=高明度，底部=低明度
    final dy = 1.0 - (local.dy / size.height).clamp(0.0, 1.0);
    return widget.hsv.withSaturation(dx).withValue(dy);
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.themeData;
    return LayoutBuilder(
      builder: (context, constraints) {
        final panelHeight = constraints.maxWidth;
        return GestureDetector(
          key: _key,
          behavior: HitTestBehavior.opaque,
          onPanDown: (details) {
            widget.onChanged(_colorFromPosition(details.localPosition));
          },
          onPanUpdate: (details) {
            widget.onChanged(_colorFromPosition(details.localPosition));
          },
          onPanEnd: (_) {
            widget.onComplete();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(t.borderRadiusSM.r),
            child: SizedBox(
              height: panelHeight,
              child: CustomPaint(
                painter: _SvPainter(hue: widget.hsv.hue),
                child: Stack(
                  children: [
                    Positioned(
                      left: (widget.hsv.saturation *
                              (constraints.maxWidth - 12.r))
                          .clamp(0.0, constraints.maxWidth - 12.r),
                      top: ((1.0 - widget.hsv.value) * (panelHeight - 12.r))
                          .clamp(0.0, panelHeight - 12.r),
                      child: Container(
                        width: 12.r,
                        height: 12.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.hsv.toColor(),
                          border: Border.all(color: Colors.white, width: 2.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 2.r,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SvPainter extends CustomPainter {
  _SvPainter({required this.hue});

  final double hue;

  @override
  void paint(Canvas canvas, Size size) {
    final baseColor = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
    final rect = Offset.zero & size;

    // 底色：当前色相的纯色
    final basePaint = Paint()..color = baseColor;
    canvas.drawRect(rect, basePaint);

    // 横向：白色 → 透明（饱和度 0 → 1）
    final whiteGradient = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Colors.white, Colors.white.withValues(alpha: 0)],
      ).createShader(rect);
    canvas.drawRect(rect, whiteGradient);

    // 纵向：透明 → 黑色（明度 1 → 0）
    final blackGradient = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.black.withValues(alpha: 0), Colors.black],
      ).createShader(rect);
    canvas.drawRect(rect, blackGradient);
  }

  @override
  bool shouldRepaint(_SvPainter oldDelegate) => oldDelegate.hue != hue;
}

// ---------- 色相滑块 ----------

class _HueSlider extends StatefulWidget {
  const _HueSlider({
    required this.hue,
    required this.onChanged,
    required this.onComplete,
  });

  final double hue;
  final ValueChanged<double> onChanged;
  final VoidCallback onComplete;

  @override
  State<_HueSlider> createState() => _HueSliderState();
}

class _HueSliderState extends State<_HueSlider> {
  final GlobalKey _key = GlobalKey();

  double _hueFromPosition(Offset local) {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return widget.hue;
    final dx = (local.dx / box.size.width).clamp(0.0, 1.0);
    return dx * 360;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          key: _key,
          behavior: HitTestBehavior.opaque,
          onPanDown: (details) =>
              widget.onChanged(_hueFromPosition(details.localPosition)),
          onPanUpdate: (details) =>
              widget.onChanged(_hueFromPosition(details.localPosition)),
          onPanEnd: (_) => widget.onComplete(),
          child: SizedBox(
            height: 12.r,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: CustomPaint(
                    size: Size(width, 12.r),
                    painter: _HuePainter(),
                  ),
                ),
                Positioned(
                  left: (widget.hue / 360 * (width - 12.r))
                      .clamp(0.0, width - 12.r),
                  top: -2.r,
                  child: Container(
                    width: 14.r,
                    height: 14.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HSVColor.fromAHSV(1.0, widget.hue, 1.0, 1.0)
                          .toColor(),
                      border: Border.all(color: Colors.white, width: 2.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 2.r,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HuePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFF0000),
          Color(0xFFFFFF00),
          Color(0xFF00FF00),
          Color(0xFF00FFFF),
          Color(0xFF0000FF),
          Color(0xFFFF00FF),
          Color(0xFFFF0000),
        ],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(_HuePainter oldDelegate) => false;
}

// ---------- 透明度滑块 ----------

class _AlphaSlider extends StatefulWidget {
  const _AlphaSlider({
    required this.hsv,
    required this.onChanged,
    required this.onComplete,
  });

  final HSVColor hsv;
  final ValueChanged<double> onChanged;
  final VoidCallback onComplete;

  @override
  State<_AlphaSlider> createState() => _AlphaSliderState();
}

class _AlphaSliderState extends State<_AlphaSlider> {
  final GlobalKey _key = GlobalKey();

  double _alphaFromPosition(Offset local) {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return widget.hsv.alpha;
    final dx = (local.dx / box.size.width).clamp(0.0, 1.0);
    return dx;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          key: _key,
          behavior: HitTestBehavior.opaque,
          onPanDown: (details) =>
              widget.onChanged(_alphaFromPosition(details.localPosition)),
          onPanUpdate: (details) =>
              widget.onChanged(_alphaFromPosition(details.localPosition)),
          onPanEnd: (_) => widget.onComplete(),
          child: SizedBox(
            height: 12.r,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: CustomPaint(
                    size: Size(width, 12.r),
                    painter: _AlphaPainter(color: widget.hsv.toColor()),
                  ),
                ),
                Positioned(
                  left: (widget.hsv.alpha * (width - 12.r))
                      .clamp(0.0, width - 12.r),
                  top: -2.r,
                  child: Container(
                    width: 14.r,
                    height: 14.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.hsv.toColor(),
                      border: Border.all(color: Colors.white, width: 2.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 2.r,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AlphaPainter extends CustomPainter {
  _AlphaPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    // 棋盘格背景
    const cellCount = 12;
    final cellWidth = size.width / cellCount;
    for (var i = 0; i < cellCount; i++) {
      canvas.drawRect(
        Rect.fromLTWH(i * cellWidth, 0, cellWidth, size.height / 2),
        Paint()..color = i.isEven ? Colors.white : const Color(0xFFE0E0E0),
      );
      canvas.drawRect(
        Rect.fromLTWH(
            i * cellWidth, size.height / 2, cellWidth, size.height / 2,),
        Paint()..color = i.isOdd ? Colors.white : const Color(0xFFE0E0E0),
      );
    }
    // 透明 → 当前色
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [color.withValues(alpha: 0), color.withValues(alpha: 1)],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(_AlphaPainter oldDelegate) => oldDelegate.color != color;
}

// ---------- 预设色块 ----------

class _PresetSwatch extends StatelessWidget {
  const _PresetSwatch({
    required this.hex,
    required this.themeData,
    required this.isSelected,
    required this.onTap,
  });

  final String hex;
  final AntThemeData themeData;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = themeData;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20.r,
        height: 20.r,
        decoration: BoxDecoration(
          color: _parseHex(hex),
          borderRadius: BorderRadius.circular(t.borderRadiusXS.r),
          border: Border.all(
            color: isSelected ? t.colorText : t.colorSplit,
            width: isSelected ? 2.r : 1.r,
          ),
        ),
      ),
    );
  }
}
