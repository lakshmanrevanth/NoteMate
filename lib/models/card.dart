import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:promissorynotemanager/data/note_data.dart';

import 'package:promissorynotemanager/screens/details_page.dart';
import 'package:google_fonts/google_fonts.dart';

class NewCard extends StatefulWidget {
  final String name;
  final double principalamount;
  final DateTime fromdate;
  final List<File> images;
  final NoteData noteData;

  const NewCard(
      {Key? key,
      required this.name,
      required this.fromdate,
      required this.principalamount,
      required this.images,
      required this.noteData})
      : super(key: key);

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
          builder: (context) => DetailsPage(
            noteData: widget.noteData,
          ),
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
                        widget.noteData.name,
                        style: GoogleFonts.robotoMono(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                          "Amount:",
                          "₹${widget.noteData.principalAmount}",
                          context), // Format amount with comma
                      _buildDetailRow("Interest:",
                          "${widget.noteData.interestRate} (Rs)", context),

                      _buildDetailRow(
                          "Date:",
                          DateFormat('dd/MM/yyyy')
                              .format(widget.noteData.date), // Format the date
                          context), // Added status
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
                    child: widget.images.isNotEmpty // Check if there are images
                        ? Image.file(
                            widget.noteData.images[0], // Use the first image
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            // Use a placeholder image if the list is empty
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
