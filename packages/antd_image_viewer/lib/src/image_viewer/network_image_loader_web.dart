import 'package:flutter/widgets.dart';

/// 构建网络图片（Web 平台实现：浏览器缓存）。
Widget buildAntNetworkImage({
  required String url,
  required BoxFit fit,
  Widget Function(BuildContext context, String url)? placeholder,
  Widget Function(BuildContext context, String url, Object error)? errorWidget,
}) {
  return Image.network(
    url,
    fit: fit,
    loadingBuilder: (context, child, progress) {
      if (progress == null) return child;
      return placeholder?.call(context, url) ?? child;
    },
    errorBuilder: (context, error, stackTrace) =>
        errorWidget?.call(context, url, error) ?? const SizedBox.shrink(),
  );
}
