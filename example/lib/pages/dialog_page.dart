library;

/// AntDialog 对话框演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class DialogPage extends StatefulWidget {
  const DialogPage({super.key});

  @override
  State<DialogPage> createState() => _DialogPageState();
}

class _DialogPageState extends State<DialogPage> {
  bool _controlledVisible = false;
  String _lastResult = '暂无';

  void _showResult(String result) {
    setState(() => _lastResult = result);
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
            title: 'alert 单按钮（函数式）',
            theme: theme,
            child: AntButton(
              type: AntButtonType.primary,
              onTap: () async {
                final ok = await AntDialog.alert(
                  context,
                  title: '提示',
                  content: const AntText(text: '操作已提交成功。'),
                  okText: '知道了',
                );
                _showResult('alert 结果: $ok');
              },
              child: const AntText(text: '显示 alert 对话框'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: 'confirm 双按钮（函数式）',
            theme: theme,
            child: AntButton(
              type: AntButtonType.primary,
              onTap: () async {
                final ok = await AntDialog.confirm(
                  context,
                  title: '删除确认',
                  content: const AntText(text: '确定要删除这条记录吗？'),
                );
                _showResult('confirm 结果: $ok');
              },
              child: const AntText(text: '显示 confirm 对话框'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '自定义 actions 按钮区',
            theme: theme,
            child: AntButton(
              onTap: () {
                AntDialog.alert(
                  context,
                  title: '自定义按钮',
                  content: const AntText(text: '可自定义任意数量的操作按钮。'),
                  actions: [
                    AntDialogAction(text: '取消', onClick: () {}),
                    AntDialogAction(
                      text: '删除',
                      bold: true,
                      primary: true,
                      onClick: () => _showResult('已删除'),
                    ),
                  ],
                );
              },
              child: const AntText(text: '显示自定义 actions'),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '遮罩点击配置（受控 visible）',
            theme: theme,
            child: Wrap(
              spacing: theme.s(8),
              runSpacing: theme.s(8),
              children: [
                AntButton(
                  onTap: () => setState(() => _controlledVisible = true),
                  child: const AntText(text: '遮罩可关闭'),
                ),
                AntButton(
                  onTap: () {
                    AntDialog.alert(
                      context,
                      title: '强制操作',
                      content: const AntText(
                        text: 'closeOnMaskClick = false，必须点击按钮关闭。',
                      ),
                      closeOnMaskClick: false,
                    );
                  },
                  child: const AntText(text: '遮罩不可关闭'),
                ),
                AntDialog(
                  visible: _controlledVisible,
                  title: '受控对话框',
                  content: const AntText(text: 'visible 由宿主控制，点击遮罩或按钮均会关闭。'),
                  mode: AntDialogMode.confirm,
                  onClick: () => setState(() => _controlledVisible = false),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '回调结果展示',
            theme: theme,
            child: Container(
              padding: EdgeInsets.all(theme.s(12)),
              decoration: BoxDecoration(
                color: theme.colorFillQuaternary,
                borderRadius: BorderRadius.circular(theme.borderRadius),
              ),
              child: AntText(
                text: '最近结果：$_lastResult',
                style: TextStyle(fontSize: theme.s(14), color: theme.colorText),
              ),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '自定义内容',
            theme: theme,
            child: AntButton(
              onTap: () {
                AntDialog.alert(
                  context,
                  title: '更新日志',
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AntText(text: 'v2.0 新特性：'),
                      SizedBox(height: 4),
                      AntText(text: '· 全新移动端对话框'),
                      AntText(text: '· 四方向弹出层'),
                    ],
                  ),
                );
              },
              child: const AntText(text: '显示富内容对话框'),
            ),
          ),
        ],
      ),
    );
  }
}

/// 区块容器。
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
        AntText(
          text: title,
          style: TextStyle(
            fontSize: theme.s(15),
            fontWeight: FontWeight.w600,
            color: theme.colorTextHeading,
          ),
        ),
        SizedBox(height: theme.s(8)),
        child,
      ],
    );
  }
}
