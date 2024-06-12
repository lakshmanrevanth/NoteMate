import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:promissorynotemanager/data/note_data.dart';
import 'package:promissorynotemanager/dataprovider/authprovider.dart'
    as authprovider;
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CreateNotePage extends StatefulWidget {
  final Function(NoteData) onAddNote;
  const CreateNotePage({super.key, required this.onAddNote});
  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final _nameController = TextEditingController();
  final _principalAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _fromDateController = TextEditingController();
  List<File>? _selectedimages = [];
  void _clearFields() {
    _nameController.clear();
    _principalAmountController.clear();
    _interestRateController.clear();
    _fromDateController.clear();
  }

  @override
  void dispose() {
    _principalAmountController.dispose();
    _interestRateController.dispose();
    _fromDateController.dispose();
    super.dispose();
  }

  double calculateInterest(
      double principalAmount, double interestRate, DateTime fromDate) {
    double rate = interestRate * 12 / 100;
    DateTime tillDate =
        DateTime.now(); // Or use noteData.tillDate if you have it
    int durationInDays = tillDate.difference(fromDate).inDays;
    double durationInYears = durationInDays / 365;
    double interest = (principalAmount * rate * durationInYears);
    return interest;
  }

  String calculateDuration(DateTime fromDate, DateTime tillDate) {
    final difference = tillDate.difference(fromDate);
    return '${difference.inDays ~/ 365} years ${(difference.inDays % 365) ~/ 30} months';
  }

  void _saveNote() async {
    final authProvider =
        Provider.of<authprovider.AuthProvider>(context, listen: false);

    if (authProvider.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in first')),
      );
      return;
    }

    try {
      List<String> imageUrls = [];
      if (_selectedimages != null) {
        for (var image in _selectedimages!) {
          final ref = firebase_storage.FirebaseStorage.instance.ref().child(
              'notes/${authProvider.user!.uid}/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}');
          await ref.putFile(image);
          final url = await ref.getDownloadURL();
          imageUrls.add(url);
        }
      }

      DateTime fromDate = _fromDateController.text != ''
          ? DateFormat('dd/MM/yyyy').parse(_fromDateController.text)
          : DateTime.now();
      DateTime tillDate =
          DateTime.now(); // Assuming you want tillDate to be the current time

      String durationText = calculateDuration(fromDate, tillDate);

      // Parse and validate principal and interest rate
      double principalAmount =
          double.tryParse(_principalAmountController.text) ?? 0.0;
      double interestRate =
          double.tryParse(_interestRateController.text) ?? 0.0;

      // Check if either principalAmount or interestRate is zero
      if (principalAmount == 0.0 || interestRate == 0.0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Principal or interest rate cannot be zero')),
        );
        return;
      }

      double calculatedInterest =
          calculateInterest(principalAmount, interestRate, fromDate);
      double totalAmount = principalAmount + calculatedInterest;

      final noteData = NoteData(
        name: _nameController.text,
        principalAmount: principalAmount,
        interestRate: interestRate,
        fromDate: fromDate,
        duration: durationText,
        imageUrls: imageUrls,
        interest: calculatedInterest,
        totalAmount: totalAmount,
        tillDate: tillDate,
      );

      final userNotesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(authProvider.user!.uid)
          .collection('notes');
      await userNotesCollection.add(noteData.toMap()); // Convert to Map
      widget.onAddNote(noteData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Note saved successfully")),
      );
      Navigator.pop(context); // Close the bottom sheet
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving note: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 800,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Create A Note",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: _clearFields,
                  child: const Text(
                    "Clear",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                label: Text("Enter Name"),
                hintText: "Name",
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _principalAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      label: Text("Enter Principal Amount"),
                      hintText: "100000",
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _interestRateController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      label: Text("Interest Rate"),
                      hintText: "In rupees",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Pick A Date",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _fromDateController,
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      hintText: "dd/mm/yyyy",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(double.infinity, double.minPositive),
                backgroundColor: const Color(0xFF8B3DFF),
                shape: const RoundedRectangleBorder(),
              ),
              onPressed: () {
                _imagePickingFromGallery();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Upload Images',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(Icons.image, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _selectedimages != null
                ? Expanded(
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _selectedimages!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _showFullScreenImage(_selectedimages![index]);
                          },
                          child: Image.file(
                            _selectedimages![index],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  )
                : const Text("Please select images"),
            const Expanded(
              child: SizedBox(),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      WidgetStateColor.resolveWith((states) => Colors.green),
                ),
                onPressed: () {
                  _saveNote();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Save Note",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _imagePickingFromGallery() async {
    try {
      final List<XFile> pickedImages = await ImagePicker().pickMultiImage();
      setState(() {
        _selectedimages = pickedImages.map((e) => File(e.path)).toList();
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking images: $e')),
      );
    }
  }

  // void _clearImageFields() {
  //   setState(() {
  //     _selectedimages!.clear();
  //   });
  // }

  void _showFullScreenImage(File imageFile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Center(
            child: Image.file(
              imageFile,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
