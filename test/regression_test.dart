import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eateries/app.dart';
import 'package:eateries/core/app_controller.dart';
import 'package:eateries/shared/widgets.dart';

import 'test_assets.dart';

Future<void> showApp(WidgetTester tester, AppController state) async {
  await tester.pumpWidget(
    DefaultAssetBundle(
      bundle: TestAssets(),
      child: EateriesApp(controller: state),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await loadTestFont();
  });
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets('home cart entry can edit and empty an existing cart', (
    tester,
  ) async {
    final s = AppController()..screen = 15;
    s.add(foods[2], 1);
    await showApp(tester, s);
    await tester.tap(find.byTooltip('Cart'));
    await tester.pumpAndSettle();
    expect(s.screen, 24);
    await tester.tap(find.byTooltip('Remove one Combo Burger'));
    await tester.pumpAndSettle();
    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(s.count, 0);
    expect(s.total, 0);
  });
  testWidgets(
    'filter tabs close to results and keep the search query on apply',
    (tester) async {
      final s = AppController()
        ..screen = 33
        ..search = 'burger';
      await showApp(tester, s);
      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sort by'));
      await tester.pumpAndSettle();
      expect(s.screen, 27);
      await tester.tap(find.byTooltip('Close filters'));
      await tester.pumpAndSettle();
      expect(s.screen, 33);
      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sort by'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Fastest Delivery'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Complete'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Complete'));
      await tester.pumpAndSettle();
      expect(s.search, 'burger');
      expect(s.results.length, 2);
      expect(s.sort, 'Fastest Delivery');
    },
  );
  testWidgets('type selection stays in the filter sheet until applied', (
    tester,
  ) async {
    final s = AppController()..screen = 26;
    await showApp(tester, s);
    await tester.tap(find.text('Pizza'));
    await tester.pumpAndSettle();
    expect(s.category, 'Pizza');
    expect(s.screen, 26);
    await tester.tap(find.text('Complete'));
    await tester.pumpAndSettle();
    expect(s.screen, 33);
    expect(s.results.single.id, 'pizza');
  });
  testWidgets('gallery theme icon tracks the selected appearance', (
    tester,
  ) async {
    final s = AppController()..screen = 15;
    await showApp(tester, s);
    await tester.tap(find.byTooltip('All design screens'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Switch light / dark theme'));
    await tester.pumpAndSettle();
    expect(s.dark, true);
    expect(find.byIcon(Icons.light_mode_outlined), findsOneWidget);
  });
  testWidgets('menu categories and hero carousel have independent state', (
    tester,
  ) async {
    final s = AppController()..screen = 21;
    await showApp(tester, s);
    await tester.ensureVisible(find.text('Dessert'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dessert'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).first, const Offset(0, 1200));
    await tester.pumpAndSettle();
    expect(tester.widget<Photo>(find.byType(Photo).first).name, 'restaurant');
  });
}
