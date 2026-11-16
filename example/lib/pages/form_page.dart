import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter/material.dart';

class FormPage extends StatelessWidget {
  const FormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _BasicFormSection(),
          SizedBox(height: 24),
          _HorizontalFormSection(),
          SizedBox(height: 24),
          _ValidationFormSection(),
          SizedBox(height: 24),
          _DisabledFormSection(),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, this.description, required this.child});

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return Column(
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
        if (description != null) ...[
          SizedBox(height: 4.h),
          Text(
            description!,
            style: TextStyle(
              fontSize: t.fontSizeSM,
              color: t.colorTextTertiary,
            ),
          ),
        ],
        SizedBox(height: 12.h),
        child,
      ],
    );
  }
}

class _BasicFormSection extends StatelessWidget {
  const _BasicFormSection();

  @override
  Widget build(BuildContext context) {
    final controller = AntFormController();
    return _Section(
      title: '基础表单',
      description: '垂直布局 + 初始值 + 提交',
      child: AntForm(
        controller: controller,
        initialValues: {'username': 'admin', 'remark': '备注内容'},
        onFinish: (values) {
          debugPrint('表单提交: $values');
        },
        children: [
          AntFormItem<String>(
            name: 'username',
            label: '用户名',
            builder: (field) => AntInput(
              value: field.value ?? '',
              onChange: field.didChange,
              placeholder: '请输入用户名',
            ),
          ),
          AntFormItem<String>(
            name: 'remark',
            label: '备注',
            builder: (field) => AntInputTextArea(
              value: field.value ?? '',
              onChange: field.didChange,
              placeholder: '请输入备注',
            ),
          ),
          SizedBox(height: 8.h),
          AntButton(
            type: AntButtonType.primary,
            onTap: () => controller.submit(),
            child: const Text('提交'),
          ),
        ],
      ),
    );
  }
}

class _HorizontalFormSection extends StatelessWidget {
  const _HorizontalFormSection();

  @override
  Widget build(BuildContext context) {
    final controller = AntFormController();
    return _Section(
      title: '水平布局',
      description: '标签与控件同行，labelWidth 控制标签宽度',
      child: AntForm(
        controller: controller,
        layout: AntFormLayout.horizontal,
        labelWidth: 80.w,
        onFinish: (values) {
          debugPrint('水平表单提交: $values');
        },
        children: [
          AntFormItem<String>(
            name: 'name',
            label: '姓名',
            builder: (field) => AntInput(
              value: field.value ?? '',
              onChange: field.didChange,
              placeholder: '请输入姓名',
            ),
          ),
          AntFormItem<String>(
            name: 'phone',
            label: '手机号',
            builder: (field) => AntInput(
              value: field.value ?? '',
              onChange: field.didChange,
              placeholder: '请输入手机号',
            ),
          ),
          SizedBox(height: 8.h),
          AntButton(
            type: AntButtonType.primary,
            onTap: () => controller.submit(),
            child: const Text('提交'),
          ),
        ],
      ),
    );
  }
}

class _ValidationFormSection extends StatelessWidget {
  const _ValidationFormSection();

  @override
  Widget build(BuildContext context) {
    final controller = AntFormController();
    return _Section(
      title: '表单校验',
      description: '必填 + 正则 + 最小长度 + 自定义校验器',
      child: AntForm(
        controller: controller,
        onFinish: (values) {
          debugPrint('校验通过: $values');
        },
        onFinishFailed: (errors) {
          debugPrint('校验失败: $errors');
        },
        children: [
          AntFormItem<String>(
            name: 'username',
            label: '用户名',
            required: true,
            rules: [
              AntFormFieldRule(minLength: 3, message: '用户名至少3个字符'),
            ],
            builder: (field) => AntInput(
              value: field.value ?? '',
              onChange: field.didChange,
              placeholder: '请输入用户名',
            ),
          ),
          AntFormItem<String>(
            name: 'email',
            label: '邮箱',
            rules: [
              AntFormFieldRule.required(message: '请输入邮箱'),
              AntFormFieldRule(
                pattern: RegExp(r'^[\w.-]+@[\w.-]+\.\w+$'),
                message: '邮箱格式不正确',
              ),
            ],
            builder: (field) => AntInput(
              value: field.value ?? '',
              onChange: field.didChange,
              placeholder: '请输入邮箱',
            ),
          ),
          AntFormItem<String>(
            name: 'age',
            label: '年龄',
            help: '必须为 18-60 之间的整数',
            rules: [
              AntFormFieldRule(
                validator: (value) {
                  final parsed = int.tryParse(value?.toString() ?? '');
                  if (parsed == null) return '请输入数字';
                  if (parsed < 18 || parsed > 60) return '年龄须在18-60之间';
                  return null;
                },
              ),
            ],
            builder: (field) => AntInput(
              value: field.value ?? '',
              onChange: field.didChange,
              placeholder: '请输入年龄',
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              AntButton(
                type: AntButtonType.primary,
                onTap: () => controller.submit(),
                child: const Text('提交'),
              ),
              SizedBox(width: 12.w),
              AntButton(
                onTap: () => controller.reset(),
                child: const Text('重置'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DisabledFormSection extends StatelessWidget {
  const _DisabledFormSection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: '禁用表单',
      description: 'disabled 禁用全部表单项',
      child: AntForm(
        disabled: true,
        initialValues: {'username': 'disabled_user'},
        children: [
          AntFormItem<String>(
            name: 'username',
            label: '用户名',
            builder: (field) => AntInput(
              value: field.value ?? '',
              onChange: field.didChange,
              disabled: true,
            ),
          ),
          AntFormItem<String>(
            name: 'note',
            label: '备注',
            builder: (field) => AntInputTextArea(
              value: field.value ?? '',
              onChange: field.didChange,
              disabled: true,
            ),
          ),
        ],
      ),
    );
  }
}