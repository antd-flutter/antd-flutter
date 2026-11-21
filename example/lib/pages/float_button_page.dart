library;

/// FloatButton 浮动按钮演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class FloatButtonPage extends StatefulWidget {
  const FloatButtonPage({super.key});

  @override
  State<FloatButtonPage> createState() => _FloatButtonPageState();
}

class _FloatButtonPageState extends State<FloatButtonPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _Section(title: '基本用法', description: '默认圆形悬浮按钮，点击触发 onClick'),
              _BasicDemo(),
              _Section(title: '类型', description: 'type: normal / primary'),
              _TypeDemo(),
              _Section(title: '形状', description: 'shape: circle / square'),
              _ShapeDemo(),
              _Section(title: '图标', description: '自定义 icon'),
              _IconDemo(),
              _Section(
                title: '角标',
                description: 'badge: count / dot / overflowCount',
              ),
              _BadgeDemo(),
              _Section(title: '禁用', description: 'disabled: true'),
              _DisabledDemo(),
              _Section(
                title: '按钮组 — 点击触发',
                description: 'trigger: click，点击展开/收起',
              ),
              _GroupClickDemo(),
              _Section(
                title: '按钮组 — 悬停触发',
                description: 'trigger: hover，悬停展开/移开收起',
              ),
              _GroupHoverDemo(),
              _Section(title: '按钮组 — 方形', description: 'shape: square，连体方形按钮'),
              _GroupSquareDemo(),
              _Section(
                title: '按钮组 — 方位',
                description: 'placement: top / bottom / left / right',
              ),
              _GroupPlacementDemo(),
              _Section(title: '回到顶部', description: '滚动超过 400px 后右下角出现回顶按钮'),
              _BackTopHint(),
              SizedBox(height: 600),
            ],
          ),
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: AntFloatButtonBackTop(
            scrollController: _scrollController,
            tooltip: '回到顶部',
          ),
        ),
      ],
    );
  }
}

void _showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: AntText(text: message),
      duration: const Duration(seconds: 1),
    ),
  );
}

// ============================================================
// 演示区块
// ============================================================

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
          AntText(
            text: title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: AntText(
                text: description!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BasicDemo extends StatelessWidget {
  const _BasicDemo();

  @override
  Widget build(BuildContext context) {
    return AntFloatButton(
      tooltip: '帮助',
      onClick: () => _showSnackbar(context, '点击了悬浮按钮'),
    );
  }
}

class _TypeDemo extends StatelessWidget {
  const _TypeDemo();

  @override
  Widget build(BuildContext context) {
    return AntFlex(
      wrap: true,
      gap: const AntFlexGap.only(column: 16),
      children: const [
        AntFloatButton(type: AntFloatButtonType.normal, tooltip: 'normal'),
        AntFloatButton(type: AntFloatButtonType.primary, tooltip: 'primary'),
      ],
    );
  }
}

class _ShapeDemo extends StatelessWidget {
  const _ShapeDemo();

  @override
  Widget build(BuildContext context) {
    return AntFlex(
      wrap: true,
      gap: const AntFlexGap.only(column: 16),
      children: const [
        AntFloatButton(shape: AntFloatButtonShape.circle, tooltip: 'circle'),
        AntFloatButton(shape: AntFloatButtonShape.square, tooltip: 'square'),
        AntFloatButton(
          shape: AntFloatButtonShape.square,
          type: AntFloatButtonType.primary,
          tooltip: 'primary square',
        ),
      ],
    );
  }
}

class _IconDemo extends StatelessWidget {
  const _IconDemo();

  @override
  Widget build(BuildContext context) {
    return AntFlex(
      wrap: true,
      gap: const AntFlexGap.only(column: 16),
      children: const [
        AntFloatButton(icon: Icon(AntIcons.questionOutlined), tooltip: '问题'),
        AntFloatButton(icon: Icon(AntIcons.moreOutlined), tooltip: '更多'),
        AntFloatButton(icon: Icon(AntIcons.closeOutlined), tooltip: '关闭'),
        AntFloatButton(
          icon: Icon(AntIcons.verticalAlignTopOutlined),
          tooltip: '顶部',
        ),
      ],
    );
  }
}

class _BadgeDemo extends StatelessWidget {
  const _BadgeDemo();

  @override
  Widget build(BuildContext context) {
    return AntFlex(
      wrap: true,
      gap: const AntFlexGap.only(column: 16),
      children: const [
        AntFloatButton(
          badge: AntFloatButtonBadge(count: 5),
          tooltip: 'count=5',
        ),
        AntFloatButton(
          badge: AntFloatButtonBadge(count: 200),
          tooltip: 'count=200',
        ),
        AntFloatButton(badge: AntFloatButtonBadge(dot: true), tooltip: 'dot'),
        AntFloatButton(
          badge: AntFloatButtonBadge(count: 0),
          tooltip: 'count=0 不显示',
        ),
      ],
    );
  }
}

class _DisabledDemo extends StatelessWidget {
  const _DisabledDemo();

  @override
  Widget build(BuildContext context) {
    return AntFlex(
      wrap: true,
      gap: const AntFlexGap.only(column: 16),
      children: const [
        AntFloatButton(disabled: true, tooltip: '禁用'),
        AntFloatButton(
          disabled: true,
          type: AntFloatButtonType.primary,
          tooltip: '禁用',
        ),
      ],
    );
  }
}

class _GroupClickDemo extends StatelessWidget {
  const _GroupClickDemo();

  @override
  Widget build(BuildContext context) {
    return AntFloatButtonGroup(
      trigger: AntFloatButtonGroupTrigger.click,
      children: [
        AntFloatButton(
          icon: const Icon(AntIcons.fileTextOutlined),
          tooltip: '文档',
          onClick: () => _showSnackbar(context, '文档'),
        ),
        AntFloatButton(
          icon: const Icon(AntIcons.questionOutlined),
          tooltip: '帮助',
          onClick: () => _showSnackbar(context, '帮助'),
        ),
      ],
    );
  }
}

class _GroupHoverDemo extends StatelessWidget {
  const _GroupHoverDemo();

  @override
  Widget build(BuildContext context) {
    return AntFloatButtonGroup(
      trigger: AntFloatButtonGroupTrigger.hover,
      children: [
        AntFloatButton(
          icon: const Icon(AntIcons.fileTextOutlined),
          tooltip: '文档',
          onClick: () => _showSnackbar(context, '文档'),
        ),
        AntFloatButton(
          icon: const Icon(AntIcons.questionOutlined),
          tooltip: '帮助',
          onClick: () => _showSnackbar(context, '帮助'),
        ),
      ],
    );
  }
}

class _GroupSquareDemo extends StatelessWidget {
  const _GroupSquareDemo();

  @override
  Widget build(BuildContext context) {
    return AntFloatButtonGroup(
      shape: AntFloatButtonShape.square,
      children: [
        AntFloatButton(
          icon: const Icon(AntIcons.fileTextOutlined),
          tooltip: '文档',
          onClick: () => _showSnackbar(context, '文档'),
        ),
        AntFloatButton(
          icon: const Icon(AntIcons.questionOutlined),
          tooltip: '帮助',
          onClick: () => _showSnackbar(context, '帮助'),
        ),
      ],
    );
  }
}

class _GroupPlacementDemo extends StatelessWidget {
  const _GroupPlacementDemo();

  @override
  Widget build(BuildContext context) {
    return AntFlex(
      wrap: true,
      gap: const AntFlexGap.all(32),
      children: [
        AntFloatButtonGroup(
          placement: AntFloatButtonGroupPlacement.top,
          children: [
            AntFloatButton(
              icon: const Icon(AntIcons.fileTextOutlined),
              tooltip: 'top',
            ),
          ],
        ),
        AntFloatButtonGroup(
          placement: AntFloatButtonGroupPlacement.bottom,
          children: [
            AntFloatButton(
              icon: const Icon(AntIcons.fileTextOutlined),
              tooltip: 'bottom',
            ),
          ],
        ),
        AntFloatButtonGroup(
          placement: AntFloatButtonGroupPlacement.left,
          children: [
            AntFloatButton(
              icon: const Icon(AntIcons.fileTextOutlined),
              tooltip: 'left',
            ),
          ],
        ),
        AntFloatButtonGroup(
          placement: AntFloatButtonGroupPlacement.right,
          children: [
            AntFloatButton(
              icon: const Icon(AntIcons.fileTextOutlined),
              tooltip: 'right',
            ),
          ],
        ),
      ],
    );
  }
}

class _BackTopHint extends StatelessWidget {
  const _BackTopHint();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: AntText(
        text: '向下滚动本页面，右下角将出现回到顶部按钮',
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
