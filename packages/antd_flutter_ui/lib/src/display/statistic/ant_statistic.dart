/// AntStatistic — antd React Statistic 的 Flutter 实现
///
/// API 与 antd React Statistic 对齐：
/// - [title] — 标题
/// - [value] — 数值
/// - [valueString] — 字符串值（优先于 value）
/// - [precision] — 小数位数
/// - [prefix] — 前缀
/// - [suffix] — 后缀
/// - [valueStyle] — 数值样式
/// - [groupSeparator] — 千分位分隔符
/// - [loading] — 加载中
///
/// AntStatisticCountdown — 倒计时统计。
///
/// ```dart
/// AntStatistic(title: '活跃用户', value: 112893)
/// AntStatistic(title: '剩余', value: 3.14, precision: 2)
/// ```
library;

import 'dart:async';

import 'package:antd_theme/antd_theme.dart';

export 'ant_statistic_types.dart';
import 'package:material_ui/material_ui.dart';

// ============================================================
// AntStatistic
// ============================================================

/// 统计数值 — 展示统计数值。
///
/// 对齐 antd React Statistic 组件。
class AntStatistic extends StatelessWidget {
  const AntStatistic({
    super.key,
    this.title,
    this.value,
    this.valueString,
    this.precision,
    this.prefix,
    this.suffix,
    this.valueStyle,
    this.decimalStyle,
    this.groupSeparator = ',',
    this.loading = false,
  });

  /// 标题。
  final String? title;

  /// 数值。
  final num? value;

  /// 字符串值（优先于 [value]）。
  final String? valueString;

  /// 小数位数。
  final int? precision;

  /// 前缀。
  final Widget? prefix;

  /// 后缀。
  final Widget? suffix;

  /// 数值样式。
  final TextStyle? valueStyle;

  /// 小数部分独立样式（小数点后的数字）。不传时跟随 valueStyle，
  /// 传了则整数部分用 valueStyle、小数点与小数部分用 decimalStyle。
  final TextStyle? decimalStyle;

  /// 千分位分隔符。
  final String groupSeparator;

  /// 是否加载中。
  final bool loading;

  /// 格式化数值为字符串。
  /// 构建数值的行内 span 列表。
  ///
  /// [decimalStyle] 非空且 [formatted] 含小数点时返回两个 span
  /// （整数段用 [valueStyle]、小数段用 [decimalStyle]），
  /// 否则返回单个使用 [valueStyle] 的 span。
  static List<InlineSpan> buildValueSpans({
    required String formatted,
    required TextStyle valueStyle,
    TextStyle? decimalStyle,
  }) {
    if (decimalStyle != null && formatted.contains('.')) {
      final dotIndex = formatted.indexOf('.');
      return [
        TextSpan(
          text: formatted.substring(0, dotIndex + 1),
          style: valueStyle,
        ),
        TextSpan(
          text: formatted.substring(dotIndex + 1),
          style: decimalStyle,
        ),
      ];
    }
    return [TextSpan(text: formatted, style: valueStyle)];
  }

  String _formatValue() {
    if (valueString != null) return valueString!;
    if (value == null) return '';

    var str = precision != null
        ? value!.toStringAsFixed(precision!)
        : value!.toString();

    // 移除科学计数法
    if (str.contains('e')) {
      str = value!.toStringAsFixed(precision ?? 0);
    }

    // 分割整数和小数部分
    final parts = str.split('.');
    var intPart = parts[0];

    // 处理负号
    var sign = '';
    if (intPart.startsWith('-')) {
      sign = '-';
      intPart = intPart.substring(1);
    }

    // 添加千分位
    final formatted = StringBuffer();
    for (var i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) {
        formatted.write(groupSeparator);
      }
      formatted.write(intPart[i]);
    }

    final result = sign + formatted.toString();
    if (parts.length > 1) {
      return '$result.${parts[1]}';
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Text(
            title!,
            style: TextStyle(
              fontSize: theme.fontSizeSM,
              color: theme.colorTextSecondary,
            ),
          ),
        SizedBox(height: 4.w),
        if (loading)
          _buildSkeleton(theme)
        else
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              if (prefix != null) ...[
                DefaultTextStyle.merge(
                  style: valueStyle ??
                      TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorText,
                      ),
                  child: prefix!,
                ),
                SizedBox(width: 4.w),
              ],
              Builder(
                builder: (_) => Text.rich(
                  TextSpan(
                    children: buildValueSpans(
                      formatted: _formatValue(),
                      valueStyle: valueStyle ??
                          TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorText,
                          ),
                      decimalStyle: decimalStyle,
                    ),
                  ),
                ),
              ),
              if (suffix != null) ...[
                SizedBox(width: 4.w),
                DefaultTextStyle.merge(
                  style: valueStyle ??
                      TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorText,
                      ),
                  child: suffix!,
                ),
              ],
            ],
          ),
      ],
    );
  }

  Widget _buildSkeleton(AntThemeData theme) {
    return Container(
      width: 120.w,
      height: 32.w,
      decoration: BoxDecoration(
        color: theme.colorFillSecondary,
        borderRadius: BorderRadius.circular(theme.borderRadiusSM),
      ),
    );
  }
}

// ============================================================
// AntStatisticCountdown
// ============================================================

/// 倒计时统计 — 倒计时显示组件。
///
/// 对齐 antd React Statistic.Countdown 组件。
class AntStatisticCountdown extends StatefulWidget {
  const AntStatisticCountdown({
    super.key,
    this.title,
    required this.value,
    this.format = 'HH:mm:ss',
    this.valueStyle,
    this.onFinish,
  });

  /// 标题。
  final String? title;

  /// 目标时间戳（毫秒）或 Duration。
  final dynamic value;

  /// 格式化模板（支持 DD/HH/mm/ss）。
  final String format;

  /// 数值样式。
  final TextStyle? valueStyle;

  /// 倒计时结束回调。
  final VoidCallback? onFinish;

  @override
  State<AntStatisticCountdown> createState() => _AntStatisticCountdownState();
}

class _AntStatisticCountdownState extends State<AntStatisticCountdown> {
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = _resolveDuration();
    if (_remaining > Duration.zero) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          _remaining = _remaining - const Duration(seconds: 1);
          if (_remaining <= Duration.zero) {
            _remaining = Duration.zero;
            _timer?.cancel();
            widget.onFinish?.call();
          }
        });
      });
    }
  }

  Duration _resolveDuration() {
    if (widget.value is Duration) return widget.value as Duration;
    if (widget.value is int) {
      return Duration(milliseconds: widget.value as int);
    }
    return Duration.zero;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration() {
    var str = widget.format;
    final totalSeconds = _remaining.inSeconds;
    final days = _remaining.inDays;
    final hours = _remaining.inHours % 24;
    final minutes = _remaining.inMinutes % 60;
    final seconds = totalSeconds % 60;

    str = str.replaceAll('DD', days.toString().padLeft(2, '0'));
    str = str.replaceAll('HH', hours.toString().padLeft(2, '0'));
    str = str.replaceAll('mm', minutes.toString().padLeft(2, '0'));
    str = str.replaceAll('ss', seconds.toString().padLeft(2, '0'));
    return str;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
            style: TextStyle(
              fontSize: theme.fontSizeSM,
              color: theme.colorTextSecondary,
            ),
          ),
        SizedBox(height: 4.w),
        Text(
          _formatDuration(),
          style: widget.valueStyle ??
              TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorText,
              ),
        ),
      ],
    );
  }
}
