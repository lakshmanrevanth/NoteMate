import 'package:cloud_firestore/cloud_firestore.dart';

class NoteData {
  final String name;
  final double principalAmount;
  final double interestRate;
  final DateTime fromDate;
  final String duration; // Now a String for '4years 0months 12days'
  final List<String> imageUrls;
  final double interest;
  final double totalAmount;
  final DateTime tillDate;
  String noteId;

  NoteData({
    required this.name,
    required this.principalAmount,
    required this.interestRate,
    required this.fromDate,
    required this.duration,
    required this.imageUrls,
    required this.interest,
    required this.totalAmount,
    required this.tillDate,
    this.noteId = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'principalAmount': principalAmount,
      'interestRate': interestRate,
      'fromDate': fromDate,
      'duration': duration,
      'imageUrls': imageUrls,
      'interest': interest,
      'totalAmount': totalAmount,
      'tillDate': tillDate,
    };
  }

  // Added `fromMap` method for creating a NoteData object from Firestore data
  factory NoteData.fromMap(Map<String, dynamic> map) {
    return NoteData(
      name: map['name'],
      principalAmount: map['principalAmount'],
      interestRate: map['interestRate'],
      fromDate: (map['fromDate'] as Timestamp).toDate(),
      duration: map['duration'],
      imageUrls: List<String>.from(map['imageUrls']),
      interest: map['interest'],
      totalAmount: map['totalAmount'],
      tillDate: (map['tillDate'] as Timestamp).toDate(),
    );
  }
}
