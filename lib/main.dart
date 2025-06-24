import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrio/src/provider/theme_provider.dart';
import 'package:nutrio/src/theme/app_theme.dart';
import 'package:nutrio/src/view/onboard/onboarding_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: NutriOApp(),
    ),
  );
}

// Convert NutriOApp to a ConsumerWidget to access providers.
class NutriOApp extends ConsumerWidget {
  const NutriOApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the themeProvider to get the current theme mode.
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'NutriO',
      // Set the light and dark themes.
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // Use the themeMode from the provider to control which theme is active.
      themeMode: themeMode,
      home: const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}