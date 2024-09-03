import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../consts.dart';

class MySubscriptionPage extends StatelessWidget {
  const MySubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String?>> subscriptions = [
      {
        'planName': 'Basic',
        'price': '₹1 /-',
        'duration': '3 Months',
        'totalAds': '1',
        'usedAds': '0',
        'availableAds': '1',
        'startDate': '2024-08-12',
        'expiry': '2024-11-12',
        'status': 'Active',
      },
      {
        'planName': 'Premium',
        'price': '₹3999 /-',
        'duration': '6 Months',
        'totalAds': '30',
        'usedAds': '5',
        'availableAds': '25',
        'startDate': '2023-08-12',
        'expiry': '2024-02-12',
        'status': 'Expired',
      },
      // Add more subscriptions here if needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Subscriptions'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryTextColor,
                AppColors.primaryColor,
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
            final subscription = subscriptions[index];
            return Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white, // Set card background color to white
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.trophy,
                          size: 24,
                          color: Colors.amber[700],
                        ),
                        const SizedBox(width: 10),
                        Text(
                          subscription['planName'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(), // This pushes the circle to the end
                        Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: subscription['status'] == 'Active'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          subscription['price'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryTextColor,
                          ),
                        ),
                        Text(
                          'Duration: ${subscription['duration'] ?? 'N/A'}',
                          style: const TextStyle(
                            fontSize: 14, // Reduced font size
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _buildInfoWrap(
                      items: [
                        _buildInfoItem(
                          icon: FontAwesomeIcons.rectangleAd,
                          label: "Total Ads",
                          value: subscription['totalAds'] ?? 'N/A',
                        ),
                        _buildInfoItem(
                          icon: FontAwesomeIcons.checkCircle,
                          label: "Used Ads",
                          value: subscription['usedAds'] ?? 'N/A',
                        ),
                        _buildInfoItem(
                          icon: FontAwesomeIcons.circlePlus,
                          label: "Available Ads",
                          value: subscription['availableAds'] ?? 'N/A',
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            icon: FontAwesomeIcons.calendarDays,
                            label: "Start",
                            value: subscription['startDate'] ?? 'N/A',
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildInfoItem(
                            icon: FontAwesomeIcons.hourglassEnd,
                            label: "Expiry",
                            value: subscription['expiry'] ?? 'N/A',
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

  Widget _buildInfoWrap({required List<Widget> items}) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items,
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 5),
        Text(
          "$label: $value",
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 13, // Smaller font size
            fontFamily: 'Poppins', // Poppins font family
          ),
        ),
      ],
    );
  }
}
