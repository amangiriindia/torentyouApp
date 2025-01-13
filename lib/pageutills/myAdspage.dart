import 'dart:convert'; // For decoding JSON response
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:try_test/constant/user_constant.dart';
import '../consts.dart'; // Assuming your color definitions are here
import '../pages/Postadswithnavbar.dart';

class MyAdsPage extends StatefulWidget {
  const MyAdsPage({super.key});

  @override
  _MyAdsPageState createState() => _MyAdsPageState();
}

class _MyAdsPageState extends State<MyAdsPage> {
  List<dynamic> myAds = []; // This will store the list of ads
  bool isLoading = true; // Show loading indicator initially
  bool hasError = false; // Error handling flag
  int? userId;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
  
    userId = UserConstant.USER_ID ?? 6;
    setState(() {}); // Call setState to update the UI if `id` is being used there
    if(userId != null){
      fetchMyAds(); // Fetch ads when the widget initializes
    }
  }
  // Function to fetch ads from the API
  Future<void> fetchMyAds() async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstant.API_URL}api/v1/product/user-myads-all-product'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "seller_id": userId, // Assuming seller_id is hardcoded, you can replace it with dynamic data if needed
        }),
      );
      print('seller id $userId');
      print(response.body);
      print(response.statusCode);
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success']) {
          setState(() {
            myAds = data['results']; // Store ads in myAds list
            isLoading = false;
          });
      } else {
        setState(() {
          hasError = false; // Show error if API call fails
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true; // Show error on exception
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Ads',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22.49,
            fontWeight: FontWeight.w500,
            height: 18.74 / 12.49, // Line height based on font size
            color: Colors.black,
          ),
        ),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner
          : hasError
          ? const Center(child: Text('Error loading ads')) // Error message
          : myAds.isEmpty
          ? const Center(child: Text('No Ads Available')) // Empty state
          : Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: myAds.length,
          itemBuilder: (context, index) {
            final ad = myAds[index];
            return _buildAdCard(
              context,
              imageUrl: ad['image'],
              title: ad['product_name'],
              // Replace with actual category name if available
              monthlyRental: '${ad['monthly_rental']} /-',
              deposit: '${ad['deposit']} /-',
              location: ad['location'],
              package: ad['package'].isEmpty ? 'No' : 'Yes',
              status: ad['status'] == 1 ? 'Active' : 'Inactive',
              shortDescription: ad['short_description'],
              description: ad['description'].isEmpty
                  ? 'No description available'
                  : ad['description'],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAdCard(
      BuildContext context, {
        required String imageUrl,
        required String title,
        required String monthlyRental,
        required String deposit,
        required String location,
        required String package,
        required String status,
        required String shortDescription,
        required String description,
      }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              // Image Section
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: SizedBox(
                  height: 250, // Set height of image to 60% of card
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PostAdsWithNavPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 3),
                // Information Section
                Text(
                  'Monthly Rental: $monthlyRental   Deposit: $deposit\n'
                      'Location: $location   \n'
                      'Package: $package   Status: $status',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 9 / 6,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                // Short Description
                Text(
                  'Short Description:',
                  style: GoogleFonts.poppins(
                    fontSize: 12.49,
                    fontWeight: FontWeight.w500,
                    height: 18.74 / 12.49,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  shortDescription,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                // Description
                Text(
                  'Description:',
                  style: GoogleFonts.poppins(
                    fontSize: 12.49,
                    fontWeight: FontWeight.w500,
                    height: 15.74 / 12.49,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
