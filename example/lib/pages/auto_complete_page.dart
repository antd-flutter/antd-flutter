import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

/// 业务模型：水果（id 回填、name 展示）。
class Fruit {
  const Fruit(this.id, this.name, {this.disabled = false});

  final String id;
  final String name;
  final bool disabled;
}

const _fruits = [
  Fruit('apple', 'Apple 苹果'),
  Fruit('banana', 'Banana 香蕉'),
  Fruit('cherry', 'Cherry 樱桃'),
  Fruit('grape', 'Grape 葡萄'),
  Fruit('lemon', 'Lemon 柠檬'),
  Fruit('orange', 'Orange 橙子'),
  Fruit('peach', 'Peach 桃子'),
  Fruit('pear', 'Pear 梨'),
];

/// 业务模型：国家（code 回填、name 展示）。
class Country {
  const Country(this.code, this.name);

  final String code;
  final String name;
}

const _countries = [
  Country('CN', '中国 China'),
  Country('US', '美国 United States'),
  Country('JP', '日本 Japan'),
  Country('KR', '韩国 Korea'),
];

class AutoCompletePage extends StatefulWidget {
  const AutoCompletePage({super.key});

  @override
  State<AutoCompletePage> createState() => _AutoCompletePageState();
}

class _AutoCompletePageState extends State<AutoCompletePage> {
  Fruit? _selectedFruit;
  String? _typed;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.s(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            description: '输入时自动补全匹配选项；onSelect 直接拿到模型对象。',
            child: SizedBox(
              width: theme.s(300),
              child: AntAutoComplete<Fruit>(
                options: _fruits,
                labelOf: (fruit) => fruit.name,
                placeholder: '请输入水果',
                onSelect: (fruit) {
                  setState(() => _selectedFruit = fruit);
                },
              ),
            ),
          ),
          if (_selectedFruit != null)
            _Section(
              title: '选中结果',
              description: 'onSelect 回传的就是你的业务模型。',
              child: Text(
                '已选中: ${_selectedFruit!.id} / ${_selectedFruit!.name}',
                style: TextStyle(fontSize: theme.s(14), color: Colors.blue),
              ),
            ),
          _Section(
            title: '自定义展示与回填',
            description: 'labelOf 决定下拉文案，valueOf 决定回填输入框的文本。',
            child: SizedBox(
              width: theme.s(300),
              child: AntAutoComplete<Country>(
                options: _countries,
                labelOf: (country) => country.name,
                valueOf: (country) => country.code,
                placeholder: '输入国家',
                onChange: (text) => setState(() => _typed = text),
              ),
            ),
          ),
          _Section(
            title: '当前输入',
            description: '文本值仍由 value/onChange 管理，与模型选择解耦。',
            child: Text(
              _typed == null || _typed!.isEmpty ? '（未输入）' : _typed!,
              style: TextStyle(fontSize: theme.s(14), color: Colors.grey),
            ),
          ),
          _Section(
            title: '禁用选项',
            description: 'disabledOf 命中的选项不可选中。',
            child: SizedBox(
              width: theme.s(300),
              child: AntAutoComplete<Fruit>(
                options: _fruits,
                labelOf: (fruit) => fruit.name,
                valueOf: (fruit) => fruit.id,
                disabledOf: (fruit) => fruit.id == 'orange',
                placeholder: '含禁用项（Orange 不可选）',
              ),
            ),
          ),
          _Section(
            title: '自定义选项行',
            description: 'itemBuilder 整行自定义渲染，点击/禁用逻辑仍由组件负责。',
            child: SizedBox(
              width: theme.s(300),
              child: AntAutoComplete<Fruit>(
                options: _fruits,
                labelOf: (fruit) => fruit.name,
                itemBuilder: (context, fruit, index) => Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.s(12),
                    vertical: theme.s(8),
                  ),
                  child: Row(
                    children: [
                      Icon(AntIcons.appleOutlined, size: theme.s(16)),
                      SizedBox(width: theme.s(8)),
                      Expanded(child: Text(fruit.name)),
                      Text(
                        fruit.id,
                        style: TextStyle(fontSize: theme.s(12), color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                placeholder: '自定义行',
              ),
            ),
          ),
          _Section(
            title: '三种尺寸',
            description: 'large / middle / small 三种尺寸。',
            child: Column(
              children: [
                SizedBox(
                  width: theme.s(300),
                  child: AntAutoComplete<Fruit>(
                    options: _fruits,
                    labelOf: (fruit) => fruit.name,
                    size: AntAutoCompleteSize.large,
                    placeholder: '大尺寸',
                  ),
                ),
                SizedBox(height: theme.s(12)),
                SizedBox(
                  width: theme.s(300),
                  child: AntAutoComplete<Fruit>(
                    options: _fruits,
                    labelOf: (fruit) => fruit.name,
                    size: AntAutoCompleteSize.middle,
                    placeholder: '中尺寸（默认）',
                  ),
                ),
                SizedBox(height: theme.s(12)),
                SizedBox(
                  width: theme.s(300),
                  child: AntAutoComplete<Fruit>(
                    options: _fruits,
                    labelOf: (fruit) => fruit.name,
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
              width: theme.s(300),
              child: AntAutoComplete<Fruit>(
                options: _fruits,
                labelOf: (fruit) => fruit.name,
                defaultValue: 'Apple 苹果',
                allowClear: true,
                placeholder: '可清除',
              ),
            ),
          ),
          _Section(
            title: '关闭过滤',
            description: 'filterOption=false 时输入不过滤选项，始终展示全部。',
            child: SizedBox(
              width: theme.s(300),
              child: AntAutoComplete<Fruit>(
                options: _fruits,
                labelOf: (fruit) => fruit.name,
                filterOption: false,
                placeholder: '不过滤',
              ),
            ),
          ),
          _Section(
            title: '禁用状态',
            description: 'disabled 禁用整个输入框。',
            child: SizedBox(
              width: theme.s(300),
              child: AntAutoComplete<Fruit>(
                options: _fruits,
                labelOf: (fruit) => fruit.name,
                disabled: true,
                defaultValue: 'Apple 苹果',
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
  const _Section({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: t.s(24)),
      padding: EdgeInsets.all(t.s(16)),
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
              fontSize: t.fontSizeLG,
              fontWeight: FontWeight.w600,
              color: t.colorText,
            ),
          ),
          SizedBox(height: t.s(4)),
          Text(
            description,
            style: TextStyle(
              fontSize: t.fontSizeSM,
              color: t.colorTextSecondary,
            ),
          ),
          SizedBox(height: t.s(12)),
          child,
        ],
      ),
    );
  }
}
