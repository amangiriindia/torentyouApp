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

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
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
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String planName, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.redAccent),
            SizedBox(width: 10),
            Text('Confirm Plan', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Are you sure you want to take the "$planName" plan?',
          style: const TextStyle(fontSize: 16),
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
            text: 'Yes',
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              onConfirm(); // Call the confirmation action
            },
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String planName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.greenAccent),
            SizedBox(width: 10),
            Text('Plan Purchased', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Congratulations! You have successfully subscribed to the "$planName" plan.',
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
                                        onPressed: () {
                                          _showConfirmationDialog(context, plan['description'], () {
                                            _showSuccessDialog(context, plan['description']);
                                          });
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
