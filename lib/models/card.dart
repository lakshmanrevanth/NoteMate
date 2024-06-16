import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:promissorynotemanager/data/note_data.dart';
import 'package:google_fonts/google_fonts.dart';

class NewCard extends StatelessWidget {
  final NoteData noteData; // Pass NoteData object
  final VoidCallback onTap;

  const NewCard({Key? key, required this.noteData, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.9; // 90% of screen width

    return GestureDetector(
      onTap: onTap,
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
                        noteData.name,
                        style: GoogleFonts.robotoMono(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow("Amount:", "₹${noteData.principalAmount}",
                          context), // Format amount with comma
                      _buildDetailRow(
                          "Interest:", "${noteData.interestRate}%", context),
                      _buildDetailRow(
                          "Date:",
                          DateFormat('dd/MM/yyyy').format(noteData.fromDate),
                          context), // Format the date
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
                    child: noteData.imageUrls.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl:
                                noteData.imageUrls[0], // Use the first image
                            // Placeholder while loading
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200], // Placeholder color
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            // Error widget if loading fails
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'lib/assets/images/logo.jpg',
                            height: 100,
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
