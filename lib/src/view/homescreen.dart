// lib/src/view/homescreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart'; // Import ImageSource
import 'package:nutrio/src/provider/image_picker_provider.dart'; // Import the new provider
import 'package:nutrio/src/provider/theme_provider.dart';
import '../core/constants/app_constant.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Listen to the image picker provider for changes
    ref.listen<XFile?>(imagePickerProvider, (previous, next) {
      if (next != null) {
        // An image has been picked.
        // In a real app, you'd navigate to a new screen to show the image and analysis.
        // For now, let's show a simple dialog.
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
        title: const Text(AppConstants.appName), //
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            onPressed: () {
              ref.read(themeProvider.notifier).toggleTheme();
            },
            tooltip: AppConstants.toggleTheme, //
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
                      AppConstants.whatsOnYourPlate, //
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppConstants.addAPhoto, //
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildActionButtons(context, ref), // Pass ref to the method
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    // Get the image picker service
    final imagePickerService = ref.read(imagePickerServiceProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildActionButton(
            context: context,
            icon: Icons.camera_alt_outlined,
            tooltip: AppConstants.takeAPicture, //
            onPressed: () => imagePickerService.pickImage(ImageSource.camera),
          ),
          const SizedBox(width: 24),
          _buildActionButton(
            context: context,
            icon: Icons.photo_library_outlined,
            tooltip: AppConstants.addFromGallery, //
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