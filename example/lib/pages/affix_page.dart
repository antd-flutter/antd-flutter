import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class AffixPage extends StatefulWidget {
  const AffixPage({super.key});

  @override
  State<AffixPage> createState() => _AffixPageState();
}

class _AffixPageState extends State<AffixPage> {
  final Map<String, bool> _affixed = {
    'top': false,
    'bottom': false,
    'callback': false,
    'long': false,
  };

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
            status: _statusText('top'),
            child: AntAffix(
              offsetTop: 16,
              onChange: (v) => setState(() => _affixed['top'] = v),
              child: _bar(theme, '固定在顶部 16px'),
            ),
          ),
          Container(height: 120, alignment: Alignment.center, child: const Text('占位内容')),
          _Section(
            title: 'offsetBottom',
            theme: theme,
            status: _statusText('bottom'),
            child: AntAffix(
              offsetBottom: 16,
              onChange: (v) => setState(() => _affixed['bottom'] = v),
              child: _bar(theme, '固定在底部 16px'),
            ),
          ),
          Container(height: 120, alignment: Alignment.center, child: const Text('占位内容')),
          _Section(
            title: '回调状态',
            theme: theme,
            status: _statusText('callback'),
            child: AntAffix(
              offsetTop: 56,
              onChange: (affixed) => setState(() => _affixed['callback'] = affixed),
              child: _bar(theme, '带 onChange 回调'),
            ),
          ),
          Container(height: 120, alignment: Alignment.center, child: const Text('占位内容')),
          _Section(
            title: '长页面演示（占位不跳动）',
            theme: theme,
            status: _statusText('long'),
            child: AntAffix(
              offsetTop: 0,
              onChange: (v) => setState(() => _affixed['long'] = v),
              child: _bar(theme, '滚过顶部后钉住，下方内容不跳动'),
            ),
          ),
          // 长滚动内容：保证每个固钉都有足够的滚动行程触发/解除
          for (var i = 1; i <= 40; i++)
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

  /// 状态文案：钉住/未钉住，便于滚动观察固钉效果。
  Widget _statusText(String key) {
    final theme = AntTheme.of(context);
    final affixed = _affixed[key] ?? false;
    return Padding(
      padding: EdgeInsets.only(bottom: 8.w),
      child: Text(
        affixed ? '当前状态：已固定' : '当前状态：未固定',
        style: TextStyle(
          fontSize: theme.fontSizeSM,
          color: affixed ? theme.colorSuccess : theme.colorTextSecondary,
        ),
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
          Icon(AntIcons.pushpinOutlined, size: 16.w, color: theme.colorPrimary),
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
    this.status,
  });

  final String title;
  final AntThemeData theme;
  final Widget child;
  final Widget? status;

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
          if (status != null) status!,
          SizedBox(height: 12.w),
          child,
        ],
      ),
    );
  }
}
