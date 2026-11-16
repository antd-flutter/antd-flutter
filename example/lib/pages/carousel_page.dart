import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// AntCarousel 演示页
class CarouselPage extends StatefulWidget {
  const CarouselPage({super.key});

  @override
  State<CarouselPage> createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  final AntCarouselController _controller = AntCarouselController();
  int _current = 0;

  List<Widget> _demoPages(AntThemeData theme, {bool cardStyle = false}) {
    final colors = [theme.colorPrimary, theme.colorSuccess, theme.colorWarning];
    return [
      for (var i = 0; i < colors.length; i++)
        Container(
          color: cardStyle ? null : colors[i].withValues(alpha: 0.15),
          alignment: Alignment.center,
          child: cardStyle ? null : Text('第 ${i + 1} 页'),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. 基础用法
          _Section(
            title: '基础用法',
            theme: theme,
            child: AntCarousel(height: 150.w, children: _demoPages(theme)),
          ),
          SizedBox(height: 16.w),
          // 2. 自动播放
          _Section(
            title: '自动播放（3s 间隔，末页循环回首页）',
            theme: theme,
            child: AntCarousel(
              height: 150.w,
              autoplay: true,
              loop: true,
              children: _demoPages(theme),
            ),
          ),
          SizedBox(height: 16.w),
          // 3. 指示点位置
          _Section(
            title: '指示点位置',
            theme: theme,
            child: Column(
              children: [
                AntCarousel(
                  height: 110.w,
                  dotPosition: AntCarouselDotPosition.top,
                  children: _demoPages(theme),
                ),
                SizedBox(height: 12.w),
                AntCarousel(
                  height: 110.w,
                  dotPosition: AntCarouselDotPosition.left,
                  children: _demoPages(theme),
                ),
                SizedBox(height: 12.w),
                AntCarousel(
                  height: 110.w,
                  dotPosition: AntCarouselDotPosition.right,
                  children: _demoPages(theme),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          // 4. 箭头
          _Section(
            title: '箭头（hover 加深，桌面端常用）',
            theme: theme,
            child: AntCarousel(
              height: 150.w,
              arrows: true,
              loop: true,
              children: _demoPages(theme),
            ),
          ),
          SizedBox(height: 16.w),
          // 5. 垂直轮播
          _Section(
            title: '垂直轮播',
            theme: theme,
            child: AntCarousel(
              height: 200.w,
              vertical: true,
              autoplay: true,
              loop: true,
              dotPosition: AntCarouselDotPosition.right,
              children: _demoPages(theme),
            ),
          ),
          SizedBox(height: 16.w),
          // 6. 受控 + goTo
          _Section(
            title: '受控模式 + goTo 跳转',
            theme: theme,
            child: Column(
              children: [
                AntCarousel(
                  height: 150.w,
                  controller: _controller,
                  current: _current,
                  onChange: (i) => setState(() => _current = i),
                  children: _demoPages(theme),
                ),
                SizedBox(height: 12.w),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.w,
                  children: [
                    for (var i = 0; i < 3; i++)
                      OutlinedButton(
                        onPressed: () {
                          _controller.goTo(i);
                          setState(() => _current = i);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: _current == i
                                ? theme.colorPrimary
                                : theme.colorBorder,
                          ),
                        ),
                        child: Text(
                          'goTo(${i + 1})',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: _current == i
                                ? theme.colorPrimary
                                : theme.colorText,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          // 7. 自定义内容卡片
          _Section(
            title: '自定义内容卡片',
            theme: theme,
            child: AntCarousel(
              height: 180.w,
              autoplay: true,
              loop: true,
              arrows: true,
              children: [
                _BannerCard(
                  theme: theme,
                  title: '新品发布',
                  subtitle: 'AntdFlutter v1.0 正式上线',
                  color: theme.colorPrimary,
                  icon: Icons.rocket_launch,
                ),
                _BannerCard(
                  theme: theme,
                  title: '限时优惠',
                  subtitle: '全场组件 5 折起',
                  color: theme.colorError,
                  icon: Icons.local_offer,
                ),
                _BannerCard(
                  theme: theme,
                  title: '社区共建',
                  subtitle: '欢迎提交 Issue 与 PR',
                  color: theme.colorSuccess,
                  icon: Icons.favorite,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.theme,
    required this.child,
  });

  final String title;
  final AntThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: theme.colorSplit),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          SizedBox(height: 12.w),
          child,
        ],
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({
    required this.theme,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  final AntThemeData theme;
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32.sp, color: color),
          SizedBox(height: 8.w),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          SizedBox(height: 4.w),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14.sp, color: theme.colorText),
          ),
        ],
      ),
    );
  }
}
