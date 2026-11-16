import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class BorderBeamPage extends StatelessWidget {
  const BorderBeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            theme: theme,
            child: const AntBorderBeam(
              child: SizedBox(
                width: double.infinity,
                child: Text('默认流光边框卡片'),
              ),
            ),
          ),
          _Section(
            title: '自定义颜色',
            theme: theme,
            child: Column(
              children: [
                AntBorderBeam(
                  colorPrimary: Colors.purple,
                  colorSecondary: Colors.purpleAccent,
                  child: _body('紫色流光'),
                ),
                SizedBox(height: 16.w),
                AntBorderBeam(
                  colorPrimary: Colors.orange,
                  colorSecondary: Colors.deepOrangeAccent,
                  child: _body('橙色流光'),
                ),
              ],
            ),
          ),
          _Section(
            title: '动画速度',
            theme: theme,
            child: Column(
              children: [
                AntBorderBeam(
                  duration: const Duration(seconds: 2),
                  child: _body('快速（2s 周期）'),
                ),
                SizedBox(height: 16.w),
                AntBorderBeam(
                  duration: const Duration(seconds: 10),
                  child: _body('慢速（10s 周期）'),
                ),
                SizedBox(height: 16.w),
                AntBorderBeam(
                  reverse: true,
                  child: _body('反向流动'),
                ),
              ],
            ),
          ),
          _Section(
            title: '圆角与边框宽度',
            theme: theme,
            child: Column(
              children: [
                AntBorderBeam(
                  borderRadius: BorderRadius.circular(24.w),
                  child: _body('大圆角（24）'),
                ),
                SizedBox(height: 16.w),
                AntBorderBeam(
                  size: 6,
                  borderRadius: BorderRadius.circular(12.w),
                  child: _body('粗边框（6px）'),
                ),
                SizedBox(height: 16.w),
                AntBorderBeam(
                  initialOffset: 0.5,
                  child: _body('初始相位 0.5'),
                ),
              ],
            ),
          ),
          _Section(
            title: '组合内容',
            theme: theme,
            child: AntBorderBeam(
              colorPrimary: theme.colorSuccess,
              colorSecondary: theme.colorSuccessBorder,
              padding: EdgeInsets.all(16.w),
              borderRadius: BorderRadius.circular(theme.borderRadiusLG),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified, size: 20.w, color: theme.colorSuccess),
                      SizedBox(width: 8.w),
                      Text(
                        '认证信息',
                        style: TextStyle(
                          fontSize: theme.fontSizeLG,
                          fontWeight: FontWeight.bold,
                          color: theme.colorTextHeading,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.w),
                  Text(
                    '边框流光可以包裹任意内容：文字、图标、按钮组合均可，'
                    '流光沿边框循环移动以突出展示重点内容。',
                    style: TextStyle(color: theme.colorTextSecondary),
                  ),
                  SizedBox(height: 12.w),
                  Row(
                    children: [
                      Icon(Icons.check_circle,
                          size: 16.w, color: theme.colorSuccess),
                      SizedBox(width: 4.w),
                      const Text('实时校验通过'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(String text) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(child: Text(text)),
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
      margin: EdgeInsets.only(bottom: 24.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorBgLayout,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: theme.fontSizeLG,
              fontWeight: FontWeight.bold,
              color: theme.colorTextHeading,
            ),
          ),
          SizedBox(height: 12.w),
          child,
        ],
      ),
    );
  }
}
