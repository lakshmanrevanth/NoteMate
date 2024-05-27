import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:promissorynotemanager/data/note_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:photo_view/photo_view.dart';

class DetailsPage extends StatelessWidget {
  final NoteData noteData;
  const DetailsPage({super.key, required this.noteData});

  @override
  Widget build(BuildContext context) {
    // Correct Calculation of Interest
    Widget _buildImagePreview(File imageFile) {
      return GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              child: PhotoView(
                imageProvider: FileImage(imageFile),
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
            child: Image.file(
              imageFile,
              height: MediaQuery.of(context).size.height *
                  0.25, // Adjust height as needed
              width: double.infinity, // Adjust width as needed
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    double _calculateInterest() {
      double principal = double.parse(noteData.principalAmount.toString());
      double rate = double.parse(noteData.interestRate.toString()) * 12 / 100;
      DateTime fromDate = noteData.date;
      DateTime tillDate = DateTime.now();
      int durationInDays = tillDate.difference(fromDate).inDays;
      double durationInYears = durationInDays / 365;
      double interest = (principal * rate * durationInYears);
      return interest;
    }

    String _calculateDuration(DateTime fromDate, DateTime tillDate) {
      final difference = tillDate.difference(fromDate);
      return '${difference.inDays ~/ 365} years ${(difference.inDays % 365) ~/ 30} months';
    }

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
                    _buildDetailRow("Name", "${noteData.name}", context),
                    _buildDetailRow("Principal Amount",
                        "₹${noteData.principalAmount}", context),
                    _buildDetailRow("Interest Rate",
                        "${noteData.interestRate} Rs", context),
                    _buildDetailRow(
                        "From Date",
                        DateFormat('dd/MM/yyyy').format(noteData.date),
                        context), // Formatted date
                    _buildDetailRow(
                        "Till Date",
                        DateFormat('dd/MM/yyyy').format(DateTime.now()),
                        context),
                    const SizedBox(
                        height: 20), // Additional spacing before total
                    _buildDetailRow(
                        "Duration: ",
                        _calculateDuration(noteData.date, DateTime.now()),
                        context),
                    _buildDetailRow(
                      "Interest",
                      "₹${_calculateInterest().toStringAsFixed(2)}",
                      context,
                      isSecondary: true,
                    ), // Interest in secondary style
                    const SizedBox(height: 10),
                    _buildDetailRow(
                        "Total Amount",
                        "₹${(noteData.principalAmount + _calculateInterest()).toStringAsFixed(2)}",
                        context,
                        isTotal: true), // Total in primary style
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (noteData.images.isNotEmpty)
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
                      items: noteData.images.map((image) {
                        return _buildImagePreview(image);
                      }).toList(),
                    ),
                  ),
                ],
              ),
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
}
