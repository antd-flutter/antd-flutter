import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// AntTooltip 组件 Demo 页
class TooltipPage extends StatelessWidget {
  const TooltipPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.s(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            description: '鼠标移入 / 点击触发元素时显示气泡提示，默认出现在上方。',
            theme: theme,
            child: Wrap(
              spacing: theme.s(24),
              runSpacing: theme.s(12),
              children: const [
                AntTooltip(tooltip: Text('提示文案'), child: Text('鼠标移上来')),
                AntTooltip(
                  tooltip: Text('下方提示'),
                  placement: AntTooltipPlacement.bottom,
                  child: Text('下方出现'),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '位置',
            description: '支持 top/bottom/left/right 及 8 个角落变体共 12 个方向。',
            theme: theme,
            child: Wrap(
              spacing: theme.s(16),
              runSpacing: theme.s(12),
              children: [
                for (final p in const [
                  AntTooltipPlacement.topLeft,
                  AntTooltipPlacement.top,
                  AntTooltipPlacement.topRight,
                  AntTooltipPlacement.bottomLeft,
                  AntTooltipPlacement.bottom,
                  AntTooltipPlacement.bottomRight,
                ])
                  AntTooltip(
                    key: ValueKey(p),
                    tooltip: Text(p.name),
                    placement: p,
                    child: Text(p.name),
                  ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '水平方向',
            description: '左侧 / 右侧弹出及上下对齐变体。',
            theme: theme,
            child: Wrap(
              spacing: theme.s(16),
              runSpacing: theme.s(12),
              children: [
                for (final p in const [
                  AntTooltipPlacement.left,
                  AntTooltipPlacement.leftTop,
                  AntTooltipPlacement.leftBottom,
                  AntTooltipPlacement.right,
                  AntTooltipPlacement.rightTop,
                  AntTooltipPlacement.rightBottom,
                ])
                  AntTooltip(
                    key: ValueKey(p),
                    tooltip: Text(p.name),
                    placement: p,
                    child: Text(p.name),
                  ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '箭头',
            description: 'arrow 控制是否显示指向箭头，默认显示。',
            theme: theme,
            child: Wrap(
              spacing: theme.s(24),
              runSpacing: theme.s(12),
              children: const [
                AntTooltip(
                  tooltip: Text('带箭头'),
                  arrow: true,
                  child: Text('带箭头'),
                ),
                AntTooltip(
                  tooltip: Text('无箭头'),
                  arrow: false,
                  child: Text('无箭头'),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '自定义颜色',
            description: 'color 自定义气泡背景色，文字颜色按明暗自动取反。',
            theme: theme,
            child: Wrap(
              spacing: theme.s(16),
              runSpacing: theme.s(12),
              children: const [
                AntTooltip(
                  tooltip: Text('紫色气泡'),
                  color: Colors.purple,
                  child: Text('紫色'),
                ),
                AntTooltip(
                  tooltip: Text('青色气泡'),
                  color: Colors.teal,
                  child: Text('青色'),
                ),
                AntTooltip(
                  tooltip: Text('黄色气泡'),
                  color: Colors.yellow,
                  child: Text('黄色'),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '受控模式',
            description: 'open 受控显示，配合 onOpenChange 响应状态变化。',
            theme: theme,
            child: const _ControlledTooltipDemo(),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: 'Controller 模式',
            description:
                'controller.show/hide/toggle 程序化控制，无需 GlobalKey 或外部 state。',
            theme: theme,
            child: const _ControllerTooltipDemo(),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '点击 / 长按触发',
            description: '移动端点击切换显示、长按打开；桌面端可显式指定 click 触发。',
            theme: theme,
            child: Wrap(
              spacing: theme.s(24),
              runSpacing: theme.s(12),
              children: const [
                AntTooltip(
                  trigger: AntTooltipTrigger.click,
                  tooltip: Text('点击切换显示'),
                  child: Text('点击触发'),
                ),
                AntTooltip(
                  trigger: AntTooltipTrigger.focus,
                  tooltip: Text('聚焦后显示'),
                  child: Text('焦点触发'),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
        ],
      ),
    );
  }
}

/// 受控模式示例。
class _ControlledTooltipDemo extends StatefulWidget {
  const _ControlledTooltipDemo();

  @override
  State<_ControlledTooltipDemo> createState() => _ControlledTooltipDemoState();
}

class _ControlledTooltipDemoState extends State<_ControlledTooltipDemo> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AntTooltip(
          open: _open,
          onOpenChange: (value) => setState(() => _open = value),
          tooltip: const Text('受控气泡'),
          child: const Text('受控触发'),
        ),
        SizedBox(width: theme.s(16)),
        AntButton(
          onTap: () => setState(() => _open = !_open),
          child: Text(
            _open ? '关闭气泡' : '打开气泡',
            style: TextStyle(fontSize: theme.s(13), color: theme.colorPrimary),
          ),
        ),
      ],
    );
  }
}

/// Controller 模式示例（R35.2）。
class _ControllerTooltipDemo extends StatefulWidget {
  const _ControllerTooltipDemo();

  @override
  State<_ControllerTooltipDemo> createState() => _ControllerTooltipDemoState();
}

class _ControllerTooltipDemoState extends State<_ControllerTooltipDemo> {
  final AntTooltipController _controller = AntTooltipController();

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AntTooltip(
          controller: _controller,
          tooltip: const Text('Controller 气泡'),
          child: const Text('Controller 触发'),
        ),
        SizedBox(width: theme.s(16)),
        AntButton(
          onTap: () => _controller.toggle(),
          child: const Text('toggle'),
        ),
        SizedBox(width: theme.s(12)),
        AntButton(onTap: () => _controller.show(), child: const Text('show')),
        SizedBox(width: theme.s(12)),
        AntButton(onTap: () => _controller.hide(), child: const Text('hide')),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.description,
    required this.theme,
    required this.child,
  });

  final String title;
  final String description;
  final AntThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
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
          Text(
            title,
            style: TextStyle(
              fontSize: theme.s(16),
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          SizedBox(height: theme.s(4)),
          Text(
            description,
            style: TextStyle(fontSize: theme.s(12), color: theme.colorTextSecondary),
          ),
          SizedBox(height: theme.s(12)),
          child,
        ],
      ),
    );
  }
}
