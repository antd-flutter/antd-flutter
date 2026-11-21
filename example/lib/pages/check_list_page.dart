import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// 自定义模型：支付方式（带描述的业务数据）。
class Payment {
  const Payment(this.id, this.name, this.description, {this.disabled = false});

  final String id;
  final String name;
  final String description;
  final bool disabled;
}

const _payments = [
  Payment('wechat', '微信支付', '推荐使用，安全便捷'),
  Payment('alipay', '支付宝', '余额支付，快捷方便'),
  Payment('card', '银行卡', '支持各大银行储蓄卡/信用卡', disabled: true),
];

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
              items: const ['a', 'b', 'c'],
              labelOf: (value) => _fruitNames[value] ?? value,
              onChange: (v) => _showSnackbar(context, '选中: $v'),
            ),
          ),
          SizedBox(height: 12.h),
          _Section(
            title: '多选',
            child: AntCheckList<String>(
              multiple: true,
              defaultValue: const ['a'],
              items: const ['a', 'b', 'c'],
              labelOf: (value) => _sportNames[value] ?? value,
              onChange: (v) => _showSnackbar(context, '选中: $v'),
            ),
          ),
          SizedBox(height: 12.h),
          _Section(
            title: '带描述（自定义模型）',
            child: AntCheckList<Payment>(
              items: _payments,
              labelOf: (payment) => payment.name,
              descriptionOf: (payment) => payment.description,
              disabledOf: (payment) => payment.disabled,
              onChange: (v) =>
                  _showSnackbar(context, '选中: ${v.map((p) => p.id)}'),
            ),
          ),
          SizedBox(height: 12.h),
          _Section(
            title: '带前缀',
            child: AntCheckList<String>(
              items: const ['apple', 'android'],
              labelOf: (value) => value == 'apple' ? '苹果' : '安卓',
              prefixBuilder: (context, value) => Icon(
                value == 'apple'
                    ? AntIcons.appleOutlined
                    : AntIcons.androidOutlined,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          _Section(
            title: '禁用',
            child: AntCheckList<String>(
              defaultValue: const ['a'],
              items: const ['a', 'b', 'c'],
              labelOf: (value) => _optionNames[value] ?? value,
              disabledOf: (value) => value == 'b',
            ),
          ),
          SizedBox(height: 12.h),
          _Section(
            title: '只读',
            child: AntCheckList<String>(
              readOnly: true,
              defaultValue: const ['b'],
              items: const ['a', 'b'],
              labelOf: (value) => _optionNames[value] ?? value,
            ),
          ),
          SizedBox(height: 12.h),
          _Section(
            title: '单项只读',
            child: AntCheckList<String>(
              defaultValue: const ['a'],
              items: const ['a', 'b'],
              labelOf: (value) => _optionNames[value] ?? value,
              readOnlyOf: (value) => value == 'b',
            ),
          ),
          SizedBox(height: 12.h),
          _Section(
            title: '隐藏勾选标记',
            child: AntCheckList<String>(
              showCheckMark: false,
              defaultValue: const ['a'],
              items: const ['a', 'b'],
              labelOf: (value) => _optionNames[value] ?? value,
              onChange: (v) => _showSnackbar(context, '选中: $v'),
            ),
          ),
          SizedBox(height: 12.h),
          const _ControlledDemo(),
          SizedBox(height: 12.h),
          _Section(
            title: '整行自定义（itemBuilder）',
            child: AntCheckList<Payment>(
              items: _payments,
              itemBuilder: (context, payment, index) => Row(
                children: [
                  Icon(
                    AntIcons.creditCardOutlined,
                    size: 18.w,
                    color: payment.disabled
                        ? AntTheme.of(context).colorTextDisabled
                        : AntTheme.of(context).colorPrimary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(payment.name),
                        Text(
                          payment.description,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AntTheme.of(context).colorTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const AntTag(child: '自定义'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const _fruitNames = {'a': '苹果', 'b': '香蕉', 'c': '橙子'};
const _sportNames = {'a': '足球', 'b': '篮球', 'c': '游泳'};
const _optionNames = {'a': '选项一', 'b': '选项二', 'c': '选项三'};

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
            items: const ['a', 'b', 'c'],
            labelOf: (value) => _optionNames[value] ?? value,
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
