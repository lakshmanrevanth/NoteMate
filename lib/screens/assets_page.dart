import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:promissorynotemanager/data/note_data.dart';
import 'package:provider/provider.dart';
import 'package:promissorynotemanager/dataprovider/authprovider.dart';

class AssetsPage extends StatefulWidget {
  const AssetsPage({super.key});

  @override
  _AssetsPageState createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  double totalPrincipal = 0.0;
  double totalInterest = 0.0;
  double totalAmount = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotesData();
  }

  Future<void> fetchNotesData() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final userNotesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(authProvider.user!.uid)
          .collection('notes');

      final querySnapshot = await userNotesCollection.get();

      double principal = 0.0;
      double interest = 0.0;

      for (var doc in querySnapshot.docs) {
        NoteData note = NoteData.fromMap(doc.data());
        principal += note.principalAmount;
        interest += note
            .interest; // Adjust this calculation based on how you store interest
      }

      setState(() {
        totalPrincipal = principal;
        totalInterest = interest;
        totalAmount = principal + interest;
        isLoading = false;
      });
    } catch (e) {
      // Handle error (e.g., show a SnackBar)
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "My Assets",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF007BFF), Color(0xFF0056b3)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Total Principal",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '\u{20B9} ${totalPrincipal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              "Total Interest",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '\u{20B9} ${totalInterest.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              "Total Amount",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '\u{20B9} ${totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // ... (Add your transaction list or widgets here)
                  ],
                ),
        ),
      ),
    );
  }
}
