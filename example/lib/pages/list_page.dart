import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            theme: theme,
            child: SizedBox(
              height: 260.w,
              child: AntList<String>(
                dataSource: const ['条目一', '条目二', '条目三'],
                itemKey: (item, _) => item,
                renderItem: (item, _) => AntListItem(content: AntText(text: item)),
              ),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '尺寸',
            theme: theme,
            child: Column(
              children: [
                SizedBox(
                  height: 180.w,
                  child: AntList<String>(
                    size: AntListSize.large,
                    header: const AntText(text: '大尺寸'),
                    dataSource: const ['大尺寸条目一', '大尺寸条目二'],
                    itemKey: (item, _) => item,
                    renderItem: (item, _) => AntListItem(content: AntText(text: item)),
                  ),
                ),
                SizedBox(height: 12.w),
                SizedBox(
                  height: 160.w,
                  child: AntList<String>(
                    size: AntListSize.small,
                    header: const AntText(text: '小尺寸'),
                    dataSource: const ['小尺寸条目一', '小尺寸条目二'],
                    itemKey: (item, _) => item,
                    renderItem: (item, _) => AntListItem(content: AntText(text: item)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '边框与分割线',
            theme: theme,
            child: Column(
              children: [
                SizedBox(
                  height: 180.w,
                  child: AntList<String>(
                    bordered: true,
                    header: const AntText(text: '有边框'),
                    dataSource: const ['条目一', '条目二'],
                    itemKey: (item, _) => item,
                    renderItem: (item, _) => AntListItem(content: AntText(text: item)),
                  ),
                ),
                SizedBox(height: 12.w),
                SizedBox(
                  height: 160.w,
                  child: AntList<String>(
                    split: false,
                    dataSource: const ['无分割线条目一', '无分割线条目二'],
                    itemKey: (item, _) => item,
                    renderItem: (item, _) => AntListItem(content: AntText(text: item)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: 'actions 与 extra',
            theme: theme,
            child: SizedBox(
              height: 200.w,
              child: AntList<String>(
                bordered: true,
                dataSource: const ['文章标题一', '文章标题二'],
                itemKey: (item, _) => item,
                renderItem: (item, _) => AntListItem(
                  content: AntText(text: item),
                  extra: AntText(text: '2026-01-01',
                      style: TextStyle(
                          fontSize: 12.sp, color: theme.colorTextSecondary)),
                  actions: const [
                    AntListAction(child: AntText(text: '编辑')),
                    AntListAction(child: AntText(text: '删除')),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '空状态',
            theme: theme,
            child: SizedBox(
              height: 240.w,
              child: AntList<String>(
                bordered: true,
                dataSource: const [],
                itemKey: (item, _) => item,
                renderItem: (item, _) => AntListItem(content: AntText(text: item)),
              ),
            ),
          ),
          SizedBox(height: 16.w),
          _Section(
            title: '加载态与长列表分页',
            theme: theme,
            child: Column(
              children: [
                SizedBox(
                  height: 180.w,
                  child: AntList<String>(
                    loading: true,
                    dataSource: const ['条目一'],
                    itemKey: (item, _) => item,
                    renderItem: (item, _) => AntListItem(content: AntText(text: item)),
                  ),
                ),
                SizedBox(height: 12.w),
                SizedBox(
                  height: 300.w,
                  child: AntList<String>(
                    bordered: true,
                    pageSize: 5,
                    dataSource: List.generate(20, (i) => '长列表条目${i + 1}'),
                    itemKey: (item, _) => item,
                    renderItem: (item, _) => AntListItem(content: AntText(text: item)),
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
  const _Section({required this.title, required this.theme, required this.child});

  final String title;
  final AntThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorBgContainer,
        borderRadius: BorderRadius.circular(theme.borderRadiusLG),
        border: Border.all(color: theme.colorSplit),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntText(text: 
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorText,
            ),
          ),
          SizedBox(height: 12.w),
          child,
        ],
      ),
    );
  }
}
