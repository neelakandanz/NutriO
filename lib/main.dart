import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrio/src/features/onboarding/presentation/onboarding_screen.dart'; // We will create this next

void main() {
  // Any app-level initialization can go here.
  // For example, setting up Firebase, error monitoring, etc.
  runApp(
    const ProviderScope(
      child: NutriOApp(),
    ),
  );
}

class NutriOApp extends StatelessWidget {
  const NutriOApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      // For now, we'll point to an onboarding screen. Later, this will be handled by our router.
      home: const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}