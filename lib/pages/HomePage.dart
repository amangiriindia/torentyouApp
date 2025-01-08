import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../consts.dart';
import '../pageutills/homeRentalCategory.dart';
import '../pageutills/productByCategory.dart';
import 'home/slider.dart'; // Import the new widget

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 8, right: 8, bottom: 10.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Rentals near you...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                gapPadding: 0,
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                    color: Colors.grey.shade300),
              ),
            ),
            onChanged: _searchProducts,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CarouselSlider(), // Use the new widget here
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
          child: RentalCategory(),
        ),

        ProductByCategory(
          categoryName: 'Hotel',categoryId: 7,
        ),
        ProductByCategory(
          categoryName: 'Furniture',categoryId: 5,
        ),

        ProductByCategory(
          categoryName: 'Vehicle',categoryId: 4,
        ),

        ProductByCategory(
          categoryName: 'Clothes',categoryId: 9,
        ),
        ProductByCategory(
          categoryName: 'Appliances',categoryId: 6,
        ),
      ],
    );
  }

  void _searchProducts(String query) {
    setState(() {
      // Implement your search logic here
    });
  }
}
