import 'package:flutter/material.dart';

import 'paymentService.dart';
import 'payment_config.dart';


class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  PhonePeService phonePeService = PhonePeService(
    baseUrl: PhonePeConfig.testHostUrl,
    apiKey: PhonePeConfig.testApiKey,
    apiKeyIndex: PhonePeConfig.testApiKeyIndex,
  );

  void startPayment() {
    phonePeService.initiateTransaction(
      merchantId: 'PGTESTPAYUAT',  // For testing
      transactionId: 'TXN12345678',  // Unique Transaction ID
      amount: 1000,  // Amount in paise, 1000 = 10 INR
      currency: 'INR',
      redirectUrl: 'https://amzsoftinnovexa.com',  // Your callback URL
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PhonePe Payment')),
      body: Center(
        child: ElevatedButton(
          onPressed: startPayment,
          child: Text('Pay with PhonePe'),
        ),
      ),
    );
  }
}
