import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_controller.dart';
import '../core/theme.dart';
import '../shared/widgets.dart';
import 'orders.dart';

class AccountScreen extends StatefulWidget {
  final AppController state;
  const AccountScreen(this.state, {super.key});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(),
      email = TextEditingController(),
      phone = TextEditingController();
  final password = TextEditingController(),
      confirm = TextEditingController(),
      query = TextEditingController();
  int helpTab = 0;
  AppController get s => widget.state;
  int get n => s.screen;
  @override
  void initState() {
    super.initState();
    name.text = s.name;
    email.text = s.email;
    phone.text = s.phone;
  }

  @override
  void dispose() {
    for (final c in [name, email, phone, password, confirm, query]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (n == 38) return settings();
    if (n == 45 || n == 46) return refer();
    if (n == 47) return help();
    final title = {
      39: 'Profile Settings',
      40: 'Change Password',
      41: 'Payment Method',
      42: 'Payment Method',
      43: 'Locations',
      44: 'Add Social Account',
    }[n]!;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: BackButton(onPressed: s.back),
      ),
      body: Form(
        key: form,
        child: PageBody(
          children: [
            if (n == 39) ...[
              const Center(
                child: Photo('avatar', width: 90, height: 90, radius: 50),
              ),
              gap,
              const Note('Full name'),
              smallGap,
              Field(
                'John Smith',
                controller: name,
                validator: (v) =>
                    (v?.trim().isNotEmpty ?? false) ? null : 'Enter your name',
              ),
              const Note('Email address'),
              smallGap,
              Field(
                'Email',
                controller: email,
                keyboard: TextInputType.emailAddress,
                validator: (v) =>
                    RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v ?? '')
                    ? null
                    : 'Enter a valid email',
              ),
              const Note('Phone number'),
              smallGap,
              Field(
                'Phone',
                controller: phone,
                keyboard: TextInputType.phone,
                validator: (v) =>
                    (v?.replaceAll(RegExp(r'\D'), '').length ?? 0) >= 7
                    ? null
                    : 'Enter a valid phone',
              ),
              gap,
              Primary('Change Profile', () {
                if (!form.currentState!.validate()) return;
                s.name = name.text.trim();
                s.email = email.text.trim();
                s.phone = phone.text.trim();
                s.save();
                message(context, 'Profile saved on this device');
              }),
            ] else if (n == 40) ...[
              const Heading('Change password', size: 27),
              smallGap,
              const Note('Preview a password update in this local demo.'),
              gap,
              Field(
                'New Password',
                controller: password,
                password: true,
                validator: (v) =>
                    (v?.length ?? 0) >= 8 ? null : 'Use at least 8 characters',
              ),
              Field(
                'Confirm Password',
                controller: confirm,
                password: true,
                validator: (v) =>
                    v == password.text ? null : 'Passwords do not match',
              ),
              gap,
              Primary('Change password', () {
                if (form.currentState!.validate()) {
                  password.clear();
                  confirm.clear();
                  message(
                    context,
                    'Demo password updated. No remote account was changed.',
                  );
                }
              }),
            ] else if (n == 41) ...[
              const DemoCard(),
              const SizedBox(height: 35),
              const Center(child: Heading('Add a payment method', size: 24)),
              smallGap,
              const Note(
                'Use a sample card to preview the checkout experience.',
                align: TextAlign.center,
              ),
              const SizedBox(height: 60),
              Primary('Add Credit Cards', () => s.open(25)),
              smallGap,
              OutlinedButton(
                onPressed: () => s.open(42),
                child: const Text('View payment methods'),
              ),
            ] else if (n == 42) ...[
              for (final method in ['Cash', 'Visa', 'Mastercard', 'PayPal'])
                OptionTile<String>(
                  value: method,
                  groupValue: s.payment,
                  activeColor: orange,
                  secondary: Icon(
                    method == 'Cash'
                        ? Icons.payments_outlined
                        : Icons.credit_card_outlined,
                    color: orange,
                  ),
                  title: Text(method),
                  subtitle: const Text('Demo payment method'),
                  onChanged: (v) {
                    s.payment = v!;
                    s.refresh();
                  },
                ),
              gap,
              Primary('Use payment method', () {
                message(context, 'Default method updated');
                s.back();
              }),
            ] else if (n == 43) ...[
              Field(
                'Search address',
                controller: query,
                prefix: const Icon(Icons.search),
                onSubmitted: (v) {
                  if (v.trim().isNotEmpty) saveLocation(v);
                },
              ),
              gap,
              const Section('Recent Address'),
              for (final location in {
                s.address,
                'Washington DC',
                'Washington DC City Hall',
                'Washington DC Zoo',
                'Washington DC Colorado',
              })
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(location),
                  trailing: s.address == location
                      ? const Icon(Icons.check, color: orange)
                      : null,
                  onTap: () => saveLocation(location),
                ),
              gap,
              const Note(
                'Enter an address and press enter to save a custom location.',
              ),
            ] else if (n == 44) ...[
              const Heading('Add Social Accounts', size: 27),
              smallGap,
              const Note(
                'Choose social services for this demo profile. These switches do not connect real accounts.',
              ),
              gap,
              for (var i = 0; i < 4; i++)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeThumbColor: orange,
                  title: Text(
                    ['WhatsApp', 'Instagram', 'Twitter', 'Snapchat'][i],
                  ),
                  secondary: Icon(
                    [
                      Icons.chat_bubble_outline,
                      Icons.camera_alt_outlined,
                      Icons.alternate_email,
                      Icons.emoji_emotions_outlined,
                    ][i],
                  ),
                  value: s.socials[i],
                  onChanged: (v) {
                    s.socials[i] = v;
                    s.refresh();
                  },
                ),
              const SizedBox(height: 60),
              Primary('Save & Changes', () {
                s.save();
                message(context, 'Demo preferences saved');
              }),
            ],
          ],
        ),
      ),
    );
  }

  void saveLocation(String value) {
    s.address = value;
    s.save();
    s.refresh();
    message(context, 'Delivery address updated');
  }

  Widget settings() {
    final items = [
      (
        Icons.person,
        'Profile Information',
        'Change your account information',
        39,
      ),
      (Icons.lock, 'Change Password', 'Change your password', 40),
      (
        Icons.credit_card,
        'Payment Methods',
        'Add your credit & debit cards',
        41,
      ),
      (
        Icons.location_on,
        'Locations',
        'Add or remove your delivery locations',
        43,
      ),
      (Icons.people_alt, 'Add Social Account', 'Add Facebook, Twitter etc', 44),
      (
        Icons.ios_share,
        'Refer to Friends',
        'Get credits for referring friends',
        45,
      ),
    ];
    return Scaffold(
      bottomNavigationBar: BottomTabs(s),
      body: SafeArea(
        child: PageBody(
          children: [
            const SizedBox(height: 16),
            const Heading('Account Settings', size: 29),
            smallGap,
            const Note(
              'Update your settings like notifications,\npayments, profile edit etc.',
            ),
            gap,
            for (final item in items) ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                minLeadingWidth: 25,
                leading: Icon(item.$1, color: muted(context), size: 20),
                title: Text(
                  item.$2,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  item.$3,
                  style: TextStyle(fontSize: 12, color: muted(context)),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => s.open(item.$4),
              ),
              const Divider(height: 1),
            ],
            gap,
            const Heading('Appearance', size: 18),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: s.dark,
              activeThumbColor: orange,
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text('Dark Mode'),
              subtitle: const Text('Light / Dark Pixso themes'),
              onChanged: (_) => s.toggleTheme(),
            ),
            gap,
            const Heading('Notifications', size: 18),
            smallGap,
            for (var i = 0; i < 3; i++)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: Icon(
                  i == 1 ? Icons.sms_outlined : Icons.notifications_none,
                ),
                title: Text(
                  [
                    'Push Notifications',
                    'SMS Notifications',
                    'Promotional Notifications',
                  ][i],
                  style: const TextStyle(fontSize: 14),
                ),
                subtitle: const Text(
                  'Local preference only',
                  style: TextStyle(fontSize: 12),
                ),
                value: s.notifications[i],
                activeThumbColor: orange,
                onChanged: (v) {
                  s.notifications[i] = v;
                  s.save();
                  s.refresh();
                },
              ),
            gap,
            const Heading('More', size: 18),
            smallGap,
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.star_outline),
              title: const Text('Rate Us'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => message(
                context,
                'Thanks! This demo is not published to an app store.',
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.help_outline),
              title: const Text('FAQ'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => s.open(47),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: s.logout,
            ),
          ],
        ),
      ),
    );
  }

  Widget refer() => Scaffold(
    appBar: AppBar(leading: BackButton(onPressed: s.back)),
    body: Stack(
      children: [
        PageBody(
          children: [
            const SizedBox(height: 26),
            const Center(child: Photo('gift', width: 140, height: 140)),
            gap,
            const Center(child: Heading('Refer a friend, Get \$20', size: 27)),
            smallGap,
            const Note(
              'Get \$20 in credits when someone signs up\nusing your referral link',
              align: TextAlign.center,
            ),
            const SizedBox(height: 38),
            OutlinedButton.icon(
              onPressed: () async {
                await Clipboard.setData(
                  const ClipboardData(text: 'https://ui8.net/76738b'),
                );
                if (mounted) message(context, 'Reference link copied');
              },
              icon: const Icon(Icons.reply, size: 20),
              label: const Text('https://ui8.net/76738b'),
            ),
            const SizedBox(height: 125),
            Primary(
              'Email Address',
              () =>
                  message(context, 'Demo referral preview — no email is sent'),
            ),
            smallGap,
            OutlinedButton(
              onPressed: () => s.open(46),
              child: const Text('Others'),
            ),
          ],
        ),
        if (n == 46) ...[
          Positioned.fill(
            child: GestureDetector(
              onTap: s.back,
              child: Container(color: Colors.black45),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Heading('Share', size: 20),
                  gap,
                  Wrap(
                    spacing: 25,
                    runSpacing: 22,
                    children: [
                      for (final service in [
                        'WhatsApp',
                        'Instagram',
                        'Facebook',
                        'YouTube',
                        'LinkedIn',
                        'Snapchat',
                      ])
                        SizedBox(
                          width: 85,
                          child: InkWell(
                            onTap: () => message(
                              context,
                              'Demo preview for $service. Nothing was shared.',
                            ),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: orange.withValues(
                                    alpha: .12,
                                  ),
                                  child: Text(
                                    service[0],
                                    style: const TextStyle(color: orange),
                                  ),
                                ),
                                smallGap,
                                Text(
                                  service,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  gap,
                  Primary('Cancel', s.back),
                ],
              ),
            ),
          ),
        ],
      ],
    ),
  );
  Widget help() {
    final questions = [
      (
        'What is Eateries?',
        'Eateries helps you explore restaurants, choose food and manage delivery orders. This version demonstrates the UI locally.',
      ),
      (
        'Is the Eateries App Free?',
        'This demonstration is free to explore. No real purchases are processed.',
      ),
      (
        'How do I place an order?',
        'Choose a restaurant and a food item, add it to your cart, then continue to demo checkout.',
      ),
      (
        'How can I log out from Eateries?',
        'Open Profile, scroll to More, then select Logout.',
      ),
      (
        'How do I change my address?',
        'Open Profile → Locations and choose or enter a delivery address.',
      ),
    ];
    final filtered = questions
        .where((q) => q.$1.toLowerCase().contains(query.text.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        leading: BackButton(onPressed: s.back),
      ),
      body: PageBody(
        children: [
          Row(
            children: List.generate(
              3,
              (i) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      ['General', 'Account', 'Service'][i],
                      style: const TextStyle(fontSize: 12),
                    ),
                    selected: helpTab == i,
                    selectedColor: orange.withValues(alpha: .2),
                    onSelected: (_) => setState(() => helpTab = i),
                  ),
                ),
              ),
            ),
          ),
          gap,
          TextField(
            controller: query,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Search for help',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          gap,
          if (filtered.isEmpty)
            const Note('No matching questions. Try another search.'),
          for (final q in filtered.where(
            (q) =>
                helpTab == 0 ||
                (helpTab == 1
                    ? q == questions[3] || q == questions[4]
                    : q == questions[0] || q == questions[2]),
          ))
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(q.$1, style: const TextStyle(fontSize: 14)),
              childrenPadding: const EdgeInsets.only(bottom: 20),
              children: [Note(q.$2)],
            ),
        ],
      ),
    );
  }
}
