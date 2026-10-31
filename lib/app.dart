import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/app_controller.dart';
import 'core/screen_catalog.dart';
import 'core/theme.dart';
import 'features/auth.dart';
import 'features/discover.dart';
import 'features/orders.dart';
import 'features/account.dart';
import 'shared/widgets.dart';

class EateriesApp extends StatelessWidget {
  final AppController controller;
  const EateriesApp({super.key, required this.controller});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => MaterialApp(
      title: 'Eateries',
      debugShowCheckedModeBanner: false,
      theme: appTheme(false),
      darkTheme: appTheme(true),
      themeMode: controller.dark ? ThemeMode.dark : ThemeMode.light,
      home: AppShell(controller),
    ),
  );
}

class AppShell extends StatelessWidget {
  final AppController state;
  const AppShell(this.state, {super.key});
  @override
  Widget build(BuildContext context) {
    final n = state.screen;
    Widget page;
    if (n <= 14) {
      page = AuthScreen(state, key: ValueKey(n));
    } else if ((n >= 15 && n <= 20) || (n >= 26 && n <= 34) || n == 48) {
      page = DiscoverScreen(
        state,
        key: ValueKey(n),
        onGallery: () => gallery(context),
      );
    } else if (n <= 37) {
      page = OrderScreen(state, key: ValueKey(n));
    } else {
      page = AccountScreen(state, key: ValueKey(n));
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: state.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: PopScope(
        canPop: !state.canBack,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) state.back();
        },
        child: ColoredBox(
          color: state.dark ? const Color(0xFF151515) : const Color(0xFFF2F2F2),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: RepaintBoundary(
                key: const ValueKey('app-capture'),
                child: page,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void gallery(BuildContext context) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => ListenableBuilder(
      listenable: state,
      builder: (context, _) => SizedBox(
        height: MediaQuery.sizeOf(context).height * .86,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                children: [
                  const Expanded(child: Heading('Design screens', size: 24)),
                  IconButton(
                    tooltip: 'Switch light / dark theme',
                    onPressed: state.toggleTheme,
                    icon: Icon(
                      state.dark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Note(
                '48 screens · Light & Dark\nChoose any screen to review the Pixso implementation.',
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: screenNames.length,
                itemBuilder: (context, i) => ListTile(
                  leading: Text(
                    (i + 1).toString().padLeft(2, '0'),
                    style: const TextStyle(color: orange),
                  ),
                  title: Text(
                    screenNames[i].replaceFirst(RegExp(r'^\d+-\s*'), ''),
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: const Icon(Icons.chevron_right, size: 18),
                  onTap: () {
                    Navigator.pop(context);
                    state.open(i + 1);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
