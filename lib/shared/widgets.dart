import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../core/theme.dart';

const gap = SizedBox(height: 22);

class CartAction extends StatelessWidget {
  final AppController state;
  const CartAction(this.state, {super.key});
  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: 'Cart',
    onPressed: () => state.open(24),
    icon: Badge.count(
      count: state.count,
      isLabelVisible: state.count > 0,
      backgroundColor: orange,
      child: const Icon(Icons.shopping_bag_outlined),
    ),
  );
}

class OptionTile<T> extends StatelessWidget {
  final T value, groupValue;
  final ValueChanged<T?> onChanged;
  final Widget title;
  final Widget? subtitle, secondary;
  final Color? activeColor;
  final EdgeInsetsGeometry? contentPadding;
  const OptionTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.subtitle,
    this.secondary,
    this.activeColor,
    this.contentPadding,
  });
  @override
  Widget build(BuildContext context) => RadioGroup<T>(
    groupValue: groupValue,
    onChanged: onChanged,
    child: RadioListTile<T>(
      value: value,
      title: title,
      subtitle: subtitle,
      secondary: secondary,
      activeColor: activeColor,
      contentPadding: contentPadding,
    ),
  );
}

const smallGap = SizedBox(height: 12);
bool isDark(BuildContext c) => Theme.of(c).brightness == Brightness.dark;
Color muted(BuildContext c) =>
    isDark(c) ? Colors.white54 : const Color(0xFF8D8D8D);

class Heading extends StatelessWidget {
  final String text;
  final double size;
  const Heading(this.text, {super.key, this.size = 28});
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w600,
      height: 1.25,
      letterSpacing: -.8,
    ),
  );
}

class Note extends StatelessWidget {
  final String text;
  final TextAlign align;
  const Note(this.text, {super.key, this.align = TextAlign.start});
  @override
  Widget build(BuildContext context) => Text(
    text,
    textAlign: align,
    style: TextStyle(color: muted(context), height: 1.55, fontSize: 14),
  );
}

class Primary extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const Primary(this.label, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) =>
      FilledButton(onPressed: onTap, child: Text(label));
}

class Photo extends StatelessWidget {
  final String name;
  final double? width, height;
  final double radius;
  final BoxFit fit;
  const Photo(
    this.name, {
    super.key,
    this.width,
    this.height,
    this.radius = 10,
    this.fit = BoxFit.cover,
  });
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: Image.asset(
      'assets/images/$name.webp',
      width: width,
      height: height,
      fit: fit,
    ),
  );
}

class PageBody extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets padding;
  const PageBody({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.fromLTRB(20, 24, 20, 30),
  });
  @override
  Widget build(BuildContext context) => ListView(
    padding: padding,
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    children: children,
  );
}

class Field extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final bool password;
  final String? Function(String?)? validator;
  final TextInputType? keyboard;
  final ValueChanged<String>? onSubmitted;
  final Widget? prefix;
  const Field(
    this.hint, {
    super.key,
    this.controller,
    this.password = false,
    this.validator,
    this.keyboard,
    this.onSubmitted,
    this.prefix,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextFormField(
      controller: controller,
      obscureText: password,
      validator: validator,
      keyboardType: keyboard,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(hintText: hint, prefixIcon: prefix),
    ),
  );
}

class Section extends StatelessWidget {
  final String title;
  final VoidCallback? onAll;
  const Section(this.title, {super.key, this.onAll});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      children: [
        Expanded(child: Heading(title, size: 23)),
        if (onAll != null)
          TextButton(onPressed: onAll, child: const Text('See all')),
      ],
    ),
  );
}

class Rating extends StatelessWidget {
  final bool compact;
  final int minutes;
  const Rating({super.key, this.compact = false, this.minutes = 30});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: orange,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Text(
          '4.5',
          style: TextStyle(fontSize: 11, color: Colors.white),
        ),
      ),
      const SizedBox(width: 8),
      Flexible(
        child: Text(
          compact ? '$minutes min · Free' : '$minutes min  ·  Free delivery',
          maxLines: 1,
          style: TextStyle(fontSize: 11, color: muted(context)),
        ),
      ),
    ],
  );
}

class FoodCard extends StatelessWidget {
  final Food food;
  final VoidCallback onTap;
  final bool small;
  const FoodCard(
    this.food, {
    super.key,
    required this.onTap,
    this.small = false,
  });
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Photo(food.image, height: small ? 140 : 160, width: double.infinity),
        const SizedBox(height: 10),
        Text(
          food.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: small ? 15 : 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          small ? '\$\$ · ${food.category}' : 'Washington DC, city mall',
          maxLines: 1,
          style: TextStyle(color: muted(context), fontSize: small ? 12 : 13),
        ),
        const SizedBox(height: 10),
        Rating(compact: true, minutes: food.minutes),
      ],
    ),
  );
}

class RestaurantCard extends StatelessWidget {
  final int index;
  final VoidCallback onTap;
  const RestaurantCard(this.index, {super.key, required this.onTap});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Photo(
            index.isEven ? 'burger' : 'burger2',
            width: double.infinity,
            height: 185,
          ),
          smallGap,
          Text(
            index.isEven ? "McDonald's" : 'Burger King',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          const Note(r'$$  ·  Chinese  ·  American  ·  Deshi food'),
          const SizedBox(height: 9),
          Row(
            children: [
              const Text('4.3', style: TextStyle(fontSize: 12)),
              const Icon(Icons.star, color: orange, size: 16),
              Flexible(
                child: Text(
                  ' 500+ Ratings     ◷ 25 Min     Free',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: muted(context)),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class FoodRow extends StatelessWidget {
  final Food food;
  final VoidCallback onTap;
  const FoodRow(this.food, {super.key, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Photo(food.image, width: 90, height: 90),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Note(food.description),
                const SizedBox(height: 8),
                Text(
                  'USD ${food.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class BottomTabs extends StatelessWidget {
  final AppController state;
  const BottomTabs(this.state, {super.key});
  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.local_offer_outlined, 'Offers', 19),
      (Icons.search, 'Search', 30),
      (Icons.home_outlined, 'Home', 15),
      (Icons.receipt_long_outlined, 'Orders', 35),
      (Icons.person_outline, 'Profile', 38),
    ];
    return SafeArea(
      top: false,
      child: Container(
        height: 74,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: Row(
          children: items.map((i) {
            final active =
                i.$3 == state.screen ||
                (i.$3 == 15 && state.screen >= 16 && state.screen <= 18);
            return Expanded(
              child: Semantics(
                button: true,
                label: i.$2,
                child: InkWell(
                  onTap: () => state.open(i.$3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: active
                            ? const BoxDecoration(
                                color: orange,
                                shape: BoxShape.circle,
                              )
                            : null,
                        child: Icon(
                          i.$1,
                          size: 23,
                          color: active ? Colors.white : muted(context),
                        ),
                      ),
                      if (!active)
                        Text(
                          i.$2,
                          style: TextStyle(fontSize: 10, color: muted(context)),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

void message(BuildContext context, String text) => ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(
    SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
  );
