import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/ProductCard.dart';
import '../components/no_data_found.dart';
import '../consts.dart';
import 'ProductDetailsPage.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> products = [];
  bool isLoading = false;

  // Filter values
  RangeValues _priceRange = RangeValues(0, 10000);
  String? selectedCategory;
  String? selectedLocation;

  // Filter visibility
  bool isFilterVisible = false;

  Future<void> searchProducts(
    String searchTerm, {
    String? categoryId,
    double? priceMin,
    double? priceMax,
    String? location,
  }) async {
    setState(() => isLoading = true);

    try {
      // Update the endpoint URL to match your API
      final response = await http.post(
        Uri.parse(
            '${AppConstant.API_URL}api/v1/product/search-product'), // Remove '-product'
        headers: {
          'Content-Type': 'application/json',
          // Add any required authentication headers here if needed
        },
        body: jsonEncode({
          'searchTerm': searchTerm,
          if (categoryId != null)
            'category_id': int.parse(categoryId), // Convert to int
          if (priceMin != null) 'priceMin': priceMin.toInt(), // Convert to int
          if (priceMax != null) 'priceMax': priceMax.toInt(), // Convert to int
          if (location != null) 'location': location,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          products = data['products'];
          isLoading = false;
        });
      } else {
        // Better error handling
        print('Error Status Code: ${response.statusCode}');
        print('Error Response: ${response.body}');
        throw Exception('Failed to search products: ${response.statusCode}');
      }
    } catch (e) {
      print('Search Error: $e');
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error searching products. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 50,
            floating: true,
            pinned: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor,
                    AppColors.primaryTextColor,
                  ],
                ),
              ),
              child: FlexibleSpaceBar(
                title: Text('Search Products'),
                background: Container(
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
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Search Bar
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search products...',
                              prefixIcon: Icon(Icons.search),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.filter_list),
                                onPressed: () {
                                  setState(() {
                                    isFilterVisible = !isFilterVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: (value) => searchProducts(value),
                          ),
                        ),

                        // Filter Section
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: isFilterVisible ? 280 : 0,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16),
                                Text(
                                  'Filters',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),

                                // Price Range Slider
                                Text('Price Range'),
                                RangeSlider(
                                  values: _priceRange,
                                  min: 0,
                                  max: 10000,
                                  divisions: 100,
                                  labels: RangeLabels(
                                    _priceRange.start.round().toString(),
                                    _priceRange.end.round().toString(),
                                  ),
                                  onChanged: (RangeValues values) {
                                    setState(() {
                                      _priceRange = values;
                                    });
                                  },
                                ),

                                // Category Dropdown
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Category',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  value: selectedCategory,
                                  items: [
                                    DropdownMenuItem(
                                        value: '1', child: Text('Furniture')),
                                    DropdownMenuItem(
                                        value: '2', child: Text('Electronics')),
                                    // Add more categories
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCategory = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 16),

                                // Location Dropdown
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Location',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  value: selectedLocation,
                                  items: [
                                    DropdownMenuItem(
                                        value: 'New York',
                                        child: Text('New York')),
                                    DropdownMenuItem(
                                        value: 'Los Angeles',
                                        child: Text('Los Angeles')),
                                    // Add more locations
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedLocation = value;
                                    });
                                  },
                                ),

                                SizedBox(height: 16),

                                // Apply Filter Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      searchProducts(
                                        _searchController.text,
                                        categoryId: selectedCategory,
                                        priceMin: _priceRange.start,
                                        priceMax: _priceRange.end,
                                        location: selectedLocation,
                                      );
                                      setState(() {
                                        isFilterVisible = false;
                                      });
                                    },
                                    child: Text('Apply Filters'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Products Grid
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : products.isEmpty
                          ? NoDataFound(
                              message: 'No products found',
                            )
                          : Padding(
                              padding: EdgeInsets.all(16),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.6,
                                  mainAxisSpacing: 15.0, // Space between rows
                                ),
                                itemCount:
                                    products.length > 4 ? 4 : products.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final product = products[index];

                                  final String title =
                                      product['product_name'] ?? 'Unknown';
                                  final String imageUrl =
                                      product['image'] ?? '';
                                  final String price =
                                      "${product['monthly_rental']}/Month";

                                  final int productId =
                                      product['id']; // Get product ID
                                  String image_url = product['image'] ?? '';
                                  String image;
// Check if the image URL starts with "https://"
                                  if (!image_url.startsWith("https://")) {
                                    image =
                                        "https://www.torentyou.com/admin/uploads/$image_url";
                                  } else {
                                    image = image_url;
                                  }
                                  print(image);

                                  return ProductCard(
                                    title: title,
                                    imageUrl: imageUrl,
                                    price: price,
                                    category: product['category_id'].toString(),
                                    onRentNow: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailsPage(
                                            productId: productId,
                                            image: image,
                                            categoryId: product['category_id'],
                                            subcategoryId:
                                                product['subcategory'],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
