import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// 业务模型：成员（name 展示、username 插入文本）。
class Member {
  const Member(this.id, this.name, this.username, {this.disabled = false});

  final String id;
  final String name;
  final String username;
  final bool disabled;
}

const _members = [
  Member('u1', '张三', 'afc163'),
  Member('u2', '李四', 'zombiej', disabled: true),
  Member('u3', '王五', 'yesmeck'),
  Member('u4', '陈帅', 'chenshuai'),
  Member('u5', '王浩', 'wanghao'),
];

/// 业务模型：话题（label 展示、value 插入）。
class Topic {
  const Topic(this.value, this.label);

  final String value;
  final String label;
}

const _topics = [
  Topic('flutter', 'Flutter'),
  Topic('dart', 'Dart'),
  Topic('antd', 'Ant Design'),
  Topic('mobile', 'Ant Design Mobile'),
];

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
            title: '基础用法（自定义模型）',
            child: AntMentions<Member>(
              options: _members,
              labelOf: (member) => member.name,
              valueOf: (member) => member.username,
              placeholder: '输入 @ 提及他人',
              onChange: (text) => debugPrint('mentions onChange: $text'),
              onSelect: (member) =>
                  debugPrint('mentions onSelect: ${member.id}'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '默认值',
            child: AntMentions<Member>(
              options: _members,
              labelOf: (member) => member.name,
              valueOf: (member) => member.username,
              defaultValue: '你好 @afc163 ',
              placeholder: '输入 @ 提及他人',
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '自定义前缀',
            child: AntMentions<Topic>(
              options: _topics,
              labelOf: (topic) => topic.label,
              valueOf: (topic) => topic.value,
              prefix: '#',
              placeholder: '输入 # 标记话题',
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '禁用选项',
            child: AntMentions<Member>(
              options: _members,
              labelOf: (member) => member.name,
              valueOf: (member) => member.username,
              disabledOf: (member) => member.disabled,
              placeholder: '输入 @ 提及他人（李四禁用）',
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '自定义选项行',
            child: AntMentions<Member>(
              options: _members,
              labelOf: (member) => member.name,
              valueOf: (member) => member.username,
              itemBuilder: (context, member, index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                child: Row(
                  children: [
                    Icon(AntIcons.userOutlined, size: 14.w),
                    SizedBox(width: 8.w),
                    Expanded(child: Text(member.name)),
                    Text(
                      '@${member.username}',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              placeholder: '自定义行',
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '三种尺寸',
            child: Column(
              children: [
                AntMentions<Member>(
                  options: _members,
                  labelOf: (member) => member.name,
                  valueOf: (member) => member.username,
                  size: AntMentionsSize.large,
                  placeholder: '大号 large',
                ),
                SizedBox(height: 8.h),
                AntMentions<Member>(
                  options: _members,
                  labelOf: (member) => member.name,
                  valueOf: (member) => member.username,
                  size: AntMentionsSize.middle,
                  placeholder: '中号 middle',
                ),
                SizedBox(height: 8.h),
                AntMentions<Member>(
                  options: _members,
                  labelOf: (member) => member.name,
                  valueOf: (member) => member.username,
                  size: AntMentionsSize.small,
                  placeholder: '小号 small',
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '允许清除',
            child: AntMentions<Member>(
              options: _members,
              labelOf: (member) => member.name,
              valueOf: (member) => member.username,
              defaultValue: '清除我试试',
              allowClear: true,
              placeholder: '输入 @ 提及他人',
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '禁用状态',
            child: AntMentions<Member>(
              options: _members,
              labelOf: (member) => member.name,
              valueOf: (member) => member.username,
              disabled: true,
              defaultValue: '禁用内容',
              placeholder: '禁用状态',
            ),
          ),
          SizedBox(height: 16.h),
          _Section(title: '受控用法', child: _ControlledMentions()),
        ],
      ),
    );
  }
}

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
        AntMentions<Member>(
          options: _members,
          labelOf: (member) => member.name,
          valueOf: (member) => member.username,
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
