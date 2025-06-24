// lib/src/model/water_log_model.dart

import 'package:flutter/foundation.dart';

@immutable
class WaterLog {
  final String id;
  final double amount; // in milliliters
  final DateTime timestamp;

  const WaterLog({
    required this.id,
    required this.amount,
    required this.timestamp,
  });

  // A copyWith method is useful for immutable classes
  WaterLog copyWith({
    String? id,
    double? amount,
    DateTime? timestamp,
  }) {
    return WaterLog(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}