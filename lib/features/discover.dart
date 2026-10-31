import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../core/theme.dart';
import '../shared/widgets.dart';

class DiscoverScreen extends StatefulWidget {
  final AppController state;
  final VoidCallback onGallery;
  const DiscoverScreen(this.state, {super.key, required this.onGallery});
  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final query = TextEditingController();
  AppController get s => widget.state;
  int get n => s.screen;
  @override
  void initState() {
    super.initState();
    query.text = s.search;
  }

  @override
  void dispose() {
    query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (n >= 26 && n <= 29) return filters();
    if (n >= 30 && n <= 34) return search();
    final home = n >= 15 && n <= 18;
    final grid = [16, 18, 20].contains(n);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          home
              ? 'Home'
              : n == 48
              ? 'Browse Foods'
              : 'Featured Partners',
        ),
        leading: home
            ? IconButton(
                tooltip: 'All design screens',
                onPressed: widget.onGallery,
                icon: const Icon(Icons.grid_view_outlined, size: 20),
              )
            : BackButton(onPressed: s.back),
        actions: [
          CartAction(s),
          IconButton(
            tooltip: 'Profile',
            onPressed: () => s.open(38),
            icon: const Photo('avatar', width: 36, height: 36, radius: 20),
          ),
        ],
      ),
      bottomNavigationBar: BottomTabs(s),
      body: PageBody(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 24),
        children: [
          if (home) ...[searchBar(), gap],
          if (n == 15) ...[
            InkWell(
              onTap: () => s.open(43),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: orange,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: orange.withValues(alpha: .15),
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Delivery to Home',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            s.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          smallGap,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '2.4km',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
          if ([15, 16].contains(n)) ...[
            Section('Top of week', onAll: () => s.open(19)),
            horizontalFoods(foods.take(2).toList()),
            gap,
          ],
          if (n == 15) ...[
            promotion(),
            const SizedBox(height: 30),
            Section('Best picks\nRestaurants by team', onAll: () => s.open(20)),
            horizontalFoods([foods[0], foods[2]]),
            const SizedBox(height: 30),
          ],
          if ([17, 18].contains(n)) ...[
            Section('All Categories', onAll: () => s.open(31)),
            categoryList(),
            gap,
          ],
          if (!grid) ...[
            if (home) Section('All Restaurants', onAll: () => s.open(48)),
            for (var i = 0; i < 3; i++)
              RestaurantCard(i, onTap: () => s.open(i.isEven ? 21 : 22)),
          ] else
            foodGrid(foods),
          if (n == 17) ...[
            Section('New Restaurants', onAll: () => s.open(20)),
            horizontalFoods([foods[0], foods[1]]),
          ],
        ],
      ),
    );
  }

  Widget searchBar() => Row(
    children: [
      Expanded(
        child: TextField(
          controller: query,
          readOnly: n < 30,
          onTap: n < 30 ? () => s.open(32) : null,
          onSubmitted: s.applySearch,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search, size: 22),
            hintText: 'Search on food',
          ),
        ),
      ),
      if (n >= 30)
        IconButton(
          tooltip: 'Filters',
          onPressed: () => s.open(29),
          icon: const Icon(Icons.tune),
        ),
    ],
  );
  Widget horizontalFoods(List<Food> list) => SizedBox(
    height: 255,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      separatorBuilder: (_, _) => const SizedBox(width: 14),
      itemBuilder: (_, i) => SizedBox(
        width: 200,
        child: FoodCard(
          list[i],
          onTap: () {
            s.selected = list[i];
            s.open(21);
          },
        ),
      ),
    ),
  );
  Widget foodGrid(List<Food> list) => LayoutBuilder(
    builder: (context, box) => Wrap(
      spacing: 14,
      runSpacing: 24,
      children: list
          .map(
            (f) => SizedBox(
              width: (box.maxWidth - 14) / 2,
              child: FoodCard(f, small: true, onTap: () => s.choose(f)),
            ),
          )
          .toList(),
    ),
  );
  Widget promotion() => InkWell(
    onTap: () {
      s.search = '';
      s.category = 'All Type';
      s.open(48);
    },
    child: Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDC39),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const DefaultTextStyle(
        style: TextStyle(color: Colors.black, fontFamily: 'Manrope'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chicken Teriyaki',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 5),
            Text('Get discount up to 30% off', style: TextStyle(fontSize: 12)),
            SizedBox(height: 24),
            Text(
              'You’ve to order at least \$10 for get\ndiscount 30% off for 1 month.',
              style: TextStyle(height: 1.6, fontSize: 14),
            ),
          ],
        ),
      ),
    ),
  );
  Widget categoryList({bool applyImmediately = true}) {
    final items = [
      ('Burgers', 'burger_food'),
      ('Pizza', 'pizza'),
      ('Soups', 'soup'),
      ('Breakfast', 'eggs'),
    ];
    return SizedBox(
      height: 134,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemCount: items.length,
        itemBuilder: (_, i) => InkWell(
          onTap: () {
            s.category = items[i].$1;
            if (applyImmediately) {
              s.search = '';
              s.open(33);
            } else {
              s.refresh();
            }
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: s.category == items[i].$1
                        ? orange
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Photo(items[i].$2, width: 90, height: 90, radius: 50),
              ),
              smallGap,
              Text(items[i].$1, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  Widget search() {
    final results = n == 33 || n == 34;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: s.back),
        title: Text(
          results ? (s.search.isEmpty ? 'Burgers' : s.search) : 'Search',
        ),
        actions: [
          if (results)
            TextButton.icon(
              onPressed: () => s.open(29),
              icon: const Icon(Icons.tune, size: 18),
              label: const Text('Filter'),
            ),
          CartAction(s),
        ],
      ),
      bottomNavigationBar: n <= 31 ? BottomTabs(s) : null,
      body: PageBody(
        children: [
          if (!results) ...[searchBar(), gap],
          if (n == 32) ...[
            Row(
              children: [
                const Expanded(child: Heading('Recent Searches', size: 19)),
                TextButton(
                  onPressed: () {
                    s.recent.clear();
                    s.save();
                    s.refresh();
                  },
                  child: const Text('Clear all'),
                ),
              ],
            ),
            if (s.recent.isEmpty)
              const Note('Your recent searches will appear here.'),
            for (final term in s.recent)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.history, size: 20),
                title: Text(term),
                trailing: const Icon(Icons.north_west, size: 17),
                onTap: () => s.applySearch(term),
              ),
          ] else if (n == 31) ...[
            const Section('Top Categories'),
            foodGrid(foods),
            gap,
            categoryList(),
          ] else if (results) ...[
            Note('${s.results.length} results found'),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () => s.open(n == 33 ? 34 : 33),
                  icon: Icon(n == 33 ? Icons.grid_view : Icons.view_list),
                  label: const Text('Change view'),
                ),
                TextButton(
                  onPressed: () => s.open(32),
                  child: const Text('Search Again'),
                ),
              ],
            ),
            if (s.results.isEmpty) ...[
              const SizedBox(height: 60),
              const Icon(Icons.search_off, size: 64, color: orange),
              gap,
              const Center(child: Heading('No foods found', size: 24)),
              smallGap,
              const Note(
                'Try another search or clear your filters.',
                align: TextAlign.center,
              ),
              gap,
              Primary('Clear filters', () {
                s.resetFilters();
                s.search = '';
                s.refresh();
              }),
            ] else if (n == 34)
              foodGrid(s.results)
            else
              for (final f in s.results) ...[
                FoodRow(f, onTap: () => s.choose(f)),
                const Divider(),
              ],
          ] else ...[
            const Section('Top of week'),
            foodGrid(foods),
          ],
        ],
      ),
    );
  }

  Widget filters() {
    final tab = n - 26;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Close filters',
                    onPressed: s.back,
                    icon: const Icon(Icons.close),
                  ),
                  const Spacer(),
                  if (n == 29)
                    const Text(
                      'Filters',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: s.resetFilters,
                    child: const Text('Clear all'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: List.generate(
                  4,
                  (i) => Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                      ),
                      onPressed: () => s.replace(26 + i),
                      child: Text(
                        ['Type', 'Sort by', 'Price', 'Categories'][i],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: tab == i ? orange : muted(context),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: PageBody(
                children: [
                  if (tab == 0) categoryList(applyImmediately: false),
                  if (tab == 1) ...[
                    const Section('Sort by'),
                    for (final item in [
                      'Most Popular',
                      'Recommended',
                      'Fastest Delivery',
                      'Price: low to high',
                    ])
                      OptionTile<String>(
                        value: item,
                        groupValue: s.sort,
                        activeColor: orange,
                        title: Text(item),
                        onChanged: (v) {
                          s.sort = v!;
                          s.refresh();
                        },
                      ),
                  ],
                  if (tab >= 2) ...[
                    const Section('Price Range'),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: ChoiceChip(
                              showCheckmark: false,
                              label: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(r'$' * (i + 1)),
                              ),
                              selected: s.priceLevel == i + 1,
                              selectedColor: orange.withValues(alpha: .2),
                              onSelected: (_) {
                                s.priceLevel = i + 1;
                                s.refresh();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    smallGap,
                    Note('Maximum item price: USD ${s.priceLevel * 5}'),
                  ],
                  if (tab == 3) ...[
                    gap,
                    const Section('All Categories'),
                    Wrap(
                      spacing: 9,
                      runSpacing: 12,
                      children:
                          [
                                'All Type',
                                'Chinese',
                                'Salads',
                                'Soups',
                                'Breakfast',
                                'Pizza',
                                'Burgers',
                                'Desserts',
                                'Dinner',
                              ]
                              .map(
                                (c) => ChoiceChip(
                                  label: Text(c),
                                  selected: s.category == c,
                                  selectedColor: orange.withValues(alpha: .2),
                                  onSelected: (_) {
                                    s.category = c;
                                    s.refresh();
                                  },
                                ),
                              )
                              .toList(),
                    ),
                  ],
                  gap,
                  Primary(tab == 3 ? 'Apply Filters' : 'Complete', () {
                    s.open(33);
                  }),
                  if (tab < 3) ...[
                    gap,
                    const Divider(),
                    gap,
                    const Opacity(opacity: .55, child: Heading('Top of week')),
                    gap,
                    Opacity(
                      opacity: .55,
                      child: horizontalFoods(foods.take(2).toList()),
                    ),
                    gap,
                    Opacity(opacity: .55, child: promotion()),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
