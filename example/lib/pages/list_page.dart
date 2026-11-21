import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

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
            theme: theme,
            child: SizedBox(
              height: theme.s(260),
              child: AntList<String>(
                items: const ['条目一', '条目二', '条目三'],
                keyOf: (item) => item,
                itemBuilder: (context, item, index) =>
                    AntListItem(content: AntText(text: item)),
              ),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '尺寸',
            theme: theme,
            child: Column(
              children: [
                SizedBox(
                  height: theme.s(180),
                  child: AntList<String>(
                    size: AntListSize.large,
                    header: const AntText(text: '大尺寸'),
                    items: const ['大尺寸条目一', '大尺寸条目二'],
                    keyOf: (item) => item,
                    itemBuilder: (context, item, index) =>
                        AntListItem(content: AntText(text: item)),
                  ),
                ),
                SizedBox(height: theme.s(12)),
                SizedBox(
                  height: theme.s(160),
                  child: AntList<String>(
                    size: AntListSize.small,
                    header: const AntText(text: '小尺寸'),
                    items: const ['小尺寸条目一', '小尺寸条目二'],
                    keyOf: (item) => item,
                    itemBuilder: (context, item, index) =>
                        AntListItem(content: AntText(text: item)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '边框与分割线',
            theme: theme,
            child: Column(
              children: [
                SizedBox(
                  height: theme.s(180),
                  child: AntList<String>(
                    bordered: true,
                    header: const AntText(text: '有边框'),
                    items: const ['条目一', '条目二'],
                    keyOf: (item) => item,
                    itemBuilder: (context, item, index) =>
                        AntListItem(content: AntText(text: item)),
                  ),
                ),
                SizedBox(height: theme.s(12)),
                SizedBox(
                  height: theme.s(160),
                  child: AntList<String>(
                    split: false,
                    items: const ['无分割线条目一', '无分割线条目二'],
                    keyOf: (item) => item,
                    itemBuilder: (context, item, index) =>
                        AntListItem(content: AntText(text: item)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: 'actions 与 extra',
            theme: theme,
            child: SizedBox(
              height: theme.s(200),
              child: AntList<String>(
                bordered: true,
                items: const ['文章标题一', '文章标题二'],
                keyOf: (item) => item,
                itemBuilder: (context, item, index) => AntListItem(
                  content: AntText(text: item),
                  extra: AntText(
                    text: '2026-01-01',
                    style: TextStyle(
                      fontSize: theme.s(12),
                      color: theme.colorTextSecondary,
                    ),
                  ),
                  actions: const [
                    AntListAction(child: AntText(text: '编辑')),
                    AntListAction(child: AntText(text: '删除')),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '空状态',
            theme: theme,
            child: SizedBox(
              height: theme.s(240),
              child: AntList<String>(
                bordered: true,
                items: const [],
                keyOf: (item) => item,
                itemBuilder: (context, item, index) =>
                    AntListItem(content: AntText(text: item)),
              ),
            ),
          ),
          SizedBox(height: theme.s(16)),
          _Section(
            title: '加载态与长列表分页',
            theme: theme,
            child: Column(
              children: [
                SizedBox(
                  height: theme.s(180),
                  child: AntList<String>(
                    loading: true,
                    items: const ['条目一'],
                    keyOf: (item) => item,
                    itemBuilder: (context, item, index) =>
                        AntListItem(content: AntText(text: item)),
                  ),
                ),
                SizedBox(height: theme.s(12)),
                SizedBox(
                  height: theme.s(300),
                  child: AntList<String>(
                    bordered: true,
                    pageSize: 5,
                    items: List.generate(20, (i) => '长列表条目${i + 1}'),
                    keyOf: (item) => item,
                    itemBuilder: (context, item, index) =>
                        AntListItem(content: AntText(text: item)),
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

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.theme,
    required this.child,
  });

  final String title;
  final AntThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(theme.s(16)),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: theme.colorSplit),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntText(
            text: title,
            style: TextStyle(
              fontSize: theme.s(16),
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          SizedBox(height: theme.s(12)),
          child,
        ],
      ),
    );
  }
}
