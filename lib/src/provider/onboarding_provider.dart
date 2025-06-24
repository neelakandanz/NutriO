import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/onboarding_model.dart';

/// The StateNotifier manages the OnboardingState.
/// It contains methods to update the state in a controlled way.
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(const OnboardingState());

  void setAge(int age) {
    state = state.copyWith(age: age);
  }

  void setGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void setHeight(double height) {
    state = state.copyWith(height: height);
  }

  void setHeightUnit(String unit) {
    // When changing units, convert the existing value.
    if (unit == 'ft' && state.heightUnit == 'cm') {
      state = state.copyWith(height: state.height * 0.0328084, heightUnit: unit);
    } else if (unit == 'cm' && state.heightUnit == 'ft') {
      state = state.copyWith(height: state.height * 30.48, heightUnit: unit);
    }
  }

  void setWeight(double weight) {
    state = state.copyWith(weight: weight);
  }

  void setWeightUnit(String unit) {
    // When changing units, convert the existing value.
    if (unit == 'lb' && state.weightUnit == 'kg') {
      state = state.copyWith(weight: state.weight * 2.20462, weightUnit: unit);
    } else if (unit == 'kg' && state.weightUnit == 'lb') {
      state = state.copyWith(weight: state.weight * 0.453592, weightUnit: unit);
    }
  }

  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page);
  }
}

/// The provider that exposes the OnboardingNotifier to the widget tree.
/// Widgets will use this to interact with the state.
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>(
        (ref) => OnboardingNotifier());
