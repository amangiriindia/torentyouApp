import 'package:flutter/material.dart';
import '../pageutills/homeRentalCategory.dart';
import '../pageutills/productByCategory.dart';
import 'home/slider.dart';
import 'search_screen.dart'; // Import the SearchScreen

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 8, right: 8, bottom: 10.0),
          child: GestureDetector(
            onTap: () {
              // Navigate to SearchScreen when the container is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(),
                ),
              );
            },
            child: AbsorbPointer(
              // This prevents the TextField from receiving input
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Rentals near you...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    gapPadding: 0,
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabled: true, // Keep enabled for visual appearance
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CarouselSlider(),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
          child: RentalCategory(),
        ),
        ProductByCategory(
          categoryName: 'Furniture',
          categoryId: 5,
        ),
        ProductByCategory(
          categoryName: 'Vehicle',
          categoryId: 4,
        ),
        ProductByCategory(
          categoryName: 'Clothes',
          categoryId: 9,
        ),
        ProductByCategory(
          categoryName: 'Appliances',
          categoryId: 6,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}