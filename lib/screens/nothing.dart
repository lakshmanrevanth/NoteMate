import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Dark background color
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0, // Remove app bar shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text('Payment', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView( // Allow scrolling if content overflows
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Payment Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 20),
            _buildTextField('Email Address', 'myemail@gmail.com', Icons.mail_outline, TextInputType.emailAddress),
            const SizedBox(height: 20),
            _buildTextField('Card Number', '8365 9263 9002 273', Icons.credit_card, TextInputType.number),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildTextField('Expiry', 'mm/yy', Icons.calendar_today, TextInputType.datetime),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTextField('CVC', 'XXX', Icons.lock_outline, TextInputType.number),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(value: false, onChanged: (value) {}), // Placeholder checkbox
                const Text('I have a promo code', style: TextStyle(color: Colors.white)),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Order Info', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            _buildOrderInfoRow('Subtotal', '\$90'),
            _buildOrderInfoRow('Fee', '\$10'),
            const Divider(color: Colors.grey), // Add a divider
            _buildOrderInfoRow('Total Amount', '\$100', isBold: true),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50), // Full width button
              ),
              onPressed: () {},
              child: const Text('Pay \$100', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String initialValue, IconData icon, TextInputType keyboardType) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label, 
        labelStyle: const TextStyle(color: Colors.grey),
        hintText: initialValue,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white), // White border
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildOrderInfoRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(color: Colors.white, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}

