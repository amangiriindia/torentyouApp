import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package
import '../consts.dart'; // Make sure this file has your color definitions
import '../pages/PostAdsPage.dart';
import '../pages/Postadswithnavbar.dart';

class MyAdsPage extends StatelessWidget {
  const MyAdsPage({super.key});

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
            height: 18.74 / 12.49, // This sets line height based on fontSize
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
      body: Container(
        color: Colors.white, // Background color of the page
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildAdCard(
              context, // Pass context to _buildAdCard
              imageUrl: 'https://torentyou.com/admin/uploads/SofacumBed6_90e7bdd9-77de-4704-a83b-d5c895c643ce_540x.png', // Online image URL
              title: 'Beautiful Home Stay',
              category: 'Home Stay',
              monthlyRental: '2000 /-',
              deposit: '6000 /-',
              location: 'Lucknow',
              package: 'Yes',
              status: 'Active',
              shortDescription: 'Cozy and spacious home stay in the heart of Lucknow. Ideal for families.',
              description: 'Spacious home stay with modern amenities. Located in a prime area with easy access to local attractions. Ideal for families and groups. Features include comfortable furnishings, a well-equipped kitchen, and a beautiful garden.',
            ),
            _buildAdCard(
              context, // Pass context to _buildAdCard
              imageUrl: 'https://torentyou.com/admin/uploads/SofacumBed6_90e7bdd9-77de-4704-a83b-d5c895c643ce_540x.png',
              title: 'Luxurious Apartment',
              category: 'Apartment',
              monthlyRental: '5000 /-',
              deposit: '15000 /-',
              location: 'Delhi',
              package: 'No',
              status: 'Available',
              shortDescription: 'Modern apartment with stunning city views. Perfect for professionals.',
              description: 'This modern apartment offers a luxurious living experience with breathtaking city views. It includes state-of-the-art amenities, a spacious living area, and is located in a prime neighborhood with easy access to all conveniences.',
            ),
            _buildAdCard(
              context, // Pass context to _buildAdCard
              imageUrl: 'https://torentyou.com/admin/uploads/SofacumBed6_90e7bdd9-77de-4704-a83b-d5c895c643ce_540x.png',
              title: 'Charming Cottage',
              category: 'Cottage',
              monthlyRental: '3000 /-',
              deposit: '9000 /-',
              location: 'Shimla',
              package: 'Yes',
              status: 'Occupied',
              shortDescription: 'A cozy cottage with a beautiful garden and serene environment.',
              description: 'This charming cottage is nestled in a tranquil location, offering a serene escape from the hustle and bustle. It features a beautiful garden, comfortable living spaces, and is ideal for a relaxing retreat.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdCard(
      BuildContext context, {
        required String imageUrl,
        required String title,
        required String category,
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
                        builder: (context) => const PostAdsWithNavPage(), // Navigate to PostAdsPage
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
                  'Category: $category   Monthly Rental: $monthlyRental\n'
                      'Location: $location   Deposit: $deposit\n'
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
