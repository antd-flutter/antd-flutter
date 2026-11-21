/// AntPicker widget tests
///
/// 全部用例都使用自定义模型 [_Season] / [_Fruit]（dataSource + keyOf +
/// labelBuilder），验证泛型数据源 API。
library;

import 'package:antd_picker/antd_picker.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

/// 用户自定义模型
class _Season {
  const _Season(this.id, this.name);

  final String id;
  final String name;
}

class _Fruit {
  const _Fruit(this.code, this.label);

  final int code;
  final String label;
}

const _seasons = <_Season>[
  _Season('spring', '春'),
  _Season('summer', '夏'),
  _Season('autumn', '秋'),
  _Season('winter', '冬'),
];

const _fruits = <_Fruit>[
  _Fruit(1, '苹果'),
  _Fruit(2, '香蕉'),
  _Fruit(3, '橙子'),
];

AntPickerColumn<_Season> _seasonColumn() => AntPickerColumn<_Season>(
      dataSource: _seasons,
      keyOf: (season) => season.id,
      labelBuilder: (context, season) => Text(season.name),
    );

AntPickerColumn<_Fruit> _fruitColumn() => AntPickerColumn<_Fruit>(
      dataSource: _fruits,
      keyOf: (fruit) => fruit.code,
      labelBuilder: (context, fruit) => Text(fruit.label),
    );

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(
        body: AntTheme(
          data: AntThemeData.light(),
          child: Material(child: child),
        ),
      ),
    );

void main() {
  group('AntPicker', () {
    testWidgets('renders trigger child', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntPicker<_Season>(
            columns: [_seasonColumn()],
            child: const Text('打开选择器'),
          ),
        ),
      );
      expect(find.text('打开选择器'), findsOneWidget);
    });

    testWidgets('tapping child opens bottom sheet', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntPicker<_Season>(
            columns: [_seasonColumn()],
            title: '选择季节',
            child: const Text('打开选择器'),
          ),
        ),
      );
      await tester.tap(find.text('打开选择器'));
      await tester.pumpAndSettle();
      expect(find.text('选择季节'), findsOneWidget);
      expect(find.text('春'), findsOneWidget);
    });

    testWidgets('cancel button closes sheet and calls onCancel',
        (tester) async {
      bool cancelled = false;
      await tester.pumpWidget(
        _wrap(
          AntPicker<_Season>(
            columns: [_seasonColumn()],
            onCancel: () => cancelled = true,
            child: const Text('打开选择器'),
          ),
        ),
      );
      await tester.tap(find.text('打开选择器'));
      await tester.pumpAndSettle();
      expect(find.text('取消'), findsOneWidget);

      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(cancelled, isTrue);
      expect(find.text('春'), findsNothing);
    });

    testWidgets('confirm returns custom model resolved from key',
        (tester) async {
      List<_Season>? confirmed;
      await tester.pumpWidget(
        _wrap(
          AntPicker<_Season>(
            columns: [_seasonColumn()],
            defaultValue: const ['spring'],
            onConfirm: (seasons) => confirmed = seasons,
            child: const Text('打开选择器'),
          ),
        ),
      );
      await tester.tap(find.text('打开选择器'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(confirmed, isNotNull);
      expect(confirmed!.single.id, 'spring');
      expect(confirmed!.single.name, '春');
    });

    testWidgets('accepts model instances in defaultValue', (tester) async {
      List<_Season>? confirmed;
      await tester.pumpWidget(
        _wrap(
          AntPicker<_Season>(
            columns: [_seasonColumn()],
            defaultValue: [_seasons[3]],
            onConfirm: (seasons) => confirmed = seasons,
            child: const Text('打开选择器'),
          ),
        ),
      );
      await tester.tap(find.text('打开选择器'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(confirmed!.single.id, 'winter');
    });

    testWidgets('custom confirmText and cancelText display', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntPicker<_Season>(
            columns: [_seasonColumn()],
            confirmText: 'OK',
            cancelText: 'Close',
            child: const Text('打开选择器'),
          ),
        ),
      );
      await tester.tap(find.text('打开选择器'));
      await tester.pumpAndSettle();
      expect(find.text('OK'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('title displays in sheet', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntPicker<_Season>(
            columns: [_seasonColumn()],
            title: '请选择',
            child: const Text('打开选择器'),
          ),
        ),
      );
      await tester.tap(find.text('打开选择器'));
      await tester.pumpAndSettle();
      expect(find.text('请选择'), findsOneWidget);
    });

    testWidgets('onSelect fires when wheel scrolls in sheet', (tester) async {
      List<_Season>? selected;
      await tester.pumpWidget(
        _wrap(
          AntPicker<_Season>(
            columns: [_seasonColumn()],
            onSelect: (seasons) => selected = seasons,
            child: const Text('打开选择器'),
          ),
        ),
      );
      await tester.tap(find.text('打开选择器'));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(CupertinoPicker), const Offset(0, -40));
      await tester.pumpAndSettle();
      expect(selected, isNotNull);
      expect(selected!.single.id, 'summer');
    });

    testWidgets('multiple columns return one model per column', (tester) async {
      List<_Season>? seasons;
      List<_Fruit>? fruits;
      await tester.pumpWidget(
        _wrap(
          AntPicker<_Season>(
            columns: [_seasonColumn()],
            defaultValue: const ['autumn'],
            onConfirm: (items) => seasons = items,
            child: const Text('打开选择器'),
          ),
        ),
      );
      await tester.tap(find.text('打开选择器'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(seasons!.single.name, '秋');

      await tester.pumpWidget(
        _wrap(
          AntPicker<_Fruit>(
            columns: [_fruitColumn()],
            defaultValue: const [2],
            onConfirm: (items) => fruits = items,
            child: const Text('打开水果'),
          ),
        ),
      );
      await tester.tap(find.text('打开水果'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(fruits!.single.label, '香蕉');
    });

    testWidgets('labelBuilder renders custom widget', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntPicker<_Season>(
            columns: [
              AntPickerColumn<_Season>(
                dataSource: _seasons,
                labelBuilder: (context, season) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.eco),
                    Text('季节:${season.name}'),
                  ],
                ),
              ),
            ],
            child: const Text('打开选择器'),
          ),
        ),
      );
      await tester.tap(find.text('打开选择器'));
      await tester.pumpAndSettle();
      expect(find.text('季节:春'), findsOneWidget);
      expect(find.byIcon(Icons.eco), findsWidgets);
    });

    testWidgets('mask tap closes sheet when closeOnMaskClick is true',
        (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntPicker<_Season>(
            columns: [_seasonColumn()],
            closeOnMaskClick: true,
            child: const Text('打开选择器'),
          ),
        ),
      );
      await tester.tap(find.text('打开选择器'));
      await tester.pumpAndSettle();
      expect(find.text('春'), findsOneWidget);

      // Tap on the barrier (outside the sheet)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.text('春'), findsNothing);
    });
  });
}
