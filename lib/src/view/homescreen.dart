import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrio/src/provider/theme_provider.dart';

// Convert HomeScreen to a ConsumerWidget.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Add WidgetRef
    final theme = Theme.of(context);
    // Determine the current brightness to select the correct icon.
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('NutriO'),
        // Add the actions property to the AppBar.
        actions: [
          IconButton(
            // Show a sun icon for dark mode, and a moon icon for light mode.
            icon: Icon(
              isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            onPressed: () {
              // Call the toggleTheme method on our provider.
              ref.read(themeProvider.notifier).toggleTheme();
            },
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
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
                      'What\'s on your plate?',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add a photo to get a nutritional breakdown of your meal.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  /// Builds the bottom action buttons for user actions.
  Widget _buildActionButtons(BuildContext context) {
      return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildActionButton(
            context: context,
            icon: Icons.camera_alt_outlined,
            tooltip: 'Take a picture',
            onPressed: () {
              print('Camera button pressed');
            },
          ),
          const SizedBox(width: 24),
          _buildActionButton(
            context: context,
            icon: Icons.photo_library_outlined,
            tooltip: 'Add from gallery',
            onPressed: () {
              print('Gallery button pressed');
            },
          ),
        ],
      ),
    );
  }

  /// A reusable widget for creating the circular action buttons.
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