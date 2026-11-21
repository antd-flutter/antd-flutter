import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// 自定义模型：水果（带价格/禁用态的业务数据）。
class Fruit {
  const Fruit(this.id, this.name, this.price, {this.disabled = false});

  final String id;
  final String name;
  final String price;
  final bool disabled;
}

const _fruits = [
  Fruit('a', '苹果', '¥5/斤'),
  Fruit('b', '香蕉', '¥4/斤'),
  Fruit('c', '橙子', '¥6/斤（缺货）', disabled: true),
];

/// 自定义模型：场次（带时间段）。
class Session {
  const Session(this.id, this.name, this.time);

  final String id;
  final String name;
  final String time;
}

const _sessions = [
  Session('a', '上午场', '09:00 - 12:00'),
  Session('b', '下午场', '14:00 - 17:00'),
  Session('c', '晚间场', '19:00 - 22:00'),
];

class SelectorPage extends StatelessWidget {
  const SelectorPage({super.key});

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
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
            title: '基础用法（自定义模型）',
            child: AntSelector<Fruit>(
              options: _fruits,
              labelOf: (fruit) => fruit.name,
              onChange: (v) => _showSnackbar(
                context,
                '选中: ${v.map((fruit) => fruit.id).toList()}',
              ),
            ),
          ),
          SizedBox(height: theme.s(12)),
          _Section(
            title: '多选',
            child: AntSelector<String>(
              multiple: true,
              defaultValue: const ['b'],
              options: const ['a', 'b', 'c', 'd'],
              labelOf: (value) => _sportNames[value] ?? value,
              onChange: (v) => _showSnackbar(context, '选中: $v'),
            ),
          ),
          SizedBox(height: theme.s(12)),
          _Section(
            title: '带描述',
            child: AntSelector<Session>(
              options: _sessions,
              labelOf: (session) => session.name,
              descriptionOf: (session) => session.time,
            ),
          ),
          SizedBox(height: theme.s(12)),
          _Section(
            title: '两列布局',
            child: AntSelector<String>(
              columns: 2,
              options: const ['a', 'b', 'c'],
              labelOf: (value) => _optionNames[value] ?? value,
              onChange: (v) => _showSnackbar(context, '选中: $v'),
            ),
          ),
          SizedBox(height: theme.s(12)),
          _Section(
            title: '三列布局',
            child: AntSelector<String>(
              columns: 3,
              defaultValue: const ['b'],
              options: const ['a', 'b', 'c'],
              labelOf: (value) => _sizeNames[value] ?? value,
            ),
          ),
          SizedBox(height: theme.s(12)),
          _Section(
            title: '禁用',
            child: AntSelector<String>(
              options: const ['a', 'b', 'c'],
              labelOf: (value) => value == 'b' ? '禁用' : '可用',
              disabledOf: (value) => value == 'b',
            ),
          ),
          SizedBox(height: theme.s(12)),
          _Section(
            title: '自定义内容（itemBuilder）',
            child: AntSelector<Fruit>(
              columns: 2,
              options: _fruits,
              itemBuilder: (context, fruit, index) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    AntIcons.shoppingCartOutlined,
                    size: theme.s(18),
                    color: AntTheme.of(context).colorPrimary,
                  ),
                  SizedBox(height: theme.s(4)),
                  Text(fruit.name),
                  SizedBox(height: theme.s(2)),
                  Text(
                    fruit.price,
                    style: TextStyle(
                      fontSize: theme.s(12),
                      color: AntTheme.of(context).colorTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: theme.s(12)),
          const _ControlledDemo(),
        ],
      ),
    );
  }
}

const _sportNames = {'a': '足球', 'b': '篮球', 'c': '游泳', 'd': '跑步'};
const _optionNames = {'a': '选项一', 'b': '选项二', 'c': '选项三'};
const _sizeNames = {'a': '小', 'b': '中', 'c': '大'};

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
            padding: EdgeInsets.only(bottom: t.s(8)),
            child: Text(
              '当前值: $_value',
              style: TextStyle(
                fontSize: t.fontSizeSM,
                color: t.colorTextSecondary,
              ),
            ),
          ),
          AntSelector<String>(
            value: _value,
            multiple: true,
            options: const ['a', 'b', 'c'],
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
      padding: EdgeInsets.all(t.s(12)),
      decoration: BoxDecoration(
        color: t.colorBgContainer,
        borderRadius: BorderRadius.circular(t.borderRadiusLG),
        border: Border.all(color: t.colorSplit, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: t.s(8)),
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
