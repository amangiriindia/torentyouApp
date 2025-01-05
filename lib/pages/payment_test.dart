// import 'dart:convert';
// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
//
// class PaymentScreen extends StatefulWidget {
//   @override
//   _PaymentScreenState createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   final TextEditingController _amountController = TextEditingController();
//   String _transactionStatus = "Enter amount and click Pay Now";
//
//   @override
//   void initState() {
//     super.initState();
//     _initializePhonePeSDK();
//   }
//
//   Future<void> _initializePhonePeSDK() async {
//     try {
//       bool isInitialized = await PhonePePaymentSdk.init(
//         "SANDBOX", // Use "PRODUCTION" for live environment
//         null, // appId (optional)
//         "PGTESTPAYUAT", // Test Merchant ID
//         true, // Enable logging
//       );
//       if (isInitialized) {
//         setState(() {
//           _transactionStatus = "PhonePe SDK Initialized Successfully";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _transactionStatus = "Error initializing SDK: $e";
//       });
//     }
//   }
//
//   Future<void> _startTransaction() async {
//     String amount = _amountController.text.trim();
//     if (amount.isEmpty || double.tryParse(amount) == null) {
//       setState(() {
//         _transactionStatus = "Please enter a valid amount";
//       });
//       return;
//     }
//
//     String requestBody = {
//       "merchantId": "PGTESTPAYUAT",
//       "merchantTransactionId": "TXN${DateTime.now().millisecondsSinceEpoch}",
//       "merchantUserId": "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399",
//       "amount": (double.parse(amount) * 100).toInt(),
//       "callbackUrl": "https://api-preprod.phonepe.com/apis/hermes",
//       "mobileNumber": "9999999999",
//       "paymentInstrument": {"type": "PAY_PAGE"}
//     }.toString();
//
//     String base64RequestBody = base64Encode(utf8.encode(requestBody));
//     String checksum = "";
//     //_calculateChecksum(base64RequestBody);
//
//
//
//
//   String _calculateChecksum(String base64RequestBody) {
//     const apiEndPoint = "/pg/v1/pay";
//     const salt = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";
//     const saltIndex = "1";
//
//     String checksum = sha256.convert(utf8.encode(base64RequestBody + apiEndPoint + salt)).toString();
//     return "$checksum###$saltIndex";
//   }
//     Future<void> _startTransaction() async {
//       // ... (Prepare requestBody and checksum as shown above) ...
//
//       try {
//         Map<dynamic, dynamic>? response = await PhonePePaymentSdk.startTransaction(
//           base64RequestBody,
//           "com.amzsoft.torentyou", // Replace with your app schema for iOS
//          // checksum,
//           "com.amzsoft.torentyou", // Package name (optional for Android)
//         );
//         if (response != null) {
//           // Handle the transaction response
//         } else {
//           // Handle transaction failure
//         }
//       } catch (e) {
//         // Handle errors
//       }
//     }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Payment Gateway")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _amountController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(
//                 labelText: "Enter Amount",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _startTransaction,
//               child: Text("Pay Now"),
//             ),
//             SizedBox(height: 16),
//             Text(_transactionStatus, textAlign: TextAlign.center),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }
