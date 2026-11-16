import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

class CollapsePage extends StatelessWidget {
  const CollapsePage({super.key});

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
            child: AntCollapse(
              items: const [
                AntCollapsePanel(
                  label: '面板一',
                  child: Text('面板一的内容，点击标题展开或收起。'),
                ),
                AntCollapsePanel(
                  label: '面板二',
                  child: Text('面板二的内容，点击标题展开或收起。'),
                ),
                AntCollapsePanel(
                  label: '面板三',
                  child: Text('面板三的内容，点击标题展开或收起。'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '手风琴',
            theme: theme,
            child: AntCollapse(
              accordion: true,
              items: const [
                AntCollapsePanel(label: '第一项', child: Text('同时只能展开一个面板。')),
                AntCollapsePanel(label: '第二项', child: Text('同时只能展开一个面板。')),
                AntCollapsePanel(label: '第三项', child: Text('同时只能展开一个面板。')),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '受控展开',
            theme: theme,
            child: _ControlledCollapse(),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '禁用面板',
            theme: theme,
            child: AntCollapse(
              defaultActiveKey: const ['panel_0'],
              items: const [
                AntCollapsePanel(label: '可展开', child: Text('正常面板。')),
                AntCollapsePanel(
                  label: '禁用面板',
                  disabled: true,
                  child: Text('禁用面板的内容不可展开。'),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '无边框',
            theme: theme,
            child: AntCollapse(
              bordered: false,
              size: AntCollapseSize.small,
              items: const [
                AntCollapsePanel(label: '无边框一', child: Text('无边框变体。')),
                AntCollapsePanel(label: '无边框二', child: Text('无边框变体。')),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: 'extra 与自定义图标',
            theme: theme,
            child: AntCollapse(
              expandIconPosition: AntCollapseExpandIconPosition.right,
              items: [
                AntCollapsePanel(
                  label: '带附加内容',
                  extra: Text('OK',
                      style: TextStyle(
                          fontSize: 14.sp, color: theme.colorSuccess)),
                  child: const Text('extra 展示在标题右侧。'),
                ),
                const AntCollapsePanel(
                  label: '自定义图标',
                  child: Text('自定义展开图标。'),
                ),
              ],
              expandIcon: (context, isExpanded) => Icon(
                isExpanded ? Icons.remove_circle : Icons.add_circle,
                size: 16.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlledCollapse extends StatefulWidget {
  @override
  State<_ControlledCollapse> createState() => _ControlledCollapseState();
}

class _ControlledCollapseState extends State<_ControlledCollapse> {
  final List<String> _activeKey = const ['panel_0'];

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '当前展开：${_activeKey.isEmpty ? "无" : _activeKey.join(", ")}',
          style: TextStyle(fontSize: 13.sp, color: theme.colorTextSecondary),
        ),
        SizedBox(height: 8.w),
        AntCollapse(
          activeKey: _activeKey,
          onChange: (_) {},
          items: const [
            AntCollapsePanel(label: '受控面板一', child: Text('受控模式内容。')),
            AntCollapsePanel(label: '受控面板二', child: Text('受控模式内容。')),
          ],
        ),
      ],
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
