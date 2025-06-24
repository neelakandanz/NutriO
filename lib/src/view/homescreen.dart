// lib/src/view/homescreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrio/src/provider/image_picker_provider.dart';
import 'package:nutrio/src/provider/theme_provider.dart';
import '../core/constants/app_constant.dart';

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
        // No more 'actions' here! The title will remain centered.
        // Flutter automatically adds a menu button to open the drawer.
      ),
      // Add the drawer to the Scaffold
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

  // This is the only method we are modifying.
  Widget _buildAppDrawer(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Replace the old DrawerHeader with this UserAccountsDrawerHeader
          UserAccountsDrawerHeader(
            accountName: Text(
              "Your Name", // Placeholder for user's name
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            accountEmail: Text(
              "your.email@example.com", // Placeholder for user's email
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              child: const Text(
                "Y", // Placeholder for user's initial
                style: TextStyle(fontSize: 24.0, color: Colors.white),
              ),
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface, // Use surface color for a clean look
            ),
          ),
          ListTile(
            leading: const Icon(Icons.water_drop_outlined),
            title: const Text('Log Water Intake'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              _showWaterIntakeDialog(context);
            },
          ),
          ListTile(
            leading: Icon(
              isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            ),
            title: const Text('Toggle Theme'),
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.of(context).pop();
              // TODO: Navigate to a Settings screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              // TODO: Implement logout functionality
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

  void _showWaterIntakeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Log Water Intake',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount (e.g., 250 ml)',
                  border: OutlineInputBorder(),
                  suffixText: 'ml',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Add logic to save the water intake value
                    Navigator.of(context).pop();
                  },
                  child: const Text('Log Water'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}