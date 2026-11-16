library;

/// AntPopup 弹出层演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class PopupPage extends StatefulWidget {
  const PopupPage({super.key});

  @override
  State<PopupPage> createState() => _PopupPageState();
}

class _PopupPageState extends State<PopupPage> {
  bool _bottomVisible = false;
  bool _directionVisible = false;
  AntPopupPosition _direction = AntPopupPosition.bottom;
  bool _noMaskCloseVisible = false;
  String _lastEvent = '暂无';

  void _log(String event) {
    setState(() => _lastEvent = event);
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
            title: '底部弹出（默认）',
            theme: theme,
            child: AntButton(
              type: AntButtonType.primary,
              onTap: () => setState(() => _bottomVisible = true),
              child: const Text('底部弹出'),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '四方向弹出',
            theme: theme,
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: [
                for (final position in AntPopupPosition.values)
                  AntButton(
                    onTap: () => setState(() {
                      _direction = position;
                      _directionVisible = true;
                    }),
                    child: Text('从${_positionLabel(position)}弹出'),
                  ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '带关闭图标 + 遮罩配置',
            theme: theme,
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.w,
              children: [
                AntButton(
                  onTap: () {
                    AntPopup.show(
                  context,
                  position: AntPopupPosition.bottom,
                  showCloseIcon: true,
                  onClose: () => _log('关闭图标面板关闭'),
                  body: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('右上角有关闭图标'),
                  ),
                );
                  },
                  child: const Text('显示关闭图标'),
                ),
                AntButton(
                  onTap: () => setState(() => _noMaskCloseVisible = true),
                  child: const Text('遮罩不可关闭'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '内容滚动',
            theme: theme,
            child: AntButton(
              onTap: () {
                AntPopup.show(
                  context,
                  position: AntPopupPosition.bottom,
                  onClose: () => _log('滚动内容面板关闭'),
                  body: SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: 30,
                      itemBuilder: (context, index) =>
                          ListTile(title: Text('列表项 $index')),
                    ),
                  ),
                );
              },
              child: const Text('长列表滚动内容'),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '回调展示',
            theme: theme,
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: theme.colorFillQuaternary,
                borderRadius: BorderRadius.circular(theme.borderRadius.r),
              ),
              child: Text('最近事件：$_lastEvent',
                  style: TextStyle(fontSize: 14.sp, color: theme.colorText)),
            ),
          ),
          SizedBox(height: 32.w),

          // ---- 受控弹出层实例 ----
          AntPopup(
            visible: _bottomVisible,
            position: AntPopupPosition.bottom,
            showCloseIcon: true,
            onClose: () {
              _log('底部弹出层关闭');
              setState(() => _bottomVisible = false);
            },
            body: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('底部弹出内容', style: TextStyle(fontSize: 16.sp)),
                  SizedBox(height: 12.w),
                  AntButton(
                    onTap: () => setState(() => _bottomVisible = false),
                    child: const Text('关闭'),
                  ),
                ],
              ),
            ),
          ),
          AntPopup(
            visible: _directionVisible,
            position: _direction,
            onClose: () {
              _log('${_positionLabel(_direction)}弹出层关闭');
              setState(() => _directionVisible = false);
            },
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Text('${_positionLabel(_direction)}弹出内容',
                    style: TextStyle(fontSize: 16.sp)),
              ),
            ),
          ),
          AntPopup(
            visible: _noMaskCloseVisible,
            position: AntPopupPosition.bottom,
            maskClosable: false,
            showCloseIcon: true,
            onClose: () {
              _log('强制操作面板关闭');
              setState(() => _noMaskCloseVisible = false);
            },
            body: Padding(
              padding: EdgeInsets.all(16.w),
              child: Text('maskClosable = false，只能通过关闭图标关闭。',
                  style: TextStyle(fontSize: 14.sp)),
            ),
          ),
        ],
      ),
    );
  }

  String _positionLabel(AntPopupPosition position) {
    switch (position) {
      case AntPopupPosition.bottom:
        return '底部';
      case AntPopupPosition.top:
        return '顶部';
      case AntPopupPosition.left:
        return '左侧';
      case AntPopupPosition.right:
        return '右侧';
    }
  }
}

/// 区块容器。
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.theme, required this.child});

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
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorTextHeading,
          ),
        ),
        SizedBox(height: 8.w),
        child,
      ],
    );
  }
}
