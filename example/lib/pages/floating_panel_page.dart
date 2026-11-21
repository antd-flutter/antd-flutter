import 'package:antd_flutter_plus/antd_flutter_plus.dart';
// 组件尚未加入 barrel export 前的临时直接引用；export 行合入后可移除。
import 'package:material_ui/material_ui.dart';

/// 每个演示区块内面板容器的固定高度。
const double _kDemoPanelHeight = 360;

class FloatingPanelPage extends StatefulWidget {
  const FloatingPanelPage({super.key});

  @override
  State<FloatingPanelPage> createState() => _FloatingPanelPageState();
}

class _FloatingPanelPageState extends State<FloatingPanelPage> {
  double _heightPercent = 0.6;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法（三锚点）',
            theme: theme,
            child: _buildPanel(
              theme,
              _buildList(20),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '自定义把手',
            theme: theme,
            child: _buildPanel(
              theme,
              _buildList(20),
              handle: Container(
                margin: EdgeInsets.symmetric(vertical: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(AntIcons.expandAltOutlined, size: 16.w, color: theme.colorTextQuaternary),
                    SizedBox(width: 4.w),
                    AntText(text: 
                      '拖动调整高度',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: theme.colorTextQuaternary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '两锚点',
            theme: theme,
            child: _buildPanel(
              theme,
              _buildList(20),
              anchors: const [0.4, 1],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '内容滚动列表',
            theme: theme,
            child: _buildPanel(
              theme,
              _buildList(50),
              contentHeight: 400,
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: 'onHeightChange 回调',
            theme: theme,
            child: Column(
              children: [
                AntText(text: 
                  '当前高度比例：${(_heightPercent * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: theme.colorText,
                  ),
                ),
                SizedBox(height: 8.w),
                _buildPanel(
                  theme,
                  _buildList(20),
                  onHeightChange: (p) => setState(() => _heightPercent = p),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 固定高度容器内演示浮动面板。
  Widget _buildPanel(
    AntThemeData theme,
    Widget child, {
    List<double>? anchors,
    Widget? handle,
    double? contentHeight,
    void Function(double)? onHeightChange,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(theme.borderRadiusLG),
      child: Container(
        height: _kDemoPanelHeight.w,
        decoration: BoxDecoration(
          color: theme.colorBgLayout,
          border: Border(top: BorderSide(color: theme.colorSplit)),
        ),
        child: AntFloatingPanel(
          anchors: anchors ?? const [0.6, 0.8, 1],
          handle: handle,
          contentHeight: contentHeight,
          onHeightChange: onHeightChange,
          child: child,
        ),
      ),
    );
  }

  Widget _buildList(int count) {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (_, int index) => ListTile(
        dense: true,
        leading: AntdIcon(AntIcons.fileTextOutlined, size: 18.w),
        title: AntText(text: '内容项 ${index + 1}'),
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
          AntText(text: 
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
