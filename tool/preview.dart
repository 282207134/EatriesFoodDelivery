// Deterministic browser capture entrypoint; not used in the shipped Android app.
import 'package:flutter/material.dart';
import 'package:eateries/app.dart';
import 'package:eateries/core/app_controller.dart';

void main() {
  final params = Uri.base.queryParameters;
  final s = AppController()
    ..screen = (int.tryParse(params['screen'] ?? '15') ?? 15).clamp(1, 48)
    ..dark = params['theme'] == 'dark';
  s.cart.addAll({'coffee': 1, 'burger': 1, 'eggs': 2});
  s.orders.add(LocalOrder('EA20261031', '2026-10-31', 32.9, Map.of(s.cart)));
  if (s.screen == 33 || s.screen == 34) s.search = 'burger';
  runApp(EateriesApp(controller: s));
}
