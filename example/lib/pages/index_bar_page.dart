/// IndexBar 索引栏演示页
library;

import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class _IndexData {
  const _IndexData({required this.index, this.title, this.brief, this.child});

  final String index;
  final String? title;
  final String? brief;
  final Widget? child;
}

Widget _indexBar({
  Key? key,
  List<_IndexData> items = const [],
  bool sticky = true,
  ValueChanged<Object>? onChange,
}) {
  return AntIndexBar<_IndexData>(
    key: key,
    items: items,
    keyOf: (item) => item.index,
    titleBuilder: (context, item, index) => Text(item.title ?? item.index),
    briefBuilder: (context, item) =>
        item.brief == null ? null : Text(item.brief!),
    childBuilder: (context, item) => item.child,
    sticky: sticky,
    onChange: onChange,
  );
}

class IndexBarPage extends StatefulWidget {
  const IndexBarPage({super.key});

  @override
  State<IndexBarPage> createState() => _IndexBarPageState();
}

class _IndexBarPageState extends State<IndexBarPage> {
  String _current = 'A';

  static const _contacts = <String, List<String>>{
    'A': ['阿明', '安妮', '安琪'],
    'B': ['白露', '柏林', '北辰'],
    'C': ['陈晨', '程诺', '崔灿'],
    'D': ['戴维', '丁一', '杜若'],
    'F': ['方糖', '冯雪', '付饶'],
    'G': ['高远', '顾北', '关欣'],
    'H': ['韩梅', '何夕', '胡杨'],
    'J': ['江南', '蒋雯', '金果'],
    'L': ['李雷', '林深', '刘夏'],
    'M': ['马可', '孟然', '茉莉'],
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基本用法',
            description: '固定高度 + 右侧索引条，点击/拖动跳转，分组标题吸顶；当前索引：$_current',
          ),
          SizedBox(
            height: 420,
            child: _indexBar(
              items: [
                for (final entry in _contacts.entries)
                  _IndexData(
                    index: entry.key,
                    title: '${entry.key} · ${entry.value.length} 人',
                    child: Column(
                      children: [
                        for (var i = 0; i < entry.value.length; i++) ...[
                          _ContactRow(name: entry.value[i]),
                          if (i != entry.value.length - 1)
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: AntTheme.of(context).colorSplit,
                            ),
                        ],
                      ],
                    ),
                  ),
              ],
              onChange: (index) => setState(() => _current = index.toString()),
            ),
          ),
          _Section(title: '索引字幕', description: 'brief 可自定义右侧字母（如“热门”取首字“热”）'),
          SizedBox(
            height: 260,
            child: _indexBar(
              sticky: false,
              items: const [
                _IndexData(
                  index: 'hot',
                  title: '热门城市',
                  brief: '热',
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Text('北京 · 上海 · 广州 · 深圳 · 杭州'),
                  ),
                ),
                _IndexData(
                  index: 'near',
                  title: '附近城市',
                  brief: '近',
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    child: Text('苏州 · 南京 · 宁波 · 无锡 · 合肥'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorFillSecondary,
              shape: BoxShape.circle,
            ),
            child: Text(
              name.characters.first,
              style: TextStyle(fontSize: 13, color: theme.colorTextSecondary),
            ),
          ),
          const SizedBox(width: 12),
          Text(name, style: TextStyle(fontSize: 14, color: theme.colorText)),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, this.description});

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                description!,
                style: TextStyle(fontSize: 12, color: theme.colorTextTertiary),
              ),
            ),
        ],
      ),
    );
  }
}
