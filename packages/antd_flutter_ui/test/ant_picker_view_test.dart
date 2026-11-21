import 'package:antd_flutter_ui/antd_flutter_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

class _Season {
  const _Season(this.id, this.name);

  final String id;
  final String name;
}

const _seasons = <_Season>[
  _Season('spring', '春'),
  _Season('summer', '夏'),
  _Season('autumn', '秋'),
  _Season('winter', '冬'),
];

AntPickerColumn<_Season> _seasonColumn() => AntPickerColumn<_Season>(
      dataSource: _seasons,
      keyOf: (season) => season.id,
      labelBuilder: (context, season) => Text(season.name),
    );

Widget _wrap(Widget child) {
  return AntScreenUtilInit(
    designSize: const Size(375, 812),
    builder: (context, _) => AntTheme(
      data: AntThemeData.light(),
      child: MaterialApp(home: Scaffold(body: child)),
    ),
  );
}

void main() {
  group('AntPickerView', () {
    testWidgets('renders column items', (tester) async {
      await tester.pumpWidget(
        _wrap(AntPickerView<_Season>(columns: [_seasonColumn()])),
      );
      expect(find.text('春'), findsOneWidget);
      expect(find.text('夏'), findsOneWidget);
      expect(find.text('秋'), findsOneWidget);
      expect(find.text('冬'), findsOneWidget);
    });

    testWidgets('renders multiple columns', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntPickerView<_Season>(
            columns: [
              _seasonColumn(),
              AntPickerColumn<_Season>(
                dataSource: _seasons,
                keyOf: (season) => season.id,
                labelBuilder: (context, season) => Text('名称:${season.name}'),
              ),
            ],
          ),
        ),
      );
      expect(find.text('春'), findsOneWidget);
      expect(find.text('名称:周一'), findsNothing);
      expect(find.text('名称:春'), findsOneWidget);
    });

    testWidgets('defaultValue selects correct item', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntPickerView<_Season>(
            columns: [_seasonColumn()],
            defaultValue: const ['autumn'],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final picker = tester.widget<CupertinoPicker>(
        find.byType(CupertinoPicker),
      );
      expect(picker.scrollController!.initialItem, 2);
    });

    testWidgets('controlled value selects correct item', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntPickerView<_Season>(
            columns: [_seasonColumn()],
            value: const ['winter'],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final picker = tester.widget<CupertinoPicker>(
        find.byType(CupertinoPicker),
      );
      expect(picker.scrollController!.initialItem, 3);
    });

    testWidgets('accepts model instances as value', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntPickerView<_Season>(
            columns: [_seasonColumn()],
            value: [_seasons[2]],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final picker = tester.widget<CupertinoPicker>(
        find.byType(CupertinoPicker),
      );
      expect(picker.scrollController!.initialItem, 2);
    });

    testWidgets('null value defaults to first item', (tester) async {
      await tester.pumpWidget(
        _wrap(AntPickerView<_Season>(columns: [_seasonColumn()])),
      );
      final picker = tester.widget<CupertinoPicker>(
        find.byType(CupertinoPicker),
      );
      expect(picker.scrollController!.initialItem, 0);
    });

    testWidgets('invalid value defaults to first item', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntPickerView<_Season>(
            columns: [_seasonColumn()],
            defaultValue: const ['nonexistent'],
          ),
        ),
      );
      final picker = tester.widget<CupertinoPicker>(
        find.byType(CupertinoPicker),
      );
      expect(picker.scrollController!.initialItem, 0);
    });

    testWidgets('onChange fires with custom models on scroll', (tester) async {
      List<_Season>? changed;
      await tester.pumpWidget(
        _wrap(
          AntPickerView<_Season>(
            columns: [_seasonColumn()],
            onChange: (values) => changed = values,
          ),
        ),
      );
      await tester.drag(find.byType(CupertinoPicker), const Offset(0, -40));
      await tester.pumpAndSettle();
      expect(changed, isNotNull);
      expect(changed!.first.id, 'summer');
      expect(changed!.first.name, '夏');
    });

    testWidgets('labelBuilder renders custom widget', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AntPickerView<_Season>(
            columns: [
              AntPickerColumn<_Season>(
                dataSource: _seasons,
                keyOf: (season) => season.id,
                labelBuilder: (context, season) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.eco),
                    Text('季节:${season.name}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      expect(find.text('季节:春'), findsOneWidget);
      expect(find.byIcon(Icons.eco), findsWidgets);
    });
  });
}
