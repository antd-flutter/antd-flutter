/// antd_carousel — Ant Design v6 Carousel 走马灯独立组件包（数据展示类，无 sliver 依赖）
///
/// 从主包 antd_flutter_plus 拆分的独立组件包：
/// - [AntCarousel] — 走马灯（自动播放、循环、指示点、箭头、垂直轮播、受控/非受控）
/// - [AntCarouselController] — 外部控制器（goTo 程序化跳转）
/// - [AntCarouselDotPosition] — 指示点位置（top / bottom / left / right）
///
/// 依赖方向约定：antd_carousel → antd_theme（+ material_ui），
/// 不依赖主包 antd_flutter_plus；主包通过 export re-export 保持零符号破坏。
/// 轮播为固定布局展示类组件（非滚动场景），不需要 sliver 支持（R33）。
/// 无限循环采用 PageView.builder + 页码取模方案（对照吸收 carousel_slider 的实现思路，MIT）。
///
/// ```dart
/// import 'package:antd_carousel/antd_carousel.dart';
///
/// final controller = AntCarouselController();
/// AntCarousel(
///   children: [Text('1'), Text('2')],
///   autoplay: true,
///   loop: true,
///   controller: controller,
/// );
/// controller.goTo(1);
/// ```
library;

export 'src/carousel/ant_carousel.dart';
export 'src/carousel/ant_carousel_types.dart';
