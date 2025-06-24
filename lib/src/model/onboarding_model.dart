import 'package:flutter/material.dart';

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
    this.heightUnit = 'cm',
    this.weight = 70,
    this.weightUnit = 'kg',
    this.currentPage = 0,
  });

  // Helper method to create a copy of the state with updated values.
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
