import 'package:flutter/material.dart';

class HistoryData {
  final int principalAmount;
  final double interestRate;
  final DateTime fromDate;
  final DateTime tillDate;
  final int interestEarned;

  HistoryData({
    required this.principalAmount,
    required this.interestRate,
    required this.fromDate,
    required this.tillDate,
    required this.interestEarned,
  });

  // Optional: Factory constructor to calculate interest if not provided
  factory HistoryData.calculate({
    required int principalAmount,
    required double interestRate,
    required DateTime fromDate,
    required DateTime tillDate,
  }) {
    // Your interest calculation logic here
    final interest = 0;

    return HistoryData(
      principalAmount: principalAmount,
      interestRate: interestRate,
      fromDate: fromDate,
      tillDate: tillDate,
      interestEarned: interest,
    );
  }

  // Optional: toString for debugging/display
  @override
  String toString() {
    return 'Principal: $principalAmount, Rate: $interestRate%, From: $fromDate, To: $tillDate, Interest: $interestEarned';
  }
}
