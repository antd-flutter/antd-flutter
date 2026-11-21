import 'package:material_ui/material_ui.dart';

/// 浮层内容基座。
///
/// 通过 `Overlay` 插入的内容不在任何 `Material` 之下，Flutter 调试模式下
/// 会给其中的文本画出黄色下划线，`InkWell` 等也需要 `Material` 才能正常工作。
/// 所有自行插入根 Overlay 的浮层都应包一层本组件。
class AntOverlayMaterial extends StatelessWidget {
  const AntOverlayMaterial({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: child,
    );
  }
}
