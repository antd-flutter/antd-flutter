import 'package:antd_flutter_plus/antd_flutter_plus.dart';
import 'package:flutter/material.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: '基础用法',
            child: AntTransfer(
              dataSource: _defaultData,
              titles: ['待选', '已选'],
              onChange: (keys, direction, moves) =>
                  debugPrint('onChange: $keys, $direction, $moves'),
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '默认目标项',
            child: AntTransfer(
              dataSource: _defaultData,
              titles: ['待选', '已选'],
              defaultTargetKeys: ['b'],
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '带搜索',
            child: AntTransfer(
              dataSource: _defaultData,
              titles: ['待选', '已选'],
              showSearch: true,
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '禁用选项',
            child: AntTransfer(
              dataSource: _disabledData,
              titles: ['待选', '已选'],
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '单向模式',
            child: AntTransfer(
              dataSource: _defaultData,
              titles: ['待选', '已选'],
              oneWay: true,
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '自定义操作文案',
            child: AntTransfer(
              dataSource: _defaultData,
              titles: ['待选', '已选'],
              operations: ['右移', '左移'],
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '禁用状态',
            child: AntTransfer(
              dataSource: _defaultData,
              titles: ['待选', '已选'],
              disabled: true,
            ),
          ),
          SizedBox(height: 16.h),
          _Section(
            title: '受控用法',
            child: _ControlledTransfer(),
          ),
        ],
      ),
    );
  }
}

const _defaultData = <AntTransferItem>[
  AntTransferItem(key: 'a', title: '选项A'),
  AntTransferItem(key: 'b', title: '选项B'),
  AntTransferItem(key: 'c', title: '选项C'),
  AntTransferItem(key: 'd', title: '选项D'),
  AntTransferItem(key: 'e', title: '选项E'),
  AntTransferItem(key: 'f', title: '选项F'),
];

const _disabledData = <AntTransferItem>[
  AntTransferItem(key: 'a', title: '选项A'),
  AntTransferItem(key: 'b', title: '选项B（禁用）', disabled: true),
  AntTransferItem(key: 'c', title: '选项C'),
  AntTransferItem(key: 'd', title: '选项D（禁用）', disabled: true),
  AntTransferItem(key: 'e', title: '选项E'),
];

class _ControlledTransfer extends StatefulWidget {
  @override
  State<_ControlledTransfer> createState() => _ControlledTransferState();
}

class _ControlledTransferState extends State<_ControlledTransfer> {
  List<String> _targetKeys = ['b'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AntTransfer(
          dataSource: _defaultData,
          titles: ['待选', '已选'],
          targetKeys: _targetKeys,
          onChange: (keys, direction, moves) =>
              setState(() => _targetKeys = keys),
        ),
        SizedBox(height: 8.h),
        Text(
          '当前 targetKeys: $_targetKeys',
          style: TextStyle(
            fontSize: 14.sp,
            color: AntTheme.of(context).colorTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = AntTheme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: t.colorBgContainer,
        borderRadius: BorderRadius.circular(t.borderRadiusLG.r),
        border: Border.all(color: t.colorSplit),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: t.colorText,
            ),
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}