library;

/// Input 输入框演示页
import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:material_ui/material_ui.dart';

class InputPage extends StatelessWidget {
  const InputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Section(title: '基础用法', description: '通过鼠标或键盘输入内容'),
          _BasicDemo(),
          _Section(title: '三种尺寸', description: 'size: large / middle / small'),
          _SizeDemo(),
          _Section(title: '前缀和后缀', description: 'prefix / suffix'),
          _AffixDemo(),
          _Section(title: '前置和后置标签', description: 'addonBefore / addonAfter'),
          _AddonDemo(),
          _Section(title: '清除按钮', description: 'allowClear: true'),
          _ClearDemo(),
          _Section(title: '字数统计', description: 'showCount + maxLength'),
          _CountDemo(),
          _Section(title: '校验状态', description: 'status: error / warning'),
          _StatusDemo(),
          _Section(title: '禁用与只读', description: 'disabled / readOnly'),
          _DisabledDemo(),
          _Section(
            title: '文本域',
            description: 'AntInputTextArea：rows / autoSize / showCount',
          ),
          _TextAreaDemo(),
          _Section(
            title: '密码框',
            description: 'AntInputPassword：visibilityToggle',
          ),
          _PasswordDemo(),
          _Section(
            title: '搜索框',
            description: 'AntInputSearch：enterButton / onSearch',
          ),
          _SearchDemo(),
          _Section(title: '输入框组', description: 'AntInputGroup：compact'),
          _GroupDemo(),
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
          AntText(
            text: title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: AntText(
                text: description!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 输入框行容器
class _InputRow extends StatelessWidget {
  const _InputRow({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AntFlex(
      wrap: true,
      gap: const AntFlexGap.all(12),
      children: children,
    );
  }
}

class _BasicDemo extends StatelessWidget {
  const _BasicDemo();
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: const AntInput(placeholder: '基本输入框'),
    );
  }
}

class _SizeDemo extends StatelessWidget {
  const _SizeDemo();
  @override
  Widget build(BuildContext context) {
    return const _InputRow(
      children: [
        SizedBox(
          width: 200,
          child: AntInput(size: AntInputSize.large, placeholder: 'large'),
        ),
        SizedBox(
          width: 200,
          child: AntInput(size: AntInputSize.middle, placeholder: 'middle'),
        ),
        SizedBox(
          width: 200,
          child: AntInput(size: AntInputSize.small, placeholder: 'small'),
        ),
      ],
    );
  }
}

class _AffixDemo extends StatelessWidget {
  const _AffixDemo();
  @override
  Widget build(BuildContext context) {
    return const _InputRow(
      children: [
        SizedBox(
          width: 240,
          child: AntInput(
            prefix: AntdIcon(AntIcons.userOutlined),
            placeholder: '前缀图标',
          ),
        ),
        SizedBox(
          width: 240,
          child: AntInput(
            suffix: AntdIcon(AntIcons.searchOutlined),
            placeholder: '后缀图标',
          ),
        ),
      ],
    );
  }
}

class _AddonDemo extends StatelessWidget {
  const _AddonDemo();
  @override
  Widget build(BuildContext context) {
    return const _InputRow(
      children: [
        SizedBox(
          width: 300,
          child: AntInput(
            addonBefore: AntText(text: 'http://'),
            placeholder: '前置标签',
          ),
        ),
        SizedBox(
          width: 300,
          child: AntInput(
            addonAfter: AntText(text: '.com'),
            placeholder: '后置标签',
          ),
        ),
        SizedBox(
          width: 360,
          child: AntInput(
            addonBefore: AntText(text: 'http://'),
            addonAfter: AntText(text: '.com'),
            placeholder: '前后置标签',
          ),
        ),
      ],
    );
  }
}

class _ClearDemo extends StatelessWidget {
  const _ClearDemo();
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: const AntInput(
        allowClear: true,
        defaultValue: '输入内容后可清除',
        placeholder: 'allowClear',
      ),
    );
  }
}

class _CountDemo extends StatelessWidget {
  const _CountDemo();
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 320),
      child: const AntInput(
        showCount: true,
        maxLength: 20,
        placeholder: '最多输入 20 个字符',
      ),
    );
  }
}

class _StatusDemo extends StatelessWidget {
  const _StatusDemo();
  @override
  Widget build(BuildContext context) {
    return const _InputRow(
      children: [
        SizedBox(
          width: 240,
          child: AntInput(
            status: AntInputStatus.error,
            placeholder: 'error 状态',
          ),
        ),
        SizedBox(
          width: 240,
          child: AntInput(
            status: AntInputStatus.warning,
            placeholder: 'warning 状态',
          ),
        ),
      ],
    );
  }
}

class _DisabledDemo extends StatelessWidget {
  const _DisabledDemo();
  @override
  Widget build(BuildContext context) {
    return const _InputRow(
      children: [
        SizedBox(
          width: 240,
          child: AntInput(disabled: true, placeholder: '禁用状态'),
        ),
        SizedBox(
          width: 240,
          child: AntInput(readOnly: true, defaultValue: '只读状态'),
        ),
      ],
    );
  }
}

class _TextAreaDemo extends StatelessWidget {
  const _TextAreaDemo();
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 360,
          child: AntInputTextArea(rows: 4, placeholder: '固定 4 行'),
        ),
        SizedBox(height: 12),
        SizedBox(
          width: 360,
          child: AntInputTextArea(autoSize: true, placeholder: '自适应高度（最少 1 行）'),
        ),
        SizedBox(height: 12),
        SizedBox(
          width: 360,
          child: AntInputTextArea(
            autoSize: [2, 6],
            placeholder: '自适应高度（2~6 行）',
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          width: 360,
          child: AntInputTextArea(
            rows: 3,
            maxLength: 100,
            showCount: true,
            placeholder: '字数统计',
          ),
        ),
      ],
    );
  }
}

class _PasswordDemo extends StatelessWidget {
  const _PasswordDemo();
  @override
  Widget build(BuildContext context) {
    return const _InputRow(
      children: [
        SizedBox(width: 280, child: AntInputPassword(placeholder: '输入密码')),
        SizedBox(
          width: 280,
          child: AntInputPassword(
            placeholder: '无切换按钮',
            visibilityToggle: false,
          ),
        ),
      ],
    );
  }
}

class _SearchDemo extends StatelessWidget {
  const _SearchDemo();
  @override
  Widget build(BuildContext context) {
    return const _InputRow(
      children: [
        SizedBox(
          width: 280,
          child: AntInputSearch(placeholder: '图标搜索', onSearch: null),
        ),
        SizedBox(
          width: 280,
          child: AntInputSearch(placeholder: '按钮搜索', enterButton: true),
        ),
        SizedBox(
          width: 280,
          child: AntInputSearch(placeholder: '自定义文案', enterButton: '查找'),
        ),
      ],
    );
  }
}

class _GroupDemo extends StatelessWidget {
  const _GroupDemo();
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 420,
          child: AntInputGroup(
            compact: true,
            children: [
              AntInput(
                addonBefore: AntText(text: 'http://'),
                placeholder: '域名',
              ),
              AntInput(placeholder: '.com'),
            ],
          ),
        ),
      ],
    );
  }
}
