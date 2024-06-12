import 'package:flutter/material.dart';

class AssetsPage extends StatelessWidget {
  const AssetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(
              20.0), // Increased padding for better spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "My Assets",
                style: TextStyle(
                  fontSize: 28, // Slightly larger font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                  height: 30), // Increased spacing for visual separation
              // Stylish Card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      20), // More pronounced rounded corners
                  gradient: const LinearGradient(
                    // Gradient background
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF007BFF),
                      Color(0xFF0056b3)
                    ], // Blue gradient
                  ),
                  boxShadow: [
                    // Subtle shadow
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(25.0), // More padding inside the card
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align text to the start
                    children: [
                      Text(
                        "Total Assets",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white, // White text for contrast
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '\u{20B9} 35,00,000', // Indian Rupee symbol and commas for readability
                        style: TextStyle(
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
