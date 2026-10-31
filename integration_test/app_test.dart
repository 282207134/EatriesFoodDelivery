import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:eateries/app.dart';
import 'package:eateries/core/app_controller.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Android checkout flow and theme screenshots', (tester) async {
    final s = AppController()..screen = 15;
    await tester.pumpWidget(EateriesApp(controller: s));
    await tester.pumpAndSettle();
    final context = tester.element(find.byKey(const ValueKey('app-capture')));
    for (final name in [
      'coffee',
      'noodles',
      'restaurant',
      'avatar',
      'cake',
      'eggs',
      'burger',
      'burger2',
      'burger_food',
      'zinger',
      'pizza',
      'soup',
      'onboarding1',
    ]) {
      await precacheImage(AssetImage('assets/images/$name.webp'), context);
    }
    await tester.pumpAndSettle();
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    await binding.takeScreenshot('15-home');
    s.choose(foods[3]);
    await tester.pumpAndSettle();
    await binding.takeScreenshot('23-food');
    final add = find.textContaining('Add to Cart');
    await tester.scrollUntilVisible(
      add,
      450,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(add);
    await tester.pumpAndSettle();
    expect(s.screen, 24);
    expect(s.count, 1);
    await binding.takeScreenshot('24-cart');
    s.home();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Cart'));
    await tester.pumpAndSettle();
    expect(s.screen, 24);
    expect(s.count, 1);
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
    expect(s.orders.length, 1);
    expect(s.cart, isEmpty);
    await binding.takeScreenshot('37-success');
    s.home();
    s.toggleTheme();
    await tester.pumpAndSettle();
    await binding.takeScreenshot('15-home-dark');
    expect(tester.takeException(), isNull);
    s.beginSession();
    s.open(38);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Logout'),
      350,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    expect(s.hasSession, false);
    expect(s.canBack, false);
    expect(s.screen, 4);
    s.dark = false;
    await s.save();
    s.refresh();
    await tester.pumpAndSettle();
    await binding.takeScreenshot('04-logged-out');
    s.open(28);
    await tester.pumpAndSettle();
    await binding.takeScreenshot('28-price');
    s.open(1);
    await tester.pumpAndSettle();
    await binding.takeScreenshot('01-onboarding');
  });
}
