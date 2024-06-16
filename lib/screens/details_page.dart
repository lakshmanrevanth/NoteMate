import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:promissorynotemanager/data/note_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:promissorynotemanager/dataprovider/authprovider.dart'
    as authprovider;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class DetailsPage extends StatefulWidget {
  final String noteId; // Receive noteId from the previous screen
  const DetailsPage({super.key, required this.noteId});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
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
        // Handle the case where the note doesn't exist (e.g., show an error message)
      }
    } catch (e) {
      print("Error fetching note data: $e");
      // Handle errors appropriately (e.g., show a SnackBar)
    }
  }

  void _shareNoteDetails(NoteData noteData) async {
    final textToShare = "Note Details:\n\n"
        "Name: ${noteData.name}\n"
        "Principal Amount: ₹${noteData.principalAmount.toStringAsFixed(2)}\n"
        "Interest Rate: ${noteData.interestRate.toStringAsFixed(2)}Rs\n"
        "From Date: ${DateFormat('dd/MM/yyyy').format(noteData.fromDate)}\n"
        "Till Date: ${DateFormat('dd/MM/yyyy').format(noteData.tillDate)}\n"
        "Duration: ${noteData.duration}\n"
        "Interest Earned: ₹${noteData.interest.toStringAsFixed(2)}\n"
        "Total Amount: ₹${noteData.totalAmount.toStringAsFixed(2)}";

    // Optionally, share a screenshot of the page (you'll need to implement this separately)
    // ...
    await Share.share(
        textToShare); // Use Share.share to initiate sharing dialog
  }

  Widget buildImagePreview(String imageUrl) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(imageUrl),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 1.8,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(5), // Add some margin between images
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            height: MediaQuery.of(context).size.height * 0.25,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
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
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isSecondary ? Colors.grey[600] : null,
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

  @override
  Widget build(BuildContext context) {
    // Correct Calculation of Interest
    if (noteData == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.9,
        child: SingleChildScrollView(
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
                      _buildDetailRow("Name", noteData!.name, context),
                      _buildDetailRow("Principal Amount",
                          "₹${noteData!.principalAmount}", context),
                      _buildDetailRow("Interest Rate",
                          "${noteData!.interestRate} Rs", context),
                      _buildDetailRow(
                          "From Date",
                          DateFormat('dd/MM/yyyy').format(noteData!.fromDate),
                          context), // Formatted date
                      _buildDetailRow(
                          "Till Date",
                          DateFormat('dd/MM/yyyy').format(DateTime.now()),
                          context),
                      const SizedBox(
                          height: 20), // Additional spacing before total
                      _buildDetailRow(
                          "Duration: ", noteData!.duration, context),
                      _buildDetailRow(
                        "Interest",
                        "₹${noteData!.interest.toStringAsFixed(2)}",
                        context,
                        isSecondary: true,
                      ), // Interest in secondary style
                      const SizedBox(height: 10),
                      _buildDetailRow(
                          "Total Amount",
                          "₹${(noteData!.principalAmount + noteData!.interest).toStringAsFixed(2)}",
                          context,
                          isTotal: true), // Total in primary style
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (noteData!.imageUrls.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20), // Add spacing before images
                    Text(
                      'Images:',
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.35, // Adjust height as needed
                      child: CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 0.8,
                        ),
                        items: noteData!.imageUrls.map((image) {
                          return buildImagePreview(image);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              Center(
                child: IconButton(
                  onPressed: () {
                    if (noteData != null) {
                      _shareNoteDetails(noteData!);
                    } else {
                      // Handle the case where noteData is not yet loaded
                    }
                  },
                  icon: const Icon(Icons.ios_share, size: 30),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
