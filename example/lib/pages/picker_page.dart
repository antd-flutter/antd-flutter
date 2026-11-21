import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// 自定义模型：滚轮列直接吃业务对象，无需构造字符串 label/value 项。
class _PickerOption {
  const _PickerOption(this.id, this.name);

  final String id;
  final String name;
}

const _seasons = <_PickerOption>[
  _PickerOption('spring', '春'),
  _PickerOption('summer', '夏'),
  _PickerOption('autumn', '秋'),
  _PickerOption('winter', '冬'),
];

const _weekdays = <_PickerOption>[
  _PickerOption('mon', '周一'),
  _PickerOption('tue', '周二'),
  _PickerOption('wed', '周三'),
  _PickerOption('thu', '周四'),
  _PickerOption('fri', '周五'),
];

const _times = <_PickerOption>[
  _PickerOption('am', '上午'),
  _PickerOption('pm', '下午'),
  _PickerOption('night', '晚上'),
];

AntPickerColumn<_PickerOption> _optionColumn(List<_PickerOption> options) {
  return AntPickerColumn<_PickerOption>(
    dataSource: options,
    keyOf: (option) => option.id,
    labelBuilder: (context, option) => Text(option.name),
  );
}

class PickerPage extends StatelessWidget {
  const PickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(t.s(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            child: AntPicker<_PickerOption>(
              columns: [_optionColumn(_seasons)],
              onConfirm: (options) => debugPrint(
                'onConfirm: ${options.map((o) => o.name).toList()}',
              ),
              onCancel: () => debugPrint('onCancel'),
              child: _trigger(t, '选择季节', _seasons[0]),
            ),
          ),
          SizedBox(height: t.s(16)),
          _Section(
            title: '带标题',
            child: AntPicker<_PickerOption>(
              columns: [_optionColumn(_seasons)],
              title: '请选择季节',
              onConfirm: (options) => debugPrint(
                'onConfirm: ${options.map((o) => o.name).toList()}',
              ),
              child: _trigger(t, '选择季节', null),
            ),
          ),
          SizedBox(height: t.s(16)),
          _Section(
            title: '多列选择',
            child: AntPicker<_PickerOption>(
              columns: [_optionColumn(_weekdays), _optionColumn(_times)],
              title: '选择时间',
              onConfirm: (options) => debugPrint(
                'onConfirm: ${options.map((o) => o.name).toList()}',
              ),
              child: _trigger(t, '选择日期时段', null),
            ),
          ),
          SizedBox(height: t.s(16)),
          _Section(
            title: '自定义按钮文本',
            child: AntPicker<_PickerOption>(
              columns: [_optionColumn(_seasons)],
              confirmText: 'OK',
              cancelText: 'Close',
              onConfirm: (options) => debugPrint(
                'onConfirm: ${options.map((o) => o.name).toList()}',
              ),
              child: _trigger(t, '选择季节', null),
            ),
          ),
          SizedBox(height: t.s(16)),
          _Section(
            title: '默认值（直接传模型 / key）',
            child: AntPicker<_PickerOption>(
              columns: [_optionColumn(_seasons)],
              defaultValue: [_seasons[2]],
              onConfirm: (options) => debugPrint(
                'onConfirm: ${options.map((o) => o.name).toList()}',
              ),
              child: _trigger(t, '选择季节', _seasons[2]),
            ),
          ),
          SizedBox(height: t.s(16)),
          _Section(title: '受控模式', child: const _ControlledPicker()),
          SizedBox(height: t.s(16)),
          _Section(
            title: '内嵌选择器（AntPickerView）',
            child: AntPickerView<_PickerOption>(
              columns: [_optionColumn(_seasons)],
              onChange: (options) => debugPrint(
                'onChange: ${options.map((o) => o.name).toList()}',
              ),
            ),
          ),
          SizedBox(height: t.s(16)),
          _Section(
            title: '内嵌多列选择器',
            child: AntPickerView<_PickerOption>(
              columns: [_optionColumn(_weekdays), _optionColumn(_times)],
              onChange: (options) => debugPrint(
                'onChange: ${options.map((o) => o.name).toList()}',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _trigger(AntThemeData t, String label, _PickerOption? value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: t.s(12), vertical: t.s(10)),
      decoration: BoxDecoration(
        color: t.colorFillSecondary,
        borderRadius: BorderRadius.circular(t.borderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: t.s(14), color: t.colorText),
          ),
          if (value != null)
            Text(
              value.name,
              style: TextStyle(fontSize: t.s(14), color: t.colorPrimary),
            )
          else
            Icon(
              AntIcons.rightOutlined,
              size: t.s(18),
              color: t.colorTextTertiary,
            ),
        ],
      ),
    );
  }
}

class _ControlledPicker extends StatefulWidget {
  const _ControlledPicker();

  @override
  State<_ControlledPicker> createState() => _ControlledPickerState();
}

class _ControlledPickerState extends State<_ControlledPicker> {
  List<_PickerOption> _value = [_seasons[0]];

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return AntPicker<_PickerOption>(
      columns: [_optionColumn(_seasons)],
      value: _value,
      onConfirm: (options) => setState(() => _value = options),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: t.s(12), vertical: t.s(10)),
        decoration: BoxDecoration(
          color: t.colorFillSecondary,
          borderRadius: BorderRadius.circular(t.borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '当前选择',
              style: TextStyle(fontSize: t.s(14), color: t.colorText),
            ),
            Text(
              _value.first.name,
              style: TextStyle(fontSize: t.s(14), color: t.colorPrimary),
            ),
          ],
        ),
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
