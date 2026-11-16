library;

/// AntToast 轻提示演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class ToastPage extends StatelessWidget {
  const ToastPage({super.key});

  void _show(
    BuildContext context,
    String text, {
    Object? icon,
    Duration? duration,
    bool maskClickable = true,
    AntToastPosition position = AntToastPosition.center,
    VoidCallback? onClose,
  }) {
    AntToast.show(
      context,
      text,
      icon: icon,
      duration: duration,
      maskClickable: maskClickable,
      position: position,
      onClose: onClose,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '纯文字',
            theme: theme,
            child: AntButton(
              onTap: () => _show(context, '这是一条轻提示'),
              child: const Text('纯文字提示'),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '带图标',
            theme: theme,
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: [
                AntButton(
                  onTap: () => _show(
                    context,
                    '操作成功',
                    icon: AntToastIconType.success,
                  ),
                  child: const Text('Success'),
                ),
                AntButton(
                  onTap: () => _show(
                    context,
                    '操作失败',
                    icon: AntToastIconType.fail,
                  ),
                  child: const Text('Fail'),
                ),
                AntButton(
                  onTap: () => _show(
                    context,
                    '自定义图标',
                    icon: const Icon(Icons.favorite, color: Colors.pink),
                  ),
                  child: const Text('自定义图标'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: 'Loading 手动关闭',
            theme: theme,
            child: Wrap(
              spacing: 8.w,
              children: [
                AntButton(
                  onTap: () {
                    final handle = AntToast.show(
                      context,
                      '正在加载...',
                      icon: AntToastIconType.loading,
                    );
                    Future<void>.delayed(
                      const Duration(seconds: 3),
                      handle.close,
                    );
                  },
                  child: const Text('Loading（3 秒后关闭）'),
                ),
                AntButton(
                  onTap: () => _show(
                    context,
                    '5 秒后消失',
                    duration: const Duration(seconds: 5),
                  ),
                  child: const Text('5 秒自动消失'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '位置三档',
            theme: theme,
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: [
                AntButton(
                  onTap: () => _show(
                    context,
                    '顶部提示',
                    position: AntToastPosition.top,
                  ),
                  child: const Text('顶部'),
                ),
                AntButton(
                  onTap: () => _show(
                    context,
                    '中央提示',
                    position: AntToastPosition.center,
                  ),
                  child: const Text('中央'),
                ),
                AntButton(
                  onTap: () => _show(
                    context,
                    '底部提示',
                    position: AntToastPosition.bottom,
                  ),
                  child: const Text('底部'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '遮罩不可穿透',
            theme: theme,
            child: Wrap(
              spacing: 8.w,
              children: [
                AntButton(
                  onTap: () => _show(
                    context,
                    '点击遮罩可关闭（拦截下层）',
                    maskClickable: false,
                  ),
                  child: const Text('拦截遮罩'),
                ),
                AntButton(
                  onTap: () => _show(
                    context,
                    '关闭后弹出提示',
                    onClose: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('提示已关闭')),
                      );
                    },
                  ),
                  child: const Text('带 onClose 回调'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.theme, required this.child});

  final String title;
  final AntThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
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
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          SizedBox(height: 12.w),
          child,
        ],
      ),
    );
  }
}
