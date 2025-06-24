import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// In a real scenario, a provider would manage the state of the onboarding process.
// For now, we'll keep it simple.

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 'ref' is our gateway to interacting with other providers.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to NutriO'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Let\'s get started on your nutrition journey!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Here, we would navigate to the next screen, e.g., the authentication or dashboard.
                // We'll set up navigation properly in the next steps.
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text('Get Started'),
            )
          ],
        ),
      ),
    );
  }
}