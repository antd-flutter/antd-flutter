import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// AntConfigProvider 全局配置演示页
class ConfigProviderPage extends StatefulWidget {
  const ConfigProviderPage({super.key});

  @override
  State<ConfigProviderPage> createState() => _ConfigProviderPageState();
}

class _ConfigProviderPageState extends State<ConfigProviderPage> {
  bool _dark = false;
  AntConfigDirection _direction = AntConfigDirection.ltr;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.s(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '暗色主题切换',
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AntSwitch(
                  checked: _dark,
                  onChange: (v) => setState(() => _dark = v),
                ),
                SizedBox(height: theme.s(8)),
                AntConfigProvider(
                  antdTheme: _dark ? AntThemeData.dark() : AntThemeData.light(),
                  child: _ThemeCard(),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: 'RTL 方向',
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: theme.s(8),
                  children: [
                    AntButton(
                      type: _direction == AntConfigDirection.ltr
                          ? AntButtonType.primary
                          : AntButtonType.normal,
                      child: const Text('LTR'),
                      onTap: () =>
                          setState(() => _direction = AntConfigDirection.ltr),
                    ),
                    AntButton(
                      type: _direction == AntConfigDirection.rtl
                          ? AntButtonType.primary
                          : AntButtonType.normal,
                      child: const Text('RTL'),
                      onTap: () =>
                          setState(() => _direction = AntConfigDirection.rtl),
                    ),
                  ],
                ),
                SizedBox(height: theme.s(8)),
                AntConfigProvider(
                  direction: _direction,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(theme.s(8)),
                    color: theme.colorFillQuaternary,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('开始侧'), Text('结束侧')],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: 'locale 自定义文案',
            theme: theme,
            child: Builder(
              builder: (context) {
                const zh = AntConfigLocale(
                  languageCode: 'zh-CN',
                  messages: {'ok': '确认', 'cancel': '取消'},
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('语言码：${zh.languageCode}'),
                    SizedBox(height: theme.s(4)),
                    AntConfigProvider(
                      locale: zh,
                      child: Builder(
                        builder: (context) => Text(
                          '文案：${AntConfigProvider.of(context).text('ok')} / '
                          '${AntConfigProvider.of(context).text('cancel')}',
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '嵌套覆盖',
            theme: theme,
            child: AntConfigProvider(
              locale: const AntConfigLocale(languageCode: 'zh'),
              direction: AntConfigDirection.ltr,
              child: AntConfigProvider(
                locale: const AntConfigLocale(languageCode: 'en'),
                direction: AntConfigDirection.rtl,
                child: Builder(
                  builder: (context) {
                    final config = AntConfigProvider.of(context);
                    return Text(
                      '内层生效：${config.locale?.languageCode} / '
                      '${config.direction.name}',
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '默认值',
            theme: theme,
            child: Builder(
              builder: (context) {
                final config = AntConfigProvider.of(context);
                return Text(
                  '当前页面无 Provider 时返回默认：'
                  'direction=${config.direction.name}、'
                  'locale=${config.locale?.languageCode ?? "未设置"}、'
                  '主题=${AntTheme.of(context).isDark ? "暗色" : "亮色"}',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(theme.s(12)),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: theme.colorBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '主题卡片',
            style: TextStyle(
              color: theme.colorTextHeading,
              fontSize: theme.fontSizeLG,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: theme.s(4)),
          Text(
            '主色即当前 ConfigProvider 注入的 antdTheme 主色',
            style: TextStyle(color: theme.colorTextSecondary),
          ),
          SizedBox(height: theme.s(8)),
          AntTag(child: '主色标签', color: AntTagColor.processing),
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
      padding: EdgeInsets.all(theme.s(12)),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: theme.colorBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: theme.fontSizeLG,
              fontWeight: FontWeight.w600,
              color: theme.colorTextHeading,
            ),
          ),
          SizedBox(height: theme.s(8)),
          child,
        ],
      ),
    );
  }
}
