import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:promissorynotemanager/data/note_data.dart';

class CreateNotePage extends StatefulWidget {
  final Function(NoteData) onAddNote;
  const CreateNotePage({super.key, required this.onAddNote});
  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final _formKey = GlobalKey<FormState>();
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

  void _saveNote() {
    // if (_formKey.currentState!.validate()) {
      final noteData = NoteData(
        name: _nameController.text,
        principalAmount: double.parse(_principalAmountController.text),
        interestRate: double.parse(_interestRateController.text),
        date: DateFormat('dd/MM/yyyy').parse(_fromDateController.text),
        images: _selectedimages!,
      );
      widget.onAddNote(noteData); // Call the callback to pass data to HomePage

      // Close the bottom sheet or navigate back to HomePage
      Navigator.pop(context);
    // }
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
      final List<XFile>? pickedImages = await ImagePicker().pickMultiImage();
      if (pickedImages != null) {
        setState(() {
          _selectedimages = pickedImages.map((e) => File(e.path)).toList();
        });
      }
    } catch (e) {
      print('Error picking images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking images: $e')),
      );
    }
  }

  void _clearImageFields() {
    setState(() {
      _selectedimages!.clear();
    });
  }

  void _showFullScreenImage(File imageFile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(10),
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
