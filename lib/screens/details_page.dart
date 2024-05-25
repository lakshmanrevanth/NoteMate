import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key}); // Remove data parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Details'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.ios_share),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow("Name", "R. Naga Srinivasa Rao"), // Example data
              _buildDetailRow("Principal Amount", "₹100,000"), // Example data
              _buildDetailRow("Interest Rate", "2.00%"), // Example data
              _buildDetailRow("From Date",
                  DateFormat('dd MMM yyyy').format(DateTime.now())),
              _buildDetailRow(
                  "Till Date",
                  DateFormat('dd MMM yyyy')
                      .format(DateTime.now().add(const Duration(days: 365)))),
              _buildDetailRow("Interest", "₹2,000"), // Example data
              const SizedBox(height: 10),
              _buildDetailRow("Total Amount", "₹102,000", isTotal: true),
              const SizedBox(height: 20),
              // Add other details here if needed
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
