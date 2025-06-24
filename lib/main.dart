// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrio/src/provider/theme_provider.dart';
import 'package:nutrio/src/theme/app_theme.dart';
import 'package:nutrio/src/view/onboard/onboarding_screen.dart';

import 'src/core/constants/app_constant.dart';

void main() {
  runApp(
    const ProviderScope(
      child: NutriOApp(),
    ),
  );
}

class NutriOApp extends ConsumerWidget {
  const NutriOApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}