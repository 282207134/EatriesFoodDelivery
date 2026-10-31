import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Food {
  final String id, name, image, category;
  final double price;
  final int minutes, popularity;
  const Food(
    this.id,
    this.name,
    this.image,
    this.category,
    this.price, [
    this.minutes = 30,
    this.popularity = 100,
  ]);
  String get description => switch (id) {
    'coffee' => 'Espresso with steamed milk and a smooth layer of foam.',
    'noodles' => 'Stir-fried noodles with chicken and crisp vegetables.',
    'burger' => 'A juicy burger with lettuce, cheese and our house sauce.',
    'cake' => 'Soft cake with a creamy filling and fresh berry topping.',
    'eggs' => 'Fresh eggs with greens, tomatoes and toasted bread.',
    'burger2' => 'Crispy chicken, melted cheese and a soft toasted bun.',
    'pizza' => 'Stone-baked pizza with cheese, tomatoes and vegetables.',
    'soup' => 'A warm vegetable soup with a tangy, lightly spiced broth.',
    _ => name,
  };
  String get ingredients => switch (id) {
    'coffee' => 'Espresso and steamed milk.',
    'noodles' => 'Wheat noodles, chicken, vegetables and soy sauce.',
    'burger' => 'Bread bun, beef patty, lettuce, cheese and house sauce.',
    'cake' => 'Flour, eggs, sugar, cream cheese and berries.',
    'eggs' => 'Eggs, greens, tomatoes and bread.',
    'burger2' => 'Bread bun, chicken, cheese, lettuce and sauce.',
    'pizza' => 'Wheat dough, cheese, tomatoes and vegetables.',
    'soup' => 'Vegetable stock, mushrooms, tomatoes and spices.',
    _ => 'See the restaurant menu for details.',
  };
}

const foods = [
  Food('coffee', 'Cream Coffee', 'coffee', 'Breakfast', 7.4, 10, 92),
  Food('noodles', 'Chicken chowmine', 'noodles', 'Chinese', 12, 25, 85),
  Food('burger', 'Combo Burger', 'burger_food', 'Burgers', 12, 20, 98),
  Food('cake', 'Sweet Potato cake', 'cake', 'Desserts', 7.4, 15, 83),
  Food('eggs', 'Small Egg Green', 'eggs', 'Breakfast', 6, 12, 80),
  Food('burger2', 'Zinger Double Decker', 'zinger', 'Burgers', 14, 30, 90),
  Food('pizza', 'Mexican Pizza', 'pizza', 'Pizza', 15.9, 22, 88),
  Food('soup', 'Hot & Sour Soup', 'soup', 'Soups', 9.5, 18, 82),
];

class LocalOrder {
  final String id, date;
  final double total;
  final Map<String, int> items;
  LocalOrder(this.id, this.date, this.total, this.items);
  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'total': total,
    'items': items,
  };
  factory LocalOrder.fromJson(Map<String, dynamic> json) => LocalOrder(
    json['id'],
    json['date'],
    (json['total'] as num).toDouble(),
    Map<String, int>.from(json['items']),
  );
}

/// Local demo state. Authentication and payment never contact a remote service.
class AppController extends ChangeNotifier {
  int screen = 1;
  bool dark = false, remember = true, promo = false;
  bool hasSession = false;
  String name = 'John Smith', email = 'johnsmith@icloud.com';
  String address = 'Utma street no 14, Washington', phone = '+1 501 444 3451';
  String search = '',
      sort = 'Recommended',
      category = 'All Type',
      payment = 'Cash';
  int priceLevel = 5;
  Food selected = foods[3];
  final cart = <String, int>{};
  final orders = <LocalOrder>[];
  final history = <int>[];
  final notifications = <bool>[true, false, true];
  final socials = <bool>[false, false, false, false];
  final recent = <String>[
    'Starbucks',
    'Zinger Burgers',
    'Chicken Sandwich',
    'Mexican Grilled Pizza',
  ];
  bool get canBack => history.isNotEmpty;
  double get subtotal => cart.entries.fold(
    0,
    (sum, e) => sum + foods.firstWhere((f) => f.id == e.key).price * e.value,
  );
  double get shipping => cart.isEmpty ? 0 : 1.5;
  double get discount => promo ? subtotal * .1 : 0;
  double get total => subtotal + shipping - discount;
  int get count => cart.values.fold(0, (a, b) => a + b);
  List<Food> get results {
    final result = foods
        .where(
          (f) =>
              (category == 'All Type' || f.category == category) &&
              (search.isEmpty ||
                  ('${f.name} ${f.category}').toLowerCase().contains(
                    search.toLowerCase(),
                  )) &&
              f.price <= priceLevel * 5,
        )
        .toList();
    if (sort == 'Price: low to high') {
      result.sort((a, b) => a.price.compareTo(b.price));
    }
    if (sort == 'Most Popular') {
      result.sort((a, b) => b.popularity.compareTo(a.popularity));
    }
    if (sort == 'Fastest Delivery') {
      result.sort((a, b) => a.minutes.compareTo(b.minutes));
    }
    return result;
  }

  void open(int next) {
    if (next == screen) return;
    history.add(screen);
    screen = next;
    notifyListeners();
  }

  void replace(int next) {
    screen = next;
    notifyListeners();
  }

  void beginSession() {
    hasSession = true;
    save();
  }

  void logout() {
    hasSession = false;
    history.clear();
    screen = 4;
    save();
    notifyListeners();
  }

  void back() {
    screen = history.isEmpty ? 15 : history.removeLast();
    notifyListeners();
  }

  void home() {
    history.clear();
    screen = 15;
    notifyListeners();
  }

  void refresh() => notifyListeners();
  void toggleTheme() {
    dark = !dark;
    save();
    notifyListeners();
  }

  void choose(Food food) {
    selected = food;
    open(23);
  }

  void add(Food food, int quantity) {
    cart.update(food.id, (v) => v + quantity, ifAbsent: () => quantity);
    save();
    notifyListeners();
  }

  void quantity(String id, int delta) {
    final value = (cart[id] ?? 0) + delta;
    if (value <= 0) {
      cart.remove(id);
    } else {
      cart[id] = value;
    }
    save();
    notifyListeners();
  }

  bool applyPromo(String code) {
    promo = code.trim().toUpperCase() == 'EAT10';
    notifyListeners();
    return promo;
  }

  void applySearch(String query) {
    search = query.trim();
    if (search.isNotEmpty) {
      recent.remove(search);
      recent.insert(0, search);
      if (recent.length > 8) recent.removeLast();
    }
    save();
    open(33);
  }

  void resetFilters() {
    category = 'All Type';
    sort = 'Recommended';
    priceLevel = 5;
    notifyListeners();
  }

  LocalOrder? checkout() {
    if (cart.isEmpty) return null;
    final order = LocalOrder(
      'EA${DateTime.now().millisecondsSinceEpoch}',
      DateTime.now().toIso8601String(),
      total,
      Map.of(cart),
    );
    orders.insert(0, order);
    cart.clear();
    promo = false;
    save();
    open(37);
    return order;
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'eateries',
      jsonEncode({
        'dark': dark,
        'session': hasSession && remember,
        'remember': remember,
        'name': name,
        'email': email,
        'address': address,
        'phone': phone,
        'cart': cart,
        'orders': orders.map((o) => o.toJson()).toList(),
        'notifications': notifications,
        'socials': socials,
        'recent': recent,
      }),
    );
  }

  Future<void> restore() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('eateries');
    if (raw == null) return;
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      dark = j['dark'] ?? false;
      hasSession = j['session'] ?? false;
      remember = j['remember'] ?? true;
      name = j['name'] ?? name;
      email = j['email'] ?? email;
      address = j['address'] ?? address;
      phone = j['phone'] ?? phone;
      cart.addAll(Map<String, int>.from(j['cart'] ?? {}));
      orders.addAll(
        (j['orders'] as List? ?? []).map((o) => LocalOrder.fromJson(o)),
      );
      for (var i = 0; i < 3; i++) {
        notifications[i] = j['notifications']?[i] ?? notifications[i];
      }
      for (var i = 0; i < 4; i++) {
        socials[i] = j['socials']?[i] ?? false;
      }
      if (j['recent'] != null) {
        recent
          ..clear()
          ..addAll(List<String>.from(j['recent']));
      }
      screen = hasSession ? 15 : 4;
    } on FormatException {
      await prefs.remove('eateries');
    }
  }
}
