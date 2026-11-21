/// antd_keyboard example — 虚拟键盘族演示画廊（AntKeyboard 引擎 / NumberKeyboard / PasscodeInput / VirtualInput）。
///
/// - 主题经 antd_theme（P03 桥接）注入：`AntThemeData.light/dark().toThemeData()`
/// - R35.4 多平台适配：AntResponsiveInit + AntLayoutData 断点布局
///   （desktop 宽屏双栏 / phone 窄屏单栏），窗口缩放无溢出
/// - 暗色切换：AppBar 按钮联动 AntTheme + themeMode
/// - 覆盖关键形态：五布局预设（numeric/decimal/text/symbol/email）、
///   custom 自定义布局、长按变体气泡、长按连删、桌面密度与 hover、
///   AntNumberKeyboard 兼容用法、PasscodeInput / VirtualInput 接入
///
/// R33 判定：键盘为浮层唤起类组件（Overlay 弹出，非滚动场景），不需要 sliver 支持。
library;

import 'package:antd_keyboard/antd_keyboard.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const AntdKeyboardGalleryApp());
}

/// 演示卡片：标题 + 内容。
typedef _DemoCard = (String, Widget);

/// antd 键盘族画廊根组件。
class AntdKeyboardGalleryApp extends StatefulWidget {
  const AntdKeyboardGalleryApp({super.key});

  @override
  State<AntdKeyboardGalleryApp> createState() => _AntdKeyboardGalleryAppState();
}

class _AntdKeyboardGalleryAppState extends State<AntdKeyboardGalleryApp> {
  bool _isDark = false;

  static const List<String> _sectionTitles = [
    'AntKeyboard 引擎',
    'NumberKeyboard',
    'PasscodeInput',
    'VirtualInput',
    '桌面形态',
  ];

  static final List<List<_DemoCard>> _sectionCards = [
    _engineCards,
    _numberKeyboardCards,
    [], // PasscodeInput 分区为 StatefulWidget，见 _buildSectionBody
    [], // VirtualInput 分区为 StatefulWidget，见 _buildSectionBody
    _desktopCards,
  ];

  @override
  Widget build(BuildContext context) {
    // 结构对齐 antd_picker example：AntTheme 包裹 MaterialApp，theme + darkTheme +
    // themeMode 三件套联动，Scaffold 背景跟随 colorBgLayout。
    return AntTheme(
      data: _isDark ? AntThemeData.dark() : AntThemeData.light(),
      child: AntResponsiveInit(
          builder: (context, layout, _) => MaterialApp(
            title: 'AntdKeyboard Demo',
            debugShowCheckedModeBanner: false,
            themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
            theme: AntThemeData.light().toThemeData(),
            darkTheme: AntThemeData.dark().toThemeData(),
            home: DefaultTabController(
              length: _sectionTitles.length,
              child: Scaffold(
                backgroundColor: AntTheme.of(context).colorBgLayout,
                appBar: AppBar(
                  title: const Text('Keyboard 键盘族'),
                  actions: [
                    IconButton(
                      onPressed: () => setState(() => _isDark = !_isDark),
                      icon: AntdIcon(
                        _isDark ? AntIcons.sunOutlined : AntIcons.moonOutlined,
                        semanticLabel: _isDark ? '浅色模式' : '深色模式',
                      ),
                    ),
                  ],
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: [
                      for (final t in _sectionTitles) Tab(text: t),
                    ],
                  ),
                ),
                // R35.4：desktop 宽屏双栏、phone 窄屏单栏，缩放窗口不溢出。
                body: TabBarView(
                  children: [
                    for (var i = 0; i < _sectionTitles.length; i++)
                      _sectionBody(context, layout, i),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }

  Widget _sectionBody(
      BuildContext pageContext, AntLayoutData layout, int index) {
    final theme = AntTheme.of(pageContext);
    final cards = switch (index) {
      2 => const _PasscodeSection().cards,
      3 => const _VirtualInputSection().cards,
      _ => _sectionCards[index],
    };
    final isWide = layout.width >= 768 ||
        layout.breakpoint == AntBreakpoint.lg ||
        layout.breakpoint == AntBreakpoint.xl ||
        layout.breakpoint == AntBreakpoint.xxl;
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.s(16)),
      child: isWide
          ? Wrap(
              spacing: theme.s(16),
              runSpacing: theme.s(16),
              children: [
                for (final card in cards)
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: theme.s(480)),
                    child: _sectionCard(pageContext, card.$1, card.$2),
                  ),
              ],
            )
          : Column(
              children: [
                for (final card in cards)
                  Padding(
                    padding: EdgeInsets.only(bottom: theme.s(16)),
                    child: _sectionCard(pageContext, card.$1, card.$2),
                  ),
              ],
            ),
    );
  }
}

/// 卡片容器。
Widget _sectionCard(BuildContext context, String title, Widget child) {
  final theme = AntTheme.of(context);
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(theme.s(16)),
    decoration: BoxDecoration(
      color: theme.colorBgContainer,
      borderRadius: BorderRadius.circular(theme.borderRadiusLG),
      border: Border.all(color: theme.colorSplit),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: theme.s(12)),
          child: Text(title,
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: theme.s(15))),
        ),
        child,
      ],
    ),
  );
}

/// 输出文本。
Widget _output(BuildContext context, String label, String value) {
  final theme = AntTheme.of(context);
  return Padding(
    padding: EdgeInsets.only(top: theme.s(8)),
    child: Text(
      '$label：${value.isEmpty ? '（空）' : value}',
      style: TextStyle(fontSize: theme.s(13), color: theme.colorText),
    ),
  );
}

// ── AntKeyboard 引擎：五布局预设 + 自定义布局 ───────────────
class _EnginePreview extends StatelessWidget {
  const _EnginePreview({required this.layout, this.title});

  final AntKeyboardLayout layout;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    var buffer = '';
    return StatefulBuilder(
      builder: (context, setState) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: EdgeInsets.only(bottom: theme.s(4)),
              child: Text(title!,
                  style: TextStyle(fontSize: theme.s(12), color: AntTheme.of(context).colorTextSecondary)),
            ),
          AntKeyboard(
            layout: layout,
                        onTextInput: (ch) => setState(() => buffer += ch),
            onBackspace: () =>
                setState(() => buffer = buffer.isEmpty ? '' : buffer.substring(0, buffer.length - 1)),
            onConfirm: () => setState(() => buffer += '⏎'),
          ),
          _output(context, '输出', buffer),
        ],
      ),
    );
  }
}

/// 自定义布局（九宫格方向键示例）。
AntKeyboardLayout _customLayout() => AntKeyboardLayout(rows: [
      const AntKeyboardRow([
        AntKeyboardKey.text('↑'),
        AntKeyboardKey.text('↓'),
        AntKeyboardKey.text('←'),
        AntKeyboardKey.text('→'),
      ]),
      const AntKeyboardRow([
        AntKeyboardKey.action(AntKeyAction.none),
        AntKeyboardKey.text('OK', flex: 2),
        AntKeyboardKey.action(AntKeyAction.none),
      ]),
    ]);

final List<_DemoCard> _engineCards = [
  (
    'numeric 数字布局',
    _EnginePreview(layout: AntKeyboardLayout.numeric(), title: 'AntKeyboardLayout.numeric()'),
  ),
  (
    'decimal 小数布局',
    _EnginePreview(layout: AntKeyboardLayout.decimal(), title: 'AntKeyboardLayout.decimal()'),
  ),
  (
    'text QWERTY 布局（字母带长按变体气泡）',
    _EnginePreview(layout: AntKeyboardLayout.text(), title: 'AntKeyboardLayout.text()（长按 a/e 等键试变体）'),
  ),
  (
    'symbol 符号布局',
    _EnginePreview(layout: AntKeyboardLayout.symbol(), title: 'AntKeyboardLayout.symbol()'),
  ),
  (
    'email 布局',
    _EnginePreview(layout: AntKeyboardLayout.email(), title: 'AntKeyboardLayout.email()'),
  ),
  (
    'custom 自定义布局',
    _EnginePreview(layout: _customLayout(), title: '自定义 rows（方向键九宫格）'),
  ),
];

// ── NumberKeyboard（兼容用法）───────────────────────────────
class _NumberKeyboardPreview extends StatefulWidget {
  const _NumberKeyboardPreview({this.confirmText, this.randomOrder = false, this.customKey});

  final String? confirmText;
  final bool randomOrder;
  final String? customKey;

  @override
  State<_NumberKeyboardPreview> createState() => _NumberKeyboardPreviewState();
}

class _NumberKeyboardPreviewState extends State<_NumberKeyboardPreview> {
  String _value = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntNumberKeyboard(
          value: _value,
          confirmText: widget.confirmText,
          randomOrder: widget.randomOrder,
          customKey: widget.customKey,
          onChange: (v) => setState(() => _value = v),
          onConfirm: widget.confirmText != null ? () {} : null,
        ),
        _output(context, '值', _value),
      ],
    );
  }
}

final List<_DemoCard> _numberKeyboardCards = [
  (
    '基础数字键盘',
    const _NumberKeyboardPreview(),
  ),
  (
    '带确认键（confirmText）',
    const _NumberKeyboardPreview(confirmText: '确定'),
  ),
  (
    '乱序键盘（randomOrder）',
    const _NumberKeyboardPreview(randomOrder: true),
  ),
  (
    '自定义槽位键（customKey「.」）',
    const _NumberKeyboardPreview(customKey: '.'),
  ),
];

// ── PasscodeInput / VirtualInput ────────────────────────────
class _PasscodeSection {
  const _PasscodeSection();

  List<_DemoCard> get cards => [
        (
          '密码格子输入（keyboard: true，6 位）',
          StatefulBuilder(
            builder: (context, setState) {
              var value = '';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AntPasscodeInput(
                    value: value,
                    onChange: (v) => setState(() => value = v),
                    onFill: (v) => setState(() {}),
                  ),
                  _output(context, '密码长度', '${value.length}'),
                ],
              );
            },
          ),
        ),
        (
          '明文 + 分隔样式（plain / separated）',
          StatefulBuilder(
            builder: (context, setState) {
              var value = '';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AntPasscodeInput(
                    value: value,
                    length: 4,
                    plain: true,
                    separated: true,
                    onChange: (v) => setState(() => value = v),
                  ),
                  _output(context, '值', value),
                ],
              );
            },
          ),
        ),
      ];
}

class _VirtualInputSection {
  const _VirtualInputSection();

  List<_DemoCard> get cards => [
        (
          '虚拟输入框（默认数字键盘）',
          StatefulBuilder(
            builder: (context, setState) {
              var value = '';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AntVirtualInput(
                    value: value,
                    placeholder: '请输入内容',
                    clearable: true,
                    onChange: (v) => setState(() => value = v),
                  ),
                  _output(context, '值', value),
                ],
              );
            },
          ),
        ),
        (
          '虚拟输入框（QWERTY text 布局）',
          StatefulBuilder(
            builder: (context, setState) {
              var value = '';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AntVirtualInput(
                    value: value,
                    placeholder: '自定义布局输入',
                    keyboardLayout: AntKeyboardLayout.text(),
                    confirmText: '完成',
                    onChange: (v) => setState(() => value = v),
                  ),
                  _output(context, '值', value),
                ],
              );
            },
          ),
        ),
      ];
}

// ── 桌面形态（密度与 hover）────────────────────────────────
final List<_DemoCard> _desktopCards = [
  (
    'NumberKeyboard 桌面形态（desktop: true，紧凑密度 + hover）',
    const _NumberKeyboardDesktopPreview(),
  ),
  (
    'VirtualInput 桌面键盘（keyboardDesktop: true）',
    StatefulBuilder(
      builder: (context, setState) {
        var value = '';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AntVirtualInput(
              value: value,
              placeholder: '桌面键盘输入',
              keyboardDesktop: true,
              onChange: (v) => setState(() => value = v),
            ),
            _output(context, '值', value),
          ],
        );
      },
    ),
  ),
];

class _NumberKeyboardDesktopPreview extends StatefulWidget {
  const _NumberKeyboardDesktopPreview();

  @override
  State<_NumberKeyboardDesktopPreview> createState() =>
      _NumberKeyboardDesktopPreviewState();
}

class _NumberKeyboardDesktopPreviewState
    extends State<_NumberKeyboardDesktopPreview> {
  String _value = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntNumberKeyboard(
          value: _value,
          desktop: true,
          onChange: (v) => setState(() => _value = v),
        ),
        _output(context, '值', _value),
      ],
    );
  }
}
