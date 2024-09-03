import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../consts.dart';

class SubscriptionPlanPage extends StatelessWidget {
  const SubscriptionPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> subscriptions = [
      {'duration': '3 Months', 'price': '₹1 /-', 'ads': '1', 'description': 'Basic'},
      {'duration': '3 Months', 'price': '₹3999 /-', 'ads': '30', 'description': 'Standard'},
      {'duration': '3 Months', 'price': '₹9999 /-', 'ads': '90', 'description': 'Super'},
      {'duration': '6 Months', 'price': '₹15999 /-', 'ads': '150', 'description': 'Premium'},
      {'duration': '6 Months', 'price': '₹19999 /-', 'ads': '200', 'description': 'Platinum'},
      {'duration': '6 Months', 'price': '₹39999 /-', 'ads': '500', 'description': 'Blockbuster'},
      {'duration': '12 Months', 'price': '₹69999 /-', 'ads': '1000', 'description': 'Platinum'},
    ];

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
        child: ListView.builder(
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
                          plan['description']!,
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
                              plan['duration']!,
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
                              "${plan['ads']} Ads",
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
                          plan['price']!,
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
                                color: Colors.white, // Set text color to white
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
