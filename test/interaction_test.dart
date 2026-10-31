import 'test_assets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eateries/app.dart';
import 'package:eateries/core/app_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await loadTestFont();
  });
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets('sign-in validates input and opens address selection', (
    tester,
  ) async {
    final s = AppController()..screen = 4;
    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: TestAssets(),
        child: EateriesApp(controller: s),
      ),
    );
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(s.screen, 4);
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'demo@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'eateries123');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Sign In'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();
    expect(s.screen, 13);
    await tester.tap(find.text('Use current location'));
    await tester.pumpAndSettle();
    expect(s.screen, 15);
  });
  testWidgets('food detail adds to cart, checkout creates an order', (
    tester,
  ) async {
    final s = AppController()..screen = 23;
    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: TestAssets(),
        child: EateriesApp(controller: s),
      ),
    );
    await tester.pumpAndSettle();
    final add = find.textContaining('Add to Cart');
    await tester.scrollUntilVisible(
      add,
      450,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(add);
    await tester.pumpAndSettle();
    expect(s.count, 1);
    expect(s.screen, 24);
    await tester.scrollUntilVisible(
      find.text('Continue Pay'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue Pay'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Pay & Confirm (Demo)'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pay & Confirm (Demo)'));
    await tester.pumpAndSettle();
    expect(s.screen, 37);
    expect(s.orders.length, 1);
    expect(s.cart, isEmpty);
  });
}
