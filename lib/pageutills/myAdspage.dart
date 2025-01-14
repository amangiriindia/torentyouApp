import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../service/api_service.dart';
import '../consts.dart';
import '../pages/Postadswithnavbar.dart';

class MyAdsPage extends StatefulWidget {
  const MyAdsPage({super.key});

  @override
  _MyAdsPageState createState() => _MyAdsPageState();
}

class _MyAdsPageState extends State<MyAdsPage> {
  final ApiService _apiService = ApiService();
  List<dynamic> myAds = [];
  bool isLoading = true;
  bool hasError = false;
  int? userId;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    userId = 6; // Replace with your logic to fetch user ID
    setState(() {});
    if (userId != null) {
      fetchMyAds();
    }
  }

  Future<void> fetchMyAds() async {
    try {
      final ads = await _apiService.fetchMyAds(userId!);
      setState(() {
        myAds = ads;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
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
          color: Colors.black,
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor, AppColors.primaryTextColor],
          ),
        ),
      ),
    ),
    body: isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : hasError
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/anim/anim_4.json',
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Oops! Something went wrong. Please try again later.',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
              )
            : myAds.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/anim/anim_4.json',
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'No Ads Available!',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: myAds.length,
                    itemBuilder: (context, index) {
                      final ad = myAds[index];
                      return _buildAdCard(
                        context,
                        imageUrl: ad['image'],
                        title: ad['product_name'],
                        monthlyRental: '${ad['monthly_rental']} /-',
                        deposit: '${ad['deposit']} /-',
                        location: ad['location'],
                        package: ad['package']?.isEmpty ?? true ? 'No' : 'Yes',
                        status: ad['status'] == 1 ? 'Active' : 'Inactive',
                        shortDescription: ad['short_description'] ?? '',
                        description: ad['description']?.isEmpty ?? true
                            ? 'No description available'
                            : ad['description'],
                      );
                    },
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
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: SizedBox(
                  height: 250,
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
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Monthly Rental: $monthlyRental   Deposit: $deposit\n'
                  'Location: $location\nPackage: $package   Status: $status',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Text('Short Description:', style: GoogleFonts.poppins(fontSize: 12.49, fontWeight: FontWeight.w500)),
                Text(shortDescription, style: GoogleFonts.poppins(fontSize: 14)),
                const SizedBox(height: 6),
                Text('Description:', style: GoogleFonts.poppins(fontSize: 12.49, fontWeight: FontWeight.w500)),
                Text(description, style: GoogleFonts.poppins(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
