import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eateries/core/app_controller.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test('cart quantity, promo, checkout snapshot and restoration', () async {
    final s = AppController();
    s.add(foods[2], 2);
    s.add(foods[4], 1);
    expect(s.count, 3);
    expect(s.subtotal, 30);
    expect(s.applyPromo('bad'), false);
    expect(s.applyPromo(' eat10 '), true);
    expect(s.total, 28.5);
    final order = s.checkout()!;
    expect(order.total, 28.5);
    expect(order.items['burger'], 2);
    expect(s.cart, isEmpty);
    expect(s.checkout(), isNull);
    s.dark = true;
    s.address = 'Tokyo';
    await s.save();
    final restored = AppController();
    await restored.restore();
    expect(restored.dark, true);
    expect(restored.address, 'Tokyo');
    expect(restored.orders.single.items['burger'], 2);
  });
  test('search, category, price and sort compose; reset restores results', () {
    final s = AppController();
    s.search = 'burger';
    expect(s.results.length, 2);
    s.search = '';
    s.category = 'Burgers';
    s.priceLevel = 2;
    expect(s.results, isEmpty);
    s.resetFilters();
    s.sort = 'Price: low to high';
    expect(s.results.first.price, 6);
    expect(s.results.last.price, 15.9);
    s.sort = 'Fastest Delivery';
    expect(s.results.first.id, 'coffee');
    s.sort = 'Most Popular';
    expect(s.results.first.id, 'burger');
  });
  test('removing last quantity deletes the line and clears shipping', () {
    final s = AppController();
    s.add(foods.first, 1);
    s.quantity(foods.first.id, -1);
    expect(s.cart, isEmpty);
    expect(s.total, 0);
  });
  test(
    'remembered demo session restores; logout clears navigation and session',
    () async {
      final s = AppController()..screen = 38;
      s.beginSession();
      s.history.addAll([15, 39]);
      await s.save();
      final restored = AppController();
      await restored.restore();
      expect(restored.hasSession, true);
      expect(restored.screen, 15);
      s.logout();
      await s.save();
      expect(s.screen, 4);
      expect(s.canBack, false);
      final loggedOut = AppController();
      await loggedOut.restore();
      expect(loggedOut.hasSession, false);
      expect(loggedOut.screen, 4);
    },
  );
  test('unremembered demo session stays local to this run', () async {
    final s = AppController()..remember = false;
    s.beginSession();
    await s.save();
    expect(s.hasSession, true);
    final restored = AppController();
    await restored.restore();
    expect(restored.hasSession, false);
    expect(restored.screen, 4);
    expect(restored.remember, false);
  });
  test('switching filter tabs preserves the original return destination', () {
    final s = AppController()
      ..screen = 33
      ..search = 'burger';
    s.open(29);
    s.replace(26);
    s.replace(27);
    s.replace(28);
    s.back();
    expect(s.screen, 33);
    expect(s.search, 'burger');
    expect(s.history, isEmpty);
  });
}
