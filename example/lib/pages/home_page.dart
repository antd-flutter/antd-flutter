library;

/// 官网首页 — antd 风格：宽屏 Header + 常驻侧栏，窄屏 NavBar + 抽屉导航
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

import '../data/nav_data.dart';
import '../main.dart';
import 'component_page.dart';

/// 宽窄屏布局切换断点（逻辑像素宽，自原 isWide >= 840 逻辑迁移）。
const double kHomeWideBreakpoint = 840;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NavItem? _selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // AntResponsive 细粒度订阅：宽度 aspect + 设备类型 aspect，
    // desktop/web 断点常驻侧栏，移动窄屏走 NavBar + Drawer。
    final deviceType = AntResponsive.deviceTypeOf(context);
    final isWide =
        AntResponsive.widthOf(context) >= kHomeWideBreakpoint ||
        deviceType == AntDeviceType.desktop ||
        deviceType == AntDeviceType.web;
    final content = _selected == null
        ? _buildOverview(theme)
        : ComponentPage(snakeName: _selected!.snakeName);

    if (isWide) {
      return Scaffold(
        body: SafeArea(
          child: AntLayout(
          sider: AntLayoutSider(
            theme: AntLayoutSiderTheme.light,
            width: 260,
            child: _buildSidebarContent(theme),
          ),
          header: AntLayoutHeader(
            child: Row(
              children: [
                Expanded(
                  child: AntText(
                    text: _selected?.label ?? 'Ant Design v6 · Flutter 实现',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                const _DarkModeToggle(),
              ],
            ),
          ),
          content: AntLayoutContent(child: content),
        ),
        ),
      );
    }

    // 窄屏：抽屉导航模式，AntNavBar 左侧菜单按钮打开抽屉
    return Scaffold(
      drawer: Drawer(child: _buildSidebarContent(theme, closeOnTap: true)),
      body: SafeArea(
        child: Builder(
          builder: (scaffoldContext) => Column(
          children: [
            AntNavBar(
              back: false,
              left: AntButton(
                type: AntButtonType.text,
                shape: AntButtonShape.round,
                icon: const AntdIcon(AntIcons.menuOutlined),
                onTap: () => Scaffold.of(scaffoldContext).openDrawer(),
              ),
              right: const _DarkModeToggle(),
              child: AntText(text: _selected?.label ?? 'antd-flutter'),
            ),
            Expanded(child: AntLayoutContent(child: content)),
          ],
        ),
      ),
    );
  }

  /// 左侧导航栏内容 — 分组标题 + 组件列表
  /// [closeOnTap] 为 true 时点击项后自动关闭抽屉
  Widget _buildSidebarContent(ThemeData theme, {bool closeOnTap = false}) {
    return AntFlex(
      vertical: true,
      children: [
        // Logo 区
        Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          alignment: Alignment.centerLeft,
          child: AntFlex(
            gap: const AntFlexGap.all(10),
            children: [
              AntdIcon(
                AntIcons.appstoreOutlined,
                color: theme.colorScheme.primary,
                size: 28,
              ),
              Flexible(
                child: AntText(
                  child: Text(
                    'antd-flutter',
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        AntDivider(spacing: 1, color: theme.dividerColor),
        // 导航列表
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              for (final group in navGroups) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 16, 4),
                  child: AntText(
                    text: group.title,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                for (final item in group.items)
                  _buildNavItem(theme, item, closeOnTap: closeOnTap),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// 单个导航项
  Widget _buildNavItem(
    ThemeData theme,
    NavItem item, {
    bool closeOnTap = false,
  }) {
    final selected = _selected == item;
    return GestureDetector(
      onTap: () {
        setState(() => _selected = item);
        if (closeOnTap) Navigator.of(context).pop();
      },
      child: Container(
        color: selected
            ? theme.colorScheme.primaryContainer
            : Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: AntText(
            text: item.label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: selected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurface,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  /// 未选中组件时的总览页
  Widget _buildOverview(ThemeData theme) {
    final count = navGroups.fold<int>(0, (sum, g) => sum + g.items.length);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: AntSpace(
          direction: AntSpaceDirection.vertical,
          size: const AntSpaceSize.large(),
          children: [
            Icon(
              AntIcons.bgColorsOutlined,
              size: 72,
              color: theme.colorScheme.primary,
            ),
            AntSpace(
              direction: AntSpaceDirection.vertical,
              size: const AntSpaceSize.small(),
              children: [
                AntText(
                  text: 'antd-flutter',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AntText(
                  child: Text(
                    'Ant Design v6 设计规范的 Flutter 组件库',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ),
              ],
            ),
            AntText(
              text: '共 ${navGroups.length} 大分类 · $count 个组件规划中',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 暗黑模式切换（演示 AntSwitch + 全局主题联动）
class _DarkModeToggle extends StatelessWidget {
  const _DarkModeToggle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          themeModeController.value
              ? AntIcons.moonOutlined
              : AntIcons.sunOutlined,
          size: 18,
        ),
        const SizedBox(width: 8),
        AntSwitch(
          checked: themeModeController.value,
          onChange: (_) => themeModeController.toggle(),
        ),
      ],
    );
  }
}
