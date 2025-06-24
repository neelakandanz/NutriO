// lib/src/provider/onboarding_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constant.dart';
import '../model/onboarding_model.dart';

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
    if (unit == AppConstants.ft && state.heightUnit == AppConstants.cm) {
      state = state.copyWith(height: state.height * 0.0328084, heightUnit: unit);
    } else if (unit == AppConstants.cm && state.heightUnit == AppConstants.ft) {
      state = state.copyWith(height: state.height * 30.48, heightUnit: unit);
    }
  }

  void setWeight(double weight) {
    state = state.copyWith(weight: weight);
  }

  void setWeightUnit(String unit) {
    if (unit == AppConstants.lb && state.weightUnit == AppConstants.kg) {
      state = state.copyWith(weight: state.weight * 2.20462, weightUnit: unit);
    } else if (unit == AppConstants.kg && state.weightUnit == AppConstants.lb) {
      state = state.copyWith(weight: state.weight * 0.453592, weightUnit: unit);
    }
  }

  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page);
  }
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>(
        (ref) => OnboardingNotifier());