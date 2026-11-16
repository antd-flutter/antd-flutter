import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

class MentionsPage extends StatelessWidget {
  const MentionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            child: AntMentions(
              options: _defaultOptions,
              placeholder: '输入 @ 提及他人',
              onChange: (text) => debugPrint('mentions onChange: $text'),
              onSelect: (opt) => debugPrint('mentions onSelect: ${opt.value}'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '默认值',
            child: AntMentions(
              options: _defaultOptions,
              defaultValue: '你好 @afc163 ',
              placeholder: '输入 @ 提及他人',
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '自定义前缀',
            child: AntMentions(
              options: _tagOptions,
              prefix: '#',
              placeholder: '输入 # 标记话题',
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '禁用选项',
            child: AntMentions(
              options: _disabledOptions,
              placeholder: '输入 @ 提及他人',
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '三种尺寸',
            child: Column(
              children: [
                AntMentions(
                  options: _defaultOptions,
                  size: AntMentionsSize.large,
                  placeholder: '大号 large',
                ),
                SizedBox(height: 8.h),
                AntMentions(
                  options: _defaultOptions,
                  size: AntMentionsSize.middle,
                  placeholder: '中号 middle',
                ),
                SizedBox(height: 8.h),
                AntMentions(
                  options: _defaultOptions,
                  size: AntMentionsSize.small,
                  placeholder: '小号 small',
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '允许清除',
            child: AntMentions(
              options: _defaultOptions,
              defaultValue: '清除我试试',
              allowClear: true,
              placeholder: '输入 @ 提及他人',
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '禁用状态',
            child: AntMentions(
              options: _defaultOptions,
              disabled: true,
              defaultValue: '禁用内容',
              placeholder: '禁用状态',
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '受控用法',
            child: _ControlledMentions(),
          ),
        ],
      ),
    );
  }
}

const _defaultOptions = <AntMentionsOption>[
  AntMentionsOption(value: 'afc163', label: 'afc163'),
  AntMentionsOption(value: 'zombiej', label: 'zombiej'),
  AntMentionsOption(value: 'yesmeck', label: 'yesmeck'),
  AntMentionsOption(value: 'chenshuai', label: 'chenshuai'),
  AntMentionsOption(value: 'wanghao', label: 'wanghao'),
];

const _tagOptions = <AntMentionsOption>[
  AntMentionsOption(value: 'flutter', label: 'Flutter'),
  AntMentionsOption(value: 'dart', label: 'Dart'),
  AntMentionsOption(value: 'antd', label: 'Ant Design'),
  AntMentionsOption(value: 'mobile', label: 'Ant Design Mobile'),
];

const _disabledOptions = <AntMentionsOption>[
  AntMentionsOption(value: 'afc163', label: 'afc163'),
  AntMentionsOption(value: 'zombiej', label: 'zombiej（禁用）', disabled: true),
  AntMentionsOption(value: 'yesmeck', label: 'yesmeck'),
];

class _ControlledMentions extends StatefulWidget {
  @override
  State<_ControlledMentions> createState() => _ControlledMentionsState();
}

class _ControlledMentionsState extends State<_ControlledMentions> {
  String _value = '受控内容';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AntMentions(
          options: _defaultOptions,
          value: _value,
          onChange: (text) => setState(() => _value = text),
          placeholder: '受控模式',
        ),
        SizedBox(height: 8.h),
        Text(
          '当前值：$_value',
          style: TextStyle(
            fontSize: 14.sp,
            color: AntTheme.of(context).colorTextSecondary,
          ),
        ),
      ],
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
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: t.colorBgContainer,
        borderRadius: BorderRadius.circular(t.borderRadiusLG.r),
        border: Border.all(color: t.colorSplit),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: t.colorText,
            ),
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}