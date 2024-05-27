import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart'; // For a unique font

class DetailsPage extends StatelessWidget {
  const DetailsPage({
    super.key,
  }); // Remove data parameter

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 600,
      child: SingleChildScrollView(
        // Allow scrolling for long content
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Content Area
            Card(
              elevation: 4, // Increase elevation for more depth
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(15)), // More rounded corners
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow("Name", "R. Naga Srinivasa Rao", context),
                    _buildDetailRow("Principal Amount", "₹100,000", context),
                    _buildDetailRow("Interest Rate", "2.00%", context),
                    _buildDetailRow(
                        "From Date",
                        DateFormat('dd MMM yyyy').format(DateTime.now()),
                        context),
                    _buildDetailRow(
                        "Till Date",
                        DateFormat('dd MMM yyyy').format(
                            DateTime.now().add(const Duration(days: 365))),
                        context),
                    const SizedBox(
                        height: 20), // Additional spacing before total
                    _buildDetailRow("Interest", "₹2,000", context,
                        isSecondary: true), // Interest in secondary style
                    const SizedBox(height: 10),
                    _buildDetailRow("Total Amount", "₹102,000", context,
                        isTotal: true), // Total in primary style
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30), // Larger spacing

            // Action Button

            const SizedBox(height: 20),
            Center(
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.ios_share, size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    BuildContext context, {
    bool isTotal = false,
    bool isSecondary = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.lato(
              // Use Lato font
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isSecondary
                  ? Colors.grey[600]
                  : null, // Secondary info is grey
            ),
          ),
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
