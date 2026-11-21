import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// 自定义模型：内嵌滚轮列直接使用业务对象。
class _NamedOption {
  const _NamedOption(this.id, this.name);

  final String id;
  final String name;
}

const _fruits = <_NamedOption>[
  _NamedOption('apple', '苹果'),
  _NamedOption('banana', '香蕉'),
  _NamedOption('orange', '橙子'),
  _NamedOption('grape', '葡萄'),
];

const _drinks = <_NamedOption>[
  _NamedOption('tea', '茶'),
  _NamedOption('coffee', '咖啡'),
  _NamedOption('juice', '果汁'),
];

AntPickerColumn<_NamedOption> _optionColumn(List<_NamedOption> options) {
  return AntPickerColumn<_NamedOption>(
    dataSource: options,
    keyOf: (option) => option.id,
    labelBuilder: (context, option) => Text(option.name),
  );
}

/// PickerViewPage — AntPickerView 内嵌滚轮选择器演示页。
class PickerViewPage extends StatefulWidget {
  const PickerViewPage({super.key});

  @override
  State<PickerViewPage> createState() => _PickerViewPageState();
}

class _PickerViewPageState extends State<PickerViewPage> {
  List<_NamedOption> _value = [_fruits[1], _drinks[0]];

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(t.s(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础多列选择',
            child: AntPickerView<_NamedOption>(
              columns: [_optionColumn(_fruits), _optionColumn(_drinks)],
              onChange: (options) => debugPrint(
                'onChange: ${options.map((o) => o.name).toList()}',
              ),
            ),
          ),
          SizedBox(height: t.s(16)),
          _Section(
            title: '受控 value（onChange 同步外部状态）',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AntPickerView<_NamedOption>(
                  columns: [_optionColumn(_fruits), _optionColumn(_drinks)],
                  value: _value,
                  onChange: (options) => setState(() => _value = options),
                ),
                SizedBox(height: t.s(8)),
                Text(
                  '当前选择：${_value.map((o) => o.name).join(' / ')}',
                  style: TextStyle(fontSize: t.s(14), color: t.colorPrimary),
                ),
              ],
            ),
          ),
          SizedBox(height: t.s(16)),
          _Section(
            title: '禁用交互（IgnorePointer 包裹）',
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.6,
                child: AntPickerView<_NamedOption>(
                  columns: [_optionColumn(_fruits)],
                  defaultValue: [_fruits[2]],
                  onChange: (options) => debugPrint('不应触发: $options'),
                ),
              ),
            ),
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
        border: Border.all(color: t.colorSplit),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: t.s(14),
              fontWeight: FontWeight.w600,
              color: t.colorText,
            ),
          ),
          SizedBox(height: t.s(12)),
          child,
        ],
      ),
    );
  }
}
