import 'package:flutter/material.dart';

import '../core/app_controller.dart';
import '../core/theme.dart';
import '../shared/widgets.dart';

class AuthScreen extends StatefulWidget {
  final AppController state;
  const AuthScreen(this.state, {super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController(), email = TextEditingController();
  final password = TextEditingController(), confirm = TextEditingController();
  final code = TextEditingController(), phone = TextEditingController();
  AppController get s => widget.state;
  int get n => s.screen;
  @override
  void initState() {
    super.initState();
    if ([5, 10].contains(n)) {
      name.text = s.name;
      email.text = s.email;
      password.text = 'eateries123';
    }
  }

  @override
  void dispose() {
    for (final c in [name, email, password, confirm, code, phone]) {
      c.dispose();
    }
    super.dispose();
  }

  String? requiredValue(String? v) =>
      v == null || v.trim().isEmpty ? 'Please fill in this field' : null;
  String? validEmail(String? v) =>
      v != null && RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v)
      ? null
      : 'Enter a valid email address';
  String? validPassword(String? v) =>
      (v?.length ?? 0) >= 8 ? null : 'Use at least 8 characters';
  @override
  Widget build(BuildContext context) {
    if (n <= 3) return onboarding();
    if (n == 7) return centeredMessage();
    if (n == 13 || n == 14) return location();
    final signup = n == 9 || n == 10;
    final login = n == 4 || n == 5;
    final title = signup
        ? 'Account'
        : login
        ? 'Sign in'
        : n == 6
        ? 'Forgot password'
        : n == 8
        ? 'Change password'
        : 'Phone Number';
    final heading = signup
        ? 'Create Account'
        : login
        ? 'Welcome Back!'
        : n == 6
        ? 'Forgot password'
        : n == 8
        ? 'Create new password'
        : n == 11
        ? 'Get Started'
        : 'Verify phone number';
    final subtitle = signup
        ? 'Please create your account, Enter\nyour details'
        : login
        ? 'Please login your account, Enter\nyour details'
        : n == 6
        ? 'Enter your email address and we will send\nyou a reset password.'
        : n == 8
        ? 'Your new password must be different from\nprevious used password.'
        : n == 11
        ? 'Enter your phone number to use Eateries\nand enjoy your food.'
        : 'Enter the 4-digit demo code 1234\nfor your phone number.';
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: s.canBack ? BackButton(onPressed: s.back) : null,
      ),
      body: Form(
        key: form,
        child: PageBody(
          children: [
            Heading(heading, size: 31),
            smallGap,
            Note(subtitle),
            const SizedBox(height: 30),
            if (login || signup) ...[
              OutlinedButton.icon(
                onPressed: () => message(
                  context,
                  'Google sign-in requires a connected backend. Use the demo form below.',
                ),
                icon: const Text(
                  'G',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF4285F4),
                  ),
                ),
                label: Text(
                  signup ? 'Sign up with google' : 'Sign in with google',
                ),
              ),
              gap,
              LayoutBuilder(
                builder: (context, box) => Row(
                  children: [
                    const Expanded(child: Divider()),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: box.maxWidth - 48),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Note(
                          signup
                              ? 'or sign up with email'
                              : 'or sign in with email',
                          align: TextAlign.center,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              if (signup)
                Field('Full Name', controller: name, validator: requiredValue),
              Field(
                'Email address',
                controller: email,
                validator: validEmail,
                keyboard: TextInputType.emailAddress,
              ),
              Field(
                'Password',
                controller: password,
                password: true,
                validator: validPassword,
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: s.remember,
                            shape: const CircleBorder(),
                            activeColor: orange,
                            onChanged: (v) => setState(() => s.remember = v!),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Flexible(
                          child: Text(
                            'Remember me',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => signup ? showTerms() : s.open(6),
                        child: Text(
                          signup ? 'Terms & conditions' : 'Forgot password?',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              gap,
              Primary(signup ? 'Create account' : 'Sign In', () {
                if (!form.currentState!.validate()) return;
                s.email = email.text.trim();
                if (signup) s.name = name.text.trim();
                s.beginSession();
                s.open(13);
              }),
              smallGap,
              TextButton(
                onPressed: () => s.open(signup ? 4 : 9),
                child: Text(
                  signup
                      ? 'Already have an account? Login'
                      : 'Not registered yet? Create an account',
                ),
              ),
              if (login)
                TextButton(
                  onPressed: () => s.open(11),
                  child: const Text('Continue with phone number'),
                ),
              const Note(
                'Local demo · No real account is created',
                align: TextAlign.center,
              ),
            ] else if (n == 6) ...[
              Field(
                'Email address',
                controller: email,
                validator: validEmail,
                keyboard: TextInputType.emailAddress,
              ),
              gap,
              Primary('Reset password', () {
                if (form.currentState!.validate()) s.open(7);
              }),
              smallGap,
              const Note('Demo recovery flow; no email will be sent.'),
            ] else if (n == 8) ...[
              Field(
                'New password',
                controller: password,
                password: true,
                validator: validPassword,
              ),
              Field(
                'Confirm password',
                controller: confirm,
                password: true,
                validator: (v) => v == password.text
                    ? validPassword(v)
                    : 'Passwords do not match',
              ),
              const Note('Password must be at least 8 characters'),
              gap,
              Primary('Reset password', () {
                if (form.currentState!.validate()) {
                  message(context, 'Demo password updated');
                  s.open(4);
                }
              }),
            ] else if (n == 11) ...[
              Field(
                'Phone number',
                prefix: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('+1'),
                ),
                controller: phone,
                keyboard: TextInputType.phone,
                validator: (v) =>
                    (v?.replaceAll(RegExp(r'\D'), '').length ?? 0) >= 7
                    ? null
                    : 'Enter a valid phone number',
              ),
              gap,
              Primary('Continue', () {
                if (form.currentState!.validate()) {
                  s.phone = phone.text;
                  s.open(12);
                }
              }),
              gap,
              const Note('Demo mode: the verification code is 1234.'),
            ] else ...[
              Field(
                '4-digit code',
                controller: code,
                keyboard: TextInputType.number,
                validator: (v) => v == '1234' ? null : 'Use the demo code 1234',
              ),
              gap,
              Primary('Verify number', () {
                if (form.currentState!.validate()) {
                  s.beginSession();
                  s.open(13);
                }
              }),
              TextButton(
                onPressed: () =>
                    message(context, 'Demo code: 1234. No SMS sent.'),
                child: const Text('Resend again'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget onboarding() => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, box) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: box.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  SizedBox(height: box.maxHeight * .1),
                  Photo(
                    'onboarding$n',
                    width: 324,
                    height: 324,
                    fit: BoxFit.contain,
                    radius: 0,
                  ),
                  const SizedBox(height: 30),
                  Heading(
                    [
                      'Order Online Food',
                      'Free Home Delivery',
                      'Choose your food',
                    ][n - 1],
                    size: 28,
                  ),
                  smallGap,
                  Note(
                    n == 2
                        ? 'Free delivery for new customers via Apple Pay\nand other payment methods.'
                        : 'Easily find your type of food craving and you’ll\nget delivery in wide range.',
                    align: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (i) => Container(
                        width: 14,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: i == n - 1 ? orange : const Color(0xFFDDDDDD),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 65),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27),
                    child: Primary(
                      'Get started',
                      () => s.open(n == 3 ? 4 : n + 1),
                    ),
                  ),
                  const SizedBox(height: 35),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  Widget centeredMessage() => Scaffold(
    appBar: AppBar(leading: BackButton(onPressed: s.back)),
    body: PageBody(
      children: [
        const SizedBox(height: 28),
        const Center(child: Photo('mail', width: 140, height: 140)),
        gap,
        const Center(child: Heading('Check your mail')),
        smallGap,
        const Note(
          'We have sent a password recovery\ninstruction preview to your email.',
          align: TextAlign.center,
        ),
        const SizedBox(height: 30),
        Primary('Continue demo reset', () => s.open(8)),
        TextButton(
          onPressed: () => message(context, 'Demo mode — no email sent.'),
          child: const Text('Send again'),
        ),
        const SizedBox(height: 80),
        const Note(
          'Did not receive the email? This local demo does not send mail. Continue above to preview password reset.',
          align: TextAlign.center,
        ),
      ],
    ),
  );
  Widget location() => Scaffold(
    appBar: AppBar(leading: BackButton(onPressed: s.back)),
    body: PageBody(
      children: [
        const Heading('Find restaurants near you', size: 26),
        smallGap,
        const Note(
          'Please enter your location or allow access to\nyour locations to find restaurants near you.',
        ),
        gap,
        if (n == 13) ...[
          Primary('Use current location', () {
            s.address = 'Washington DC, City Mall';
            s.save();
            s.home();
          }),
          smallGap,
          OutlinedButton.icon(
            onPressed: () => s.open(14),
            icon: const Icon(Icons.location_on_outlined),
            label: const Text('Enter new address'),
          ),
          gap,
          const Note(
            'Demo location is Washington DC; device location is not requested.',
          ),
        ] else ...[
          Field(
            'Washington',
            controller: name,
            prefix: const Icon(Icons.search),
            onSubmitted: (v) {
              if (v.trim().isNotEmpty) {
                s.address = v.trim();
                s.save();
                s.home();
              }
            },
          ),
          for (final location in [
            'Washington DC',
            'Washington DC City Hall',
            'Washington DC, CA',
            'San Francisco',
          ])
            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: Text(location),
              subtitle: const Text('United States'),
              onTap: () {
                s.address = location;
                s.save();
                s.home();
              },
            ),
        ],
      ],
    ),
  );
  void showTerms() => showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (c) => const Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Heading('Demo terms'),
          gap,
          Note(
            'This app is an offline UI demonstration. No real accounts, deliveries or payments are created.',
          ),
          gap,
        ],
      ),
    ),
  );
}
