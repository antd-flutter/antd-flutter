import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class PopoverPage extends StatefulWidget {
  const PopoverPage({super.key});

  @override
  State<PopoverPage> createState() => _PopoverPageState();
}

class _PopoverPageState extends State<PopoverPage> {
  bool _controlledOpen = false;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    final textStyle = TextStyle(fontSize: 14.sp, color: theme.colorText);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            theme: theme,
            child: AntPopover(
              trigger: AntPopoverTrigger.click,
              title: const Text('标题'),
              content: const Text('这是一段气泡内容'),
              child: AntButton(child: const Text('点击显示气泡')),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '悬停触发',
            theme: theme,
            child: AntPopover(
              trigger: AntPopoverTrigger.hover,
              content: const Text('悬停触发的气泡内容'),
              child: AntButton(child: const Text('Hover me')),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '九个方向',
            theme: theme,
            child: Wrap(
              spacing: 12.w,
              runSpacing: 12.w,
              children: [
                AntPopover(
                  trigger: AntPopoverTrigger.click,
                  placement: AntPopoverPlacement.topLeft,
                  content: const Text('上左'),
                  child: AntButton(child: const Text('上左')),
                ),
                AntPopover(
                  trigger: AntPopoverTrigger.click,
                  placement: AntPopoverPlacement.topCenter,
                  content: const Text('上中'),
                  child: AntButton(child: const Text('上中')),
                ),
                AntPopover(
                  trigger: AntPopoverTrigger.click,
                  placement: AntPopoverPlacement.topRight,
                  content: const Text('上右'),
                  child: AntButton(child: const Text('上右')),
                ),
                AntPopover(
                  trigger: AntPopoverTrigger.click,
                  placement: AntPopoverPlacement.bottomLeft,
                  content: const Text('下左'),
                  child: AntButton(child: const Text('下左')),
                ),
                AntPopover(
                  trigger: AntPopoverTrigger.click,
                  placement: AntPopoverPlacement.bottomCenter,
                  content: const Text('下中'),
                  child: AntButton(child: const Text('下中')),
                ),
                AntPopover(
                  trigger: AntPopoverTrigger.click,
                  placement: AntPopoverPlacement.bottomRight,
                  content: const Text('下右'),
                  child: AntButton(child: const Text('下右')),
                ),
                AntPopover(
                  trigger: AntPopoverTrigger.click,
                  placement: AntPopoverPlacement.rightCenter,
                  content: const Text('右侧'),
                  child: AntButton(child: const Text('右侧')),
                ),
                AntPopover(
                  trigger: AntPopoverTrigger.click,
                  placement: AntPopoverPlacement.leftCenter,
                  content: const Text('左侧'),
                  child: AntButton(child: const Text('左侧')),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '箭头显示',
            theme: theme,
            child: AntPopover(
              trigger: AntPopoverTrigger.click,
              arrow: true,
              title: const Text('带箭头'),
              content: const Text('气泡带箭头指向触发元素'),
              child: AntButton(child: const Text('带箭头气泡')),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '受控显示',
            theme: theme,
            child: Row(
              children: [
                AntButton(
                  child: Text(_controlledOpen ? '关闭气泡' : '打开气泡'),
                  onTap: () => setState(() => _controlledOpen = !_controlledOpen),
                ),
                SizedBox(width: 12.w),
                AntPopover(
                  open: _controlledOpen,
                  onOpenChange: (open) => setState(() => _controlledOpen = open),
                  title: const Text('受控气泡'),
                  content: const Text('由外部状态控制显示与隐藏'),
                  child: const Text('受控触发元素'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: 'Controller 模式',
            theme: theme,
            child: _ControllerPopoverDemo(),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义背景色',
            theme: theme,
            child: Wrap(
              spacing: 12.w,
              children: [
                AntPopover(
                  trigger: AntPopoverTrigger.click,
                  color: theme.colorPrimary,
                  title: const Text('主题色'),
                  content: const Text('主色背景气泡'),
                  child: AntButton(child: const Text('主色')),
                ),
                AntPopover(
                  trigger: AntPopoverTrigger.click,
                  color: Colors.deepPurple,
                  title: const Text('自定义色'),
                  content: const Text('自定义背景气泡'),
                  child: AntButton(child: const Text('紫色')),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '复杂内容',
            theme: theme,
            child: AntPopover(
              trigger: AntPopoverTrigger.click,
              title: const Text('任务进度'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('设计阶段：已完成', style: textStyle),
                  SizedBox(height: 4.w),
                  Text('开发阶段：进行中', style: textStyle),
                  SizedBox(height: 4.w),
                  Text('测试阶段：未开始', style: textStyle),
                ],
              ),
              child: AntButton(child: const Text('查看详情')),
            ),
          ),
        ],
      ),
    );
  }
}

/// Controller 模式示例（R35.2）。
class _ControllerPopoverDemo extends StatefulWidget {
  @override
  State<_ControllerPopoverDemo> createState() => _ControllerPopoverDemoState();
}

class _ControllerPopoverDemoState extends State<_ControllerPopoverDemo> {
  final AntPopoverController _controller = AntPopoverController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AntPopover(
          controller: _controller,
          trigger: AntPopoverTrigger.click,
          title: const Text('Controller 气泡'),
          content: const Text('由 controller 程序化控制'),
          child: const Text('Controller 触发元素'),
        ),
        SizedBox(width: 12.w),
        AntButton(onTap: () => _controller.show(), child: const Text('show')),
        SizedBox(width: 12.w),
        AntButton(onTap: () => _controller.hide(), child: const Text('hide')),
      ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorText,
          ),
        ),
        SizedBox(height: 12.w),
        child,
      ],
    );
  }
}
