import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryData {
  final double principalAmount;
  final double interestRate;
  final DateTime fromDate;
  final DateTime tillDate;
  final double interestEarned; // Renamed for clarity
  final double totalAmount;
  final String duration;

  HistoryData({
    required this.principalAmount,
    required this.interestRate,
    required this.fromDate,
    required this.tillDate,
    required this.interestEarned, // Renamed for clarity
    required this.totalAmount,
    required this.duration,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'principalAmount': principalAmount,
      'interestRate': interestRate,
      'fromDate': Timestamp.fromDate(fromDate), // Use Timestamp for Firestore
      'tillDate': Timestamp.fromDate(tillDate), // Use Timestamp for Firestore
      'interestEarned': interestEarned,
      'totalAmount': totalAmount,
      'duration': duration,
    };
  }

  // Construct from Firestore data
  factory HistoryData.fromMap(Map<String, dynamic> map) {
    return HistoryData(
      principalAmount:
          (map['principalAmount'] as num).toDouble(), // Type casting
      interestRate: (map['interestRate'] as num).toDouble(), // Type casting
      fromDate: (map['fromDate'] as Timestamp).toDate(),
      tillDate: (map['tillDate'] as Timestamp).toDate(),
      interestEarned: (map['interestEarned'] as num).toDouble(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      duration: map['duration'],
    );
  }
}
