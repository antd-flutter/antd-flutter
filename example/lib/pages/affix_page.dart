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
          Container(
            height: 120,
            alignment: Alignment.center,
            child: const Text('占位内容'),
          ),
          _Section(
            title: '回调状态',
            theme: theme,
            status: _statusText('callback'),
            child: AntAffix(
              offsetTop: 56,
              onChange: (affixed) =>
                  setState(() => _affixed['callback'] = affixed),
              child: _bar(theme, '带 onChange 回调'),
            ),
          ),
          Container(
            height: 120,
            alignment: Alignment.center,
            child: const Text('占位内容'),
          ),
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
              margin: EdgeInsets.only(bottom: theme.s(8)),
              padding: EdgeInsets.all(theme.s(16)),
              decoration: BoxDecoration(
                color: theme.colorFillQuaternary,
                borderRadius: BorderRadius.circular(theme.borderRadiusLG),
              ),
              child: Text('滚动内容块 $i'),
            ),
          // offsetBottom 固钉放在长内容末尾：加载即钉在视口底部（原位低于
          // 底部阈值线），向下滚过原位解除，向上滚回重新钉住
          _Section(
            title: 'offsetBottom（页面末尾，向上滚回即钉底）',
            theme: theme,
            status: _statusText('bottom'),
            child: AntAffix(
              offsetBottom: 16,
              onChange: (v) => setState(() => _affixed['bottom'] = v),
              child: _bar(theme, '固定在底部 16px'),
            ),
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
      padding: EdgeInsets.only(bottom: theme.s(8)),
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
      padding: EdgeInsets.symmetric(horizontal: theme.s(16), vertical: theme.s(12)),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: theme.colorBorder),
      ),
      child: Row(
        children: [
          Icon(AntIcons.pushpinOutlined, size: theme.s(16), color: theme.colorPrimary),
          SizedBox(width: theme.s(8)),
          // Expanded：窄屏/钉住宽度约束下长文本换行，不产生横向溢出
          Expanded(child: Text(text, softWrap: true)),
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
      margin: EdgeInsets.only(bottom: theme.s(24)),
      padding: EdgeInsets.all(theme.s(16)),
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
          SizedBox(height: theme.s(12)),
          child,
        ],
      ),
    );
  }
}
