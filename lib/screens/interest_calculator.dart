import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:promissorynotemanager/data/history_data.dart';
import 'package:promissorynotemanager/models/history.dart';
import 'package:promissorynotemanager/screens/history_popup.dart';

class InterestCalculatorPage extends StatefulWidget {
  const InterestCalculatorPage({super.key});
  @override
  State<InterestCalculatorPage> createState() => _InterestCalculatorPageState();
}

class _InterestCalculatorPageState extends State<InterestCalculatorPage> {
  final List<HistoryData> _history = [];
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

  void _calculateInterest() {
    FocusScope.of(context).unfocus();
    double principal = double.parse(_principalAmountController.text);
    double rate = double.parse(_interestRateController.text) * 12 / 100;
    DateTime fromDate =
        DateFormat('dd/MM/yyyy').parse(_fromDateController.text);
    DateTime tillDate =
        DateFormat('dd/MM/yyyy').parse(_tillDateController.text);
    int durationInDays = tillDate.difference(fromDate).inDays;
    double durationInYears = durationInDays / 365;
    double interest = (principal * rate * durationInYears);
    setState(() {
      _history.add(HistoryData(
        principalAmount: principal.toInt(),
        interestRate: rate * 100,
        fromDate: fromDate,
        tillDate: tillDate,
        interestEarned: interest.toInt(),
      ));
    });
    _clearFields();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).primaryColor
            : Colors.white,
        appBar: AppBar(
          title: const Text("Interest Calculator"),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField('Enter Principal Amount', '₹', Icons.money,
                        TextInputType.number,
                        controller: _principalAmountController),
                    const SizedBox(height: 20),
                    _buildTextField('Interest Rate (Rs)', 'Rs',
                        Icons.currency_rupee, TextInputType.number,
                        controller: _interestRateController),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateField('From Date',
                              Icons.calendar_today, TextInputType.datetime,
                              controller: _fromDateController),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildDateField('Till Date',
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
                          onPressed: () {
                            _calculateInterest();
                            HistoryPopUp()
                                .showHistoryDialog(context, _history.last);
                          },
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
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onLongPress: () {
                      HistoryPopUp()
                          .showHistoryDialog(context, _history[index]);
                    },
                    child: HistoryModel(
                      historyData: _history.reversed.toList()[index],
                    ),
                  ),
                ),
                childCount: _history.length,
              ),
            ),
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

  Widget _buildDateField(
    String label,
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
        hintText: "dd/MM/yyyy",
        labelText: label,
        labelStyle: TextStyle(
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
