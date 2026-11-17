/// Ant Design 颜色操作工具类。
///
/// 精确移植 `@ant-design/fast-color` v3 的 [FastColor] 类，
/// 保证 Dart 侧生成的色值与 antd 源码逐一断言对齐。
///
/// 参考: https://github.com/ant-design/fast-color
library;

import 'dart:math' as math;

/// HSV 颜色模型值。
///
/// ```dart
/// final hsv = AntHsv(h: 210, s: 0.9, v: 1.0);
/// final color = AntFastColor.of(hsv);
/// ```
class AntHsv {
  /// 色相（0-360）。
  final double h;

  /// HSV 饱和度（0-1）。
  final double s;

  /// 明度（0-1）。
  final double v;

  /// 透明度（0-1），默认 1。
  final double a;
  const AntHsv({required this.h, required this.s, required this.v, this.a = 1});
}

/// HSL 颜色模型值。
///
/// ```dart
/// final hsl = AntHsl(h: 210, s: 0.9, l: 0.5);
/// final color = AntFastColor.of(hsl);
/// ```
class AntHsl {
  /// 色相（0-360）。
  final double h;

  /// HSL 饱和度（0-1）。
  final double s;

  /// 亮度（0-1）。
  final double l;

  /// 透明度（0-1），默认 1。
  final double a;
  const AntHsl({required this.h, required this.s, required this.l, this.a = 1});
}

/// RGB 颜色模型值。
///
/// ```dart
/// final rgb = AntRgb(r: 22, g: 119, b: 255);
/// final color = AntFastColor.of(rgb);
/// ```
class AntRgb {
  /// 红色通道（0-255）。
  final int r;

  /// 绿色通道（0-255）。
  final int g;

  /// 蓝色通道（0-255）。
  final int b;

  /// 透明度（0-1），默认 1。
  final double a;
  const AntRgb({required this.r, required this.g, required this.b, this.a = 1});
}

/// 与 @ant-design/fast-color 的 limitRange 一致：仅钳位，不取整。
/// RGB 通道的取整在赋值处通过 `.toInt()` 完成，alpha 保持浮点精度。
num _limitRange(num value, [num max = 255]) {
  if (value > max) return max;
  if (value < 0) return 0;
  return value;
}

/// 高性能颜色操作类，支持 RGB / HSV / HSL 互转及 darken / lighten / mix 等操作。
///
/// 与 `@ant-design/fast-color` 的 `FastColor` 行为完全一致。
/// 所有 setter 与颜色变换方法均返回新实例，原实例不可变地保留。
///
/// ```dart
/// final color = AntFastColor('#1677ff');
/// print(color.toHexString()); // '#1677ff'
/// print(color.darken(10).toHexString()); // 加深后的 hex
/// print(color.isDark()); // false
/// ```
class AntFastColor {
  /// 红色通道 (0-255)。
  int r = 0;

  /// 绿色通道 (0-255)。
  int g = 0;

  /// 蓝色通道 (0-255)。
  int b = 0;

  /// 透明度 (0-1)。
  double a = 1;

  // HSV/HSL 缓存
  double? _h;
  double? _hslS;
  double? _hsvS;
  double? _l;
  double? _v;
  int? _max;
  int? _min;

  /// 从 hex / rgb / hsl / hsv 字符串构造。
  ///
  /// [input] 支持以下格式（允许前导/尾随空白）：
  /// - hex：`#1677ff`、`1677ff`、`#fff`、`#rrggbbaa`；
  /// - `rgb(r,g,b)` / `rgba(r,g,b,a)`，分量支持百分比；
  /// - `hsl(h,s%,l%)` / `hsla(...)`；
  /// - `hsv(h,s%,v%)` / `hsb(...)`。
  ///
  /// 不支持预设色名（如 `red`）；无法识别的输入保持全零黑、alpha 为 1。
  /// 便捷写法可使用 [AntFastColor.of]。
  AntFastColor.fromString(String input) {
    final trimStr = input.trim();
    if (RegExp(r'^#?[A-F\d]{3,8}$', caseSensitive: false).hasMatch(trimStr)) {
      _fromHexString(trimStr);
    } else if (trimStr.startsWith('rgb')) {
      _fromRgbString(trimStr);
    } else if (trimStr.startsWith('hsl')) {
      _fromHslString(trimStr);
    } else if (trimStr.startsWith('hsv') || trimStr.startsWith('hsb')) {
      _fromHsvString(trimStr);
    }
    // preset color names 不支持，Flutter 侧直接使用 hex
  }

  /// 从 RGB 值构造。
  ///
  /// [r]、[g]、[b] 为 0-255 通道值，超出范围时被钳位到边界；
  /// [alpha] 为 0-1 透明度，超出范围时钳位，传入 `null` 时为 1（不透明）。
  AntFastColor.fromRgb(int r, int g, int b, [double? alpha]) {
    this.r = _limitRange(r).toInt();
    this.g = _limitRange(g).toInt();
    this.b = _limitRange(b).toInt();
    a = alpha != null ? _limitRange(alpha, 1).toDouble() : 1;
  }

  /// 从 HSL 值构造。
  ///
  /// [h] 为色相（0-360，越界自动取模），[s] 为 HSL 饱和度（0-1），
  /// [l] 为亮度（0-1），[alpha] 为透明度（0-1，`null` 时为 1）。
  AntFastColor.fromHsl(double h, double s, double l, [double? alpha]) {
    _fromHsl(h, s, l, alpha ?? 1);
  }

  /// 从 HSV 值构造。
  ///
  /// [h] 为色相（0-360，越界自动取模），[s] 为 HSV 饱和度（0-1），
  /// [v] 为明度（0-1），[alpha] 为透明度（0-1，`null` 时为 1）。
  AntFastColor.fromHsv(double h, double s, double v, [double? alpha]) {
    _fromHsv(h, s, v, alpha ?? 1);
  }

  /// 从另一个 [AntFastColor] 拷贝构造（含 HSV/HSL 缓存）。
  AntFastColor.fromColor(AntFastColor other) {
    r = other.r;
    g = other.g;
    b = other.b;
    a = other.a;
    _h = other._h;
    _hslS = other._hslS;
    _hsvS = other._hsvS;
    _l = other._l;
    _v = other._v;
  }

  /// 便捷工厂：自动判断输入类型，等同于 [AntFastColor.of]。
  ///
  /// [input] 可为 [String]（hex/rgb/hsl/hsv）、[AntRgb]、[AntHsl]、
  /// [AntHsv] 或 [AntFastColor]。
  factory AntFastColor(Object input) => AntFastColor.of(input);

  /// 通用工厂：自动判断输入类型。
  ///
  /// [input] 可为 [String]、[AntRgb]、[AntHsl]、[AntHsv] 或 [AntFastColor]；
  /// 其他类型抛出 [ArgumentError]。
  factory AntFastColor.of(Object input) {
    if (input is AntFastColor) return AntFastColor.fromColor(input);
    if (input is String) return AntFastColor.fromString(input);
    if (input is AntRgb) {
      return AntFastColor.fromRgb(input.r, input.g, input.b, input.a);
    }
    if (input is AntHsl) {
      return AntFastColor.fromHsl(input.h, input.s, input.l, input.a);
    }
    if (input is AntHsv) {
      return AntFastColor.fromHsv(input.h, input.s, input.v, input.a);
    }
    throw ArgumentError('@ant-design/fast-color: unsupported input $input');
  }

  // ======================= Setter =======================

  /// 返回修改红色通道后的新实例。
  AntFastColor setR(int value) => _cloneWith((c) => c.r = _limitRange(value).toInt());

  /// 返回修改绿色通道后的新实例。
  AntFastColor setG(int value) => _cloneWith((c) => c.g = _limitRange(value).toInt());

  /// 返回修改蓝色通道后的新实例。
  AntFastColor setB(int value) => _cloneWith((c) => c.b = _limitRange(value).toInt());

  /// 返回修改透明度后的新实例。
  AntFastColor setA(double value) =>
      _cloneWith((c) => c.a = _limitRange(value, 1).toDouble());

  // ======================= Getter =======================

  /// 感知亮度 (0-1)，WCAG 相对亮度。
  ///
  /// 可用于判断文字与背景的对比度是否达标。
  double getLuminance() {
    double adjustGamma(num raw) {
      final val = raw / 255;
      return val <= 0.03928
          ? val / 12.92
          : math.pow((val + 0.055) / 1.055, 2.4).toDouble();
    }

    final R = adjustGamma(r);
    final G = adjustGamma(g);
    final B = adjustGamma(b);
    return 0.2126 * R + 0.7152 * G + 0.0722 * B;
  }

  /// 色相 (0-360)。
  double getHue() {
    if (_h == null) {
      final delta = _getMax() - _getMin();
      if (delta == 0) {
        _h = 0;
      } else {
        _h = (60 *
                (r == _getMax()
                    ? (g - b) / delta + (g < b ? 6 : 0)
                    : g == _getMax()
                        ? (b - r) / delta + 2
                        : (r - g) / delta + 4))
            .roundToDouble();
      }
    }
    return _h!;
  }

  /// HSV 饱和度 (0-1)。
  double getHsvSaturation() {
    if (_hsvS == null) {
      final delta = _getMax() - _getMin();
      if (delta == 0) {
        _hsvS = 0;
      } else {
        _hsvS = delta / _getMax();
      }
    }
    return _hsvS!;
  }

  /// HSL 饱和度 (0-1)。
  double getHslSaturation() {
    if (_hslS == null) {
      final delta = _getMax() - _getMin();
      if (delta == 0) {
        _hslS = 0;
      } else {
        final l = getLightness();
        _hslS = (delta / 255) / (1 - (2 * l - 1).abs());
      }
    }
    return _hslS!;
  }

  /// HSL 亮度 (0-1)。
  double getLightness() {
    _l ??= (_getMax() + _getMin()) / 510;
    return _l!;
  }

  /// HSV 明度 (0-1)。
  double getValue() {
    _v ??= _getMax() / 255;
    return _v!;
  }

  /// 感知明亮度 (0-255)，非 HSB 的 B。
  double getBrightness() {
    return (r * 299 + g * 587 + b * 114) / 1000;
  }

  // ======================== Func ========================

  /// 降低亮度。amount 为降低的百分比 (0-100)，默认 10。
  ///
  /// 注意：与 fast-color 一致，使用 HSV 饱和度作为 HSL 饱和度传入。
  /// 返回降低亮度后的新实例，原实例不变。
  ///
  /// ```dart
  /// final darker = AntFastColor('#1677ff').darken(10);
  /// ```
  AntFastColor darken([double amount = 10]) {
    final h = getHue();
    final s = getHsvSaturation();
    var l = getLightness() - amount / 100;
    if (l < 0) l = 0;
    return AntFastColor.fromHsl(h, s, l, a);
  }

  /// 提升亮度。amount 为提升的百分比 (0-100)，默认 10。
  ///
  /// 注意：与 fast-color 一致，使用 HSV 饱和度作为 HSL 饱和度传入。
  /// 返回提升亮度后的新实例，原实例不变。
  AntFastColor lighten([double amount = 10]) {
    final h = getHue();
    final s = getHsvSaturation();
    var l = getLightness() + amount / 100;
    if (l > 1) l = 1;
    return AntFastColor.fromHsl(h, s, l, a);
  }

  /// 与另一个颜色混合。amount 为混合比例百分比 (0-100)，0 表示不混合、
  /// 100 表示完全取 [input] 颜色，默认 50。
  ///
  /// [input] 接受与 [AntFastColor.of] 相同的类型；返回混合后的新实例。
  AntFastColor mix(Object input, [double amount = 50]) {
    final color = AntFastColor.of(input);
    final p = amount / 100;

    double calc(num self, num other) => (other - self) * p + self;

    return AntFastColor.fromRgb(
      calc(r, color.r).round(),
      calc(g, color.g).round(),
      calc(b, color.b).round(),
      (calc(a * 100, color.a * 100).round()) / 100,
    );
  }

  /// 与纯白混合。amount 为混合比例百分比 (0-100)，默认 10。
  AntFastColor tint([double amount = 10]) =>
      mix(const AntRgb(r: 255, g: 255, b: 255), amount);

  /// 与纯黑混合。amount 为混合比例百分比 (0-100)，默认 10。
  AntFastColor shade([double amount = 10]) =>
      mix(const AntRgb(r: 0, g: 0, b: 0), amount);

  /// 在背景色上合成（alpha blending）。
  ///
  /// [background] 接受与 [AntFastColor.of] 相同的类型；返回按
  /// 本色 alpha 与背景色合成后的不透明等效颜色。
  AntFastColor onBackground(Object background) {
    final bg = AntFastColor.of(background);
    final alpha = a + bg.a * (1 - a);

    int calc(int self, int other) =>
        ((self * a + other * bg.a * (1 - a)) / alpha).round();

    return AntFastColor.fromRgb(
      calc(r, bg.r),
      calc(g, bg.g),
      calc(b, bg.b),
      alpha,
    );
  }

  // ======================= Status =======================

  /// 是否为深色。
  bool isDark() => getBrightness() < 128;

  /// 是否为浅色。
  bool isLight() => getBrightness() >= 128;

  // ======================== MISC ========================

  /// 判断颜色是否相等。
  @override
  bool operator ==(Object other) =>
      other is AntFastColor &&
      r == other.r &&
      g == other.g &&
      b == other.b &&
      a == other.a;

  @override
  int get hashCode => Object.hash(r, g, b, a);

  /// 克隆。
  AntFastColor clone() => AntFastColor.fromColor(this);

  // ======================= Format =======================

  /// 输出 hex 字符串 `#rrggbb`；alpha 小于 1 时输出 `#rrggbbaa`。
  String toHexString() {
    var hex = '#';
    var rHex = (r).toRadixString(16);
    hex += rHex.length == 2 ? rHex : '0$rHex';
    var gHex = (g).toRadixString(16);
    hex += gHex.length == 2 ? gHex : '0$gHex';
    var bHex = (b).toRadixString(16);
    hex += bHex.length == 2 ? bHex : '0$bHex';
    if (a >= 0 && a < 1) {
      final aHex = (a * 255).round().toRadixString(16);
      hex += aHex.length == 2 ? aHex : '0$aHex';
    }
    return hex;
  }

  /// 输出 HSL 对象。
  AntHsl toHsl() => AntHsl(
        h: getHue(),
        s: getHslSaturation(),
        l: getLightness(),
        a: a,
      );

  /// 输出 HSL CSS 字符串。
  String toHslString() {
    final h = getHue();
    final s = (getHslSaturation() * 100).round();
    final l = (getLightness() * 100).round();
    return a != 1 ? 'hsla($h,$s%,$l%,$a)' : 'hsl($h,$s%,$l%)';
  }

  /// 输出 HSV 对象。
  AntHsv toHsv() => AntHsv(
        h: getHue(),
        s: getHsvSaturation(),
        v: getValue(),
        a: a,
      );

  /// 输出 RGB 对象。
  AntRgb toRgb() => AntRgb(r: r, g: g, b: b, a: a);

  /// 输出 RGB CSS 字符串 `rgb(r,g,b)` 或 `rgba(r,g,b,a)`。
  String toRgbString() {
    return a != 1 ? 'rgba($r,$g,$b,${_formatAlpha(a)})' : 'rgb($r,$g,$b)';
  }

  @override
  String toString() => toRgbString();

  // ====================== Privates ======================

  AntFastColor _cloneWith(void Function(AntFastColor) mutate) {
    final clone = AntFastColor.fromColor(this);
    mutate(clone);
    return clone;
  }

  int _getMax() {
    _max ??= math.max(r, math.max(g, b));
    return _max!;
  }

  int _getMin() {
    _min ??= math.min(r, math.min(g, b));
    return _min!;
  }

  void _fromHexString(String trimStr) {
    final withoutPrefix = trimStr.replaceAll('#', '');

    int connectNum(int index1, [int? index2]) {
      final i2 = index2 ?? index1;
      return int.parse(withoutPrefix[index1] + withoutPrefix[i2], radix: 16);
    }

    if (withoutPrefix.length < 6) {
      // #rgb or #rgba
      r = connectNum(0);
      g = connectNum(1);
      b = connectNum(2);
      a = withoutPrefix.length > 3 ? connectNum(3) / 255 : 1;
    } else {
      // #rrggbb or #rrggbbaa
      r = connectNum(0, 1);
      g = connectNum(2, 3);
      b = connectNum(4, 5);
      a = withoutPrefix.length > 6 ? connectNum(6, 7) / 255 : 1;
    }
  }

  void _fromHsl(double hVal, double s, double l, double alpha) {
    final h = ((hVal % 360) + 360) % 360;
    _h = h;
    _hslS = s;
    _l = l;
    a = alpha;

    if (s <= 0) {
      final rgb = (l * 255).round();
      r = rgb;
      g = rgb;
      b = rgb;
      return;
    }

    var rv = 0.0, gv = 0.0, bv = 0.0;
    final huePrime = h / 60;
    final chroma = (1 - (2 * l - 1).abs()) * s;
    final secondComponent = chroma * (1 - (huePrime % 2 - 1).abs());

    if (huePrime >= 0 && huePrime < 1) {
      rv = chroma;
      gv = secondComponent;
    } else if (huePrime >= 1 && huePrime < 2) {
      rv = secondComponent;
      gv = chroma;
    } else if (huePrime >= 2 && huePrime < 3) {
      gv = chroma;
      bv = secondComponent;
    } else if (huePrime >= 3 && huePrime < 4) {
      gv = secondComponent;
      bv = chroma;
    } else if (huePrime >= 4 && huePrime < 5) {
      rv = secondComponent;
      bv = chroma;
    } else if (huePrime >= 5 && huePrime < 6) {
      rv = chroma;
      bv = secondComponent;
    }

    final lightnessModification = l - chroma / 2;
    r = ((rv + lightnessModification) * 255).round();
    g = ((gv + lightnessModification) * 255).round();
    b = ((bv + lightnessModification) * 255).round();
  }

  void _fromHsv(double hVal, double s, double v, double alpha) {
    final h = ((hVal % 360) + 360) % 360;
    _h = h;
    _hsvS = s;
    _v = v;
    a = alpha;

    final vv = (v * 255).round();
    r = vv;
    g = vv;
    b = vv;

    if (s <= 0) return;

    final hh = h / 60;
    final i = hh.floor();
    final ff = hh - i;
    final p = (v * (1.0 - s) * 255).round();
    final q = (v * (1.0 - s * ff) * 255).round();
    final t = (v * (1.0 - s * (1.0 - ff)) * 255).round();

    switch (i) {
      case 0:
        g = t;
        b = p;
        break;
      case 1:
        r = q;
        b = p;
        break;
      case 2:
        r = p;
        b = t;
        break;
      case 3:
        r = p;
        g = q;
        break;
      case 4:
        r = t;
        g = p;
        break;
      case 5:
      default:
        g = p;
        b = q;
        break;
    }
  }

  static String _formatAlpha(double alpha) {
    // 保持与 JS 一致的两位小数精度
    final rounded = (alpha * 100).round() / 100;
    return rounded.toString();
  }

  void _fromRgbString(String trimStr) {
    final cells = _splitColorStr(trimStr, (num value, String txt, int index) {
      return (txt.contains('%') ? (value / 100 * 255).round() : value.round()).toDouble();
    });
    r = cells[0].round();
    g = cells[1].round();
    b = cells[2].round();
    a = cells[3];
  }

  void _fromHslString(String trimStr) {
    final cells = _splitColorStr(trimStr, (num value, String _, int index) {
      return index == 0 ? value.round().toDouble() : value / 100;
    });
    _fromHsl(cells[0], cells[1], cells[2], cells[3]);
  }

  void _fromHsvString(String trimStr) {
    final cells = _splitColorStr(trimStr, (num value, String _, int index) {
      return index == 0 ? value.round().toDouble() : value / 100;
    });
    _fromHsv(cells[0], cells[1], cells[2], cells[3]);
  }
}

/// 解析颜色字符串中的数字列表。
///
/// 与 JS 侧 `splitColorStr` 对齐：先截取括号内内容，
/// 再用 `RegExp.allMatches` 等价 JS `.match(/\d*\.?\d+%?/g)` 提取纯数字 token。
List<double> _splitColorStr(
  String str,
  double Function(num, String, int) parseNum,
) {
  // Remove str before `(`
  final content = str
      .replaceAllMapped(RegExp(r'^[^(]*\((.*)'), (m) => m.group(1) ?? '')
      .replaceAll(RegExp(r'\).*'), '');
  // Match all number tokens (equivalent to JS .match(/\d*\.?\d+%?/g))
  final match = RegExp(r'\d*\.?\d+%?')
      .allMatches(content)
      .map((m) => m.group(0)!)
      .where((s) => s.isNotEmpty)
      .toList();
  // JS parseFloat 忽略尾部非数字（如 '100%' → 100），Dart tryParse 需先去 %
  final numList =
      match.map((item) => double.tryParse(item.replaceAll('%', '')) ?? 0).toList();

  final result = <double>[];
  for (var i = 0; i < 3; i++) {
    result.add(parseNum(
      numList.length > i ? numList[i] : 0,
      match.length > i ? match[i] : '',
      i,
    ),);
  }
  if (match.length > 3) {
    result.add(match[3].contains('%') ? numList[3] / 100 : numList[3]);
  } else {
    result.add(1);
  }
  return result;
}