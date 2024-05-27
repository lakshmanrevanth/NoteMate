import 'package:flutter/material.dart';
import 'package:promissorynotemanager/screens/create_note.dart';
import 'package:promissorynotemanager/screens/details_page.dart';
import 'package:google_fonts/google_fonts.dart';

class NewCard extends StatefulWidget {
  const NewCard({Key? key}) : super(key: key);

  @override
  State<NewCard> createState() => _NewCardState();
}

class _NewCardState extends State<NewCard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.9; // 80% of screen width

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const DetailsPage(),
              ).then((value) {
                setState(() {});
              });
      },
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.symmetric(
            vertical: 8, horizontal: 10), // Adjust margins for better spacing
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)), // Add rounded corners
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Details Column
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nagasrinivasarao",
                        style: GoogleFonts.robotoMono(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow("Amount:", "₹10,000",
                          context), // Format amount with comma
                      _buildDetailRow("Interest:", "2 rs", context),
                      _buildDetailRow(
                          "Date:", "12/05/2023", context), // Added status
                    ],
                  ),
                ),
                const SizedBox(width: 16), // Add spacing between columns
                // Image
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    // Clip to match card's rounded corners
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'lib/assets/images/logo.jpg',
                      height: 100, // Fixed height for the image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
