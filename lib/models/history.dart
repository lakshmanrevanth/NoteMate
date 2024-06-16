import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:promissorynotemanager/data/history_data.dart';

class HistoryModel extends StatelessWidget {
  final HistoryData historyData;
  const HistoryModel({
    super.key,
    required this.historyData,
  });

  @override
  Widget build(BuildContext context) {
    final principalAmount = historyData.principalAmount ?? 0.0;
    final interestRate = historyData.interestRate ?? 0.0;
    final interestEarned = historyData.interestEarned ?? 0.0;
    final fromDate = historyData.fromDate ?? DateTime.now();
    final tillDate = historyData.tillDate ?? DateTime.now();
    final duration = _calculateDuration(fromDate, tillDate);

    final pertoint = interestRate / 12 * 100;
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
            _buildRow('Interest Rate:', '${pertoint.toString()}rs'),
            _buildRow('From Date:', formattedFromDate),
            _buildRow('Till Date:', formattedTillDate),
            _buildRow('Duration:', duration),
            _buildRow('Interest:', '₹${interestEarned.toStringAsFixed(2)}'),
            const Divider(color: Colors.grey), // Add a divider
            _buildRow('Total Amount:',
                '₹${(principalAmount + interestEarned).toStringAsFixed(2)}',
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
    return '${difference.inDays ~/ 365} years ${(difference.inDays % 365) ~/ 30} months ${(difference.inDays % 365) % 30} days'; // Added days calculation
  }
}
