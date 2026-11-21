import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/flutter_svg.dart';

/// Ant Design 统一图标组件。
///
/// 同时支持 TTF 字体图标（Outlined/Filled）和 SVG 双色图标（TwoTone），
/// 通过 [icon] 参数类型自动分发：
///
/// - [IconData] → TTF 字体渲染（[AntIcons] 常量）
/// - [String] → SVG 资产渲染（[AntIconsTwotone] 常量）
///
/// 使用场景：
/// - 与 antd 设计规范保持视觉一致的 Flutter 应用；
/// - 用线框 / 实心 / 双色三形态表达选中、强调等状态差异；
/// - 迁移自 antd React 项目，沿用既有图标命名。
///
/// 注意：
/// - `color` 只影响 TTF 图标，`twoToneColor` 只影响 TwoTone 图标，
///   传错模式不会生效也不会报错；
/// - TwoTone 首次渲染需异步读取 SVG 资产，避免在 `build` 中同步依赖其
///   像素结果（替换结果已按「路径 + 主色 + 次色」缓存）；
/// - 功能性图标务必传 [semanticLabel]，纯装饰图标可省略；
/// - TTF 模式同步无首帧延迟、适合高频单色小图标；TwoTone 适合需要
///   双色视觉层次的品牌化、强调性场景。
///
/// ```dart
/// // TTF 字体图标（Outlined / Filled）
/// AntdIcon(AntIcons.checkOutlined)
/// AntdIcon(AntIcons.searchOutlined, size: 24, color: Colors.blue)
///
/// // TwoTone 双色图标（默认 #333 + #E6E6E6，无需额外参数）
/// AntdIcon(AntIconsTwotone.checkCircleTwoTone)
///
/// // TwoTone 自定义主色（次色自动生成）
/// AntdIcon(AntIconsTwotone.heartTwoTone, twoToneColor: Colors.red)
/// ```
class AntdIcon extends StatelessWidget {
  /// 创建 AntdIcon。
  ///
  /// [icon] 接受 [IconData]（TTF 字体模式）或 [String]（TwoTone SVG 资产路径）。
  const AntdIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.twoToneColor,
    this.semanticLabel,
  }) : assert(
          icon is IconData || icon is String,
          'icon 必须是 IconData（TTF 模式）或 String（TwoTone SVG 路径）',
        );

  /// 图标定义，决定渲染模式。
  ///
  /// - 传 [IconData]（如 [AntIcons.checkOutlined]）→ TTF 字体渲染；
  /// - 传 [String]（如 [AntIconsTwotone.checkCircleTwoTone]）→ TwoTone SVG 资产渲染。
  ///
  /// 传入其他类型会在调试期断言失败。
  final Object icon;

  /// 图标尺寸（逻辑像素），默认值因模式而异。
  ///
  /// - TTF 模式：未设置时继承 [IconTheme]（通常为 24.0）；
  /// - TwoTone 模式：未设置时同样先取 [IconTheme]，兜底 24.0。
  ///
  /// ```dart
  /// AntdIcon(AntIcons.starOutlined, size: 32)
  /// AntdIcon(AntIconsTwotone.starTwoTone, size: 32)
  /// ```
  final double? size;

  /// 图标颜色，仅 TTF 字体模式生效。
  ///
  /// 未设置时继承 [IconTheme] 的颜色；TwoTone 模式下此参数被忽略，
  /// 着色请使用 [twoToneColor]。
  ///
  /// ```dart
  /// AntdIcon(AntIcons.heartFilled, color: Colors.red)
  /// ```
  final Color? color;

  /// TwoTone 主色（仅 TwoTone SVG 模式生效）。
  ///
  /// 设置后 SVG 中 `#333` 替换为此色，次色由主色自动提亮生成
  /// （近似 antd React 的 `generate(primary)[0]`）。
  /// 未设置时使用 SVG 原始双色（`#333` + `#E6E6E6`）。
  ///
  /// ```dart
  /// // 主色红色，次色自动生成浅红
  /// AntdIcon(AntIconsTwotone.heartTwoTone, twoToneColor: Colors.red)
  /// ```
  ///
  /// 首次渲染需异步加载 SVG 资产并做色彩替换（结果按
  /// 「路径 + 主色 + 次色」缓存，后续同参渲染无额外开销）。
  final Color? twoToneColor;

  /// 语义标签（无障碍），供屏幕阅读器朗读。
  ///
  /// 设为 `null` 时图标对无障碍服务不可见（视为纯装饰）；传入描述性
  /// 文本可让视障用户理解图标含义。
  ///
  /// ```dart
  /// AntdIcon(AntIcons.searchOutlined, semanticLabel: '搜索')
  /// ```
  final String? semanticLabel;

  /// TwoTone SVG 色彩化缓存：`path@primary@secondary` → SVG 字符串。
  static final Map<String, String> _colorizedCache = {};

  /// 包名（用于包内资产定位）。
  static const String _packageName = 'antd_icons_flutter';

  @override
  Widget build(BuildContext context) {
    // TTF 字体模式
    if (icon is IconData) {
      return Icon(
        icon as IconData,
        size: size,
        color: color,
        semanticLabel: semanticLabel,
      );
    }

    // TwoTone SVG 模式
    final svgPath = icon as String;
    final iconTheme = IconTheme.of(context);
    final effectiveSize = size ?? iconTheme.size ?? 24.0;

    // 无 twoToneColor：直接渲染原始 SVG（#333 + #E6E6E6）
    if (twoToneColor == null) {
      return SvgPicture.asset(
        svgPath,
        package: _packageName,
        width: effectiveSize,
        height: effectiveSize,
        semanticsLabel: semanticLabel,
      );
    }

    // 有 twoToneColor：动态替换双色后渲染
    final primary = twoToneColor!;
    final secondary = _generateSecondaryColor(primary);

    return FutureBuilder<String>(
      future: _loadAndColorize(svgPath, primary, secondary),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SvgPicture.string(
            snapshot.data!,
            width: effectiveSize,
            height: effectiveSize,
            semanticsLabel: semanticLabel,
          );
        }
        return SizedBox(width: effectiveSize, height: effectiveSize);
      },
    );
  }

  /// 加载 SVG 资产并替换双色（带缓存）。
  Future<String> _loadAndColorize(
    String path,
    Color primary,
    Color secondary,
  ) async {
    final primaryHex = _toHexString(primary);
    final secondaryHex = _toHexString(secondary);
    final cacheKey = '$path@$primaryHex@$secondaryHex';
    return _colorizedCache[cacheKey] ??= _applyTwoToneColors(
      await rootBundle.loadString('packages/$_packageName/$path'),
      primaryHex,
      secondaryHex,
    );
  }

  /// 替换 SVG 中的双色标记。
  static String _applyTwoToneColors(
    String svg,
    String primaryHex,
    String secondaryHex,
  ) {
    return svg
        .replaceAll('#333', primaryHex)
        .replaceAll('#E6E6E6', secondaryHex);
  }

  /// 由主色生成次色（向白色方向大幅提亮）。
  ///
  /// 近似 antd React `@ant-design/colors` 的 `generate(primary)[0]`：
  /// `#333` → 约 `#E7E7E7`（antd 原始次色为 `#E6E6E6`）。
  static Color _generateSecondaryColor(Color primary) {
    return Color.fromARGB(
      255,
      _lightenChannel(_channel8(primary.r)),
      _lightenChannel(_channel8(primary.g)),
      _lightenChannel(_channel8(primary.b)),
    );
  }

  static int _lightenChannel(int v) => (v + (255 - v) * 0.88).round();

  /// Color 0.0–1.0 通道值 → 0–255 整数。
  static int _channel8(double v) => (v * 255.0).round().clamp(0, 255);

  /// Color → `#RRGGBB` 小写十六进制字符串。
  static String _toHexString(Color c) {
    final r = _channel8(c.r).toRadixString(16).padLeft(2, '0');
    final g = _channel8(c.g).toRadixString(16).padLeft(2, '0');
    final b = _channel8(c.b).toRadixString(16).padLeft(2, '0');
    return '#$r$g$b';
  }
}
