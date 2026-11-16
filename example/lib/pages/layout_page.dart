library;

/// Layout 布局演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class LayoutPage extends StatelessWidget {
  const LayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基本结构', description: '顶栏 + 内容 + 底栏，自上而下排列'),
          _BasicDemo(),
          _Section(title: '侧边布局', description: 'Sider + Header + Content + Footer'),
          _SiderDemo(),
          _Section(title: '可折叠侧边栏', description: 'collapsible 开启折叠，默认触发器控制收起/展开'),
          _CollapsibleDemo(),
          _Section(title: '浅色侧边栏', description: 'theme: light 使用浅色主题'),
          _LightSiderDemo(),
          _Section(title: '自定义触发器', description: 'trigger 传入自定义 Widget，替换默认触发器'),
          _CustomTriggerDemo(),
          _Section(title: '自定义尺寸', description: 'width / collapsedWidth / header 自定义高度'),
          _CustomSizeDemo(),
          _Section(title: '响应式', description: 'breakpoint 在窗口宽度不足时自动折叠'),
          _ResponsiveDemo(),
          _Section(title: '组合场景', description: 'Sider + 自定义 Header + 默认折叠'),
          _ComboDemo(),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, this.description});

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(description!,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline)),
            ),
        ],
      ),
    );
  }
}

/// 演示用内容块
class _Block extends StatelessWidget {
  const _Block(this.label, {this.color, this.height = 60});

  final String label;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height,
      color: color ?? theme.colorScheme.primary.withValues(alpha: 0.12),
      alignment: Alignment.center,
      child: Text(label,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.primary)),
    );
  }
}

/// 基本结构：Header + Content + Footer
class _BasicDemo extends StatelessWidget {
  const _BasicDemo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: AntLayout(
        header: AntLayoutHeader(child: _Block('Header', height: 64)),
        content: AntLayoutContent(child: _Block('Content')),
        footer: AntLayoutFooter(child: _Block('Footer', height: 48)),
      ),
    );
  }
}

/// 侧边布局
class _SiderDemo extends StatelessWidget {
  const _SiderDemo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 280,
      child: AntLayout(
        sider: AntLayoutSider(
          child: _Block('Sider',
              color: theme.colorScheme.primary.withValues(alpha: 0.2)),
        ),
        header: AntLayoutHeader(child: _Block('Header', height: 64)),
        content: AntLayoutContent(child: _Block('Content')),
        footer: AntLayoutFooter(child: _Block('Footer', height: 48)),
      ),
    );
  }
}

/// 可折叠侧边栏
class _CollapsibleDemo extends StatefulWidget {
  const _CollapsibleDemo();

  @override
  State<_CollapsibleDemo> createState() => _CollapsibleDemoState();
}

class _CollapsibleDemoState extends State<_CollapsibleDemo> {
  bool _collapsed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 280,
      child: AntLayout(
        sider: AntLayoutSider(
          collapsed: _collapsed,
          onCollapse: (v) => setState(() => _collapsed = v),
          child: Center(
            child: Text(
              _collapsed ? 'S' : 'Sider',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
        header: AntLayoutHeader(child: _Block('Header', height: 64)),
        content: AntLayoutContent(child: _Block('Content')),
      ),
    );
  }
}

/// 浅色侧边栏
class _LightSiderDemo extends StatelessWidget {
  const _LightSiderDemo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 280,
      child: AntLayout(
        sider: AntLayoutSider(
          theme: AntLayoutSiderTheme.light,
          child: _Block('Sider',
              color: theme.colorScheme.primary.withValues(alpha: 0.08)),
        ),
        header: AntLayoutHeader(child: _Block('Header', height: 64)),
        content: AntLayoutContent(child: _Block('Content')),
      ),
    );
  }
}

/// 自定义触发器
class _CustomTriggerDemo extends StatefulWidget {
  const _CustomTriggerDemo();

  @override
  State<_CustomTriggerDemo> createState() => _CustomTriggerDemoState();
}

class _CustomTriggerDemoState extends State<_CustomTriggerDemo> {
  bool _collapsed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 280,
      child: AntLayout(
        sider: AntLayoutSider(
          collapsed: _collapsed,
          onCollapse: (v) => setState(() => _collapsed = v),
          trigger: Container(
            height: 48,
            color: theme.colorScheme.primary,
            alignment: Alignment.center,
            child: Icon(
              _collapsed ? Icons.menu : Icons.menu_open,
              color: Colors.white,
              size: 20,
            ),
          ),
          child: Center(
            child: Text(
              _collapsed ? 'S' : 'Sider',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
        header: AntLayoutHeader(child: _Block('Header', height: 64)),
        content: AntLayoutContent(child: _Block('Content')),
      ),
    );
  }
}

/// 自定义尺寸
class _CustomSizeDemo extends StatelessWidget {
  const _CustomSizeDemo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 280,
      child: AntLayout(
        sider: AntLayoutSider(
          width: 120,
          collapsedWidth: 60,
          child: _Block('120',
              color: theme.colorScheme.primary.withValues(alpha: 0.2)),
        ),
        header: AntLayoutHeader(
          height: 48,
          child: _Block('Header 48', height: 48),
        ),
        content: AntLayoutContent(child: _Block('Content')),
      ),
    );
  }
}

/// 响应式
class _ResponsiveDemo extends StatelessWidget {
  const _ResponsiveDemo();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('窗口宽度低于 992px 时侧边栏自动折叠',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.outline)),
        const SizedBox(height: 8),
        SizedBox(
          height: 240,
          child: AntLayout(
            sider: AntLayoutSider(
              breakpoint: 992,
              child: _Block('Sider',
                  color: theme.colorScheme.primary.withValues(alpha: 0.2)),
            ),
            header: AntLayoutHeader(child: _Block('Header', height: 64)),
            content: AntLayoutContent(child: _Block('Content')),
          ),
        ),
      ],
    );
  }
}

/// 组合场景
class _ComboDemo extends StatefulWidget {
  const _ComboDemo();

  @override
  State<_ComboDemo> createState() => _ComboDemoState();
}

class _ComboDemoState extends State<_ComboDemo> {
  bool _collapsed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 320,
      child: AntLayout(
        sider: AntLayoutSider(
          defaultCollapsed: true,
          collapsed: _collapsed,
          onCollapse: (v) => setState(() => _collapsed = v),
          width: 160,
          collapsedWidth: 64,
          child: Center(
            child: Text(
              _collapsed ? 'S' : 'Sider',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ),
        header: AntLayoutHeader(
          height: 48,
          child: AntFlex(
            align: AntFlexAlign.center,
            gap: const AntFlexGap.all(12),
            children: [
              Icon(Icons.dashboard_outlined,
                  size: 20, color: theme.colorScheme.primary),
              Text('Dashboard',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        content: AntLayoutContent(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AntFlex(
              vertical: true,
              gap: const AntFlexGap.all(16),
              children: [
                AntRow(
                  gutter: 16,
                  children: [
                    AntCol(span: 8, child: _Block('卡片一', height: 80)),
                    AntCol(span: 8, child: _Block('卡片二', height: 80)),
                    AntCol(span: 8, child: _Block('卡片三', height: 80)),
                  ],
                ),
                Expanded(child: _Block('主内容区')),
              ],
            ),
          ),
        ),
        footer: AntLayoutFooter(child: _Block('Footer', height: 48)),
      ),
    );
  }
}