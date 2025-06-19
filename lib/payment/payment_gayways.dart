import 'package:flutter/material.dart';

import '../service/paymentservice/phonepay_service.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  Future<void> _initializePayment() async {
    await PaymentService.initializePhonePe();
  }

  Future<void> _startPayment() async {
    // Validate input
    if (_amountController.text.isEmpty) {
      _showSnackBar("Please enter amount");
      return;
    }

    // Show loading state
    setState(() {
      _isLoading = true;
    });

    try {
      // Parse amount and validate
      final amount = double.parse(_amountController.text);
      if (amount <= 0) {
        _showSnackBar("Please enter a valid amount");
        return;
      }

      // Initiate payment using PaymentService
      final result = await PaymentService.startPayment(
        amount: amount,
        userId: "USER_${DateTime.now().millisecondsSinceEpoch}",
        mobileNumber: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      );

      // Handle payment result
      if (result['success']) {
        final transactionId = result['transactionId'];
        // Enhanced feedback: Show transaction ID and log details
        _showSnackBar("Payment initiated successfully! Transaction ID: $transactionId");
        print("Transaction ID: $transactionId");
        print("Payment Response: ${result['response']}");
      } else {
        _showSnackBar("Payment failed: ${result['error']}");
        print("Error details: ${result['error']}");
      }
    } catch (e) {
      // Handle parsing or other errors
      _showSnackBar("Invalid amount or error occurred: $e");
      print("Exception caught: $e");
    } finally {
      // Reset loading state
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PhonePe Payment"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Amount (₹)",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.currency_rupee),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Mobile Number (Optional)",
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _startPayment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                "Pay with PhonePe",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Secure payments powered by PhonePe",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}