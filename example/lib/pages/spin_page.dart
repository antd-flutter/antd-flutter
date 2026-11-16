import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class SpinPage extends StatefulWidget {
  const SpinPage({super.key});

  @override
  State<SpinPage> createState() => _SpinPageState();
}

class _SpinPageState extends State<SpinPage> {
  bool _spinning = true;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            theme: theme,
            child: const Center(child: AntSpin()),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '三种尺寸',
            theme: theme,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                AntSpin(size: AntSpinSize.small),
                AntSpin(size: AntSpinSize.middle),
                AntSpin(size: AntSpinSize.large),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '带文案（tip）',
            theme: theme,
            child: Column(
              children: const [
                Center(child: AntSpin(tip: '加载中...')),
                SizedBox(height: 16),
                Center(
                  child: AntSpin(tip: '数据提交中', size: AntSpinSize.large),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '包裹模式（容器遮罩）',
            theme: theme,
            child: Column(
              children: [
                AntSpin(
                  spinning: _spinning,
                  tip: '加载中...',
                  child: Container(
                    height: 120,
                    alignment: Alignment.center,
                    child: Text(
                      '列表内容区域',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: theme.colorText,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.w),
                ElevatedButton(
                  onPressed: () => setState(() => _spinning = !_spinning),
                  child: Text(_spinning ? '停止加载' : '开始加载'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义指示器',
            theme: theme,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                AntSpin(
                  indicator: Icon(Icons.autorenew, size: 28),
                ),
                AntSpin(
                  indicator: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
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
