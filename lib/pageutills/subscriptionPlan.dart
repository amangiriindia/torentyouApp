// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../consts.dart';

// class SubscriptionPlanPage extends StatefulWidget {
//   const SubscriptionPlanPage({super.key});

//   @override
//   _SubscriptionPlanPageState createState() => _SubscriptionPlanPageState();
// }

// class _SubscriptionPlanPageState extends State<SubscriptionPlanPage> {
//   List<Map<String, dynamic>> subscriptions = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchSubscriptions();
//   }

//   Future<void> fetchSubscriptions() async {
//     final url = '${AppConstant.API_URL}api/v1/subscription/all-subscription';

//     try {
//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success']) {
//           setState(() {
//             subscriptions = List<Map<String, dynamic>>.from(data['results']);
//             isLoading = false;
//           });
//         } else {
//           // Handle API error
//           setState(() {
//             isLoading = false;
//           });
//         }
//       } else {
//         // Handle network error
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       // Handle general error
//       setState(() {
//         isLoading = false;
//       });
//       print('Error fetching subscriptions: $e');
//     }
//   }

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
//             : ListView.builder(
//           itemCount: subscriptions.length,
//           itemBuilder: (context, index) {
//             final plan = subscriptions[index];
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
//                         Container(
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               colors: [
//                                 AppColors.primaryTextColor,
//                                 AppColors.primaryColor,
//                               ],
//                             ),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: ElevatedButton(
//                             onPressed: () {
//                               // Implement the action here
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.transparent,
//                               shadowColor: Colors.transparent,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                             child: const Text(
//                               'Select',
//                               style: TextStyle(
//                                 color: Colors.white, // Set text color to white
//                               ),
//                             ),
//                           ),
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
import '../consts.dart';


class SubscriptionPlanPage extends StatefulWidget {
  const SubscriptionPlanPage({super.key});

  @override
  _SubscriptionPlanPageState createState() => _SubscriptionPlanPageState();
}

class _SubscriptionPlanPageState extends State<SubscriptionPlanPage> {
  List<Map<String, dynamic>> subscriptions = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchSubscriptions();
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
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.primaryTextColor,
                                              AppColors.primaryColor,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Implement the action here
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text(
                                            'Select',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
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
