// lib/src/provider/water_intake_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrio/src/model/water_log_model.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

// 1. The State class
class WaterIntakeState {
  final double dailyGoalLiters;
  final List<WaterLog> logs;

  const WaterIntakeState({
    this.dailyGoalLiters = 0.0, // Default to 0, will be calculated
    this.logs = const [],
  });

  double get currentIntakeLiters {
    if (logs.isEmpty) return 0.0;
    // We sum up the amount in milliliters and convert to liters
    return logs.map((log) => log.amount).reduce((a, b) => a + b) / 1000.0;
  }

  double get progressPercentage {
    if (dailyGoalLiters <= 0) return 0.0;
    return (currentIntakeLiters / dailyGoalLiters).clamp(0.0, 1.0);
  }

  WaterIntakeState copyWith({
    double? dailyGoalLiters,
    List<WaterLog>? logs,
  }) {
    return WaterIntakeState(
      dailyGoalLiters: dailyGoalLiters ?? this.dailyGoalLiters,
      logs: logs ?? this.logs,
    );
  }
}

// 2. The Notifier
class WaterIntakeNotifier extends StateNotifier<WaterIntakeState> {
  // The notifier's constructor now calculates the initial state
  WaterIntakeNotifier(double userWeightKg) : super(const WaterIntakeState()) {
    // A common formula: 35 mL of water per kg of body weight
    final double goalInMl = userWeightKg * 35;
    // Convert to liters for the state
    final double goalInLiters = goalInMl / 1000.0;
    state = state.copyWith(dailyGoalLiters: goalInLiters);
  }

  // Method to add a new water log entry
  void addWaterLog(double amountInMl) {
    final newLog = WaterLog(
      id: _uuid.v4(),
      amount: amountInMl,
      timestamp: DateTime.now(),
    );
    state = state.copyWith(logs: [...state.logs, newLog]);
  }
}

// 3. The Provider (changed to a .family)
// It now takes a double (user's weight in kg) and creates a unique provider instance.
final waterIntakeProvider =
    StateNotifierProvider.family<WaterIntakeNotifier, WaterIntakeState, double>(
        (ref, userWeightKg) {
  return WaterIntakeNotifier(userWeightKg);
});