// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import '../components/no_data_found.dart';
// import '../service/api_service.dart';
// import '../service/paymentservice/phonepay_service.dart';
// import '../consts.dart';
//
// class SubscriptionPlanPage extends StatefulWidget {
//   const SubscriptionPlanPage({super.key});
//
//   @override
//   _SubscriptionPlanPageState createState() => _SubscriptionPlanPageState();
// }
//
// class _SubscriptionPlanPageState extends State<SubscriptionPlanPage> {
//   List<Map<String, dynamic>> subscriptions = [];
//   bool isLoading = true;
//   bool hasError = false;
//   bool isPaymentLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchSubscriptions();
//     _initializePayment();
//   }
//
//   Future<void> _initializePayment() async {
//     await PaymentService.initializePhonePe();
//   }
//
//   Future<void> fetchSubscriptions() async {
//     try {
//       final fetchedSubscriptions = await ApiService.fetchSubscriptions();
//       setState(() {
//         subscriptions = fetchedSubscriptions;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//         hasError = true;
//       });
//       print(e);
//     }
//   }
//
//   Future<void> _processPayment(double amount, String planName) async {
//     setState(() {
//       isPaymentLoading = true;
//     });
//
//     try {
//       // Initiate payment using PaymentService
//       final result = await PaymentService.startPayment(
//         amount: amount,
//         userId: "USER_${DateTime.now().millisecondsSinceEpoch}",
//         mobileNumber: null, // You can add mobile number field if needed
//       );
//
//       // Handle payment result
//       if (result['success']) {
//         final transactionId = result['transactionId'];
//         print("Transaction ID: $transactionId");
//         print("Payment Response: ${result['response']}");
//
//         // Show success dialog after successful payment
//         _showSuccessDialog(context, planName, transactionId);
//       } else {
//         _showErrorDialog(context, "Payment failed: ${result['error']}");
//         print("Error details: ${result['error']}");
//       }
//     } catch (e) {
//       _showErrorDialog(context, "Payment error occurred: $e");
//       print("Exception caught: $e");
//     } finally {
//       setState(() {
//         isPaymentLoading = false;
//       });
//     }
//   }
//
//   Widget _buildGradientButton({
//     required String text,
//     required VoidCallback onPressed,
//     bool isLoading = false,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [
//             AppColors.primaryColor,
//             AppColors.primaryTextColor,
//           ],
//         ),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: ElevatedButton(
//         onPressed: isLoading ? null : onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         child: isLoading
//             ? const SizedBox(
//           width: 20,
//           height: 20,
//           child: CircularProgressIndicator(
//             strokeWidth: 2,
//             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//           ),
//         )
//             : Text(
//           text,
//           style: const TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
//
//   void _showConfirmationDialog(BuildContext context, String planName, double amount, VoidCallback onConfirm) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         title: const Row(
//           children: [
//             Icon(Icons.payment, color: Colors.blueAccent),
//             SizedBox(width: 10),
//             Text('Confirm Payment', style: TextStyle(fontWeight: FontWeight.bold)),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Plan: $planName',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Amount: ₹${amount.toStringAsFixed(2)}',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               'Are you sure you want to proceed with the payment?',
//               style: TextStyle(fontSize: 14),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text(
//               'Cancel',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ),
//           _buildGradientButton(
//             text: 'Pay Now',
//             onPressed: () {
//               Navigator.pop(context); // Close the dialog
//               onConfirm(); // Call the confirmation action
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showSuccessDialog(BuildContext context, String planName, String transactionId) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         title: const Row(
//           children: [
//             Icon(Icons.check_circle, color: Colors.greenAccent),
//             SizedBox(width: 10),
//             Text('Payment Successful', style: TextStyle(fontWeight: FontWeight.bold)),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Congratulations! You have successfully subscribed to the "$planName" plan.',
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               'Transaction ID: $transactionId',
//               style: const TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           ],
//         ),
//         actions: [
//           _buildGradientButton(
//             text: 'OK',
//             onPressed: () => Navigator.pop(context),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showErrorDialog(BuildContext context, String errorMessage) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         title: const Row(
//           children: [
//             Icon(Icons.error, color: Colors.redAccent),
//             SizedBox(width: 10),
//             Text('Payment Failed', style: TextStyle(fontWeight: FontWeight.bold)),
//           ],
//         ),
//         content: Text(
//           errorMessage,
//           style: const TextStyle(fontSize: 16),
//         ),
//         actions: [
//           _buildGradientButton(
//             text: 'OK',
//             onPressed: () => Navigator.pop(context),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Subscription Plan'),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 AppColors.primaryColor,
//                 AppColors.primaryTextColor,
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : hasError
//             ? const NoDataFound(message: 'Unable to load subscription plans. Please try again.')
//             : subscriptions.isEmpty
//             ? const NoDataFound(message: 'No subscription plans available.')
//             : ListView.builder(
//           itemCount: subscriptions.length,
//           itemBuilder: (context, index) {
//             final plan = subscriptions[index];
//             final planPrice = double.tryParse(plan['price'].toString()) ?? 0.0;
//
//             return Card(
//               elevation: 4,
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           plan['description'] ?? 'Unknown',
//                           style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 5),
//                         Row(
//                           children: [
//                             const Icon(
//                               FontAwesomeIcons.calendarAlt,
//                               size: 16,
//                               color: Colors.grey,
//                             ),
//                             const SizedBox(width: 5),
//                             Text(
//                               '${plan['duration']} Months',
//                               style: const TextStyle(color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 5),
//                         Row(
//                           children: [
//                             const Icon(
//                               FontAwesomeIcons.tags,
//                               size: 16,
//                               color: Colors.grey,
//                             ),
//                             const SizedBox(width: 5),
//                             Text(
//                               "${plan['total_product']} Ads",
//                               style: const TextStyle(color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           '₹${plan['price']} /-',
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.primaryTextColor,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         _buildGradientButton(
//                           text: 'Select',
//                           isLoading: isPaymentLoading,
//                           onPressed: () {
//                             _showConfirmationDialog(
//                                 context,
//                                 plan['description'] ?? 'Unknown Plan',
//                                 planPrice,
//                                     () {
//                                   _processPayment(planPrice, plan['description'] ?? 'Unknown Plan');
//                                 }
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../components/no_data_found.dart';
import '../service/api_service.dart';
import '../service/paymentservice/phonepay_service.dart';
import '../consts.dart';

class SubscriptionPlanPage extends StatefulWidget {
  final int userId; // Add userId parameter

  const SubscriptionPlanPage({
    super.key,
    required this.userId,
  });

  @override
  _SubscriptionPlanPageState createState() => _SubscriptionPlanPageState();
}

class _SubscriptionPlanPageState extends State<SubscriptionPlanPage> {
  List<Map<String, dynamic>> subscriptions = [];
  bool isLoading = true;
  bool hasError = false;
  bool isPaymentLoading = false;

  @override
  void initState() {
    super.initState();
    fetchSubscriptions();
    _initializePayment();
  }

  Future<void> _initializePayment() async {
    await PaymentService.initializePhonePe();
  }

  Future<void> fetchSubscriptions() async {
    try {
      final fetchedSubscriptions = await ApiService.fetchSubscriptions();
      setState(() {
        subscriptions = fetchedSubscriptions;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      print(e);
    }
  }

  Future<void> _processPayment(double amount, String planName, int planId) async {
    setState(() {
      isPaymentLoading = true;
    });

    try {
      // Initiate payment using PaymentService
      final result = await PaymentService.startPayment(
        amount: amount,
        userId: "USER_${DateTime.now().millisecondsSinceEpoch}",
        mobileNumber: null, // You can add mobile number field if needed
      );

      // Handle payment result
      if (result['success']) {
        final transactionId = result['transactionId'];
        print("Transaction ID: $transactionId");
        print("Payment Response: ${result['response']}");

        // Call API to create user subscription after successful payment
        bool subscriptionCreated = await ApiService().createUserSubscription(
          userId: widget.userId,
          planId: planId,
        );

        if (subscriptionCreated) {
          // Show success dialog after successful payment and subscription creation
          _showSuccessDialog(context, planName, transactionId);
        } else {
          // Payment successful but subscription creation failed
          _showErrorDialog(context, "Payment successful but failed to activate subscription. Please contact support.");
        }
      } else {
        _showErrorDialog(context, "Payment failed: ${result['error']}");
        print("Error details: ${result['error']}");
      }
    } catch (e) {
      _showErrorDialog(context, "Payment error occurred: $e");
      print("Exception caught: $e");
    } finally {
      setState(() {
        isPaymentLoading = false;
      });
    }
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryTextColor,
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String planName, double amount, int planId, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(
          children: [
            Icon(Icons.payment, color: Colors.blueAccent),
            SizedBox(width: 10),
            Text('Confirm Payment', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plan: $planName',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'Amount: ₹${amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            const Text(
              'Are you sure you want to proceed with the payment?',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          _buildGradientButton(
            text: 'Pay Now',
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              onConfirm(); // Call the confirmation action
            },
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String planName, String transactionId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.greenAccent),
            SizedBox(width: 10),
            Text('Payment Successful', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Congratulations! You have successfully subscribed to the "$planName" plan.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              'Transaction ID: $transactionId',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your subscription has been activated successfully!',
              style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          _buildGradientButton(
            text: 'OK',
            onPressed: () {
              Navigator.pop(context);
              // Optionally navigate back to previous screen or refresh data
              Navigator.pop(context); // Go back to previous screen
            },
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.redAccent),
            SizedBox(width: 10),
            Text('Payment Failed', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          errorMessage,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          _buildGradientButton(
            text: 'OK',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Plan'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor,
                AppColors.primaryTextColor,
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : hasError
            ? const NoDataFound(message: 'Unable to load subscription plans. Please try again.')
            : subscriptions.isEmpty
            ? const NoDataFound(message: 'No subscription plans available.')
            : ListView.builder(
          itemCount: subscriptions.length,
          itemBuilder: (context, index) {
            final plan = subscriptions[index];
            final planPrice = double.tryParse(plan['price'].toString()) ?? 0.0;
            final planId = plan['id'] ?? 0; // Assuming the plan has an 'id' field

            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan['description'] ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.calendarAlt,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${plan['duration']} Months',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.tags,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "${plan['total_product']} Ads",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${plan['price']} /-',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildGradientButton(
                          text: 'Select',
                          isLoading: isPaymentLoading,
                          onPressed: () {
                            _showConfirmationDialog(
                                context,
                                plan['description'] ?? 'Unknown Plan',
                                planPrice,
                                planId,
                                    () {
                                  _processPayment(planPrice, plan['description'] ?? 'Unknown Plan', planId);
                                }
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}