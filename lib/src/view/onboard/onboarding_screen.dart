// lib/src/view/onboard/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constant.dart';
import '../../provider/onboarding_provider.dart';
import '../homescreen.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = PageController();
    final onboardingState = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    final List<Widget> pages = [
      const _AgeSliderPage(),
      const _GenderSelectorPage(),
      const _HeightSliderPage(),
      const _WeightSliderPage(),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (page) => notifier.setCurrentPage(page),
                children: pages,
              ),
            ),
            _buildNavigation(context, ref, pageController, pages.length),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigation(BuildContext context, WidgetRef ref,
      PageController controller, int pageCount) {
    final state = ref.watch(onboardingProvider);

    bool isNextEnabled() {
      switch (state.currentPage) {
        case 0:
          return true;
        case 1:
          return state.gender != null;
        case 2:
          return true;
        case 3:
          return true;
        default:
          return false;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: List.generate(
              pageCount,
              (index) => _buildDot(index, state.currentPage),
            ),
          ),
          ElevatedButton(
            onPressed: !isNextEnabled()
                ? null
                : () {
                    if (state.currentPage < pageCount - 1) {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => const HomeScreen(),
                        ),
                      );
                      print(AppConstants.onboardingComplete);
                      print(AppConstants.finalData);
                      print("${AppConstants.ageLabel}${state.age}");
                      print("${AppConstants.genderLabel}${state.gender}");
                      print(
                          "${AppConstants.heightLabel}${state.height.toStringAsFixed(1)} ${state.heightUnit}");
                      print(
                          "${AppConstants.weightLabel}${state.weight.toStringAsFixed(1)} ${state.weightUnit}");
                    }
                  },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
              elevation: 0,
            ).copyWith(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.grey.shade400;
                  }
                  return Colors.black;
                },
              ),
            ),
            child: const Icon(Icons.arrow_forward_ios, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index, int currentIndex) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: currentIndex == index ? 24 : 8,
      decoration: BoxDecoration(
        color: currentIndex == index ? Colors.black : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _OnboardingPageTemplate extends StatelessWidget {
  final String title;
  final Widget child;

  const _OnboardingPageTemplate({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 40),
          child,
        ],
      ),
    );
  }
}

class _AgeSliderPage extends ConsumerWidget {
  const _AgeSliderPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final age = ref.watch(onboardingProvider.select((s) => s.age));
    final notifier = ref.read(onboardingProvider.notifier);

    return _OnboardingPageTemplate(
      title: AppConstants.whatIsYourAge,
      child: _CustomNumberSlider(
        value: age.toDouble(),
        min: 13,
        max: 100,
        label: "$age",
        unit: AppConstants.years,
        onChanged: (value) => notifier.setAge(value.toInt()),
      ),
    );
  }
}

class _GenderSelectorPage extends ConsumerWidget {
  const _GenderSelectorPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedGender =
        ref.watch(onboardingProvider.select((s) => s.gender));
    final notifier = ref.read(onboardingProvider.notifier);

    return _OnboardingPageTemplate(
      title: AppConstants.tellUsAboutYou,
      child: Column(
        children: [
          _GenderOption(
            label: AppConstants.male,
            isSelected: selectedGender == AppConstants.male,
            onTap: () => notifier.setGender(AppConstants.male),
          ),
          const SizedBox(height: 16),
          _GenderOption(
            label: AppConstants.female,
            isSelected: selectedGender == AppConstants.female,
            onTap: () => notifier.setGender(AppConstants.female),
          ),
          const SizedBox(height: 16),
          _GenderOption(
            label: AppConstants.other,
            isSelected: selectedGender == AppConstants.other,
            onTap: () => notifier.setGender(AppConstants.other),
          ),
        ],
      ),
    );
  }
}

class _HeightSliderPage extends ConsumerWidget {
  const _HeightSliderPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = ref.watch(onboardingProvider.select((s) => s.height));
    final unit = ref.watch(onboardingProvider.select((s) => s.heightUnit));
    final notifier = ref.read(onboardingProvider.notifier);

    double min, max;
    String label;
    if (unit == AppConstants.cm) {
      min = 120;
      max = 220;
      label = height.toStringAsFixed(0);
    } else {
      min = 4;
      max = 7.5;
      final feet = height.truncate();
      final inches = ((height - feet) * 12).round();
      label = "$feet' $inches\"";
    }

    return _OnboardingPageTemplate(
      title: AppConstants.whatIsYourHeight,
      child: _CustomNumberSlider(
        value: height,
        min: min,
        max: max,
        label: label,
        unit: unit,
        onChanged: (value) => notifier.setHeight(value),
        unitToggle: (
          onPressed: (newUnit) => notifier.setHeightUnit(newUnit),
          options: [AppConstants.cm, AppConstants.ft],
          selected: unit,
        ),
      ),
    );
  }
}

class _WeightSliderPage extends ConsumerWidget {
  const _WeightSliderPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weight = ref.watch(onboardingProvider.select((s) => s.weight));
    final unit = ref.watch(onboardingProvider.select((s) => s.weightUnit));
    final notifier = ref.read(onboardingProvider.notifier);

    double min, max;
    if (unit == AppConstants.kg) {
      min = 30;
      max = 200;
    } else {
      min = 66;
      max = 440;
    }

    return _OnboardingPageTemplate(
      title: AppConstants.whatIsYourWeight,
      child: _CustomNumberSlider(
        value: weight,
        min: min,
        max: max,
        label: weight.toStringAsFixed(1),
        unit: unit,
        onChanged: (value) => notifier.setWeight(value),
        unitToggle: (
          onPressed: (newUnit) => notifier.setWeightUnit(newUnit),
          options: [AppConstants.kg, AppConstants.lb],
          selected: unit,
        ),
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class _CustomNumberSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final String label;
  final String unit;
  final ValueChanged<double> onChanged;
  final ({
    void Function(String) onPressed,
    List<String> options,
    String selected
  })? unitToggle;

  const _CustomNumberSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.label,
    required this.unit,
    required this.onChanged,
    this.unitToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              unit,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.black,
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: Colors.black,
            overlayColor: Colors.black.withOpacity(0.2),
            trackHeight: 6.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 20),
        if (unitToggle != null)
          _UnitToggle(
            options: unitToggle!.options,
            selectedOption: unitToggle!.selected,
            onOptionSelected: unitToggle!.onPressed,
          ),
      ],
    );
  }
}

class _UnitToggle extends StatelessWidget {
  final List<String> options;
  final String selectedOption;
  final ValueChanged<String> onOptionSelected;

  const _UnitToggle({
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) {
          final isSelected = option == selectedOption;
          return GestureDetector(
            onTap: () => onOptionSelected(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : [],
              ),
              child: Text(
                option,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}