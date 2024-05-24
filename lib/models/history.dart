import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class HistoryModel extends StatelessWidget {
  final int principalAmount; // Assuming you have data for these
  final double interestRate;
  final DateTime fromDate;
  final DateTime tillDate;
  final int interestEarned; // Or calculate it here

  const HistoryModel({
    super.key,
    required this.principalAmount,
    required this.interestRate,
    required this.fromDate,
    required this.tillDate,
    required this.interestEarned,
  });

  @override
  Widget build(BuildContext context) {
    final formattedFromDate = DateFormat('dd MMM yyyy').format(fromDate);
    final formattedTillDate = DateFormat('dd MMM yyyy').format(tillDate);

    return Card(
      elevation: 2, // Add a subtle shadow
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('Principal Amount:', '₹${principalAmount.toString()}'),
            _buildRow('Interest Rate:', '${interestRate.toStringAsFixed(2)}%'),
            _buildRow('From Date:', formattedFromDate),
            _buildRow('Till Date:', formattedTillDate),
            _buildRow('Duration:', _calculateDuration(fromDate, tillDate)),
            _buildRow('Interest:', '₹${interestEarned.toString()}'),
            const Divider(color: Colors.grey), // Add a divider
            _buildRow('Total Amount:',
                '₹${(principalAmount + interestEarned).toString()}',
                isTotal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            value,
            style: const TextStyle(
                fontWeight: FontWeight.w500), // Slightly bolder value
          ),
        ],
      ),
    );
  }

  String _calculateDuration(DateTime fromDate, DateTime tillDate) {
    final difference = tillDate.difference(fromDate);
    return '${difference.inDays ~/ 365} years ${(difference.inDays % 365) ~/ 30} months';
  }
}
