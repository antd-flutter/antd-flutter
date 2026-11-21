library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  void _show(
    BuildContext context,
    String text, {
    AntMessageType type = AntMessageType.info,
    Duration? duration,
    bool closable = false,
    VoidCallback? onClose,
  }) {
    AntMessage.show(
      context,
      Text(text),
      type: type,
      duration: duration,
      closable: closable,
      onClose: onClose,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.s(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '四种类型',
            theme: theme,
            child: Wrap(
              spacing: theme.s(8),
              runSpacing: theme.s(8),
              children: [
                AntButton(
                  onTap: () => _show(context, '这是一条普通提示'),
                  child: const Text('Info'),
                ),
                AntButton(
                  onTap: () =>
                      _show(context, '这是一条成功提示', type: AntMessageType.success),
                  child: const Text('Success'),
                ),
                AntButton(
                  onTap: () =>
                      _show(context, '这是一条警告提示', type: AntMessageType.warning),
                  child: const Text('Warning'),
                ),
                AntButton(
                  onTap: () =>
                      _show(context, '这是一条错误提示', type: AntMessageType.error),
                  child: const Text('Error'),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '加载中',
            theme: theme,
            child: Wrap(
              spacing: theme.s(8),
              children: [
                AntButton(
                  onTap: () {
                    final handle = AntMessage.show(
                      context,
                      const Text('正在加载...'),
                      type: AntMessageType.loading,
                    );
                    Future<void>.delayed(
                      const Duration(seconds: 3),
                      handle.close,
                    );
                  },
                  child: const Text('Loading（3 秒后自动关闭）'),
                ),
                AntButton(
                  onTap: () => _show(
                    context,
                    '手动关闭的加载提示',
                    type: AntMessageType.loading,
                    closable: true,
                  ),
                  child: const Text('Loading（可手动关闭）'),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '时长配置',
            theme: theme,
            child: Wrap(
              spacing: theme.s(8),
              children: [
                AntButton(
                  onTap: () => _show(
                    context,
                    '5 秒后消失',
                    duration: const Duration(seconds: 5),
                  ),
                  child: const Text('5 秒'),
                ),
                AntButton(
                  onTap: () => _show(
                    context,
                    '1 秒后消失',
                    duration: const Duration(seconds: 1),
                  ),
                  child: const Text('1 秒'),
                ),
                AntButton(
                  onTap: () => _show(
                    context,
                    '永不消失，需手动关闭',
                    duration: Duration.zero,
                    closable: true,
                  ),
                  child: const Text('不自动消失'),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '多条叠加',
            theme: theme,
            child: AntButton(
              onTap: () {
                _show(context, '第 1 条提示', type: AntMessageType.info);
                _show(context, '第 2 条提示', type: AntMessageType.success);
                _show(context, '第 3 条提示', type: AntMessageType.warning);
              },
              child: const Text('连续弹出三条'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '回调',
            theme: theme,
            child: AntButton(
              onTap: () => _show(
                context,
                '关闭后弹出 SnackBar',
                onClose: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('提示已关闭')));
                },
              ),
              child: const Text('带 onClose 回调'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '可关闭',
            theme: theme,
            child: AntButton(
              onTap: () => _show(context, '右上角带关闭按钮', closable: true),
              child: const Text('显示关闭按钮'),
            ),
          ),
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
          SizedBox(height: theme.s(12)),
          child,
        ],
      ),
    );
  }
}
