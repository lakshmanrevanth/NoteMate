import 'package:flutter/material.dart';
import 'package:promissorynotemanager/models/history.dart';

class InterestCalculatorPage extends StatefulWidget {
  const InterestCalculatorPage({super.key});

  @override
  State<InterestCalculatorPage> createState() => _InterestCalculatorPageState();
}

class _InterestCalculatorPageState extends State<InterestCalculatorPage> {
  final _principalAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _fromDateController = TextEditingController();
  final _tillDateController = TextEditingController();

  void _clearFields() {
    _principalAmountController.clear();
    _interestRateController.clear();
    _fromDateController.clear();
    _tillDateController.clear();
  }

  @override
  void dispose() {
    _principalAmountController.dispose();
    _interestRateController.dispose();
    _fromDateController.dispose();
    _tillDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).primaryColor
          : Colors.white,
      appBar: AppBar(
        title: const Text("Interest Calculator"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Enter Principal Amount', '₹', Icons.money,
                TextInputType.number,
                controller: _principalAmountController),
            const SizedBox(height: 20),
            _buildTextField(
                'Interest Rate (%)', '%', Icons.percent, TextInputType.number,
                controller: _interestRateController),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildTextField('From Date', 'dd/mm/yyyy',
                      Icons.calendar_today, TextInputType.datetime,
                      controller: _fromDateController),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTextField('Till Date', 'dd/mm/yyyy',
                      Icons.calendar_today, TextInputType.datetime,
                      controller: _tillDateController),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _clearFields,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    fixedSize: const Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text("Clear"),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    fixedSize: const Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text("Calculate",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              "History",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            HistoryModel(
                principalAmount: 200000,
                interestRate: 2,
                fromDate: DateTime.now(),
                tillDate: DateTime.now(),
                interestEarned: 20000),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String suffixText,
    IconData icon,
    TextInputType keyboardType, {
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).primaryColorLight
              : const Color.fromARGB(255, 0, 0, 0)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).primaryColorLight
                : const Color.fromARGB(255, 8, 8, 8)),
        suffixText: suffixText,
        suffixStyle: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).primaryColorLight
                : const Color.fromARGB(255, 8, 8, 8)),
        prefixIcon: Icon(icon,
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).primaryColorLight
                : const Color.fromARGB(255, 0, 0, 0)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).primaryColorLight
                  : const Color.fromARGB(255, 0, 0, 0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
