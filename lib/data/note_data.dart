import 'dart:io';

class NoteData {
  final String name;
  final double principalAmount;
  final double interestRate;
  final DateTime date;
  final List<File> images; // List of image files

  NoteData({
    required this.name,
    required this.principalAmount,
    required this.interestRate,
    required this.date,
    required this.images,
  });
}
