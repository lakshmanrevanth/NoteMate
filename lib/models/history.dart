import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:promissorynotemanager/data/history_data.dart'; // Import for date formatting
import 'package:url_launcher/url_launcher.dart';

class HistoryModel extends StatelessWidget {
  final HistoryData historyData;
  const HistoryModel({
    super.key,
    required this.historyData,
  });

  @override
  Widget build(BuildContext context) {
    final pertoint = historyData.interestRate / 12;
    final formattedFromDate =
        DateFormat('dd MMM yyyy').format(historyData.fromDate);
    final formattedTillDate =
        DateFormat('dd MMM yyyy').format(historyData.tillDate);

    return Card(
      elevation: 2, // Add a subtle shadow
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('Principal Amount:',
                '₹${historyData.principalAmount.toString()}'),
            _buildRow('Interest Rate:', '${pertoint}rs'),
            _buildRow('From Date:', formattedFromDate),
            _buildRow('Till Date:', formattedTillDate),
            _buildRow('Duration:',
                _calculateDuration(historyData.fromDate, historyData.tillDate)),
            _buildRow('Interest:', '₹${historyData.interestEarned.toString()}'),
            const Divider(color: Colors.grey), // Add a divider
            _buildRow('Total Amount:',
                '₹${(historyData.principalAmount + historyData.interestEarned).toString()}',
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
