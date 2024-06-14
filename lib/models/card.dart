import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:promissorynotemanager/data/note_data.dart';
import 'package:promissorynotemanager/dataprovider/authprovider.dart'
    as authprovider;

import 'package:promissorynotemanager/screens/details_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NewCard extends StatefulWidget {
  final String noteId;

  const NewCard({Key? key, required this.noteId}) : super(key: key);

  @override
  State<NewCard> createState() => _NewCardState();
}

class _NewCardState extends State<NewCard> {
  NoteData? noteData;
  @override
  void initState() {
    super.initState();
    fetchNoteData();
  }

  Future<void> fetchNoteData() async {
    try {
      final authProvider =
          Provider.of<authprovider.AuthProvider>(context, listen: false);

      final userNotesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(authProvider.user!.uid)
          .collection('notes');

      final noteDoc = await userNotesCollection.doc(widget.noteId).get();

      if (noteDoc.exists) {
        setState(() {
          noteData = NoteData.fromMap(noteDoc.data()!);
        });
      } else {
        // Handle the case where the note doesn't exist
        // (e.g., show an error message or remove the card)
      }
    } catch (e) {
      // ... error handling (e.g., show a SnackBar)
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.9; // 80% of screen width
    if (noteData == null) {
      return const Center(
        child: SizedBox(),
      ); // Show loading indicator while fetching
    }
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => DetailsPage(
            noteId: widget.noteId,
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
                        noteData!.name,
                        style: GoogleFonts.robotoMono(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                          "Amount:",
                          "₹${noteData!.principalAmount}",
                          context), // Format amount with comma
                      _buildDetailRow("Interest:",
                          "${noteData!.interestRate} (Rs)", context),

                      _buildDetailRow(
                          "Date:",
                          DateFormat('dd/MM/yyyy')
                              .format(noteData!.fromDate), // Format the date
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
                    child: noteData != null && noteData!.imageUrls.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl:
                                noteData!.imageUrls[0], // Use the first image
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
