import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class AutoCompletePage extends StatefulWidget {
  const AutoCompletePage({super.key});

  @override
  State<AutoCompletePage> createState() => _AutoCompletePageState();
}

class _AutoCompletePageState extends State<AutoCompletePage> {
  String? _selectedValue;

  static const _fruits = [
    AntAutoCompleteOption(value: 'apple', label: 'Apple 苹果'),
    AntAutoCompleteOption(value: 'banana', label: 'Banana 香蕉'),
    AntAutoCompleteOption(value: 'cherry', label: 'Cherry 樱桃'),
    AntAutoCompleteOption(value: 'grape', label: 'Grape 葡萄'),
    AntAutoCompleteOption(value: 'lemon', label: 'Lemon 柠檬'),
    AntAutoCompleteOption(value: 'orange', label: 'Orange 橙子'),
    AntAutoCompleteOption(value: 'peach', label: 'Peach 桃子'),
    AntAutoCompleteOption(value: 'pear', label: 'Pear 梨'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            description: '输入时自动补全匹配选项。',
            child: SizedBox(
              width: 300.w,
              child: AntAutoComplete(
                options: _fruits,
                placeholder: '请输入水果',
                onSelect: (option) {
                  setState(() => _selectedValue = option.value);
                },
              ),
            ),
          ),
          if (_selectedValue != null)
            _Section(
              title: '选中结果',
              description: '最近选中的选项值。',
              child: Text(
                '已选中: $_selectedValue',
                style: TextStyle(fontSize: 14.sp, color: Colors.blue),
              ),
            ),
          _Section(
            title: '自定义选项',
            description: 'value 和 label 可以不同，选中后回填 value。',
            child: SizedBox(
              width: 300.w,
              child: const AntAutoComplete(
                options: [
                  AntAutoCompleteOption(value: 'CN', label: '中国 China'),
                  AntAutoCompleteOption(value: 'US', label: '美国 United States'),
                  AntAutoCompleteOption(value: 'JP', label: '日本 Japan'),
                  AntAutoCompleteOption(value: 'KR', label: '韩国 Korea'),
                ],
                placeholder: '输入国家',
              ),
            ),
          ),
          _Section(
            title: '禁用选项',
            description: '选项支持 disabled 属性，禁用后不可选。',
            child: SizedBox(
              width: 300.w,
              child: const AntAutoComplete(
                options: [
                  AntAutoCompleteOption(value: 'a', label: '可选选项 A'),
                  AntAutoCompleteOption(value: 'b', label: '禁用选项 B', disabled: true),
                  AntAutoCompleteOption(value: 'c', label: '可选选项 C'),
                ],
                placeholder: '含禁用项',
              ),
            ),
          ),
          _Section(
            title: '三种尺寸',
            description: 'large / middle / small 三种尺寸。',
            child: Column(
              children: [
                SizedBox(
                  width: 300.w,
                  child: AntAutoComplete(
                    options: _fruits,
                    size: AntAutoCompleteSize.large,
                    placeholder: '大尺寸',
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: 300.w,
                  child: AntAutoComplete(
                    options: _fruits,
                    size: AntAutoCompleteSize.middle,
                    placeholder: '中尺寸（默认）',
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: 300.w,
                  child: AntAutoComplete(
                    options: _fruits,
                    size: AntAutoCompleteSize.small,
                    placeholder: '小尺寸',
                  ),
                ),
              ],
            ),
          ),
          _Section(
            title: '允许清除',
            description: 'allowClear 开启后可一键清空输入。',
            child: SizedBox(
              width: 300.w,
              child: AntAutoComplete(
                options: _fruits,
                defaultValue: 'apple',
                allowClear: true,
                placeholder: '可清除',
              ),
            ),
          ),
          _Section(
            title: '关闭过滤',
            description: 'filterOption=false 时输入不过滤选项，始终展示全部。',
            child: SizedBox(
              width: 300.w,
              child: AntAutoComplete(
                options: _fruits,
                filterOption: false,
                placeholder: '不过滤',
              ),
            ),
          ),
          _Section(
            title: '禁用状态',
            description: 'disabled 禁用整个输入框。',
            child: SizedBox(
              width: 300.w,
              child: AntAutoComplete(
                options: _fruits,
                disabled: true,
                defaultValue: 'apple',
                placeholder: '禁用',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.description, required this.child});

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: t.colorBgContainer,
        borderRadius: BorderRadius.circular(t.borderRadiusLG),
        border: Border.all(color: t.colorSplit),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: t.fontSizeLG, fontWeight: FontWeight.w600, color: t.colorText)),
          SizedBox(height: 4.h),
          Text(description, style: TextStyle(fontSize: t.fontSizeSM, color: t.colorTextSecondary)),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}