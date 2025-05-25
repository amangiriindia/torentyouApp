// import 'dart:convert';
// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
//
// class PhonePePaymentGatewaysTest extends StatefulWidget {
//   @override
//   State<PhonePePaymentGatewaysTest> createState() => _PhonePePaymentGatewaysTestState();
// }
//
// class _PhonePePaymentGatewaysTestState extends State<PhonePePaymentGatewaysTest> {
//
//       String environment ="UAT_SIM";
//       String appId ="";
//       String merchantId ="PGTESTPAYUAT";
//       bool enableLogging =true;
//       String checksum ="";
//       String saltKey ="099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";
//       String saltIndex ="1";
//       String callbackUrl ="https://webhook.site/9491c9a9-d05d-491c-b137-a48fa407bcb9";
//       String body ="";
//       String apiEndPoint = "/pg/v1/pay";
//       Object? result;
//
//       getChecksum(){
//
//        final resuestData =
//
//
//       //
//       //  {
//       //     "merchantId": merchantId,
//       //   "merchantTransactionId": "MT7850590068188104",
//       //   "merchantUserId": "MU933037302229373",
//       //   "amount": 10000,
//       //   "callbackUrl": callbackUrl,
//       //   "mobileNumber": "9999999999",
//       //   "paymentInstrument": {
//       //   "type": "PAY_PAGE",
//       // }
//
//          {
//            "merchantId": merchantId,
//            "merchantTransactionId": "MT7850590068188104",
//            "merchantUserId": "MUID123",
//            "amount": 10000,
//            "callbackUrl": callbackUrl,
//            "mobileNumber": "9999999999",
//            "paymentInstrument": {
//              "type": "PAY_PAGE"
//            }
//
//
//        };
//        String base64Body =base64.encode(utf8.encode(json.encode(resuestData)));
//
//        checksum = '${sha256.convert(utf8.encode(base64Body+apiEndPoint+saltKey)).toString()}###$saltIndex';
//
//        return base64Body;
//
//
// }
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     phonepayInit();
//     body = getChecksum().toString();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('PhonePe Payment Gateway Test'),
//         centerTitle: true,
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'PhonePe Payment Gateway Testing',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 startPgTransaction();
//                 // Simulate payment process or integrate PhonePe SDK/API here
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text('Payment process started!'),
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 backgroundColor: Colors.deepPurple,
//               ),
//               child: const Text(
//                 'Start Payment',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 20,),
//             Text("result \n $result")
//           ],
//         ),
//       ),
//     );
//   }
//
//   void phonepayInit() {
//
//     PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
//         .then((val) => {
//       setState(() {
//         result = 'PhonePe SDK Initialized - $val';
//       })
//     })
//         .catchError((error) {
//       handleError(error);
//       return <dynamic>{};
//     });
//
//   }
//
//
//       void startPgTransaction() async {
//         if (merchantId.isEmpty || callbackUrl.isEmpty || checksum.isEmpty) {
//           setState(() {
//             result = "Invalid parameters. Please check inputs.";
//           });
//           return;
//         }
//
//         try {
//           var response = await PhonePePaymentSdk.startTransaction(
//             body, apiEndPoint, checksum, "com.amzsoft.torentyou",
//           );
//           setState(() {
//             if (response != null && response['status'] == 'SUCCESS') {
//               result = "Transaction Successful!";
//             } else {
//                result = "Transaction Failed: ${response}";
//             }
//           });
//         } catch (error) {
//           handleError(error);
//         }
//       }
//
//       // void startPgTransaction() async {
//   //
//   //   try {
//   //    // PhonePePaymentSdk.startTransaction(body, appSchema, checksum, packageName)
//   //     var response = PhonePePaymentSdk.startTransaction(
//   //         body, apiEndPoint, checksum, ""  ,);
//   //     response
//   //         .then((val) => {
//   //       setState(() {
//   //         if(val != null){
//   //           String status = val['status'].toString();
//   //           String error = val['error'].toString();
//   //           if(status == 'SUCCESS'){
//   //             result ="FLow Complate = status :SUCCESS";
//   //           }else{
//   //             result ="FLow Complate = status $status and error $error";
//   //           }
//   //         }else{
//   //           result = "Flow Incomplete";
//   //         }
//   //
//   //       })
//   //     })
//   //         .catchError((error) {
//   //       handleError(error);
//   //       return <dynamic>{};
//   //     });
//   //   } catch (error) {
//   //     handleError(error);
//   //   }
//   //
//   // }
//
//
//   void handleError(error) {
//     setState(() {
//       result = {"error" :error};
//     });
//   }
//
//
// }
