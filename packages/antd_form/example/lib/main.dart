/// antd_form example — Form 表单演示画廊（校验 / 受控 / 自定义校验器 / 动态表单项 / Input 系联动）。
///
/// - 主题经 antd_theme（P03 桥接）注入：`AntThemeData.light/dark().toThemeData()`
/// - R35.4 多平台适配：AntResponsiveInit + AntResponsive.breakpointOf 断点布局
///   （desktop 宽屏双栏 / phone 窄屏单栏），窗口缩放无溢出
/// - 暗色切换：AppBar 按钮联动 AntTheme + themeMode
/// - 覆盖关键形态：基础表单校验（required/pattern/长度/数值范围）、受控
///   （AntFormController 编程式读写/提交/重置）、自定义校验器、动态增减表单项、
///   Form 与 Input 系组件联动（AntInput / AntCheckbox / AntSwitch / AntStepper）
library;

import 'package:antd_form/antd_form.dart';
import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

void main() {
  runApp(const AntdFormGalleryApp());
}

/// 演示卡片：标题 + 内容。
typedef _DemoCard = (String, Widget);

/// antd 表单画廊根组件。
class AntdFormGalleryApp extends StatefulWidget {
  const AntdFormGalleryApp({super.key});

  @override
  State<AntdFormGalleryApp> createState() => _AntdFormGalleryAppState();
}

class _AntdFormGalleryAppState extends State<AntdFormGalleryApp> {
  bool _isDark = false;

  static const List<String> _sectionTitles = [
    '基础校验',
    '受控操作',
    '自定义校验器',
    '动态表单项',
    'Input 系联动',
  ];

  @override
  Widget build(BuildContext context) {
    // 结构对齐 antd_picker example：AntTheme 包裹 MaterialApp，
    // theme + darkTheme + themeMode 三件套联动，Scaffold 背景跟随 colorBgLayout。
    return AntTheme(
      data: _isDark ? AntThemeData.dark() : AntThemeData.light(),
      child: AntResponsiveInit(
          builder: (context, layout, _) => MaterialApp(
            title: 'AntdForm Demo',
            debugShowCheckedModeBanner: false,
            themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
            theme: AntThemeData.light().toThemeData(),
            darkTheme: AntThemeData.dark().toThemeData(),
            home: DefaultTabController(
              length: _sectionTitles.length,
              child: Scaffold(
                backgroundColor: AntTheme.of(context).colorBgLayout,
                appBar: AppBar(
                  title: const Text('Form 表单'),
                  actions: [
                    IconButton(
                      onPressed: () => setState(() => _isDark = !_isDark),
                      icon: Icon(_isDark ? AntIcons.sunOutlined : AntIcons.moonOutlined),
                    ),
                  ],
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: [
                      for (final t in _sectionTitles) Tab(text: t),
                    ],
                  ),
                ),
                // R35.4：desktop 宽屏双栏、phone 窄屏单栏，缩放窗口不溢出。
                body: TabBarView(
                  children: [
                    for (var i = 0; i < _sectionTitles.length; i++)
                      _sectionBody(context, layout, i),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }

  Widget _sectionBody(BuildContext pageContext, AntLayoutData layout, int index) {
    final theme = AntTheme.of(pageContext);
    final isWide = layout.width >= 768 ||
        layout.breakpoint == AntBreakpoint.lg ||
        layout.breakpoint == AntBreakpoint.xl ||
        layout.breakpoint == AntBreakpoint.xxl;
    return SingleChildScrollView(
      padding: EdgeInsets.all(theme.s(16)),
      child: isWide
          ? Wrap(
              spacing: theme.s(16),
              runSpacing: theme.s(16),
              children: [
                for (final card in _cardsOf(index))
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: theme.s(480)),
                    child: _sectionCard(pageContext, card.$1, card.$2),
                  ),
              ],
            )
          : Column(
              children: [
                for (final card in _cardsOf(index))
                  Padding(
                    padding: EdgeInsets.only(bottom: theme.s(16)),
                    child: _sectionCard(pageContext, card.$1, card.$2),
                  ),
              ],
            ),
    );
  }

  List<_DemoCard> _cardsOf(int index) => switch (index) {
        0 => _basicCards(context),
        1 => _controlledCards(context),
        2 => _validatorCards(context),
        3 => _dynamicCards(context),
        _ => _inputLinkageCards(context),
      };
}

/// 卡片容器。
Widget _sectionCard(BuildContext context, String title, Widget child) {
  final theme = AntTheme.of(context);
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
        Padding(
          padding: EdgeInsets.only(bottom: theme.s(12)),
          child: Text(title,
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: theme.s(15))),
        ),
        child,
      ],
    ),
  );
}

Widget _hintText(BuildContext context, String text) {
  final theme = AntTheme.of(context);
  return Padding(
    padding: EdgeInsets.only(top: theme.s(8)),
    child: Text(text,
        style: TextStyle(fontSize: theme.s(12), color: theme.colorTextTertiary)),
  );
}

// ============================================================
// 分区一：基础表单校验（required / pattern / 长度 / 数值范围）
// ============================================================

List<_DemoCard> _basicCards(BuildContext context) => [
      (
        '基础校验（onFinish / onFinishFailed）',
        _BasicFormDemo(),
      ),
    ];

class _BasicFormDemo extends StatefulWidget {
  @override
  State<_BasicFormDemo> createState() => _BasicFormDemoState();
}

class _BasicFormDemoState extends State<_BasicFormDemo> {
  String _result = '尚未提交';

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return AntForm(
      onFinish: (values) =>
          setState(() => _result = '提交成功：${values.entries.map((e) => '${e.key}=${e.value}').join('，')}'),
      onFinishFailed: (errors) =>
          setState(() => _result = '校验失败：${errors.keys.join('、')}'),
      children: [Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntFormItem<String>(
            name: 'username',
            label: '用户名',
            required: true,
            rules: [
              const AntFormFieldRule.required(message: '请输入用户名'),
              const AntFormFieldRule(
                minLength: 3,
                maxLength: 12,
                message: '长度需在 3-12 个字符之间',
              ),
            ],
            builder: (field) => AntInput(
              value: field.value ?? '',
              placeholder: '3-12 个字符',
              onChange: field.didChange,
            ),
          ),
          AntFormItem<String>(
            name: 'phone',
            label: '手机号',
            rules: [
              const AntFormFieldRule.required(message: '请输入手机号'),
              AntFormFieldRule(
                pattern: RegExp(r'^1\d{10}$'),
                message: '手机号格式不正确',
              ),
            ],
            builder: (field) => AntInput(
              value: field.value ?? '',
              placeholder: '11 位手机号',
              keyboardType: TextInputType.phone,
              onChange: field.didChange,
            ),
          ),
          AntFormItem<String>(
            name: 'age',
            label: '年龄',
            rules: const [
              AntFormFieldRule(
                type: AntFormFieldRuleType.number,
                min: 1,
                max: 120,
                message: '请输入 1-120 的数字',
              ),
            ],
            builder: (field) => AntStepper(
              value: field.value == null ? null : double.parse(field.value!),
              min: 1,
              max: 120,
              onChange: (v) => field.didChange(v?.round().toString() ?? ''),
            ),
          ),
          SizedBox(height: theme.s(8)),
          ElevatedButton(
            onPressed: () => AntForm.controllerOf(context)?.submit(),
            child: const Text('提交'),
          ),
          _hintText(context, _result),
        ],
      )],
    );
  }
}

// ============================================================
// 分区二：受控操作（AntFormController 编程式读写 / 校验 / 重置）
// ============================================================

List<_DemoCard> _controlledCards(BuildContext context) => [
      (
        '受控（AntFormController）',
        _ControlledFormDemo(),
      ),
    ];

class _ControlledFormDemo extends StatefulWidget {
  @override
  State<_ControlledFormDemo> createState() => _ControlledFormDemoState();
}

class _ControlledFormDemoState extends State<_ControlledFormDemo> {
  final AntFormController _controller = AntFormController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return AntForm(
      controller: _controller,
      initialValues: const {'nickname': 'antd'},
      children: [Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntFormItem<String>(
            name: 'nickname',
            label: '昵称',
            rules: const [AntFormFieldRule.required(message: '昵称必填')],
            builder: (field) => AntInput(
              value: field.value ?? '',
              onChange: field.didChange,
            ),
          ),
          Wrap(
            spacing: theme.s(8),
            children: [
              OutlinedButton(
                onPressed: () => setState(() => _controller
                    .setValue('nickname', '受控注入', validate: true)),
                child: const Text('setValue 注入'),
              ),
              OutlinedButton(
                onPressed: () async {
                  final ok = await _controller.validate();
                  if (context.mounted) {
                    setState(() => _controller.setValue(
                        'nickname', '校验${ok ? '通过' : '未过'}'));
                  }
                },
                child: const Text('validate 校验'),
              ),
              OutlinedButton(
                onPressed: () {
                  _controller.reset();
                  setState(() {});
                },
                child: const Text('reset 重置'),
              ),
            ],
          ),
          ListenableBuilder(
            listenable: _controller,
            builder: (_, _) => _hintText(
              context,
              '当前值：${_controller.getValues()}，错误：${_controller.getErrors()}',
            ),
          ),
        ],
      )],
    );
  }
}

// ============================================================
// 分区三：自定义校验器
// ============================================================

List<_DemoCard> _validatorCards(BuildContext context) => [
      (
        '自定义校验器（validator）',
        _ValidatorFormDemo(),
      ),
    ];

class _ValidatorFormDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AntForm(
      children: [Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntFormItem<String>(
            name: 'inviteCode',
            label: '邀请码',
            required: true,
            rules: [
              const AntFormFieldRule.required(message: '请输入邀请码'),
              AntFormFieldRule(
                validator: (value) {
                  final code = value as String?;
                  if (code == null || code.length != 6) return '邀请码需为 6 位';
                  if (!code.startsWith('AF')) return '邀请码需以 AF 开头';
                  return null;
                },
              ),
            ],
            builder: (field) => AntInput(
              value: field.value ?? '',
              placeholder: '如 AF0001',
              onChange: field.didChange,
            ),
          ),
          ElevatedButton(
            onPressed: () => AntForm.controllerOf(context)?.submit(),
            child: const Text('提交'),
          ),
        ],
      )],
    );
  }
}

// ============================================================
// 分区四：动态增减表单项
// ============================================================

List<_DemoCard> _dynamicCards(BuildContext context) => [
      (
        '动态增减表单项',
        _DynamicFormDemo(),
      ),
    ];

class _DynamicFormDemo extends StatefulWidget {
  @override
  State<_DynamicFormDemo> createState() => _DynamicFormDemoState();
}

class _DynamicFormDemoState extends State<_DynamicFormDemo> {
  int _memberCount = 2;

  @override
  Widget build(BuildContext context) {
  final theme = AntTheme.of(context);
    return AntForm(
      children: [Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < _memberCount; i++)
            AntFormItem<String>(
              name: 'member_$i',
              label: '成员 ${i + 1}',
              required: true,
              rules: const [AntFormFieldRule.required(message: '不能为空')],
              builder: (field) => AntInput(
                value: field.value ?? '',
                onChange: field.didChange,
              ),
            ),
          Wrap(
            spacing: theme.s(8),
            children: [
              OutlinedButton(
                onPressed: _memberCount >= 5
                    ? null
                    : () => setState(() => _memberCount++),
                child: const Text('+ 添加成员'),
              ),
              OutlinedButton(
                onPressed: _memberCount <= 1
                    ? null
                    : () => setState(() => _memberCount--),
                child: const Text('− 移除成员'),
              ),
            ],
          ),
          _hintText(context, '成员数：$_memberCount（最多 5 人）'),
        ],
      )],
    );
  }
}

// ============================================================
// 分区五：Form 与 Input 系组件联动
// ============================================================

List<_DemoCard> _inputLinkageCards(BuildContext context) => [
      (
        'AntInput + AntCheckbox + AntSwitch 联动',
        _InputLinkageFormDemo(),
      ),
    ];

class _InputLinkageFormDemo extends StatefulWidget {
  @override
  State<_InputLinkageFormDemo> createState() => _InputLinkageFormDemoState();
}

class _InputLinkageFormDemoState extends State<_InputLinkageFormDemo> {
  String _result = '尚未提交';

  @override
  Widget build(BuildContext context) {
    final theme = AntTheme.of(context);
    return AntForm(
      onFinish: (values) => setState(
          () => _result = '提交成功：${values.entries.map((e) => '${e.key}=${e.value}').join('，')}'),
      children: [Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AntFormItem<String>(
            name: 'email',
            label: '邮箱',
            rules: [
              const AntFormFieldRule.required(message: '请输入邮箱'),
              AntFormFieldRule(
                pattern: RegExp(r'^[\w.+-]+@[\w-]+\.[\w.]+$'),
                message: '邮箱格式不正确',
              ),
            ],
            builder: (field) => AntInput(
              value: field.value ?? '',
              placeholder: 'name@example.com',
              allowClear: true,
              onChange: field.didChange,
            ),
          ),
          AntFormItem<bool>(
            name: 'agree',
            label: '用户协议',
            required: true,
            rules: const [
              AntFormFieldRule.required(message: '请先同意用户协议'),
            ],
            builder: (field) => AntCheckbox(
              checked: field.value ?? false,
              onChange: (v) => field.didChange(v),
              child: const Text('我已阅读并同意用户协议'),
            ),
          ),
          AntFormItem<bool>(
            name: 'subscribe',
            label: '订阅推送',
            builder: (field) => AntSwitch(
              checked: field.value ?? false,
              onChange: (v) => field.didChange(v),
            ),
          ),
          SizedBox(height: theme.s(8)),
          ElevatedButton(
            onPressed: () => AntForm.controllerOf(context)?.submit(),
            child: const Text('提交'),
          ),
          _hintText(context, _result),
        ],
      )],
    );
  }
}
