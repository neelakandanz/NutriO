import 'package:flutter/material.dart';

// Best practice: Using a dedicated theme file is better, but for a single screen,
// defining colors here is acceptable. This establishes a professional and clean color palette.
class AppColors {
  static const Color background = Colors.white;
  static const Color primaryText = Color(0xFF1D1D1F);
  static const Color secondaryText = Color(0xFF8A8A8E);
  static const Color accent = Color(0xFF007AFF); // A vibrant, trustworthy blue
  static const Color borderColor = Color(0xFFE5E5E5);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Using Scaffold as the base for our screen layout.
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        // The title is kept minimal. The app's name is sufficient.
        title: const Text(
          'NutriO',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        // Elevation is set to 0 to create a seamless, modern look between the app bar and body.
        elevation: 0,
      ),
      body: SafeArea(
        // SafeArea ensures our UI avoids system notches and gestures.
        child: Column(
          children: [
            // The Expanded widget pushes the action buttons to the bottom,
            // leaving the center for welcome messages.
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // A welcoming icon to represent nutrition analysis.
                    Icon(
                      Icons.food_bank_outlined,
                      size: 60,
                      color: AppColors.accent,
                    ),
                    SizedBox(height: 24),
                    // The main headline. Clear and action-oriented.
                    Text(
                      'What\'s on your plate?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    SizedBox(height: 8),
                    // The sub-headline guides the user on what to do.
                    Text(
                      'Add a photo to get a nutritional breakdown of your meal.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // The action buttons are the primary interaction point.
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  /// Builds the bottom action buttons for user actions.
  /// This layout is cleaner and more focused without the text field.
  Widget _buildActionButtons() {
    return Padding(
      // Provides ample space from the bottom edge.
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the buttons horizontally
        children: [
          // Extracted button widget for consistency and clean code.
          _buildActionButton(
            icon: Icons.camera_alt_outlined,
            tooltip: 'Take a picture',
            onPressed: () {
              // TODO: Implement camera functionality.
              print('Camera button pressed');
            },
          ),
          const SizedBox(width: 24), // Provides spacing between the buttons.
          _buildActionButton(
            icon: Icons.photo_library_outlined,
            tooltip: 'Add from gallery',
            onPressed: () {
              // TODO: Implement image picker functionality.
              print('Gallery button pressed');
            },
          ),
        ],
      ),
    );
  }

  /// A reusable widget for creating the circular action buttons.
  /// This improves maintainability and ensures a consistent UI.
  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.borderColor, width: 1.5),
        boxShadow: [
          // A subtle shadow adds depth and lifts the button off the background.
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        iconSize: 32, // A larger icon for a better visual and touch target.
        padding: const EdgeInsets.all(20), // Generous padding for a larger button area.
        icon: Icon(icon, color: AppColors.primaryText),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }
}
