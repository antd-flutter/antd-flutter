/// antd_qrcode example — 组件演示画廊。
///
/// - 主题经 antd_theme（P03 桥接）注入：`AntThemeData.light/dark().toThemeData()`
/// - 单语言中文演示（独立包 example 从简，不做国际化）
/// - 画廊模式：侧栏分区 + 分区内容，覆盖 QRCode 全部关键形态
library;

import 'package:antd_qrcode/antd_qrcode.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

void main() {
  runApp(const AntdQrcodeGalleryApp());
}

/// 演示分区定义。
class _Section {
  const _Section(this.title, this.builder);

  final String title;
  final WidgetBuilder builder;
}

/// antd 二维码画廊根组件。
class AntdQrcodeGalleryApp extends StatefulWidget {
  const AntdQrcodeGalleryApp({super.key});

  @override
  State<AntdQrcodeGalleryApp> createState() => _AntdQrcodeGalleryAppState();
}

class _AntdQrcodeGalleryAppState extends State<AntdQrcodeGalleryApp> {
  bool _isDark = false;

  static const List<_Section> _sections = [
    _Section('基础用法', _basicSection),
    _Section('纠错等级', _errorLevelSection),
    _Section('自定义颜色', _colorSection),
    _Section('尺寸', _sizeSection),
    _Section('边框', _borderedSection),
    _Section('中心图标', _iconSection),
    _Section('状态', _statusSection),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = _isDark ? AntThemeData.dark() : AntThemeData.light();
    return AntTheme(
      data: theme,
      child: AntScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          title: 'Ant Design QRCode',
          debugShowCheckedModeBanner: false,
          themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
          theme: AntThemeData.light().toThemeData(),
          darkTheme: AntThemeData.dark().toThemeData(),
          home: _GalleryPage(
            sections: _sections,
            isDark: _isDark,
            onToggleDark: () => setState(() => _isDark = !_isDark),
          ),
        ),
      ),
    );
  }
}

/// 画廊页面：左侧分区导航 + 右侧内容。
class _GalleryPage extends StatefulWidget {
  const _GalleryPage({
    required this.sections,
    required this.isDark,
    required this.onToggleDark,
  });

  final List<_Section> sections;
  final bool isDark;
  final VoidCallback onToggleDark;

  @override
  State<_GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<_GalleryPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final section = widget.sections[_selectedIndex];
    return Scaffold(
      body: Row(
        children: [
          // 侧栏导航
          Container(
            width: 220,
            color: theme.colorBgLayout,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'QRCode 二维码',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.colorText,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: widget.isDark ? '切换亮色' : '切换暗色',
                        icon: Icon(
                          widget.isDark
                              ? AntIcons.sunOutlined
                              : AntIcons.moonOutlined,
                          color: theme.colorText,
                        ),
                        onPressed: widget.onToggleDark,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView(
                    children: [
                      for (var i = 0; i < widget.sections.length; i++)
                        Material(
                          color: Colors.transparent,
                          child: ListTile(
                            selected: i == _selectedIndex,
                            selectedTileColor: theme.colorPrimaryBg,
                            title: Text(
                              widget.sections[i].title,
                              style: TextStyle(
                                color: i == _selectedIndex
                                    ? theme.colorPrimary
                                    : theme.colorText,
                              ),
                            ),
                            onTap: () => setState(() => _selectedIndex = i),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(width: 1, color: theme.colorBorderSecondary),
          // 分区内容
          Expanded(
            child: KeyedSubtree(
              key: ValueKey(_selectedIndex),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: theme.colorText,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Builder(key: UniqueKey(), builder: section.builder),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 分区通用展示容器（标题 + 说明 + 示例区）。
class _DemoCard extends StatelessWidget {
  const _DemoCard({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorBorderSecondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(fontSize: 13, color: theme.colorTextSecondary),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

/// 横向排布多个示例（自适应换行）。
class _DemoRow extends StatelessWidget {
  const _DemoRow(this.children);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 32,
      runSpacing: 24,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }
}

// ---------------------------------------------------------------------------
// 各分区实现
// ---------------------------------------------------------------------------

Widget _basicSection(BuildContext context) {
  return const _DemoCard(
    title: '基础二维码',
    description: '默认参数：纠错等级 M、尺寸 96、带边框。',
    child: AntQRCode(value: 'https://flutter-open.github.io/'),
  );
}

Widget _errorLevelSection(BuildContext context) {
  return _DemoCard(
    title: '纠错等级 L / M / Q / H',
    description: '纠错比例依次为 7% / 15% / 25% / 30%，等级越高冗余信息越多。',
    child: _DemoRow([
      for (final level in AntQRCodeErrorLevel.values)
        _LabeledExample(
          label: level.name.toUpperCase(),
          child: AntQRCode(
            value: 'antd-error-level-${level.name}',
            errorLevel: level,
          ),
        ),
    ]),
  );
}

Widget _colorSection(BuildContext context) {
  final theme = AntTheme.of(context);
  return _DemoCard(
    title: '自定义颜色',
    description: 'color 控制码点颜色，bgColor 控制背景色；跟随亮暗模式适配。',
    child: _DemoRow([
      _LabeledExample(
        label: '主色码点',
        child: AntQRCode(
          value: 'antd-color-primary',
          color: theme.colorPrimary,
        ),
      ),
      _LabeledExample(
        label: '自定义码点',
        child: AntQRCode(
          value: 'antd-color-green',
          color: const Color(0xFF00B96B),
        ),
      ),
      _LabeledExample(
        label: '自定义背景',
        child: AntQRCode(
          value: 'antd-color-bg',
          bgColor: theme.isDark
              ? const Color(0xFF1F1F1F)
              : const Color(0xFFEFF8F1),
        ),
      ),
    ]),
  );
}

Widget _sizeSection(BuildContext context) {
  return _DemoCard(
    title: '尺寸对比',
    description: 'size 控制二维码边长（逻辑像素）。',
    child: _DemoRow([
      for (final size in const [64.0, 96.0, 128.0, 160.0])
        _LabeledExample(
          label: '$size',
          child: AntQRCode(value: 'antd-size-$size', size: size),
        ),
    ]),
  );
}

Widget _borderedSection(BuildContext context) {
  return const _DemoCard(
    title: '有无边框',
    description: 'bordered 默认 true，设置 false 后移除二维码外框。',
    child: _DemoRow([
      _LabeledExample(
        label: '有边框（默认）',
        child: AntQRCode(value: 'antd-bordered-true'),
      ),
      _LabeledExample(
        label: '无边框',
        child: AntQRCode(value: 'antd-bordered-false', bordered: false),
      ),
    ]),
  );
}

Widget _iconSection(BuildContext context) {
  return const _DemoCard(
    title: '中心图标',
    description: 'icon 为 true 时在二维码中心嵌入图标（iconSize 控制其尺寸）。',
    child: _DemoRow([
      _LabeledExample(
        label: 'icon + 默认尺寸',
        child: AntQRCode(value: 'antd-icon-true', icon: true),
      ),
      _LabeledExample(
        label: 'icon + 32',
        child: AntQRCode(value: 'antd-icon-32', icon: true, iconSize: 32),
      ),
    ]),
  );
}

/// 状态演示（expired / scanned）— 需要状态管理。
class _StatusDemo extends StatefulWidget {
  const _StatusDemo();

  @override
  State<_StatusDemo> createState() => _StatusDemoState();
}

class _StatusDemoState extends State<_StatusDemo> {
  AntQRCodeStatus _expiredStatus = AntQRCodeStatus.expired;
  AntQRCodeStatus _scannedStatus = AntQRCodeStatus.scanned;
  int _refreshCount = 0;

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      title: '状态：expired / scanned',
      description: 'expired 覆盖层点击「点击刷新」重新激活；scanned 显示已扫描覆盖层。',
      child: _DemoRow([
        _LabeledExample(
          label: _refreshCount == 0 ? '已过期' : '已刷新 $_refreshCount 次',
          child: AntQRCode(
            value: 'antd-status-expired-$_refreshCount',
            status: _expiredStatus,
            onRefresh: () => setState(() {
              _refreshCount++;
              _expiredStatus = AntQRCodeStatus.active;
            }),
          ),
        ),
        _LabeledExample(
          label: '已扫描（点击复位）',
          child: AntQRCode(
            value: 'antd-status-scanned',
            status: _scannedStatus,
            onRefresh: () =>
                setState(() => _scannedStatus = AntQRCodeStatus.active),
          ),
        ),
        _LabeledExample(
          label: '重置演示',
          child: OutlinedButton(
            onPressed: () => setState(() {
              _refreshCount = 0;
              _expiredStatus = AntQRCodeStatus.expired;
              _scannedStatus = AntQRCodeStatus.scanned;
            }),
            child: const Text('重置'),
          ),
        ),
      ]),
    );
  }
}

Widget _statusSection(BuildContext context) => const _StatusDemo();

/// 带底部标签的示例单元。
class _LabeledExample extends StatelessWidget {
  const _LabeledExample({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: theme.colorTextDescription),
        ),
      ],
    );
  }
}
