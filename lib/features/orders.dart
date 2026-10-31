import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../core/theme.dart';
import '../shared/widgets.dart';

class OrderScreen extends StatefulWidget {
  final AppController state;
  const OrderScreen(this.state, {super.key});
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final promo = TextEditingController();
  final card = TextEditingController(),
      expiry = TextEditingController(),
      cvc = TextEditingController();
  final form = GlobalKey<FormState>();
  int quantity = 1, cookie = 1, foodTab = 0, imageIndex = 0;
  bool takeaway = true, addCard = false;
  AppController get s => widget.state;
  int get n => s.screen;
  @override
  void dispose() {
    for (final c in [promo, card, expiry, cvc]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (n == 21 || n == 22) return restaurant();
    if (n == 23) return detail();
    if (n == 25) return payment();
    if (n == 35) return history();
    if (n == 37) return success();
    return cart();
  }

  Widget hero({bool close = false}) => Stack(
    children: [
      GestureDetector(
        onHorizontalDragEnd: (_) =>
            setState(() => imageIndex = (imageIndex + 1) % 3),
        child: Photo(
          imageIndex == 0
              ? (n == 23 ? s.selected.image : 'restaurant')
              : imageIndex == 1
              ? 'cake'
              : 'eggs',
          width: double.infinity,
          height: n == 22 ? 220 : 270,
          radius: 0,
        ),
      ),
      Positioned(
        left: 5,
        top: 8,
        child: IconButton(
          tooltip: 'Back',
          onPressed: s.back,
          icon: Icon(
            close ? Icons.close : Icons.chevron_left,
            color: Colors.white,
          ),
        ),
      ),
      Positioned(
        right: 7,
        top: 8,
        child: IconButton(
          tooltip: 'Search',
          onPressed: () => s.open(32),
          icon: const Icon(Icons.search, color: Colors.white),
        ),
      ),
      Positioned(
        bottom: 18,
        right: 20,
        child: Row(
          children: List.generate(
            3,
            (i) => Container(
              width: 8,
              height: 5,
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: i == imageIndex ? Colors.white : Colors.white38,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    ],
  );
  Widget restaurant() => Scaffold(
    floatingActionButton: s.count > 0
        ? FloatingActionButton.extended(
            backgroundColor: orange,
            foregroundColor: Colors.white,
            onPressed: () => s.open(24),
            icon: const Icon(Icons.shopping_bag_outlined),
            label: Text('Cart (${s.count})'),
          )
        : null,
    body: SafeArea(
      child: ListView(
        children: [
          hero(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Heading('Bakery & cafe', size: 24),
                const SizedBox(height: 6),
                const Note(r'$$  ·  Chinese  ·  American  ·  Deshi food'),
                smallGap,
                const Rating(),
                gap,
                SizedBox(
                  width: 120,
                  child: FilledButton(
                    onPressed: () => setState(() => takeaway = !takeaway),
                    child: Text(takeaway ? 'Take away' : 'Delivery'),
                  ),
                ),
                const SizedBox(height: 28),
                const Section('Featured Items'),
                SizedBox(
                  height: 236,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    separatorBuilder: (_, _) => const SizedBox(width: 14),
                    itemBuilder: (_, i) {
                      final f = [foods[3], foods[4], foods[1]][i];
                      return SizedBox(
                        width: 140,
                        child: FoodCard(
                          f,
                          small: true,
                          onTap: () => s.choose(f),
                        ),
                      );
                    },
                  ),
                ),
                gap,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      4,
                      (i) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            ['Sea food', 'Appetizers', 'Pizza', 'Dessert'][i],
                          ),
                          selected: foodTab == i,
                          selectedColor: orange.withValues(alpha: .2),
                          onSelected: (_) => setState(() => foodTab = i),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Section(foodTab == 3 ? 'Desserts' : 'Most Populars'),
                for (final f
                    in (foodTab == 3 ? [foods[3]] : foods.skip(1))) ...[
                  FoodRow(f, onTap: () => s.choose(f)),
                  const Divider(),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );
  Widget detail() => Scaffold(
    body: SafeArea(
      child: ListView(
        children: [
          hero(close: true),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Heading(s.selected.name, size: 25),
                smallGap,
                Text(
                  s.selected.description,
                  style: const TextStyle(height: 1.6, fontSize: 13),
                ),
                gap,
                const Note(r'$$  ·  Chinese  ·  American  ·  Deshi food'),
                gap,
                Row(
                  children: [
                    Chip(
                      backgroundColor: orange.withValues(alpha: .15),
                      label: Text(s.selected.category),
                    ),
                    const SizedBox(width: 10),
                    Chip(label: Text('${s.selected.minutes} min')),
                  ],
                ),
                const SizedBox(height: 26),
                const Text(
                  'Sample nutrition per 100g',
                  style: TextStyle(fontSize: 13),
                ),
                gap,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (final pair in [
                      ('198', 'Kcal'),
                      ('14.1', 'Proteins'),
                      ('19.6', 'Fats'),
                      ('6.6', 'Carbo H'),
                    ])
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Heading(pair.$1, size: 28),
                            ),
                            const SizedBox(height: 5),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Note(pair.$2),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                gap,
                const Divider(),
                gap,
                const Heading('Ingredients', size: 21),
                smallGap,
                Note(s.selected.ingredients),
                gap,
                const Divider(),
                gap,
                const Heading('Terms & conditions', size: 21),
                smallGap,
                const Note(
                  'No more than a day, at temperature from +2°C to +6°C.',
                ),
                gap,
                const Divider(),
                gap,
                const Heading('Choice of top Cookie', size: 21),
                smallGap,
                for (var i = 0; i < 8; i++)
                  OptionTile<int>(
                    contentPadding: EdgeInsets.zero,
                    activeColor: orange,
                    value: i,
                    groupValue: cookie,
                    title: Text(
                      [
                        'Cookies and Cream',
                        'Chocolate Chip',
                        'Funfetti',
                        'M and M',
                        'Red Velvet',
                        'Peanut Butter',
                        'Snickerdoodle',
                        'White Chocolate Macadamia',
                      ][i],
                      style: const TextStyle(fontSize: 14),
                    ),
                    onChanged: (v) => setState(() => cookie = v!),
                  ),
                gap,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton.filledTonal(
                      tooltip: 'Decrease quantity',
                      onPressed: quantity > 1
                          ? () => setState(() => quantity--)
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Text(
                        quantity.toString().padLeft(2, '0'),
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                    IconButton.filledTonal(
                      tooltip: 'Increase quantity',
                      onPressed: () => setState(() => quantity++),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                gap,
                Primary(
                  'Add to Cart (USD ${(s.selected.price * quantity).toStringAsFixed(2)})',
                  () {
                    s.add(s.selected, quantity);
                    s.open(24);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
  Widget cart() => Scaffold(
    appBar: AppBar(
      title: const Text('Your Orders'),
      leading: IconButton(
        onPressed: s.back,
        tooltip: 'Close',
        icon: const Icon(Icons.close),
      ),
    ),
    body: s.cart.isEmpty
        ? PageBody(
            children: [
              const SizedBox(height: 70),
              const Icon(Icons.shopping_bag_outlined, size: 80, color: orange),
              gap,
              const Center(child: Heading('Your cart is empty', size: 25)),
              smallGap,
              const Note(
                'Find something delicious to start your order.',
                align: TextAlign.center,
              ),
              gap,
              Primary('Browse Foods', () => s.open(48)),
            ],
          )
        : PageBody(
            children: [
              for (final e in s.cart.entries) cartLine(e.key, e.value),
              gap,
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: promo,
                      decoration: const InputDecoration(
                        hintText: 'Promo code: EAT10',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 92,
                    child: Primary(
                      'Apply',
                      () => message(
                        context,
                        s.applyPromo(promo.text)
                            ? '10% discount applied'
                            : 'Try the demo code EAT10',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              amount('Subtotal', s.subtotal),
              amount('Shipping Fees', s.shipping),
              amount('Discount', -s.discount),
              const Divider(),
              amount('Total (incl. VAT)', s.total, bold: true),
              gap,
              Primary('Continue Pay', () => s.open(25)),
              smallGap,
              const Note(
                'All prices in USD · Demo checkout only',
                align: TextAlign.center,
              ),
            ],
          ),
  );
  Widget cartLine(String id, int count) {
    final f = foods.firstWhere((f) => f.id == id);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 23,
                height: 23,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Text('$count', style: const TextStyle(color: orange)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      f.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Note(f.description),
                    Row(
                      children: [
                        IconButton(
                          tooltip: 'Remove one ${f.name}',
                          visualDensity: VisualDensity.compact,
                          onPressed: () => s.quantity(id, -1),
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            size: 20,
                          ),
                        ),
                        Text('$count'),
                        IconButton(
                          tooltip: 'Add one ${f.name}',
                          visualDensity: VisualDensity.compact,
                          onPressed: () => s.quantity(id, 1),
                          icon: const Icon(Icons.add_circle_outline, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                (f.price * count).toStringAsFixed(2),
                style: const TextStyle(
                  color: orange,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget amount(String label, double value, {bool bold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
        Text(
          'USD ${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 13,
            color: value < 0 ? orange : null,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    ),
  );
  Widget payment() => Scaffold(
    appBar: AppBar(
      title: const Text('Payment'),
      leading: BackButton(onPressed: s.back),
    ),
    body: Form(
      key: form,
      child: PageBody(
        children: [
          const Note('Demo payment · No money will be charged'),
          gap,
          for (final method in ['Cash', 'Visa', 'Mastercard', 'PayPal'])
            OptionTile<String>(
              value: method,
              groupValue: s.payment,
              activeColor: orange,
              contentPadding: EdgeInsets.zero,
              title: Text(method),
              secondary: Icon(
                method == 'Cash' ? Icons.payments_outlined : Icons.credit_card,
                color: orange,
              ),
              onChanged: (v) {
                s.payment = v!;
                s.refresh();
              },
            ),
          gap,
          const DemoCard(),
          gap,
          OutlinedButton.icon(
            onPressed: () => setState(() => addCard = !addCard),
            icon: const Icon(Icons.add),
            label: const Text('Add New demo card'),
          ),
          if (addCard) ...[
            gap,
            const Note(
              'Use test number 4242 4242 4242 4242. Do not enter a real card.',
            ),
            smallGap,
            Field(
              'Test card number',
              controller: card,
              keyboard: TextInputType.number,
              validator: (v) => v?.replaceAll(' ', '') == '4242424242424242'
                  ? null
                  : 'Use test number 4242 4242 4242 4242',
            ),
            Field(
              'MM/YY',
              controller: expiry,
              keyboard: TextInputType.datetime,
              validator: (v) =>
                  RegExp(r'^(0[1-9]|1[0-2])/\d{2}$').hasMatch(v ?? '')
                  ? null
                  : 'Use MM/YY',
            ),
            Field(
              'CVC (test)',
              controller: cvc,
              keyboard: TextInputType.number,
              validator: (v) => RegExp(r'^\d{3}$').hasMatch(v ?? '')
                  ? null
                  : 'Enter 3 test digits',
            ),
          ],
          gap,
          amount('Total', s.total, bold: true),
          gap,
          Primary('Pay & Confirm (Demo)', () {
            if (addCard && !form.currentState!.validate()) return;
            if (s.cart.isEmpty) {
              message(context, 'Add food to your cart first');
              return;
            }
            s.checkout();
          }),
        ],
      ),
    ),
  );
  Widget history() => Scaffold(
    appBar: AppBar(
      title: const Text('Your Orders'),
      leading: BackButton(onPressed: s.back),
    ),
    bottomNavigationBar: BottomTabs(s),
    body: PageBody(
      children: [
        const Section('Upcoming Orders'),
        if (s.orders.isEmpty) ...[
          const SizedBox(height: 45),
          const Icon(Icons.receipt_long_outlined, size: 68, color: orange),
          gap,
          const Note(
            'No orders yet. Your demo orders will appear here.',
            align: TextAlign.center,
          ),
          gap,
          Primary('Explore restaurants', s.home),
        ],
        for (final order in s.orders) ...[
          Note('Order ${order.id} · Preparing'),
          for (final e in order.items.entries)
            FoodRow(
              foods.firstWhere((f) => f.id == e.key),
              onTap: () => s.choose(foods.firstWhere((f) => f.id == e.key)),
            ),
          amount('Order total', order.total, bold: true),
          OutlinedButton(
            onPressed: () {
              for (final e in order.items.entries) {
                s.add(foods.firstWhere((f) => f.id == e.key), e.value);
              }
              s.open(36);
            },
            child: const Text('Reorder'),
          ),
          gap,
          const Divider(),
        ],
        gap,
        const Section('Past Orders'),
        const Note('Completed orders will be listed here.'),
      ],
    ),
  );
  Widget success() {
    final order = s.orders.isEmpty ? null : s.orders.first;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
        leading: BackButton(onPressed: s.back),
      ),
      body: PageBody(
        children: [
          const SizedBox(height: 65),
          Center(
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: orange.withValues(alpha: .12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: orange, size: 70),
            ),
          ),
          const SizedBox(height: 35),
          const Center(child: Heading('Great!', size: 34)),
          smallGap,
          Center(
            child: Heading(
              order == null
                  ? 'Order confirmation preview'
                  : 'Order placed successfully',
              size: 23,
            ),
          ),
          gap,
          const Note(
            'Your demo order is confirmed. Estimated preparation time is 25 minutes. Enjoy your food :)',
            align: TextAlign.center,
          ),
          gap,
          amount('Total Pay', order?.total ?? 0, bold: true),
          const Note(
            'Local demonstration — no real delivery or payment.',
            align: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Primary('Keep Browsing', s.home),
          smallGap,
          OutlinedButton(
            onPressed: () => s.open(35),
            child: const Text('View Orders'),
          ),
        ],
      ),
    );
  }
}

class DemoCard extends StatelessWidget {
  const DemoCard({super.key});
  @override
  Widget build(BuildContext context) => Container(
    height: 197,
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      color: const Color(0xFFFD6920),
      borderRadius: BorderRadius.circular(16),
    ),
    child: const DefaultTextStyle(
      style: TextStyle(fontFamily: 'Manrope', color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.memory, color: Colors.white70, size: 32),
              Spacer(),
              Text(
                'VISA',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          Spacer(),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '••••  ••••  ••••  1234',
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'DEMO CARD\nMichele Jordaan',
                  style: TextStyle(fontSize: 11, height: 1.5),
                ),
              ),
              Flexible(
                child: Text(
                  'VALID THRU\n01/29',
                  style: TextStyle(fontSize: 11, height: 1.5),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
