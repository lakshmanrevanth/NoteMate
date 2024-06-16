import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:promissorynotemanager/data/history_data.dart';
import 'package:promissorynotemanager/dataprovider/authprovider.dart'
    as authprovider;
import 'package:promissorynotemanager/models/history.dart';
import 'package:promissorynotemanager/screens/history_popup.dart';
import 'package:provider/provider.dart';

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

  String _calculateDuration(DateTime fromDate, DateTime tillDate) {
    final difference = tillDate.difference(fromDate);
    return '${difference.inDays ~/ 365} years ${(difference.inDays % 365) ~/ 30} months';
  }

  double calculateint(double principalAmount, double interestRate,
      DateTime fromDate, DateTime tillDate) {
    int durationInDays = tillDate.difference(fromDate).inDays;
    double durationInYears = durationInDays / 365;
    double interest = (principalAmount * interestRate * durationInYears);
    return interest;
  }

  void _calculateInterest() async {
    final authProvider =
        Provider.of<authprovider.AuthProvider>(context, listen: false);
    FocusScope.of(context).unfocus();

    try {
      // Input validation
      if (_principalAmountController.text.isEmpty ||
          _interestRateController.text.isEmpty ||
          _fromDateController.text.isEmpty ||
          _tillDateController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')),
        );
        return;
      }

      double principal =
          double.tryParse(_principalAmountController.text) ?? 0.0;
      double interestRate =
          double.parse(_interestRateController.text) * 12 / 100;
      if (principal <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Principal amount must be greater than zero')),
        );
        return;
      }

      DateTime fromDate =
          DateFormat('dd/MM/yyyy').parse(_fromDateController.text);
      DateTime tillDate =
          DateFormat('dd/MM/yyyy').parse(_tillDateController.text);

      if (tillDate.isBefore(fromDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Till date cannot be before from date')),
        );
        return;
      }

      // Calculate interest and total amount
      double interest =
          calculateint(principal, interestRate, fromDate, tillDate);
      double totalamount = principal + interest;

      // Create HistoryData object
      final historydata = HistoryData(
        principalAmount: principal,
        interestRate: interestRate,
        fromDate: fromDate,
        tillDate: tillDate,
        interestEarned: interest,
        duration: _calculateDuration(fromDate, tillDate),
        totalAmount: totalamount,
      );

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authProvider.user!.uid)
          .collection('interestcalculationhistory')
          .add(historydata.toMap());

      setState(() {
        _history.add(historydata);
      });
      _clearFields();
    } catch (e) {
      print("Error saving interest calculation history: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving calculation history')),
      );
    }
  }

  Future<void> _refreshHistory() async {
    final authProvider =
        Provider.of<authprovider.AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(authProvider.user!.uid)
            .collection('interestcalculationhistory')
            .get();

        setState(() {
          _history.clear();
          for (var doc in snapshot.docs) {
            _history
                .add(HistoryData.fromMap(doc.data() as Map<String, dynamic>));
          }
        });
      } catch (e) {
        print("Error fetching history data: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching history data')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<authprovider.AuthProvider>(context, listen: false);
    return RefreshIndicator(
      onRefresh: _refreshHistory,
      child: GestureDetector(
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
                      _buildTextField('Enter Principal Amount', '₹',
                          Icons.money, TextInputType.number,
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
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              if (authProvider.user != null) // Check if user is logged in
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(authProvider.user!.uid)
                      .collection('interestcalculationhistory')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return SliverToBoxAdapter(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SliverToBoxAdapter(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(child: Text("No History")),
                      );
                    }

                    // Use 'snapshot.data!.docs' directly
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final historyData = snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: GestureDetector(
                              onLongPress: () {
                                HistoryPopUp().showHistoryDialog(
                                  context,
                                  HistoryData.fromMap(
                                      historyData), // Ensure correct type here
                                );
                              },
                              child: HistoryModel(
                                historyData: HistoryData.fromMap(historyData),
                              ),
                            ),
                          );
                        },
                        childCount: snapshot.data!.docs.length,
                      ),
                    );
                  },
                ),
            ],
          ),
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
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffixText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildDateField(
    String label,
    IconData icon,
    TextInputType keyboardType, {
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null) {
          setState(() {
            controller.text = DateFormat('dd/MM/yyyy').format(picked);
          });
        }
      },
    );
  }
}
