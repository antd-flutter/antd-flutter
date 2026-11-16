library;

/// Typography 排版演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class TypographyPage extends StatelessWidget {
  const TypographyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '标题 Title', description: 'AntTitle level: h1 ~ h5'),
          _TitleDemo(),
          _Section(title: '文本与段落', description: 'AntText / AntParagraph'),
          _TextParagraphDemo(),
          _Section(title: '文本类型', description: 'type: secondary / success / warning / danger'),
          _TypeDemo(),
          _Section(title: '禁用', description: 'disabled: true'),
          _DisabledDemo(),
          _Section(title: '修饰', description: 'strong / italic / underline / delete / code / mark / keyboard'),
          _DecorationDemo(),
          _Section(title: '链接 Link', description: 'AntLink — colorLink + 下划线 + hover 变色'),
          _LinkDemo(),
          _Section(title: '可复制', description: 'copyable: true — 点击复制图标写入剪贴板'),
          _CopyableDemo(),
          _Section(title: '可编辑', description: 'editable: true — 点击编辑图标进入行内编辑'),
          _EditableDemo(),
          _Section(title: '省略', description: 'ellipsis: rows / expandable / tooltip'),
          _EllipsisDemo(),
          _Section(title: '组合示例', description: '标题 + 段落 + 链接的典型文章布局'),
          _CompositionDemo(),
        ],
      ),
    );
  }
}

/// 演示区块标题
class _Section extends StatelessWidget {
  const _Section({required this.title, this.description});

  final String title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(description!,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
            ),
        ],
      ),
    );
  }
}

class _TitleDemo extends StatelessWidget {
  const _TitleDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntTitle('h1. Ant Design', level: AntTitleLevel.h1),
        AntTitle('h2. Ant Design', level: AntTitleLevel.h2),
        AntTitle('h3. Ant Design', level: AntTitleLevel.h3),
        AntTitle('h4. Ant Design', level: AntTitleLevel.h4),
        AntTitle('h5. Ant Design', level: AntTitleLevel.h5),
      ],
    );
  }
}

class _TextParagraphDemo extends StatelessWidget {
  const _TextParagraphDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntText(text: 'Ant Design (text)'),
        SizedBox(height: 8),
        AntParagraph(
          text: 'Ant Design 是一个致力于提升用户和设计师体验的设计体系。'
              '通过统一的规范，降低用户与系统之间的沟通成本，'
              '提供高效、愉悦的使用体验。',
        ),
      ],
    );
  }
}

class _TypeDemo extends StatelessWidget {
  const _TypeDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntText(text: 'Ant Design (default)'),
        SizedBox(height: 4),
        AntText(text: 'Ant Design (secondary)', type: AntTypographyType.secondary),
        SizedBox(height: 4),
        AntText(text: 'Ant Design (success)', type: AntTypographyType.success),
        SizedBox(height: 4),
        AntText(text: 'Ant Design (warning)', type: AntTypographyType.warning),
        SizedBox(height: 4),
        AntText(text: 'Ant Design (danger)', type: AntTypographyType.danger),
      ],
    );
  }
}

class _DisabledDemo extends StatelessWidget {
  const _DisabledDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntText(text: 'Ant Design (disabled)', disabled: true),
        SizedBox(height: 4),
        AntLink(text: 'Ant Design (disabled link)', disabled: true),
      ],
    );
  }
}

class _DecorationDemo extends StatelessWidget {
  const _DecorationDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntText(text: 'Ant Design (strong)', strong: true),
        SizedBox(height: 4),
        AntText(text: 'Ant Design (italic)', italic: true),
        SizedBox(height: 4),
        AntText(text: 'Ant Design (underline)', underline: true),
        SizedBox(height: 4),
        AntText(text: 'Ant Design (delete)', delete: true),
        SizedBox(height: 4),
        AntText(text: 'console.log()', code: true),
        SizedBox(height: 4),
        AntText(text: 'Ant Design (mark)', mark: true),
        SizedBox(height: 4),
        AntRow(
          children: [
            AntText(text: 'Press '),
            AntText(text: 'Ctrl', keyboard: true),
            AntText(text: ' + '),
            AntText(text: 'Shift', keyboard: true),
            AntText(text: ' + '),
            AntText(text: 'K', keyboard: true),
          ],
        ),
      ],
    );
  }
}

class _LinkDemo extends StatelessWidget {
  const _LinkDemo();

  @override
  Widget build(BuildContext context) {
    return AntFlex(
      wrap: true,
      gap: const AntFlexGap.only(row: 8, column: 16),
      align: AntFlexAlign.center,
      children: const [
        AntLink(text: 'Ant Design Link'),
        AntLink(text: 'Success Link', type: AntTypographyType.success),
        AntLink(text: 'Warning Link', type: AntTypographyType.warning),
        AntLink(text: 'Danger Link', type: AntTypographyType.danger),
      ],
    );
  }
}

class _CopyableDemo extends StatelessWidget {
  const _CopyableDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntText(text: '可复制的文本', copyable: true),
        SizedBox(height: 8),
        AntParagraph(
          text: '可复制的段落。点击右侧图标可将全文复制到剪贴板。',
          copyable: true,
        ),
        SizedBox(height: 8),
        AntText(
          text: '自定义复制文本',
          copyConfig: AntCopyConfig(text: '这是自定义的复制内容'),
        ),
      ],
    );
  }
}

class _EditableDemo extends StatelessWidget {
  const _EditableDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntText(text: '可编辑的文本', editable: true),
        SizedBox(height: 8),
        AntParagraph(
          text: '可编辑的段落。点击编辑图标进入行内编辑，'
              'Enter 确认或点击确认图标提交，点击取消图标放弃修改。',
          editable: true,
        ),
      ],
    );
  }
}

class _EllipsisDemo extends StatelessWidget {
  const _EllipsisDemo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AntText(
          text: '单行省略：Ant Design 是一个致力于提升用户和设计师体验的设计体系，通过统一的规范降低沟通成本。',
          ellipsis: AntEllipsisConfig(rows: 1),
        ),
        SizedBox(height: 12),
        AntParagraph(
          text: '可展开的段落省略：Ant Design 通过统一的规范，降低用户与系统之间的沟通成本，'
              '提供高效、愉悦的使用体验。在真实的产品设计中，排版系统需要兼顾信息密度与阅读舒适度，'
              '省略与展开是处理长文本的常见手段。antd 的 Typography 组件提供了灵活的省略配置，'
              '支持多行省略、自定义展开按钮和 tooltip 提示。',
          ellipsis: AntEllipsisConfig(rows: 2, expandable: true),
        ),
        SizedBox(height: 12),
        AntParagraph(
          text: '带 tooltip 的省略：将鼠标悬停在被省略的文本上，可查看完整内容。',
          ellipsis: AntEllipsisConfig(rows: 1, tooltip: true),
        ),
      ],
    );
  }
}

class _CompositionDemo extends StatelessWidget {
  const _CompositionDemo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntTitle('设计体系的价值观', level: AntTitleLevel.h2),
          AntParagraph(
            text: '自然、确定性、意义感、生长性。好的设计体系应当如同自然界的生态系统，'
                '各个组件之间和谐共生、有机协作。',
          ),
          AntParagraph(
            text: 'Ant Design 提供了完整的设计资源与工程实现，'
                '帮助产品团队快速构建高质量的界面。',
          ),
          AntLink(text: '了解更多 →', href: 'https://ant.design'),
        ],
      ),
    );
  }
}