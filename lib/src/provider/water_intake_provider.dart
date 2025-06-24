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
    this.dailyGoalLiters = 3.0,
    this.logs = const [],
  });

  double get currentIntakeLiters {
    if (logs.isEmpty) return 0.0;
    // We sum up the amount in milliliters and convert to liters
    return logs.map((log) => log.amount).reduce((a, b) => a + b) / 1000.0;
  }

  double get progressPercentage {
    if (dailyGoalLiters == 0) return 0.0;
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
  WaterIntakeNotifier() : super(const WaterIntakeState());

  // Method to add a new water log entry
  void addWaterLog(double amountInMl) {
    final newLog = WaterLog(
      id: _uuid.v4(),
      amount: amountInMl,
      timestamp: DateTime.now(),
    );
    state = state.copyWith(logs: [...state.logs, newLog]);
  }

  // In the future, you could add methods like:
  // void removeWaterLog(String id) { ... }
  // void setDailyGoal(double liters) { ... }
}

// 3. The Provider
final waterIntakeProvider =
    StateNotifierProvider<WaterIntakeNotifier, WaterIntakeState>((ref) {
  return WaterIntakeNotifier();
});