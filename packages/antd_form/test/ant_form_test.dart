import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_form/antd_form.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: AntTheme(
        data: AntThemeData.light(),
        child: Material(child: child),
      ),
    ),
  );
}

void main() {
  group('AntForm', () {
    testWidgets('renders form items with labels', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntForm(
            children: [
              AntFormItem<String>(
                name: 'username',
                label: '用户名',
                builder: (field) => AntInput(
                  value: field.value ?? '',
                  onChange: field.didChange,
                ),
              ),
              AntFormItem<String>(
                name: 'email',
                label: '邮箱',
                builder: (field) => AntInput(
                  value: field.value ?? '',
                  onChange: field.didChange,
                ),
              ),
            ],
          ),
        ),
      );

      expect(find.text('用户名'), findsOneWidget);
      expect(find.text('邮箱'), findsOneWidget);
    });

    testWidgets('shows required asterisk when required', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntForm(
            children: [
              AntFormItem<String>(
                name: 'username',
                label: '用户名',
                required: true,
                builder: (field) => AntInput(
                  value: field.value ?? '',
                  onChange: field.didChange,
                ),
              ),
            ],
          ),
        ),
      );

      expect(find.text('*'), findsOneWidget);
    });

    testWidgets('onFinish called when validation passes', (tester) async {
      final controller = AntFormController();
      Map<String, dynamic>? submitted;

      await tester.pumpWidget(
        _wrap(
          AntForm(
            controller: controller,
            onFinish: (values) => submitted = values,
            children: [
              AntFormItem<String>(
                name: 'username',
                label: '用户名',
                rules: [const AntFormFieldRule.required(message: '请输入用户名')],
                builder: (field) => AntInput(
                  value: field.value ?? '',
                  onChange: field.didChange,
                ),
              ),
            ],
          ),
        ),
      );

      // 输入值
      await tester.enterText(find.byType(AntInput), 'admin');
      await tester.pump();

      // 触发提交
      controller.submit();
      await tester.pumpAndSettle();

      expect(submitted, isNotNull);
      expect(submitted!['username'], 'admin');
    });

    testWidgets('onFinishFailed called when validation fails', (tester) async {
      final controller = AntFormController();
      Map<String, String>? failedErrors;

      await tester.pumpWidget(
        _wrap(
          AntForm(
            controller: controller,
            onFinishFailed: (errors) => failedErrors = errors,
            children: [
              AntFormItem<String>(
                name: 'username',
                label: '用户名',
                rules: [const AntFormFieldRule.required(message: '请输入用户名')],
                builder: (field) => AntInput(
                  value: field.value ?? '',
                  onChange: field.didChange,
                ),
              ),
            ],
          ),
        ),
      );

      // 不输入值直接提交
      controller.submit();
      await tester.pumpAndSettle();

      expect(failedErrors, isNotNull);
      expect(failedErrors!['username'], '请输入用户名');
    });

    testWidgets('error text displayed after failed validation', (tester) async {
      final controller = AntFormController();

      await tester.pumpWidget(
        _wrap(
          AntForm(
            controller: controller,
            children: [
              AntFormItem<String>(
                name: 'username',
                label: '用户名',
                rules: [const AntFormFieldRule.required(message: '请输入用户名')],
                builder: (field) => AntInput(
                  value: field.value ?? '',
                  onChange: field.didChange,
                ),
              ),
            ],
          ),
        ),
      );

      // 校验前无错误文案
      expect(find.text('请输入用户名'), findsNothing);

      await controller.validate();
      await tester.pumpAndSettle();

      expect(find.text('请输入用户名'), findsOneWidget);
    });

    testWidgets('validates on change when validateTrigger is onChange',
        (tester) async {
      final controller = AntFormController();

      await tester.pumpWidget(
        _wrap(
          AntForm(
            controller: controller,
            children: [
              AntFormItem<String>(
                name: 'username',
                label: '用户名',
                rules: [
                  const AntFormFieldRule(minLength: 3, message: '至少3个字符'),
                ],
                validateTrigger: AntFormValidateTrigger.onChange,
                builder: (field) => AntInput(
                  value: field.value ?? '',
                  onChange: field.didChange,
                ),
              ),
            ],
          ),
        ),
      );

      // 输入短文本触发校验
      await tester.enterText(find.byType(AntInput), 'ab');
      await tester.pumpAndSettle();

      expect(find.text('至少3个字符'), findsOneWidget);

      // 输入足够长度，错误消失
      await tester.enterText(find.byType(AntInput), 'abc');
      await tester.pumpAndSettle();

      expect(find.text('至少3个字符'), findsNothing);
    });

    testWidgets('controller getValue and setValue', (tester) async {
      final controller = AntFormController();

      await tester.pumpWidget(
        _wrap(
          AntForm(
            controller: controller,
            children: [
              AntFormItem<String>(
                name: 'username',
                label: '用户名',
                builder: (field) => AntInput(
                  value: field.value ?? '',
                  onChange: field.didChange,
                ),
              ),
            ],
          ),
        ),
      );

      // 通过 controller 设置值
      controller.setValue('username', 'hello');
      await tester.pump();

      expect(controller.getValue('username'), 'hello');
      // 输入框应显示设置的值
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('controller reset restores initialValues', (tester) async {
      final controller = AntFormController();

      await tester.pumpWidget(
        _wrap(
          AntForm(
            controller: controller,
            initialValues: {'username': 'initial'},
            children: [
              AntFormItem<String>(
                name: 'username',
                label: '用户名',
                builder: (field) => AntInput(
                  value: field.value ?? '',
                  onChange: field.didChange,
                ),
              ),
            ],
          ),
        ),
      );

      expect(controller.getValue('username'), 'initial');

      // 修改值
      controller.setValue('username', 'changed');
      await tester.pump();
      expect(controller.getValue('username'), 'changed');

      // 重置
      controller.reset();
      await tester.pump();
      expect(controller.getValue('username'), 'initial');
    });

    testWidgets('initialValues populated into fields', (tester) async {
      final controller = AntFormController();

      await tester.pumpWidget(
        _wrap(
          AntForm(
            controller: controller,
            initialValues: {'username': 'preset'},
            children: [
              AntFormItem<String>(
                name: 'username',
                label: '用户名',
                builder: (field) => AntInput(
                  value: field.value ?? '',
                  onChange: field.didChange,
                ),
              ),
            ],
          ),
        ),
      );

      expect(controller.getValue('username'), 'preset');
      expect(find.text('preset'), findsOneWidget);
    });

    testWidgets('horizontal layout renders label and control in a row',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntForm(
            layout: AntFormLayout.horizontal,
            children: [
              AntFormItem<String>(
                name: 'username',
                label: '用户名',
                builder: (field) => AntInput(
                  value: field.value ?? '',
                  onChange: field.didChange,
                ),
              ),
            ],
          ),
        ),
      );

      // 水平布局应有 Row 包含标签和控件
      final rowFinder = find.byType(Row);
      expect(rowFinder, findsWidgets);
    });

    testWidgets('pattern rule validates correctly', (tester) async {
      final controller = AntFormController();

      await tester.pumpWidget(
        _wrap(
          AntForm(
            controller: controller,
            children: [
              AntFormItem<String>(
                name: 'email',
                label: '邮箱',
                rules: [
                  AntFormFieldRule(
                    pattern: RegExp(r'^[\w.-]+@[\w.-]+\.\w+$'),
                    message: '邮箱格式不正确',
                  ),
                ],
                builder: (field) => AntInput(
                  value: field.value ?? '',
                  onChange: field.didChange,
                ),
              ),
            ],
          ),
        ),
      );

      // 输入非法邮箱
      await tester.enterText(find.byType(AntInput), 'not-an-email');
      await tester.pumpAndSettle();

      expect(find.text('邮箱格式不正确'), findsOneWidget);

      // 输入合法邮箱
      await tester.enterText(find.byType(AntInput), 'test@example.com');
      await tester.pumpAndSettle();

      expect(find.text('邮箱格式不正确'), findsNothing);
    });

    testWidgets('custom validator rule', (tester) async {
      final controller = AntFormController();

      await tester.pumpWidget(
        _wrap(
          AntForm(
            controller: controller,
            children: [
              AntFormItem<String>(
                name: 'age',
                label: '年龄',
                rules: [
                  AntFormFieldRule(
                    validator: (value) => (value == '18') ? null : '必须为18岁',
                  ),
                ],
                builder: (field) => AntInput(
                  value: field.value ?? '',
                  onChange: field.didChange,
                ),
              ),
            ],
          ),
        ),
      );

      await tester.enterText(find.byType(AntInput), '20');
      await tester.pumpAndSettle();
      expect(find.text('必须为18岁'), findsOneWidget);

      await tester.enterText(find.byType(AntInput), '18');
      await tester.pumpAndSettle();
      expect(find.text('必须为18岁'), findsNothing);
    });

    testWidgets('help text always displayed', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntForm(
            children: [
              AntFormItem<String>(
                name: 'password',
                label: '密码',
                help: '密码长度至少6位',
                builder: (field) => AntInput(
                  value: field.value ?? '',
                  onChange: field.didChange,
                ),
              ),
            ],
          ),
        ),
      );

      expect(find.text('密码长度至少6位'), findsOneWidget);
    });
  });
}
