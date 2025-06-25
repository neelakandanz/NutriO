// lib/src/view/homescreen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrio/src/core/constants/app_constant.dart';
import 'package:nutrio/src/provider/image_picker_provider.dart';
import 'package:nutrio/src/provider/onboarding_provider.dart'; // Import onboarding provider
import 'package:nutrio/src/provider/theme_provider.dart';
import 'package:nutrio/src/view/water_intake/water_intake_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    ref.listen<XFile?>(imagePickerProvider, (previous, next) {
      if (next != null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Image Selected'),
            content: Text('Path: ${next.path}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text(AppConstants.appName),
      ),
      drawer: _buildAppDrawer(context, ref),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.food_bank_outlined,
                      size: 60,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      AppConstants.whatsOnYourPlate,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppConstants.addAPhoto,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildActionButtons(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildAppDrawer(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              "Your Name",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            accountEmail: Text(
              "your.email@example.com",
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              child: const Text(
                "Y",
                style: TextStyle(fontSize: 24.0, color: Colors.white),
              ),
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.water_drop_outlined),
            title: const Text('Log Water Intake'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer first

              // ** MODIFICATION HERE: Get weight and navigate **
              final onboardingState = ref.read(onboardingProvider);
              double weightInKg = onboardingState.weight;

              // Convert to kg if the unit is lbs
              if (onboardingState.weightUnit == AppConstants.lb) {
                weightInKg = weightInKg * 0.453592;
              }

              Navigator.of(context).push(
                MaterialPageRoute(
                  // Pass the weight to the WaterIntakeScreen
                  builder: (context) => WaterIntakeScreen(
                    userWeightKg: weightInKg,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            title: const Text('Toggle Theme'),
            onTap: () {
              Navigator.of(context).pop();
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    final imagePickerService = ref.read(imagePickerServiceProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildActionButton(
            context: context,
            icon: Icons.camera_alt_outlined,
            tooltip: AppConstants.takeAPicture,
            onPressed: () => imagePickerService.pickImage(ImageSource.camera),
          ),
          const SizedBox(width: 24),
          _buildActionButton(
            context: context,
            icon: Icons.photo_library_outlined,
            tooltip: AppConstants.addFromGallery,
            onPressed: () => imagePickerService.pickImage(ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        shape: BoxShape.circle,
        border: Border.all(color: theme.dividerColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onBackground.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        iconSize: 32,
        padding: const EdgeInsets.all(20),
        icon: Icon(icon, color: theme.colorScheme.onBackground),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }
}