import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class ColorPickerPage extends StatelessWidget {
  const ColorPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            child: AntColorPicker(
              defaultValue: '#1677ff',
              onChange: (color) => debugPrint('onChange: $color'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '显示颜色文本',
            child: AntColorPicker(
              defaultValue: '#52c41a',
              showText: true,
              onChange: (color) => debugPrint('onChange: $color'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(title: '受控模式', child: _ControlledDemo()),
          SizedBox(height: 16.h),
          _Section(
            title: '预设颜色（自定义模型）',
            child: AntColorPicker<_Palette>(
              defaultValue: '#1677ff',
              presets: const [
                _Palette('推荐颜色', ['#1677ff', '#52c41a', '#faad14', '#f5222d']),
                _Palette('中性色', ['#000000', '#666666', '#999999', '#cccccc']),
              ],
              presetLabelOf: (palette) => palette.name,
              presetColorsOf: (palette) => palette.colors,
              showText: true,
              onChange: (color) => debugPrint('onChange: $color'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: 'RGB 格式',
            child: AntColorPicker(
              defaultValue: '#ff4d4f',
              format: AntColorFormat.rgb,
              showText: true,
              onChange: (color) => debugPrint('onChange: $color'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: 'HSL 格式',
            child: AntColorPicker(
              defaultValue: '#722ed1',
              format: AntColorFormat.hsl,
              showText: true,
              onChange: (color) => debugPrint('onChange: $color'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: 'HSB 格式',
            child: AntColorPicker(
              defaultValue: '#13c2c2',
              format: AntColorFormat.hsb,
              showText: true,
              onChange: (color) => debugPrint('onChange: $color'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '禁用透明度',
            child: AntColorPicker(
              defaultValue: '#1677ff',
              disabledAlpha: true,
              showText: true,
              onChange: (color) => debugPrint('onChange: $color'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '允许清空',
            child: AntColorPicker(
              defaultValue: '#1677ff',
              allowClear: true,
              showText: true,
              onChange: (color) => debugPrint('onChange: $color'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '三种尺寸',
            child: AntSpace(
              align: AntSpaceAlign.center,
              children: [
                AntColorPicker(
                  defaultValue: '#1677ff',
                  size: AntColorPickerSize.small,
                  showText: true,
                ),
                AntColorPicker(
                  defaultValue: '#1677ff',
                  size: AntColorPickerSize.middle,
                  showText: true,
                ),
                AntColorPicker(
                  defaultValue: '#1677ff',
                  size: AntColorPickerSize.large,
                  showText: true,
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '禁用状态',
            child: AntColorPicker(
              defaultValue: '#1677ff',
              disabled: true,
              showText: true,
            ),
          ),
        ],
      ),
    );
  }
}

/// 受控模式演示
class _ControlledDemo extends StatefulWidget {
  @override
  State<_ControlledDemo> createState() => _ControlledDemoState();
}

class _ControlledDemoState extends State<_ControlledDemo> {
  String? _color = '#1677ff';

  @override
  Widget build(BuildContext context) {
    return AntFlex(
      vertical: true,
      gap: AntFlexGap.all(12.w),
      children: [
        AntColorPicker(
          value: _color,
          showText: true,
          onChange: (color) => setState(() => _color = color),
        ),
        AntButton(
          size: AntButtonSize.small,
          onTap: () => setState(() => _color = '#52c41a'),
          child: const Text('设为绿色'),
        ),
      ],
    );
  }
}

/// 演示区块
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Container(
      padding: EdgeInsets.all(12.w),
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
              fontSize: theme.fontSizeLG,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}

/// 自定义模型：色板分组（业务里常带 id/主题等字段）。
class _Palette {
  const _Palette(this.name, this.colors);

  final String name;
  final List<String> colors;
}
