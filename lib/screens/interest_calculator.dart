import 'package:flutter/material.dart';
import 'package:promissorynotemanager/models/history.dart';

class InterestCalculatorPage extends StatelessWidget {
  const InterestCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Dark background color

      body: SafeArea(
        child: SingleChildScrollView(
          // Allow scrolling if content overflows
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Interest Calculator',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 0, 0, 0))),
              const SizedBox(height: 20),
              _buildTextField('Enter Principal Amount', '10000', Icons.money,
                  TextInputType.phone),
              const SizedBox(height: 20),
              _buildTextField('Interest rate', '2rs', Icons.interests,
                  TextInputType.number),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('From date', 'dd/mm/yy',
                        Icons.calendar_today, TextInputType.datetime),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField('Till date', 'dd/mm/yy',
                        Icons.calendar_today, TextInputType.datetime),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 219, 0, 0),
                      minimumSize: const Size(50, 50), // Keep the same height
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius
                            .zero, // Set borderRadius to zero for a square shape
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Clear",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 0, 157, 58),
                      minimumSize: const Size(250, 50), // Keep the same height
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius
                            .zero, // Set borderRadius to zero for a square shape
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Calculate",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              const Text(
                "History",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              HistoryModel(),
              HistoryModel(),
              HistoryModel()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, IconData icon,
      TextInputType keyboardType) {
    return TextField(
      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 8, 8, 8)),
        hintText: initialValue,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 0, 0, 0)),
        enabledBorder: const OutlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromARGB(255, 0, 0, 0)), // White border
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      keyboardType: keyboardType,
    );
  }
}
