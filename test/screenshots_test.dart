import 'package:flutter/widgets.dart';

import 'test_assets.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eateries/app.dart';
import 'package:eateries/core/app_controller.dart';

void main() {
  testWidgets(
    '96 screen/theme combinations fit 320, 375 and 430 pixel widths',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.runAsync(() async {
        await loadTestFont();
      });
      final s = AppController();
      await tester.pumpWidget(
        DefaultAssetBundle(
          bundle: TestAssets(),
          child: EateriesApp(controller: s),
        ),
      );
      final failures = <String>[];
      for (final width in [320.0, 375.0, 430.0]) {
        tester.view.physicalSize = Size(width, 812);
        for (final dark in [false, true]) {
          for (var n = 1; n <= 48; n++) {
            s.screen = n;
            s.dark = dark;
            s.refresh();
            s.cart
              ..clear()
              ..addAll({'coffee': 1, 'burger': 1, 'eggs': 2});
            await tester.pumpAndSettle();
            final error = tester.takeException();
            if (error != null) {
              failures.add('screen $n dark=$dark width=$width: $error');
            }
          }
        }
      }
      expect(failures, isEmpty, reason: failures.join("\n"));
    },
  );
}
