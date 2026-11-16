import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

/// AntPopconfirm 演示页
class PopconfirmPage extends StatefulWidget {
  const PopconfirmPage({super.key});

  @override
  State<PopconfirmPage> createState() => _PopconfirmPageState();
}

class _PopconfirmPageState extends State<PopconfirmPage> {
  String _lastResult = '暂无操作';
  bool _controlledOpen = false;

  void _record(String result) {
    setState(() => _lastResult = result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return AntScreenUtilInit(
      builder: (context, _) => SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Section(
              title: '基础用法',
              theme: theme,
              child: AntPopconfirm(
                title: '删除这条记录吗？',
                onConfirm: () => _record('确认删除'),
                onCancel: () => _record('取消删除'),
                child: const AntButton(child: Text('Delete')),
              ),
            ),
            SizedBox(height: 16.w),
            _Section(
              title: '带描述',
              theme: theme,
              child: AntPopconfirm(
                title: '删除任务',
                description: '删除后任务及其子任务将一并移除，且不可恢复。',
                onConfirm: () => _record('确认删除任务'),
                onCancel: () => _record('取消删除任务'),
                child: const AntButton(child: Text('删除任务')),
              ),
            ),
            SizedBox(height: 16.w),
            _Section(
              title: '自定义按钮文案',
              theme: theme,
              child: AntPopconfirm(
                title: '发布这篇文章？',
                okText: '发布',
                cancelText: '再想想',
                onConfirm: () => _record('确认发布'),
                onCancel: () => _record('暂不发布'),
                child: const AntButton(type: AntButtonType.primary, child: Text('Publish')),
              ),
            ),
            SizedBox(height: 16.w),
            _Section(
              title: '九方向弹出位置',
              theme: theme,
              child: Wrap(
                spacing: 8.w,
                runSpacing: 8.w,
                children: [
                  _placementDemo(
                    '上左',
                    AntPopconfirmPlacement.topLeft,
                  ),
                  _placementDemo(
                    '上中',
                    AntPopconfirmPlacement.topCenter,
                  ),
                  _placementDemo(
                    '上右',
                    AntPopconfirmPlacement.topRight,
                  ),
                  _placementDemo(
                    '下左',
                    AntPopconfirmPlacement.bottomLeft,
                  ),
                  _placementDemo(
                    '下中',
                    AntPopconfirmPlacement.bottomCenter,
                  ),
                  _placementDemo(
                    '下右',
                    AntPopconfirmPlacement.bottomRight,
                  ),
                  _placementDemo(
                    '左中',
                    AntPopconfirmPlacement.leftCenter,
                  ),
                  _placementDemo(
                    '右中',
                    AntPopconfirmPlacement.rightCenter,
                  ),
                  _placementDemo(
                    '右下',
                    AntPopconfirmPlacement.rightBottom,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.w),
            _Section(
              title: '禁用',
              theme: theme,
              child: AntPopconfirm(
                title: '不会弹出的确认框',
                disabled: true,
                child: const AntButton(disabled: true, child: Text('Disabled')),
              ),
            ),
            SizedBox(height: 16.w),
            _Section(
              title: '受控模式 + 回调结果',
              theme: theme,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AntPopconfirm(
                    title: '受控确认框',
                    open: _controlledOpen,
                    onOpenChange: (open) => setState(() => _controlledOpen = open),
                    onConfirm: () => _record('受控确认'),
                    onCancel: () => _record('受控取消'),
                    child: AntButton(
                      onTap: () => setState(() => _controlledOpen = true),
                      child: const Text('受控打开'),
                    ),
                  ),
                  SizedBox(height: 12.w),
                  Text(
                    '最近操作：$_lastResult',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: theme.colorTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placementDemo(String label, AntPopconfirmPlacement placement) {
    return AntPopconfirm(
      title: '$label 确认',
      placement: placement,
      onConfirm: () => _record('$label 确认'),
      onCancel: () => _record('$label 取消'),
      child: AntButton(child: Text(label)),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
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
