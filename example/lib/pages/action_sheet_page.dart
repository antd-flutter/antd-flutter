import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// AntActionSheet 演示页
class ActionSheetPage extends StatefulWidget {
  const ActionSheetPage({super.key});

  @override
  State<ActionSheetPage> createState() => _ActionSheetPageState();
}

class _ActionSheetPageState extends State<ActionSheetPage> {
  /// 当前打开的面板场景（basic / danger / disabled / cancel / extra）。
  String? _activeSheet;

  String _callbackLog = '暂无操作记录';

  void _log(String msg) {
    setState(() => _callbackLog = msg);
  }

  void _open(String scene) => setState(() => _activeSheet = scene);

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    // 面板浮层由 AntActionSheet 内部通过 Overlay 渲染，
    // 这里通过受控 visible 驱动，随页面一起 build 即可。
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text('ActionSheet 动作面板')),
          body: ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              _Section(
                title: '基础用法',
                theme: theme,
                child: _DemoButton(
                  label: '打开动作面板',
                  onTap: () => _open('basic'),
                ),
              ),
              _Section(
                title: '危险操作',
                theme: theme,
                child: _DemoButton(
                  label: '打开含危险项的面板',
                  onTap: () => _open('danger'),
                ),
              ),
              _Section(
                title: '禁用项',
                theme: theme,
                child: _DemoButton(
                  label: '打开含禁用项的面板',
                  onTap: () => _open('disabled'),
                ),
              ),
              _Section(
                title: '带取消按钮',
                theme: theme,
                child: _DemoButton(
                  label: '打开带取消按钮的面板',
                  onTap: () => _open('cancel'),
                ),
              ),
              _Section(
                title: 'extraDescription 附加说明',
                theme: theme,
                child: _DemoButton(
                  label: '打开带附加说明的面板',
                  onTap: () => _open('extra'),
                ),
              ),
              _Section(
                title: '回调结果展示',
                theme: theme,
                child: Text(
                  _callbackLog,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: theme.colorTextSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        ..._sheets,
      ],
    );
  }

  /// 各场景面板。
  List<Widget> get _sheets => [
        AntActionSheet(
          visible: _activeSheet == 'basic',
          actions: [
            ActionSheetAction(text: '复制', onClick: (_) => _log('点击了：复制')),
            ActionSheetAction(text: '修改', onClick: (_) => _log('点击了：修改')),
          ],
          onClose: () => setState(() => _activeSheet = null),
        ),
        AntActionSheet(
          visible: _activeSheet == 'danger',
          actions: [
            const ActionSheetAction(text: '操作一'),
            ActionSheetAction(
              text: '删除',
              danger: true,
              onClick: (_) => _log('点击了危险操作：删除'),
            ),
          ],
          cancelText: '取消',
          onClose: () => setState(() => _activeSheet = null),
        ),
        AntActionSheet(
          visible: _activeSheet == 'disabled',
          actions: [
            ActionSheetAction(
              text: '可用操作',
              onClick: (_) => _log('点击了：可用操作'),
            ),
            const ActionSheetAction(
              text: '禁用操作',
              disabled: true,
              description: '该选项当前不可用',
            ),
          ],
          onClose: () => setState(() => _activeSheet = null),
        ),
        AntActionSheet(
          visible: _activeSheet == 'cancel',
          actions: [
            ActionSheetAction(text: '操作一', onClick: (_) => _log('点击了：操作一')),
            ActionSheetAction(text: '操作二', onClick: (_) => _log('点击了：操作二')),
          ],
          cancelText: '取消',
          closeOnAction: true,
          onClose: () => setState(() => _activeSheet = null),
        ),
        AntActionSheet(
          visible: _activeSheet == 'extra',
          extraDescription: '请选择要执行的操作，操作不可撤销',
          actions: [
            ActionSheetAction(
              text: '发布',
              description: '将内容发布到线上',
              onClick: (_) => _log('点击了：发布'),
            ),
            ActionSheetAction(
              text: '保存草稿',
              description: '内容将保存到草稿箱',
              onClick: (_) => _log('点击了：保存草稿'),
            ),
          ],
          cancelText: '取消',
          onClose: () => setState(() => _activeSheet = null),
        ),
      ];
}

class _DemoButton extends StatelessWidget {
  const _DemoButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.colorPrimaryBg,
          borderRadius: BorderRadius.circular(theme.borderRadius),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: theme.colorPrimary,
          ),
        ),
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
      margin: const EdgeInsets.only(bottom: 16),
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
