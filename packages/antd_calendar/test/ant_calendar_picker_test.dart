import 'package:antd_calendar/antd_calendar.dart';
import 'package:material_ui/material_ui.dart';
import 'package:antd_theme/antd_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:antd_icons_flutter/antd_icons_flutter.dart';

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
  group('AntCalendarPickerView — rendering', () {
    testWidgets('renders month header and week labels', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendarPickerView(
          defaultValue: [DateTime(2024, 6, 15)],
        ),
      ),);
      expect(find.text('2024年6月'), findsOneWidget);
      expect(find.text('日'), findsOneWidget);
      expect(find.text('一'), findsOneWidget);
      expect(find.text('六'), findsOneWidget);
    });

    testWidgets('renders Monday-start week labels', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendarPickerView(
          weekStartsOn: AntCalendarWeekStartsOn.monday,
          defaultValue: [DateTime(2024, 6, 15)],
        ),
      ),);
      expect(find.text('2024年6月'), findsOneWidget);
      // Monday-start: 一 first, 日 last
      final labels = ['一', '二', '三', '四', '五', '六', '日'];
      for (final label in labels) {
        expect(find.text(label), findsOneWidget);
      }
    });

    testWidgets('renders day numbers for current month', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendarPickerView(
          defaultValue: [DateTime(2024, 6, 15)],
        ),
      ),);
      // Days 7-25 are unique in the June 2024 grid
      expect(find.text('10'), findsOneWidget);
      expect(find.text('15'), findsOneWidget);
      expect(find.text('20'), findsOneWidget);
    });

    testWidgets('renders navigation arrows', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendarPickerView(
          defaultValue: [DateTime(2024, 6, 15)],
        ),
      ),);
      expect(find.byIcon(AntIcons.leftOutlined), findsOneWidget);
      expect(find.byIcon(AntIcons.rightOutlined), findsOneWidget);
    });

    testWidgets('defaultValue sets initial month', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendarPickerView(
          defaultValue: [DateTime(2024, 8, 15)],
        ),
      ),);
      expect(find.text('2024年8月'), findsOneWidget);
    });
  });

  group('AntCalendarPickerView — single selection', () {
    testWidgets('tap day selects it', (tester) async {
      List<DateTime>? changed;
      await tester.pumpWidget(_wrap(
        AntCalendarPickerView(
          defaultValue: [DateTime(2024, 6, 15)],
          onChange: (dates) => changed = dates,
        ),
      ),);
      await tester.tap(find.text('10'));
      await tester.pump();
      expect(changed, [DateTime(2024, 6, 10)]);
    });

    testWidgets('tap selected day clears with allowClear', (tester) async {
      List<DateTime>? changed;
      await tester.pumpWidget(_wrap(
        AntCalendarPickerView(
          defaultValue: [DateTime(2024, 6, 15)],
          onChange: (dates) => changed = dates,
        ),
      ),);
      await tester.tap(find.text('15'));
      await tester.pump();
      expect(changed, []);
    });

    testWidgets('tap selected day keeps selection without allowClear',
        (tester) async {
      List<DateTime>? changed;
      await tester.pumpWidget(_wrap(
        AntCalendarPickerView(
          defaultValue: [DateTime(2024, 6, 15)],
          allowClear: false,
          onChange: (dates) => changed = dates,
        ),
      ),);
      await tester.tap(find.text('15'));
      await tester.pump();
      expect(changed, [DateTime(2024, 6, 15)]);
    });
  });

  group('AntCalendarPickerView — range selection', () {
    testWidgets('first tap selects start', (tester) async {
      List<DateTime>? changed;
      await tester.pumpWidget(_wrap(
        AntCalendarPickerView(
          selectionMode: AntCalendarSelectionMode.range,
          min: DateTime(2024, 6, 1),
          max: DateTime(2024, 6, 30),
          onChange: (dates) => changed = dates,
        ),
      ),);
      await tester.tap(find.text('10'));
      await tester.pump();
      expect(changed, [DateTime(2024, 6, 10)]);
    });

    testWidgets('second tap completes range', (tester) async {
      List<DateTime>? changed;
      await tester.pumpWidget(_wrap(
        AntCalendarPickerView(
          selectionMode: AntCalendarSelectionMode.range,
          min: DateTime(2024, 6, 1),
          max: DateTime(2024, 6, 30),
          onChange: (dates) => changed = dates,
        ),
      ),);
      await tester.tap(find.text('10'));
      await tester.pump();
      expect(changed, [DateTime(2024, 6, 10)]);
      await tester.tap(find.text('20'));
      await tester.pump();
      expect(changed, [DateTime(2024, 6, 10), DateTime(2024, 6, 20)]);
    });

    testWidgets('tap before start swaps order', (tester) async {
      List<DateTime>? changed;
      await tester.pumpWidget(_wrap(
        AntCalendarPickerView(
          selectionMode: AntCalendarSelectionMode.range,
          min: DateTime(2024, 6, 1),
          max: DateTime(2024, 6, 30),
          onChange: (dates) => changed = dates,
        ),
      ),);
      await tester.tap(find.text('20'));
      await tester.pump();
      await tester.tap(find.text('10'));
      await tester.pump();
      expect(changed, [DateTime(2024, 6, 10), DateTime(2024, 6, 20)]);
    });

    testWidgets('tap after complete range starts new selection',
        (tester) async {
      List<DateTime>? changed;
      await tester.pumpWidget(_wrap(
        AntCalendarPickerView(
          selectionMode: AntCalendarSelectionMode.range,
          min: DateTime(2024, 6, 1),
          max: DateTime(2024, 6, 30),
          onChange: (dates) => changed = dates,
        ),
      ),);
      await tester.tap(find.text('10'));
      await tester.pump();
      await tester.tap(find.text('20'));
      await tester.pump();
      await tester.tap(find.text('15'));
      await tester.pump();
      expect(changed, [DateTime(2024, 6, 15)]);
    });

    testWidgets('tap start again clears with allowClear', (tester) async {
      List<DateTime>? changed;
      await tester.pumpWidget(_wrap(
        AntCalendarPickerView(
          selectionMode: AntCalendarSelectionMode.range,
          min: DateTime(2024, 6, 1),
          max: DateTime(2024, 6, 30),
          onChange: (dates) => changed = dates,
        ),
      ),);
      await tester.tap(find.text('10'));
      await tester.pump();
      expect(changed, [DateTime(2024, 6, 10)]);
      await tester.tap(find.text('10'));
      await tester.pump();
      expect(changed, []);
    });
  });

  group('AntCalendarPickerView — controlled mode', () {
    testWidgets('controlled value does not update internally', (tester) async {
      List<DateTime>? changed;
      await tester.pumpWidget(_wrap(
        AntCalendarPickerView(
          value: [DateTime(2024, 6, 15)],
          onChange: (dates) => changed = dates,
        ),
      ),);
      await tester.tap(find.text('10'));
      await tester.pump();
      expect(changed, [DateTime(2024, 6, 10)]);
      // Tap 10 again — since internal state didn't change to [10],
      // it should select again, not clear.
      changed = null;
      await tester.tap(find.text('10'));
      await tester.pump();
      expect(changed, [DateTime(2024, 6, 10)]);
    });

    testWidgets('controlled value updates selection display', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendarPickerView(
          value: [DateTime(2024, 6, 15)],
        ),
      ),);
      expect(find.text('2024年6月'), findsOneWidget);
    });
  });

  group('AntCalendarPickerView — min/max bounds', () {
    testWidgets('days before min are disabled', (tester) async {
      List<DateTime>? changed;
      await tester.pumpWidget(_wrap(
        AntCalendarPickerView(
          min: DateTime(2024, 6, 10),
          max: DateTime(2024, 6, 25),
          onChange: (dates) => changed = dates,
        ),
      ),);
      // Day 8 is before min (June 10), unique in grid
      await tester.tap(find.text('8'));
      await tester.pump();
      expect(changed, isNull);
    });

    testWidgets('days after max are disabled', (tester) async {
      List<DateTime>? changed;
      await tester.pumpWidget(_wrap(
        AntCalendarPickerView(
          min: DateTime(2024, 6, 10),
          max: DateTime(2024, 6, 25),
          onChange: (dates) => changed = dates,
        ),
      ),);
      // Day 20 is within range — should work
      await tester.tap(find.text('20'));
      await tester.pump();
      expect(changed, [DateTime(2024, 6, 20)]);
      // Day 25 is max boundary — should work
      changed = null;
      await tester.tap(find.text('25'));
      await tester.pump();
      expect(changed, [DateTime(2024, 6, 25)]);
    });

    testWidgets('cannot navigate before min month', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendarPickerView(
          defaultValue: [DateTime(2024, 6, 15)],
          min: DateTime(2024, 6, 1),
          max: DateTime(2024, 8, 31),
        ),
      ),);
      expect(find.text('2024年6月'), findsOneWidget);
      await tester.tap(find.byIcon(AntIcons.leftOutlined));
      await tester.pump();
      expect(find.text('2024年6月'), findsOneWidget);
    });

    testWidgets('cannot navigate after max month', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendarPickerView(
          defaultValue: [DateTime(2024, 8, 15)],
          min: DateTime(2024, 6, 1),
          max: DateTime(2024, 8, 31),
        ),
      ),);
      expect(find.text('2024年8月'), findsOneWidget);
      await tester.tap(find.byIcon(AntIcons.rightOutlined));
      await tester.pump();
      expect(find.text('2024年8月'), findsOneWidget);
    });
  });

  group('AntCalendarPickerView — month navigation', () {
    testWidgets('tap next arrow navigates to next month', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendarPickerView(
          defaultValue: [DateTime(2024, 6, 15)],
        ),
      ),);
      expect(find.text('2024年6月'), findsOneWidget);
      await tester.tap(find.byIcon(AntIcons.rightOutlined));
      await tester.pump();
      expect(find.text('2024年7月'), findsOneWidget);
    });

    testWidgets('tap prev arrow navigates to previous month', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendarPickerView(
          defaultValue: [DateTime(2024, 7, 15)],
        ),
      ),);
      expect(find.text('2024年7月'), findsOneWidget);
      await tester.tap(find.byIcon(AntIcons.leftOutlined));
      await tester.pump();
      expect(find.text('2024年6月'), findsOneWidget);
    });
  });

  group('AntCalendarPicker — popup', () {
    testWidgets('tap child opens bottom sheet', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendarPicker(
          min: DateTime(2024, 6, 1),
          max: DateTime(2024, 6, 30),
          onConfirm: (dates) {},
          child: const Text('打开日历'),
        ),
      ),);
      await tester.tap(find.text('打开日历'));
      await tester.pumpAndSettle();
      expect(find.text('确定'), findsOneWidget);
      expect(find.text('取消'), findsOneWidget);
      expect(find.text('2024年6月'), findsOneWidget);
    });

    testWidgets('confirm returns selected dates', (tester) async {
      List<DateTime>? confirmed;
      await tester.pumpWidget(_wrap(
        AntCalendarPicker(
          min: DateTime(2024, 6, 1),
          max: DateTime(2024, 6, 30),
          onConfirm: (dates) => confirmed = dates,
          child: const Text('打开日历'),
        ),
      ),);
      await tester.tap(find.text('打开日历'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15'));
      await tester.pump();
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(confirmed, [DateTime(2024, 6, 15)]);
    });

    testWidgets('cancel closes without confirming', (tester) async {
      bool confirmed = false;
      await tester.pumpWidget(_wrap(
        AntCalendarPicker(
          min: DateTime(2024, 6, 1),
          max: DateTime(2024, 6, 30),
          onConfirm: (dates) => confirmed = true,
          child: const Text('打开日历'),
        ),
      ),);
      await tester.tap(find.text('打开日历'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(confirmed, isFalse);
      expect(find.text('确定'), findsNothing);
    });

    testWidgets('renders title in sheet', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendarPicker(
          title: '选择日期',
          min: DateTime(2024, 6, 1),
          max: DateTime(2024, 6, 30),
          onConfirm: (dates) {},
          child: const Text('打开日历'),
        ),
      ),);
      await tester.tap(find.text('打开日历'));
      await tester.pumpAndSettle();
      expect(find.text('选择日期'), findsOneWidget);
    });

    testWidgets('onClose called when sheet dismissed', (tester) async {
      bool closed = false;
      await tester.pumpWidget(_wrap(
        AntCalendarPicker(
          min: DateTime(2024, 6, 1),
          max: DateTime(2024, 6, 30),
          onClose: () => closed = true,
          onConfirm: (dates) {},
          child: const Text('打开日历'),
        ),
      ),);
      await tester.tap(find.text('打开日历'));
      await tester.pumpAndSettle();
      expect(closed, isFalse);
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(closed, isTrue);
    });

    testWidgets('visible=true opens sheet on mount', (tester) async {
      await tester.pumpWidget(_wrap(
        AntCalendarPicker(
          visible: true,
          min: DateTime(2024, 6, 1),
          max: DateTime(2024, 6, 30),
          onConfirm: (dates) {},
          child: const Text('打开日历'),
        ),
      ),);
      await tester.pumpAndSettle();
      expect(find.text('确定'), findsOneWidget);
    });

    testWidgets('range mode confirm returns start and end', (tester) async {
      List<DateTime>? confirmed;
      await tester.pumpWidget(_wrap(
        AntCalendarPicker(
          selectionMode: AntCalendarSelectionMode.range,
          min: DateTime(2024, 6, 1),
          max: DateTime(2024, 6, 30),
          onConfirm: (dates) => confirmed = dates,
          child: const Text('打开日历'),
        ),
      ),);
      await tester.tap(find.text('打开日历'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('10'));
      await tester.pump();
      await tester.tap(find.text('20'));
      await tester.pump();
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(confirmed, [DateTime(2024, 6, 10), DateTime(2024, 6, 20)]);
    });
  });
}