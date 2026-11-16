import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class AffixPage extends StatefulWidget {
  const AffixPage({super.key});

  @override
  State<AffixPage> createState() => _AffixPageState();
}

class _AffixPageState extends State<AffixPage> {
  bool _affixed = false;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法 offsetTop',
            theme: theme,
            child: AntAffix(
              offsetTop: 16,
              child: _bar(theme, '固定在顶部 16px'),
            ),
          ),
          Container(height: 120, alignment: Alignment.center, child: const Text('占位内容')),
          _Section(
            title: 'offsetBottom',
            theme: theme,
            child: AntAffix(
              offsetBottom: 16,
              child: _bar(theme, '固定在底部 16px'),
            ),
          ),
          Container(height: 120, alignment: Alignment.center, child: const Text('占位内容')),
          _Section(
            title: '回调状态',
            theme: theme,
            child: Column(
              children: [
                Text(
                  _affixed ? '当前状态：已钉住' : '当前状态：未钉住',
                  style: TextStyle(
                    color: _affixed ? theme.colorSuccess : theme.colorTextSecondary,
                  ),
                ),
                SizedBox(height: 8.w),
                AntAffix(
                  offsetTop: 56,
                  onChange: (affixed) => setState(() => _affixed = affixed),
                  child: _bar(theme, '带 onChange 回调'),
                ),
              ],
            ),
          ),
          Container(height: 120, alignment: Alignment.center, child: const Text('占位内容')),
          _Section(
            title: '长页面演示（占位不跳动）',
            theme: theme,
            child: AntAffix(
              offsetTop: 0,
              child: _bar(theme, '滚过顶部后钉住，下方内容不跳动'),
            ),
          ),
          for (var i = 1; i <= 20; i++)
            Container(
              margin: EdgeInsets.only(bottom: 8.w),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: theme.colorFillQuaternary,
                borderRadius: BorderRadius.circular(theme.borderRadiusLG),
              ),
              child: Text('滚动内容块 $i'),
            ),
        ],
      ),
    );
  }

  Widget _bar(AntThemeData theme, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: theme.colorBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.push_pin, size: 16.w, color: theme.colorPrimary),
          SizedBox(width: 8.w),
          Text(text),
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
