import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

/// 构建网络图片（IO 平台实现，带磁盘缓存）。
Widget buildAntNetworkImage({
  required String url,
  required BoxFit fit,
  double? width,
  double? height,
  Object? cacheManager,
  Widget Function(BuildContext context, String url)? placeholder,
  Widget Function(BuildContext context, String url, Object error)? errorWidget,
}) {
  return CachedNetworkImage(
    imageUrl: url,
    width: width,
    height: height,
    fit: fit,
    cacheManager: cacheManager as dynamic,
    placeholder: placeholder,
    errorWidget: errorWidget,
  );
}
