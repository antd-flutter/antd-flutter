import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

class CheckListPage extends StatelessWidget {
  const CheckListPage({super.key});

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            child: AntCheckList<String>(
              items: const [
                AntCheckListItem(value: 'a', child: Text('苹果')),
                AntCheckListItem(value: 'b', child: Text('香蕉')),
                AntCheckListItem(value: 'c', child: Text('橙子')),
              ],
              onChange: (v) => _showSnackbar(context, '选中: $v'),
            ),
          ),
          SizedBox(height: 12.h),
          _Section(
            title: '多选',
            child: AntCheckList<String>(
              multiple: true,
              defaultValue: ['a'],
              items: const [
                AntCheckListItem(value: 'a', child: Text('足球')),
                AntCheckListItem(value: 'b', child: Text('篮球')),
                AntCheckListItem(value: 'c', child: Text('游泳')),
              ],
              onChange: (v) => _showSnackbar(context, '选中: $v'),
            ),
          ),
          SizedBox(height: 12.h),
          _Section(
            title: '带描述',
            child: AntCheckList<String>(
              items: const [
                AntCheckListItem(
                  value: 'a',
                  child: Text('微信支付'),
                  description: Text('推荐使用，安全便捷'),
                ),
                AntCheckListItem(
                  value: 'b',
                  child: Text('支付宝'),
                  description: Text('余额支付，快捷方便'),
                ),
                AntCheckListItem(
                  value: 'c',
                  child: Text('银行卡'),
                  description: Text('支持各大银行储蓄卡/信用卡'),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          _Section(
            title: '带前缀',
            child: AntCheckList<String>(
              items: const [
                AntCheckListItem(
                  value: 'a',
                  child: Text('苹果'),
                  prefix: Icon(Icons.apple),
                ),
                AntCheckListItem(
                  value: 'b',
                  child: Text('安卓'),
                  prefix: Icon(Icons.android),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          _Section(
            title: '禁用',
            child: AntCheckList<String>(
              defaultValue: ['a'],
              items: const [
                AntCheckListItem(value: 'a', child: Text('可用选项')),
                AntCheckListItem(value: 'b', child: Text('禁用选项'), disabled: true),
                AntCheckListItem(value: 'c', child: Text('另一个可用选项')),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          _Section(
            title: '只读',
            child: AntCheckList<String>(
              readOnly: true,
              defaultValue: ['b'],
              items: const [
                AntCheckListItem(value: 'a', child: Text('选项一')),
                AntCheckListItem(value: 'b', child: Text('选项二')),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          _Section(
            title: '隐藏勾选标记',
            child: AntCheckList<String>(
              showCheckMark: false,
              defaultValue: ['a'],
              items: const [
                AntCheckListItem(value: 'a', child: Text('选项一')),
                AntCheckListItem(value: 'b', child: Text('选项二')),
              ],
              onChange: (v) => _showSnackbar(context, '选中: $v'),
            ),
          ),
          SizedBox(height: 12.h),
          const _ControlledDemo(),
        ],
      ),
    );
  }
}

class _ControlledDemo extends StatefulWidget {
  const _ControlledDemo();

  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  List<String> _value = ['a'];

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return _Section(
      title: '受控模式',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              '当前值: $_value',
              style: TextStyle(
                fontSize: t.fontSizeSM,
                color: t.colorTextSecondary,
              ),
            ),
          ),
          AntCheckList<String>(
            value: _value,
            multiple: true,
            items: const [
              AntCheckListItem(value: 'a', child: Text('选项一')),
              AntCheckListItem(value: 'b', child: Text('选项二')),
              AntCheckListItem(value: 'c', child: Text('选项三')),
            ],
            onChange: (v) => setState(() => _value = v),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: t.colorBgContainer,
        borderRadius: BorderRadius.circular(t.borderRadiusLG),
        border: Border.all(color: t.colorSplit, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              title,
              style: TextStyle(
                fontSize: t.fontSizeSM,
                fontWeight: FontWeight.w500,
                color: t.colorTextSecondary,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}