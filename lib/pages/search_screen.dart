//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:geolocator/geolocator.dart'; // Added for geolocation
// import '../components/ProductCard.dart';
// import '../components/no_data_found.dart';
// import '../constant/india_states_and_cities.dart';
// import '../consts.dart';
// import '../service/product_service.dart';
// import 'ProductDetailsPage.dart';
//
//
//
// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }
//
// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   final TextEditingController _customLocationController = TextEditingController();
//   final ProductService _productService = ProductService();
//
//   List<dynamic> products = [];
//   List<Map<String, dynamic>> categories = [];
//   bool isLoading = false;
//   bool isCategoriesLoading = true;
//
//   // Filter values
//   RangeValues _priceRange = RangeValues(0, 10000);
//   String? selectedCategory;
//   String? selectedState;
//   String? selectedCity;
//   bool showCustomLocationField = false;
//   double minPrice = 0;
//   double maxPrice = 10000;
//   bool isGettingLocation = false;
//
//   // Filter visibility
//   bool isFilterVisible = false;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchCategories();
//     _loadCachedData();
//   }
//
//   // Load cached categories
//   Future<void> _loadCachedData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final cachedCategories = prefs.getString('rental_categories');
//
//     if (cachedCategories != null) {
//       setState(() {
//         categories = List<Map<String, dynamic>>.from(jsonDecode(cachedCategories));
//         isCategoriesLoading = false;
//       });
//     }
//   }
//
//   // Fetch categories from API
//   Future<void> fetchCategories() async {
//     const url = '${AppConstant.API_URL}api/v1/category/all-category';
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success']) {
//           final List<Map<String, dynamic>> fetchedCategories =
//           List<Map<String, dynamic>>.from(data['results'].map((category) {
//             return {
//               'id': category['id'] ?? 0,
//               'name': category['c_name'],
//             };
//           }));
//
//           if (mounted) {
//             setState(() {
//               categories = fetchedCategories;
//               isCategoriesLoading = false;
//             });
//           }
//
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('rental_categories', jsonEncode(fetchedCategories));
//         }
//       } else {
//         throw Exception('Failed to load categories');
//       }
//     } catch (e) {
//       print('Error fetching categories: $e');
//       setState(() {
//         isCategoriesLoading = false;
//       });
//     }
//   }
//
//   // Get current location
//   Future<void> _getCurrentLocation() async {
//     setState(() {
//       isGettingLocation = true;
//     });
//
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         throw Exception('Location services are disabled.');
//       }
//
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           throw Exception('Location permissions are denied.');
//         }
//       }
//
//       if (permission == LocationPermission.deniedForever) {
//         throw Exception('Location permissions are permanently denied.');
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       // Note: To convert coordinates to city/state, you would need a reverse geocoding service
//       // This is a placeholder for demonstration
//       String? city = await _getCityFromCoordinates(position.latitude, position.longitude);
//       String ? state = city != null ? IndiaStatesAndCities.getStateForCity(city) : null;
//
//       if (city != null && state != null) {
//         setState(() {
//           selectedState = state;
//           selectedCity = city;
//           showCustomLocationField = false;
//           _customLocationController.clear();
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Unable to determine city from location.'),
//             backgroundColor: Colors.orange,
//             duration: Duration(seconds: 2),
//           ),
//         );
//       }
//     } catch (e) {
//       print('Error getting location: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error getting location: $e'),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 3),
//         ),
//       );
//     } finally {
//       setState(() {
//         isGettingLocation = false;
//       });
//     }
//   }
//
//   // Placeholder for reverse geocoding (would require external service)
//   Future<String?> _getCityFromCoordinates(double latitude, double longitude) async {
//     // Implement reverse geocoding here using a service like Google Maps API
//     // For now, returning a placeholder
//     return null; // Replace with actual city name from geocoding
//   }
//
//   // Get the final location value to use for search
//   String? getFinalLocationValue() {
//     if (showCustomLocationField) {
//       return _customLocationController.text.trim().isEmpty
//           ? null
//           : _customLocationController.text.trim();
//     }
//     return selectedCity;
//   }
//
//   // Search products with filters
//   Future<void> searchProducts(
//       String searchTerm, {
//         String? categoryId,
//         double? priceMin,
//         double? priceMax,
//         String? location,
//       }) async {
//     if (searchTerm.isEmpty && categoryId == null && location == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please enter search term or select filters'),
//           backgroundColor: Colors.orange,
//           duration: Duration(seconds: 2),
//         ),
//       );
//       return;
//     }
//
//     setState(() => isLoading = true);
//
//     try {
//       final searchResults = await _productService.searchProducts(
//         searchTerm: searchTerm,
//         categoryId: categoryId,
//         priceMin: priceMin,
//         priceMax: priceMax,
//         location: location ?? getFinalLocationValue(),
//       );
//
//       setState(() {
//         products = searchResults;
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Search Error: $e');
//       setState(() => isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error searching products. Please try again.'),
//           backgroundColor: Colors.red,
//           duration: Duration(seconds: 3),
//         ),
//       );
//     }
//   }
//
//   // Update price range basedidom current products
//   void updatePriceRange() {
//     if (products.isEmpty) return;
//
//     double min = double.infinity;
//     double max = 0;
//
//     for (var product in products) {
//       double price = double.tryParse(product['monthly_rental']?.toString() ?? '0') ?? 0;
//       if (price < min) min = price;
//       if (price > max) max = price;
//     }
//
//     setState(() {
//       minPrice = min == double.infinity ? 0 : min;
//       maxPrice = max == 0 ? 10000 : max;
//       _priceRange = RangeValues(minPrice, maxPrice);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             expandedHeight: 50,
//             floating: true,
//             pinned: true,
//             flexibleSpace: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     AppColors.primaryColor,
//                     AppColors.primaryTextColor,
//                   ],
//                 ),
//               ),
//               child: FlexibleSpaceBar(
//                 title: Text('Search Products'),
//                 background: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         AppColors.primaryColor,
//                         AppColors.primaryTextColor,
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: Container(
//               color: Colors.white,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Column(
//                       children: [
//                         // Search Bar
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.2),
//                                 spreadRadius: 1,
//                                 blurRadius: 5,
//                               ),
//                             ],
//                           ),
//                           child: TextField(
//                             controller: _searchController,
//                             decoration: InputDecoration(
//                               hintText: 'Search products...',
//                               prefixIcon: Icon(Icons.search),
//                               suffixIcon: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   if (_searchController.text.isNotEmpty)
//                                     IconButton(
//                                       icon: Icon(Icons.clear),
//                                       onPressed: () {
//                                         _searchController.clear();
//                                         setState(() {
//                                           products = [];
//                                         });
//                                       },
//                                     ),
//                                   IconButton(
//                                     icon: Icon(
//                                       Icons.filter_list,
//                                       color: isFilterVisible
//                                           ? AppColors.primaryColor
//                                           : Colors.grey,
//                                     ),
//                                     onPressed: () {
//                                       setState(() {
//                                         isFilterVisible = !isFilterVisible;
//                                       });
//                                     },
//                                   ),
//                                 ],
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                                 borderSide: BorderSide.none,
//                               ),
//                             ),
//                             onSubmitted: (value) => searchProducts(value),
//                           ),
//                         ),
//
//                         // Filter Section
//                         AnimatedContainer(
//                           duration: Duration(milliseconds: 300),
//                           height: isFilterVisible ? (showCustomLocationField ? 550 : 480) : 0,
//                           child: SingleChildScrollView(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(height: 16),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       'Filters',
//                                       style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     TextButton(
//                                       onPressed: () {
//                                         setState(() {
//                                           selectedCategory = null;
//                                           selectedState = null;
//                                           selectedCity = null;
//                                           showCustomLocationField = false;
//                                           _customLocationController.clear();
//                                           _priceRange = RangeValues(0, 10000);
//                                         });
//                                       },
//                                       child: Text('Clear All'),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 16),
//
//                                 // Category Dropdown
//                                 isCategoriesLoading
//                                     ? Center(child: CircularProgressIndicator())
//                                     : DropdownButtonFormField<String>(
//                                   decoration: InputDecoration(
//                                     labelText: 'Category',
//                                     prefixIcon: Icon(Icons.category),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   value: selectedCategory,
//                                   hint: Text('Select Category'),
//                                   items: categories.map((category) {
//                                     return DropdownMenuItem<String>(
//                                       value: category['id'].toString(),
//                                       child: Text(category['name']),
//                                     );
//                                   }).toList(),
//                                   onChanged: (value) {
//                                     setState(() {
//                                       selectedCategory = value;
//                                     });
//                                   },
//                                 ),
//                                 SizedBox(height: 16),
//
//                                 // State Dropdown
//                                 DropdownButtonFormField<String>(
//                                   decoration: InputDecoration(
//                                     labelText: 'State',
//                                     prefixIcon: Icon(Icons.location_city),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   value: selectedState,
//                                   hint: Text('Select State'),
//                                   items: IndiaStatesAndCities.getAllStates().map((state) {
//                                     return DropdownMenuItem<String>(
//                                       value: state,
//                                       child: Text(state),
//                                     );
//                                   }).toList(),
//                                   onChanged: (value) {
//                                     setState(() {
//                                       selectedState = value;
//                                       selectedCity = null; // Reset city when state changes
//                                       showCustomLocationField = value == 'custom';
//                                       if (value != 'custom') {
//                                         _customLocationController.clear();
//                                       }
//                                     });
//                                   },
//                                 ),
//                                 SizedBox(height: 16),
//
//                                 // City Dropdown
//                                 if (selectedState != null)
//                                   DropdownButtonFormField<String>(
//                                     decoration: InputDecoration(
//                                       labelText: 'City',
//                                       prefixIcon: Icon(Icons.location_on),
//                                       border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                     ),
//                                     value: selectedCity,
//                                     hint: Text('Select City'),
//                                     items: IndiaStatesAndCities.getCitiesForState(selectedState!).map((city) {
//                                       return DropdownMenuItem<String>(
//                                         value: city,
//                                         child: Text(city),
//                                       );
//                                     }).toList(),
//                                     onChanged: (value) {
//                                       setState(() {
//                                         selectedCity = value;
//                                         showCustomLocationField = value == 'custom';
//                                         if (value != 'custom') {
//                                           _customLocationController.clear();
//                                         }
//                                       });
//                                     },
//                                   ),
//                                 SizedBox(height: 16),
//
//                                 // Custom Location Field
//                                 if (showCustomLocationField)
//                                   Column(
//                                     children: [
//                                       TextField(
//                                         controller: _customLocationController,
//                                         decoration: InputDecoration(
//                                           labelText: 'Enter Custom Location',
//                                           prefixIcon: Icon(Icons.edit_location),
//                                           border: OutlineInputBorder(
//                                             borderRadius: BorderRadius.circular(12),
//                                           ),
//                                           hintText: 'e.g., Lucknow, Indore, etc.',
//                                         ),
//                                       ),
//                                       SizedBox(height: 16),
//                                     ],
//                                   ),
//
//                                 // Get Current Location Button
//                                 SizedBox(
//                                   width: double.infinity,
//                                   child: ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: AppColors.primaryColor,
//                                       foregroundColor: Colors.white,
//                                       padding: EdgeInsets.symmetric(vertical: 16),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                     ),
//                                     onPressed: isGettingLocation ? null : _getCurrentLocation,
//                                     child: isGettingLocation
//                                         ? CircularProgressIndicator(color: Colors.white)
//                                         : Text(
//                                       'Get My Current Location',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 16),
//
//                                 // Price Range Slider
//                                 Text(
//                                   'Price Range',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 SizedBox(height: 8),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text('₹${_priceRange.start.round()}'),
//                                     Text('₹${_priceRange.end.round()}'),
//                                   ],
//                                 ),
//                                 RangeSlider(
//                                   values: _priceRange,
//                                   min: 0,
//                                   max: 50000,
//                                   divisions: 500,
//                                   activeColor: AppColors.primaryColor,
//                                   labels: RangeLabels(
//                                     '₹${_priceRange.start.round()}',
//                                     '₹${_priceRange.end.round()}',
//                                   ),
//                                   onChanged: (RangeValues values) {
//                                     setState(() {
//                                       _priceRange = values;
//                                     });
//                                   },
//                                 ),
//                                 SizedBox(height: 16),
//
//                                 // Apply Filter Button
//                                 SizedBox(
//                                   width: double.infinity,
//                                   child: ElevatedButton(
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: AppColors.primaryColor,
//                                       foregroundColor: Colors.white,
//                                       padding: EdgeInsets.symmetric(vertical: 16),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                     ),
//                                     onPressed: () {
//                                       searchProducts(
//                                         _searchController.text,
//                                         categoryId: selectedCategory,
//                                         priceMin: _priceRange.start,
//                                         priceMax: _priceRange.end,
//                                         location: getFinalLocationValue(),
//                                       );
//                                       setState(() {
//                                         isFilterVisible = false;
//                                       });
//                                     },
//                                     child: Text(
//                                       'Apply Filters',
//                                       style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // Products Grid
//                   isLoading
//                       ? Padding(
//                     padding: EdgeInsets.all(50),
//                     child: Center(child: CircularProgressIndicator()),
//                   )
//                       : products.isEmpty
//                       ? NoDataFound(
//                     message: 'No products found',
//                   )
//                       : Column(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               '${products.length} products found',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             if (products.length > 4)
//                               TextButton(
//                                 onPressed: () {
//                                   // Navigate to view all products
//                                 },
//                                 child: Text('View All'),
//                               ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.all(16),
//                         child: GridView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             childAspectRatio: 0.6,
//                             mainAxisSpacing: 15.0,
//                             crossAxisSpacing: 15.0,
//                           ),
//                           itemCount: products.length > 4 ? 4 : products.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             final product = products[index];
//
//                             final String title =
//                                 product['product_name'] ?? 'Unknown';
//                             final String imageUrl = product['image'] ?? '';
//                             final String price =
//                                 "₹${product['monthly_rental']}/Month";
//
//                             final int productId = product['id'];
//                             String image_url = product['image'] ?? '';
//                             String image;
//
//                             if (!image_url.startsWith("https://")) {
//                               image =
//                               "https://www.torentyou.com/admin/uploads/$image_url";
//                             } else {
//                               image = image_url;
//                             }
//
//                             return ProductCard(
//                               title: title,
//                               imageUrl: image,
//                               price: price,
//                               category: product['category_id'].toString(),
//                               onRentNow: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         ProductDetailsPage(
//                                           productId: productId,
//                                           image: image,
//                                           categoryId: product['category_id'],
//                                           subcategoryId: product['subcategory'],
//                                         ),
//                                   ),
//                                 );
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import '../components/ProductCard.dart';
import '../components/no_data_found.dart';
import '../constant/india_states_and_cities.dart';
import '../consts.dart';
import '../service/product_service.dart';
import 'ProductDetailsPage.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _customLocationController = TextEditingController();
  final ProductService _productService = ProductService();

  List<dynamic> products = [];
  List<dynamic> allProducts = []; // Store all products for filtering
  List<Map<String, dynamic>> categories = [];
  bool isLoading = false;
  bool isCategoriesLoading = true;
  bool isInitialLoad = true;

  // Filter values
  RangeValues _priceRange = RangeValues(0, 50000);
  String? selectedCategory;
  String? selectedState;
  String? selectedCity;
  bool showCustomLocationField = false;
  double minPrice = 0;
  double maxPrice = 50000;
  bool isGettingLocation = false;

  // Filter visibility
  bool isFilterVisible = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  // Initialize data - load cached data and fetch fresh data
  Future<void> _initializeData() async {
    await _loadCachedData();
    await Future.wait([
      fetchCategories(),
      fetchAllProducts(),
    ]);
  }

  // Load cached data
  Future<void> _loadCachedData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load cached categories
    final cachedCategories = prefs.getString('rental_categories');
    if (cachedCategories != null) {
      setState(() {
        categories = List<Map<String, dynamic>>.from(jsonDecode(cachedCategories));
        isCategoriesLoading = false;
      });
    }

    // Load cached products
    final cachedProducts = prefs.getString('all_products');
    if (cachedProducts != null) {
      final productsList = List<dynamic>.from(jsonDecode(cachedProducts));
      setState(() {
        allProducts = productsList;
        products = productsList;
        isLoading = false;
        isInitialLoad = false;
      });
      updatePriceRange();
    }
  }

  // Fetch all products from API
  Future<void> fetchAllProducts() async {
    if (!isInitialLoad) {
      setState(() => isLoading = true);
    }

    const url = 'https://trytest-xcqt.onrender.com/api/v1/product/get-all';
    try {
      final response = await http.get(Uri.parse(url));
      print(response.statusCode);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final List<dynamic> fetchedProducts = data['results'];

          if (mounted) {
            setState(() {
              allProducts = fetchedProducts;
              products = fetchedProducts;
              isLoading = false;
              isInitialLoad = false;
            });
          }

          // Cache products
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('all_products', jsonEncode(fetchedProducts));

          updatePriceRange();
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          isInitialLoad = false;
        });
      }

      // Show error only if no cached data
      if (allProducts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading products. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Fetch categories from API
  Future<void> fetchCategories() async {
    const url = '${AppConstant.API_URL}api/v1/category/all-category';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final List<Map<String, dynamic>> fetchedCategories =
          List<Map<String, dynamic>>.from(data['results'].map((category) {
            return {
              'id': category['id'] ?? 0,
              'name': category['c_name'],
            };
          }));

          if (mounted) {
            setState(() {
              categories = fetchedCategories;
              isCategoriesLoading = false;
            });
          }

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('rental_categories', jsonEncode(fetchedCategories));
        }
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        isCategoriesLoading = false;
      });
    }
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    setState(() {
      isGettingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String? city = await _getCityFromCoordinates(position.latitude, position.longitude);
      String? state = city != null ? IndiaStatesAndCities.getStateForCity(city) : null;

      if (city != null && state != null) {
        setState(() {
          selectedState = state;
          selectedCity = city;
          showCustomLocationField = false;
          _customLocationController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to determine city from location.'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting location: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        isGettingLocation = false;
      });
    }
  }

  // Placeholder for reverse geocoding
  Future<String?> _getCityFromCoordinates(double latitude, double longitude) async {
    // Implement reverse geocoding here using a service like Google Maps API
    return null;
  }

  // Get the final location value to use for search
  String? getFinalLocationValue() {
    if (showCustomLocationField) {
      return _customLocationController.text.trim().isEmpty
          ? null
          : _customLocationController.text.trim();
    }
    return selectedCity;
  }

  // Filter products locally
  void filterProducts() {
    setState(() => isLoading = true);

    List<dynamic> filteredProducts = List.from(allProducts);

    // Apply search term filter
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filteredProducts = filteredProducts.where((product) {
        final productName = (product['product_name'] ?? '').toString().toLowerCase();
        final tags = (product['tags'] ?? '').toString().toLowerCase();
        final description = (product['short_description'] ?? '').toString().toLowerCase();
        return productName.contains(searchTerm) ||
            tags.contains(searchTerm) ||
            description.contains(searchTerm);
      }).toList();
    }

    // Apply category filter
    if (selectedCategory != null) {
      filteredProducts = filteredProducts.where((product) {
        return product['category_id'].toString() == selectedCategory;
      }).toList();
    }

    // Apply price range filter
    filteredProducts = filteredProducts.where((product) {
      final price = double.tryParse(product['monthly_rental']?.toString() ?? '0') ?? 0;
      return price >= _priceRange.start && price <= _priceRange.end;
    }).toList();

    // Apply location filter
    final locationFilter = getFinalLocationValue();
    if (locationFilter != null && locationFilter.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        final productLocation = (product['location'] ?? '').toString().toLowerCase();
        return productLocation.contains(locationFilter.toLowerCase());
      }).toList();
    }

    setState(() {
      products = filteredProducts;
      isLoading = false;
    });
  }

  // Search products (now filters locally)
  Future<void> searchProducts(
      String searchTerm, {
        String? categoryId,
        double? priceMin,
        double? priceMax,
        String? location,
      }) async {
    filterProducts();
  }

  // Update price range based on current products
  void updatePriceRange() {
    if (allProducts.isEmpty) return;

    double min = double.infinity;
    double max = 0;

    for (var product in allProducts) {
      double price = double.tryParse(product['monthly_rental']?.toString() ?? '0') ?? 0;
      if (price < min) min = price;
      if (price > max) max = price;
    }

    if (mounted) {
      setState(() {
        minPrice = min == double.infinity ? 0 : min;
        maxPrice = max == 0 ? 50000 : max;
        // Only update price range if it hasn't been manually adjusted
        if (_priceRange.start == 0 && _priceRange.end == 50000) {
          _priceRange = RangeValues(minPrice, maxPrice);
        }
      });
    }
  }

  // Clear all filters
  void clearAllFilters() {
    setState(() {
      selectedCategory = null;
      selectedState = null;
      selectedCity = null;
      showCustomLocationField = false;
      _customLocationController.clear();
      _priceRange = RangeValues(minPrice, maxPrice);
      _searchController.clear();
      products = List.from(allProducts);
    });
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
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_searchController.text.isNotEmpty)
                                    IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        filterProducts();
                                      },
                                    ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.filter_list,
                                      color: isFilterVisible
                                          ? AppColors.primaryColor
                                          : Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isFilterVisible = !isFilterVisible;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: (value) => filterProducts(),
                            onChanged: (value) {
                              if (value.isEmpty) {
                                filterProducts();
                              }
                            },
                          ),
                        ),

                        // Filter Section
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: isFilterVisible ? (showCustomLocationField ? 550 : 480) : 0,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Filters',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: clearAllFilters,
                                      child: Text('Clear All'),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),

                                // Category Dropdown
                                isCategoriesLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Category',
                                    prefixIcon: Icon(Icons.category),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  value: selectedCategory,
                                  hint: Text('Select Category'),
                                  items: categories.map((category) {
                                    return DropdownMenuItem<String>(
                                      value: category['id'].toString(),
                                      child: Text(category['name']),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCategory = value;
                                    });
                                  },
                                ),
                                SizedBox(height: 16),

                                // State Dropdown
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'State',
                                    prefixIcon: Icon(Icons.location_city),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  value: selectedState,
                                  hint: Text('Select State'),
                                  items: IndiaStatesAndCities.getAllStates().map((state) {
                                    return DropdownMenuItem<String>(
                                      value: state,
                                      child: Text(state),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedState = value;
                                      selectedCity = null;
                                      showCustomLocationField = value == 'custom';
                                      if (value != 'custom') {
                                        _customLocationController.clear();
                                      }
                                    });
                                  },
                                ),
                                SizedBox(height: 16),

                                // City Dropdown
                                if (selectedState != null && selectedState != 'custom')
                                  DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      labelText: 'City',
                                      prefixIcon: Icon(Icons.location_on),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    value: selectedCity,
                                    hint: Text('Select City'),
                                    items: IndiaStatesAndCities.getCitiesForState(selectedState!).map((city) {
                                      return DropdownMenuItem<String>(
                                        value: city,
                                        child: Text(city),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCity = value;
                                        showCustomLocationField = value == 'custom';
                                        if (value != 'custom') {
                                          _customLocationController.clear();
                                        }
                                      });
                                    },
                                  ),
                                SizedBox(height: 16),

                                // Custom Location Field
                                if (showCustomLocationField)
                                  Column(
                                    children: [
                                      TextField(
                                        controller: _customLocationController,
                                        decoration: InputDecoration(
                                          labelText: 'Enter Custom Location',
                                          prefixIcon: Icon(Icons.edit_location),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          hintText: 'e.g., Lucknow, Indore, etc.',
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                    ],
                                  ),

                                // Get Current Location Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: isGettingLocation ? null : _getCurrentLocation,
                                    child: isGettingLocation
                                        ? CircularProgressIndicator(color: Colors.white)
                                        : Text(
                                      'Get My Current Location',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),

                                // Price Range Slider
                                Text(
                                  'Price Range',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('₹${_priceRange.start.round()}'),
                                    Text('₹${_priceRange.end.round()}'),
                                  ],
                                ),
                                RangeSlider(
                                  values: _priceRange,
                                  min: 0,
                                  max: maxPrice > 50000 ? maxPrice : 50000,
                                  divisions: 500,
                                  activeColor: AppColors.primaryColor,
                                  labels: RangeLabels(
                                    '₹${_priceRange.start.round()}',
                                    '₹${_priceRange.end.round()}',
                                  ),
                                  onChanged: (RangeValues values) {
                                    setState(() {
                                      _priceRange = values;
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
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      filterProducts();
                                      setState(() {
                                        isFilterVisible = false;
                                      });
                                    },
                                    child: Text(
                                      'Apply Filters',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
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
                  if (isLoading && isInitialLoad)
                    Padding(
                      padding: EdgeInsets.all(50),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (products.isEmpty && !isLoading)
                    NoDataFound(
                      message: 'No products found',
                    )
                  else
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${products.length} products found',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (products.length > 4)
                                TextButton(
                                  onPressed: () {
                                    // Navigate to view all products
                                  },
                                  child: Text('View All'),
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.6,
                              mainAxisSpacing: 15.0,
                              crossAxisSpacing: 15.0,
                            ),
                            itemCount: products.length,
                            itemBuilder: (BuildContext context, int index) {
                              final product = products[index];

                              final String title =
                                  product['product_name'] ?? 'Unknown';
                              final String price =
                                  "₹${product['monthly_rental']}/Month";

                              final int productId = product['id'];
                              String image_url = product['image'] ?? '';
                              String image;

                              if (!image_url.startsWith("https://")) {
                                image =
                                "https://www.torentyou.com/admin/uploads/$image_url";
                              } else {
                                image = image_url;
                              }

                              return ProductCard(
                                title: title,
                                imageUrl: image,
                                price: price,
                                category: product['category_id'].toString(),
                                onRentNow: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailsPage(
                                        productId: productId,
                                        image: image,
                                        categoryId: product['category_id'],
                                        subcategoryId: product['subcategory'],
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}