import 'package:flutter/material.dart';

import '../components/ProductCard.dart';
import '../consts.dart';
import '../pages/ProductDetailsPage.dart';

class CategoryWise extends StatelessWidget {
  final String categoryName;

  const CategoryWise({
    Key? key,
    required this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define the list of products within this widget
    final List<Map<String, dynamic>> apiProducts = [
      {
        "imageUrl": 'https://torentyou.com/admin/uploads/room.jpg',
        "title": "Fabric Sofa Cum Bed",
        "price": "500/Month",
        "category": "Furniture",
        "description": "Bed sofa cum bed available",
      },
      {
        "imageUrl": 'https://torentyou.com/admin/uploads/room.jpg',
        "title": "Hotel Room",
        "price": "300/Month",
        "category": "Hotel",
      },
      {
        "imageUrl": 'https://torentyou.com/admin/uploads/room.jpg',
        "title": "Hotel Room",
        "price": "300/Month",
        "category": "Hotel",
      },
      {
        "imageUrl": 'https://torentyou.com/admin/uploads/SofacumBed6_90e7bdd9-77de-4704-a83b-d5c895c643ce_540x.png',
        "title": "Fabric Sofa Cum Bed",
        "price": "500/Month",
        "category": "Furniture",
      },
      {
        "imageUrl": 'https://torentyou.com/admin/uploads/room.jpg',
        "title": "Wooden Study Table",
        "price": "300/Month",
        "category": "Furniture",
      },
      {
        "imageUrl": 'https://torentyou.com/admin/uploads/room.jpg',
        "title": "Wooden Study Table",
        "price": "300/Month",
        "category": "Furniture",
      },
      {
        "imageUrl": 'https://www.torentyou.com/admin/uploads/Screenshot_2024-01-22_203251.png',
        "title": "Men's T-Shirt",
        "price": "100/Month",
        "category": "Clothing",
      },
      {
        "imageUrl": 'https://www.torentyou.com/admin/uploads/Screenshot_2024-01-22_203251.png',
        "title": "Men's T-Shirt",
        "price": "100/Month",
        "category": "Clothing",
      },
      {
        "imageUrl": 'https://www.torentyou.com/admin/uploads/Screenshot_2024-01-22_203251.png',
        "title": "Women's Dress",
        "price": "200/Month",
        "category": "Clothing",
      },
      {
        "imageUrl": 'https://www.torentyou.com/admin/uploads/Screenshot_2024-01-22_203251.png',
        "title": "Children's Jacket",
        "price": "150/Month",
        "category": "Clothing",
      },
      {
        "imageUrl": 'https://www.torentyou.com/admin/uploads/Bosch-GSB-501-500-Watt-Professional-Impact-Drill-Machine-BlueCorded-Electric-GSB-550x550w.jpg',
        "title": "Bosch Impact Drill",
        "price": "250/Month",
        "category": "Tools",
      },
      {
        "imageUrl": 'https://www.torentyou.com/admin/uploads/Bosch-GSB-501-500-Watt-Professional-Impact-Drill-Machine-BlueCorded-Electric-GSB-550x550w.jpg',
        "title": "Electric Screwdriver",
        "price": "150/Month",
        "category": "Tools",
      },
      {
        "imageUrl": 'https://www.torentyou.com/admin/uploads/Bosch-GSB-501-500-Watt-Professional-Impact-Drill-Machine-BlueCorded-Electric-GSB-550x550w.jpg',
        "title": "Hammer Drill Machine",
        "price": "300/Month",
        "category": "Tools",
      },
      {
        "imageUrl": 'https://www.torentyou.com/admin/uploads/Bosch-GSB-501-500-Watt-Professional-Impact-Drill-Machine-BlueCorded-Electric-GSB-550x550w.jpg',
        "title": "Hammer Drill Machine",
        "price": "300/Month",
        "category": "Tools",
      },
    ];

    // Filter products based on category
    final List<Map<String, dynamic>> categoryProducts = apiProducts
        .where((product) => product['category'] == categoryName)
        .toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
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
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
        child: categoryProducts.isNotEmpty
            ? GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            mainAxisSpacing: 15.0, // Space between rows
          ),
          itemCount: categoryProducts.length,
          itemBuilder: (BuildContext context, int index) {
            final product = categoryProducts[index];

            // Ensure non-null values
            final String title = product['title'] ?? 'Unknown';
            final String imageUrl = product['imageUrl'] ?? '';
            final String price = product['price'] ?? 'N/A';
            final String category = product['category'] ?? 'Unknown';

            return ProductCard(
              title: title,
              imageUrl: imageUrl,
              price: price,
              category: category,
              onRentNow: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) =>
                //         ProductDetailsPage(product: product),
                //   ),
                // );
              },
            );
          },
        )
            : const Center(
          child: Text(
            'No products available in this category.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
