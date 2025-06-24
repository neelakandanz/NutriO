// lib/src/model/onboarding_model.dart
import 'package:flutter/material.dart';
import '../core/constants/app_constant.dart';

@immutable
class OnboardingState {
  final int age;
  final String? gender;
  final double height;
  final String heightUnit;
  final double weight;
  final String weightUnit;
  final int currentPage;

  const OnboardingState({
    this.age = 30,
    this.gender,
    this.height = 170,
    this.heightUnit = AppConstants.cm,
    this.weight = 70,
    this.weightUnit = AppConstants.kg,
    this.currentPage = 0,
  });

  OnboardingState copyWith({
    int? age,
    String? gender,
    double? height,
    String? heightUnit,
    double? weight,
    String? weightUnit,
    int? currentPage,
  }) {
    return OnboardingState(
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      heightUnit: heightUnit ?? this.heightUnit,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}